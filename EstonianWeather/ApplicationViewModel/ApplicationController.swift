//
//  ApplicationController.swift
//  EstonianWeather
//
//  Created by Andrius Shiaulis on 02.03.2020.
//  Copyright © 2020 Andrius Shiaulis. All rights reserved.
//

import Combine
import UIKit
import CoreData

final class ApplicationController {

    // MARK: - Properties

    private let settingsService: SettingsService
    private let widgetService: WidgetService
    private let featureFlagService: FeatureFlagService

    private let defaultRequestsInterval: TimeInterval = 60 * 60

    private var disposables: Set<AnyCancellable> = []
    private var timerDisposable: AnyCancellable?

    private let coreDataStack: CoreDataStack
    private var persistentContainer: NSPersistentContainer { self.coreDataStack.persistentContainer }
    private let parser: ServerResponseParser = ServerResponseXMLParser()
    private lazy var mapper: DataMapper = { CoreDataMapper(logger: self.logger) }()
    private let logger: Logger = PrintLogger()
    private let networkClient: NetworkClient = URLSessionNetworkClient()

    // MARK: - Initialization

    init() {
        self.coreDataStack = .init()
        self.settingsService = .init(userDefaults: .standard, coreDataStack: self.coreDataStack)
        self.widgetService = .init()
        self.featureFlagService = .init(storage: RuntimeFeatureFlagStorage())

        guard self.applicationMode != .unitTests else { return }

        setTimerForRequests(with: self.defaultRequestsInterval)
        subscribeForNotifications()
    }

    private func requestAndMapData() {
        requestAndMapForecasts()

        if featureFlagService.isEnabled(.observations) {
            assertionFailure("Not expeced to be triggered yet")
            requestObservations()
        }

    }

    private func requestAndMapForecastPublisher(for localization: AppLocalization) -> AnyPublisher<[EWForecast], Swift.Error> {
        let endpoint = Endpoint.forecast(for: localization)
        let today = Date()

        return self.networkClient.requestPublisher(for: endpoint)
            // TODOx: Should validate response code as well
            .map { $0.data }
            .parseForecast(using: self.parser, date: today, languageCode: localization.languageCode)
    }

    private func requestAndMapForecasts() {
        let context = self.persistentContainer.viewContext
        let publishers = AppLocalization
            .allCases
            .map { requestAndMapForecastPublisher(for: $0) }

        Publishers
            .MergeMany(publishers)
            .removeForecastOlderThan(Date.yesterday, using: self.mapper, in: context)
            .mapForecast(using: self.mapper, in: context)
            .sink { completion in
                switch completion {
                case .finished:
                    self.widgetService.notifyWidgetsAboutUpdates()
                    self.logger.logNotImplemented(functionality: "Data request completion", module: .mainViewModel)
                    // should we somehow notify UI about this state?
                    NotificationCenter.default.post(name: .didFinishDownload, object: context)

                case .failure:
                    assertionFailure()
                }

            }
            receiveValue: { value in
                print(value)
            }
            .store(in: &self.disposables)
    }

    private func requestObservations() {
        let endpoint = Endpoint.observations()
        let today = Date()
        let context = self.persistentContainer.newBackgroundContext()

        self.networkClient.requestPublisher(for: endpoint)
            // TODOx: Should validate response code as well
            .map { $0.data }
            .parseObservations(using: self.parser, date: today)
            .removeObservationsOlderThan(today, using: self.mapper, in: context)
            .mapObservations(using: self.mapper, in: context)
            .sink { _ in
                self.widgetService.notifyWidgetsAboutUpdates()
                self.logger.logNotImplemented(functionality: "Data request completion", module: .mainViewModel)
            }
            receiveValue: { _ in }
            .store(in: &self.disposables)
    }

    private func setTimerForRequests(with interval: TimeInterval) {
        self.requestAndMapData()
        self.timerDisposable =
        Timer
            .publish(every: interval, on: RunLoop.main, in: .default)
            .sink { _ in self.requestAndMapData() }
    }

    private func subscribeForNotifications() {
        NotificationCenter
            .default
            .publisher(for: UIApplication.didEnterBackgroundNotification, object: self)
            .sink { _ in
                self.timerDisposable = nil
            }
            .store(in: &self.disposables)

        NotificationCenter
            .default
            .publisher(for: UIApplication.didBecomeActiveNotification, object: self)
            .sink { _ in
                self.setTimerForRequests(with: self.defaultRequestsInterval)
            }
            .store(in: &self.disposables)
    }
}

extension ApplicationController: ApplicationViewModel {
    func isFeatureEnabled(_ featureFlag: FeatureFlag) -> Bool {
        self.featureFlagService.isEnabled(featureFlag)
    }

    var appLocalization: AppLocalization {
        self.settingsService.appLocalization
    }

    func openApplicationSettings() {
        UIApplication.shared.open(Resource.URL.settings, options: [:])
    }

    func openDisclaimerURL() {
        UIApplication.shared.open(Resource.URL.disclaimerURL(for: self.appLocalization), options: [:])
    }

    private var isUnitTesting: Bool { ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil }

    var applicationMode: ApplicationMode {
        if self.isUnitTesting {
            return .unitTests
        }

        return .swiftUI
    }

    func forecastDataProvider() -> DataProvider {
        DataProvider()
    }

}

extension Notification.Name {
    static let didFinishDownload = Notification.Name("didFinishDownload")
}

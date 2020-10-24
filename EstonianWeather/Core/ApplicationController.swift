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

        setTimerForRequests(with: self.defaultRequestsInterval)
        subscribeForNotifications()
    }

    private func requestAndMapData() {
        requestAndMapForecasts()
        requestObservations()
    }

    private func requestAndMapForecasts() {
        let endpoint = Endpoint.forecast(for: self.settingsService.appLocalization)
        let today = Date()
        let context = self.persistentContainer.newBackgroundContext()

        self.networkClient.requestPublisher(for: endpoint)
            // TODOx: Should validate response code as well
            .map { $0.data }
            .parseForecast(using: self.parser, date: today, languageCode: self.settingsService.appLocalization.languageCode)
            .removeForecastOlderThan(today, using: self.mapper, in: context)
            .mapForecast(using: self.mapper, in: context)
            .sink { _ in
                self.widgetService.notifyWidgetsAboutUpdates()
                self.logger.logNotImplemented(functionality: "Data request completion", module: .mainViewModel)
            }
            receiveValue: { _ in }
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
    var appLocalization: AppLocalization {
        self.settingsService.appLocalization
    }

    func openApplicationSettings() {
        self.settingsService.openApplicationSettings()
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

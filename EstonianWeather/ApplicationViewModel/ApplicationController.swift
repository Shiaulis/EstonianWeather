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

    let model: Model

    var syncStatus: SyncStatus = .ready {
        didSet {
            NotificationCenter.default.post(name: .syncStatusDidChange, object: self, userInfo: nil)
        }
    }

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

    var viewContext: NSManagedObjectContext { self.coreDataStack.persistentContainer.viewContext }

    // MARK: - Initialization

    init() {
        self.coreDataStack = .init()
        self.settingsService = .init(userDefaults: .standard, coreDataStack: self.coreDataStack)
        self.widgetService = .init()
        self.featureFlagService = .init(storage: RuntimeFeatureFlagStorage())
        self.model = ApplicationModel(context: self.coreDataStack.persistentContainer.viewContext, appLocalization: self.settingsService.appLocalization)

        guard self.applicationMode != .unitTests else { return }
    }

    private func requestObservations() {
        let endpoint = Endpoint.observations()
        let today = Date()
        let context = self.persistentContainer.newBackgroundContext()
        context.mergePolicy = NSMergePolicy(merge: .overwriteMergePolicyType)
        context.automaticallyMergesChangesFromParent = true
        context.parent = self.persistentContainer.viewContext

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

    func openSourceDisclaimerURL() {
        UIApplication.shared.open(Resource.URL.sourceDisclaimerURL(for: self.appLocalization), options: [:])
    }

    func openIconDisclaimerURL() {
        UIApplication.shared.open(Resource.URL.iconDisclaimerURL(), options: [:])
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
    static let syncStatusDidChange = Notification.Name("syncStatusDidChange")
}

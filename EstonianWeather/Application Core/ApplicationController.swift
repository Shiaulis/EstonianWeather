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
    let ratingService: AppStoreRatingService

    private let settingsService: SettingsService
    private let widgetService: WidgetService
    private let persistenceService: PersistenceService

    private var disposables: Set<AnyCancellable> = []

    // MARK: - Initialization

    init() {
        self.widgetService = .init()
        self.persistenceService = .init()
        self.ratingService = .init(logger: PrintLogger())
        self.settingsService = .init(userDefaults: .standard, persistenceService: self.persistenceService)
        self.model = ApplicationModel(persistenceService: self.persistenceService)

        self.ratingService.incrementLauchCounter()
    }

}

extension ApplicationController {

    private var isUnitTesting: Bool { ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil }

    var applicationMode: ApplicationMode {
        if self.isUnitTesting {
            return .unitTests
        }

        return .swiftUI
    }

    func forecastDataProvider() -> DataProvider {
        DataProvider(formatter: ForecastDateFormatter())
    }

}

extension Notification.Name {
    static let syncStatusDidChange = Notification.Name("syncStatusDidChange")
}

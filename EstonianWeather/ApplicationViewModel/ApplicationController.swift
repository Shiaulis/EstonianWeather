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

    private let settingsService: SettingsService
    private let widgetService: WidgetService
    private let persistenceService: PersistenceService

    private var disposables: Set<AnyCancellable> = []

    let localization: AppLocalization

    // MARK: - Initialization

    init() {
        self.widgetService = .init()
        self.persistenceService = .init()
        self.settingsService = .init(userDefaults: .standard, persistenceService: self.persistenceService)
        self.localization = AppLocalization(locale: .current)
        self.model = ApplicationModel(persistenceService: self.persistenceService, appLocalization: self.localization)
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
        DataProvider(formatter: ForecastDateFormatter(localization: self.localization))
    }

}

extension Notification.Name {
    static let syncStatusDidChange = Notification.Name("syncStatusDidChange")
}

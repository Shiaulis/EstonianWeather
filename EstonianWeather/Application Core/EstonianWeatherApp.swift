//
//  EstonianWeatherApp.swift
//  EstonianWeather
//
//  Created by Andrius Shiaulis on 28.09.2020.
//

import SwiftUI

private enum AppMode {
    case unitTesting
    case regular
}

@main
struct EstonianWeatherApp: App {

    private let appMode: AppMode

    init() {
        let isUnitTesting = ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
        self.appMode = isUnitTesting ? .unitTesting : .regular
    }

    private var isUnitTesting: Bool { ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil }

    private let applicationController = ApplicationController()

    var body: some Scene {
        WindowGroup {
            switch self.appMode {
            case .unitTesting:
                Text(R.string.localizable.unitTestingMode())
            case .regular:
                tabbarView()
            }
        }
    }

    private func tabbarView() -> TabbarView {
        TabbarView(
            forecastListView: ForecastListView(
                viewModel: ForecastListViewModel(model:self.applicationController.model)
            ),
            settingsView: SettingsView(
                viewModel: SettingsViewModel(ratingService: self.applicationController.ratingService)
            )
        )
    }
}

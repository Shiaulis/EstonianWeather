//
//  EstonianWeatherApp.swift
//  EstonianWeather
//
//  Created by Andrius Shiaulis on 28.09.2020.
//

import SwiftUI

@main
struct EstonianWeatherApp: App {

    private var isUnitTesting: Bool { ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil }

    private let applicationController = ApplicationController()

    var body: some Scene {
        WindowGroup {
            if !self.isUnitTesting {
                TabbarView(
                    forecastListView: ForecastListView(
                        viewModel: ForecastListViewModel(model:self.applicationController.model)
                    ),
                    settingsView: SettingsView(
                        viewModel: SettingsViewModel(ratingService: self.applicationController.ratingService)
                    )
                )
            }
            else {
                AnyView(Text(R.string.localizable.unitTestingMode()))
            }
        }
    }
}

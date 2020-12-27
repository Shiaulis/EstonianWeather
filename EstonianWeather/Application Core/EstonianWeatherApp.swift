//
//  EstonianWeatherApp.swift
//  EstonianWeather
//
//  Created by Andrius Shiaulis on 28.09.2020.
//

import SwiftUI

enum ApplicationMode {
    case unitTests, uiKit, swiftUI
}

@main
struct EstonianWeatherApp: App {

    private let applicationController = ApplicationController()

    var body: some Scene {
        WindowGroup {
            if self.applicationController.applicationMode != .unitTests {
                TabbarView(
                    forecastListView: ForecastListView(viewModel: ForecastListViewModel(model:applicationController.model)),
                    settingsView: SettingsView(viewModel: SettingsViewModel())
                )
            }
            else {
                AnyView(Text(R.string.localizable.unitTestingMode()))
            }
        }
    }
}

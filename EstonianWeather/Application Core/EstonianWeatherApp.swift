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
    private func clearLaunchScreenCache() {
        do {
            try FileManager.default.removeItem(atPath: NSHomeDirectory()+"/Library/SplashBoard")
        } catch {
            print("Failed to delete launch screen cache: \(error)")
        }
    }

    private func delayLaunch() {
        try? FileManager.default.removeItem(atPath: NSHomeDirectory()+"/Library/SplashBoard")

        do {
            sleep(2)
        }
    }

    var body: some Scene {
        WindowGroup {
            if self.applicationController.applicationMode != .unitTests {
                TabbarView(
                    forecastListView: ForecastListView(viewModel: ForecastListViewModel(model:self.applicationController.model)),
                    settingsView: SettingsView(viewModel: SettingsViewModel(ratingService: self.applicationController.ratingService))
                )
                .onAppear {
                    clearLaunchScreenCache()
                    delayLaunch()
                }
            }
            else {
                AnyView(Text(R.string.localizable.unitTestingMode()))
            }
        }
    }
}

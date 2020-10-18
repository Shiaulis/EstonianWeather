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

protocol ApplicationViewModel {
    var applicationMode: ApplicationMode { get }
    func forecastDataProvider() -> DataProvider
    var settingsService: SettingsService { get }
}

@main
struct EstonianWeatherApp: App {
    private func tabbarView() -> TabbarView {
        let applicationViewModel: ApplicationViewModel = ApplicationController()
        let dataProvider = applicationViewModel.forecastDataProvider()
        let forecastViewModel = ForecastListController(dataProvider: dataProvider, settingsService: applicationViewModel.settingsService)
        let forecastListView = ForecastListView(viewModel: forecastViewModel)
        let observationViewModel = ObservationListController(dataProvider: dataProvider)
        let observationListView = ObservationListView(viewModel: observationViewModel)
        let settingsView = SettingsView(viewModel: SettingsViewModel(settingsService: applicationViewModel.settingsService))
        let tabbarView = TabbarView(
            observationListView: observationListView,
            forecastListView: forecastListView,
            settingsView: settingsView
        )

        return tabbarView
    }

    var body: some Scene {
        WindowGroup {
            tabbarView()
        }
    }
}

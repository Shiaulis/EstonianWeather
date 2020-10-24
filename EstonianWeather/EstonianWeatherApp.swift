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
    private func tabbarView() -> some View {
        let applicationViewModel: ApplicationViewModel = ApplicationController()
        guard applicationViewModel.applicationMode != .unitTests else {
            return AnyView(Text("Unit testing mode"))
        }
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

        return AnyView(tabbarView)
    }

    var body: some Scene {
        WindowGroup {
            tabbarView()
        }
    }
}

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
    private func tabbarView() -> some View {
        let applicationViewModel: ApplicationViewModel = ApplicationController()
        guard applicationViewModel.applicationMode != .unitTests else {
            return AnyView(Text("Unit testing mode"))
        }
        let dataProvider = applicationViewModel.forecastDataProvider()
        let forecastViewModel = ForecastListController(dataProvider: dataProvider, appViewModel: applicationViewModel)
        let forecastListView = ForecastListView(viewModel: forecastViewModel)
        let observationViewModel = ObservationListController(dataProvider: dataProvider)
        let observationListView = ObservationListView(viewModel: observationViewModel)
        let settingsView = SettingsView(viewModel: SettingsViewModel(appViewModel: applicationViewModel))
        let tabbarView = TabbarView(
            observationListView: observationListView,
            forecastListView: forecastListView,
            settingsView: settingsView,
            appViewModel: applicationViewModel
        )

        return AnyView(tabbarView)
    }

    var body: some Scene {
        WindowGroup {
            tabbarView()
        }
    }
}

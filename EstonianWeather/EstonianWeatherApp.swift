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
    func forecastDataProvider() -> ForecastDataProvider
}

@main
struct EstonianWeatherApp: App {
    private func tabbarView() -> TabbarView {
        let applicationViewModel: ApplicationViewModel = ApplicationController()
        let dataProvider = applicationViewModel.forecastDataProvider()
        let viewModel = ForecastController(dataProvider: dataProvider)
        let forecastListView = ForecastListView(viewModel: viewModel)
        let settingsView = SettingsView()
        let tabbarView = TabbarView(forecastListView: forecastListView, settingsView: settingsView)

        return tabbarView
    }

    var body: some Scene {
        WindowGroup {
            tabbarView()
        }
    }
}

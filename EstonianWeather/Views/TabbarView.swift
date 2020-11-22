//
//  TabbarView.swift
//  EstonianWeather
//
//  Created by Andrius Shiaulis on 02.03.2020.
//  Copyright © 2020 Andrius Shiaulis. All rights reserved.
//

import SwiftUI

enum Tab {
    case observationList, forecastList, settings

    private var imageName: String {
        switch self {
        case .observationList: return "thermometer"
        case .forecastList: return "smoke.fill"
        case .settings: return "gear"
        }
    }

    private var title: LocalizedStringKey {
        switch self {
        case .observationList: return "observations"
        case .forecastList: return "forecast"
        case .settings: return "settings"
        }
    }

    func item() -> some View {
        VStack {
            Image(systemName: self.imageName)
            Text(self.title)
        }
    }
}

struct TabbarView: View {

    init(
        observationListView: ObservationListView<ObservationListController>,
        forecastListView: ForecastListView<ForecastListController>,
        settingsView: SettingsView,
        appViewModel: ApplicationViewModel
    ) {
        self.observationListView = observationListView
        self.forecastListView = forecastListView
        self.settingsView = settingsView
        self.appViewModel = appViewModel
    }

    private let observationListView: ObservationListView<ObservationListController>
    private let forecastListView: ForecastListView<ForecastListController>
    private let settingsView: SettingsView
    private let appViewModel: ApplicationViewModel

    var body: some View {
        TabView {
            if self.appViewModel.isFeatureEnabled(.observations) {
                self.observationListView.tabItem { Tab.observationList.item() }
            }
            self.forecastListView.tabItem { Tab.forecastList.item() }
            self.settingsView.tabItem { Tab.settings.item() }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct TabbarView_Previews: PreviewProvider {
    static var previews: some View {
        TabbarView(
            observationListView: ObservationListView(viewModel: ObservationListController()),
            forecastListView: ForecastListView(viewModel: ForecastListController(appViewModel: MockApplicationViewModel())),
            settingsView: SettingsView(viewModel: SettingsViewModel(appViewModel: MockApplicationViewModel())),
            appViewModel: MockApplicationViewModel()
        )
    }
}

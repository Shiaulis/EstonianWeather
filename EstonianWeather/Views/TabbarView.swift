//
//  TabbarView.swift
//  EstonianWeather
//
//  Created by Andrius Shiaulis on 02.03.2020.
//  Copyright © 2020 Andrius Shiaulis. All rights reserved.
//

import SwiftUI
import WeatherKit

enum Tab {
    case observationList, forecastList, settings

    private var imageName: String {
        switch self {
        case .observationList: return "thermometer"
        case .forecastList: return "smoke.fill"
        case .settings: return "gear"
        }
    }

    private var title: String {
        switch self {
        case .observationList: return R.string.localizable.observations()
        case .forecastList: return R.string.localizable.forecast()
        case .settings: return R.string.localizable.settings()
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

    private let forecastListView: ForecastListView
    private let settingsView: SettingsView

    init(forecastListView: ForecastListView, settingsView: SettingsView) {
        self.forecastListView = forecastListView
        self.settingsView = settingsView
    }

    var body: some View {
        TabView {
            self.forecastListView.tabItem { Tab.forecastList.item() }
            self.settingsView.tabItem { Tab.settings.item() }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct TabbarView_Previews: PreviewProvider {
    static var previews: some View {
        TabbarView(
            forecastListView: ForecastListView(
                viewModel: ForecastListViewModel(
                    model: NetwokWeatherModel(
                        weatherLocale: .english,
                        responseParser: SWXMLResponseParser(),
                        networkClient: URLSessionNetworkClient()
                    )
                )
            ),
            settingsView: SettingsView(viewModel: SettingsViewModel(ratingService: AppStoreRatingService(userDefaults: .standard)))
        )
    }
}

//
//  TabbarView.swift
//  EstonianWeather
//
//  Created by Andrius Shiaulis on 02.03.2020.
//  Copyright © 2020 Andrius Shiaulis. All rights reserved.
//

import SwiftUI

enum Tab {
    case forecastList, settings

    private var imageName: String {
        switch self {
        case .forecastList: return "smoke.fill"
        case .settings: return "gear"
        }
    }

    private var title: LocalizedStringKey {
        switch self {
        case .forecastList: return "Forecast"
        case .settings: return "Settings"
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

    init(forecastListView: ForecastListView<ForecastListController>, settingsView: SettingsView) {
        self.forecastListView = forecastListView
        self.settingsView = settingsView
    }

    let forecastListView: ForecastListView<ForecastListController>
    let settingsView: SettingsView

    var body: some View {
        TabView {
            self.forecastListView.tabItem { Tab.forecastList.item() }
            self.settingsView.tabItem { Tab.settings.item() }
        }
    }
}

struct TabbarView_Previews: PreviewProvider {
    static var previews: some View {
        TabbarView(forecastListView: ForecastListView(viewModel: ForecastListController()), settingsView: SettingsView())
    }
}

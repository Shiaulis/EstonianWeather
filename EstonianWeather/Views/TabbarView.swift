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
        settingsView: SettingsView
    ) {
        self.observationListView = observationListView
        self.forecastListView = forecastListView
        self.settingsView = settingsView
    }

    private let observationListView: ObservationListView<ObservationListController>
    private let forecastListView: ForecastListView<ForecastListController>
    private let settingsView: SettingsView

    var body: some View {
        TabView {
            self.observationListView.tabItem { Tab.observationList.item() }
            self.forecastListView.tabItem { Tab.forecastList.item() }
            self.settingsView.tabItem { Tab.settings.item() }
        }
    }
}

struct TabbarView_Previews: PreviewProvider {
    static var previews: some View {
        TabbarView(
            observationListView: ObservationListView(viewModel: ObservationListController()),
            forecastListView: ForecastListView(viewModel: ForecastListController(appViewModel: MockApplicationViewModel())),
            settingsView: SettingsView(viewModel: SettingsViewModel(appViewModel: MockApplicationViewModel())))
    }
}

struct NavigationBarModifier: ViewModifier {

    var backgroundColor: UIColor?

    init( backgroundColor: UIColor?) {
        self.backgroundColor = backgroundColor
        let coloredAppearance = UINavigationBarAppearance()
        coloredAppearance.configureWithTransparentBackground()
        coloredAppearance.backgroundColor = .clear
        coloredAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        coloredAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

        UINavigationBar.appearance().standardAppearance = coloredAppearance
        UINavigationBar.appearance().compactAppearance = coloredAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
        UINavigationBar.appearance().tintColor = .white

    }

    func body(content: Content) -> some View {
        ZStack {
            content
            VStack {
                GeometryReader { geometry in
                    Color(self.backgroundColor ?? .clear)
                        .frame(height: geometry.safeAreaInsets.top)
                        .edgesIgnoringSafeArea(.top)
                    Spacer()
                }
            }
        }
    }
}

extension View {

    func navigationBarColor(_ backgroundColor: UIColor?) -> some View {
        self.modifier(NavigationBarModifier(backgroundColor: backgroundColor))
    }

}

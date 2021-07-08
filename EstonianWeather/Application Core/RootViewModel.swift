//
//  RootViewModel.swift
//  EstonianWeather
//
//  Created by Andrius Siaulis on 10.07.2021.
//

import Foundation
import WeatherKit
import Combine

final class RootViewModel {

    // MARK: - Properties
    @Published var selectedTab: Tab = .forecastList

    let forecastListViewModel: ForecastListViewModel
    let settingsViewModel: SettingsViewModel
    private let userDefaults: UserDefaults

    // MARK: - Init

    init() {
        let userDefaults = UserDefaults.standard
        let ratingService = AppStoreRatingService(userDefaults: userDefaults)

        self.forecastListViewModel = ForecastListViewModel(model: Self.weatherModel())
        self.settingsViewModel = SettingsViewModel(ratingService: ratingService)
        self.userDefaults = userDefaults

        storeVersionAndBuildNumberToUserDefaults()
        ratingService.incrementLauchCounter()
    }

    // MARK: - Private methods

    private func storeVersionAndBuildNumberToUserDefaults() {
        if let version = Bundle.main.string(for: .bundleShortVersionString) {
            self.userDefaults.set(version, for: .version_preference)
        }

        if let build: String = Bundle.main.string(for: .bundleVersion) {
            self.userDefaults.set(build, for: .build_preference)
        }
    }

    // MARK: Private static properties

    private static func weatherModel() -> WeatherModel {
        NetwokWeatherModel(
            weatherLocale: WeatherLocale(locale: .current) ?? .english,
            responseParser: SWXMLResponseParser(logger: .init(category: .weatherModel)),
            networkClient: URLSessionNetworkClient()
        )
    }

}

extension RootViewModel: SidebarViewModel {

    var selectedTabPublisher: AnyPublisher<Tab, Never> { self.$selectedTab.eraseToAnyPublisher() }

    func select(_ tab: Tab) {
        self.selectedTab = tab
    }

}

extension RootViewModel: TabbarViewModel {

    func didSwitchTo(_ tab: Tab) {
        self.selectedTab = tab
    }

}

private extension WeatherLocale {
    init?(locale: Locale) {
        switch locale.languageCode {
        case "en": self = .english
        case "ru": self = .russian
        case "et": self = .estonian
        default:
            assertionFailure("Other locale is not expected")
            return nil
        }
    }
}

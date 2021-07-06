//
//  EstonianWeatherApp.swift
//  EstonianWeather
//
//  Created by Andrius Shiaulis on 28.09.2020.
//

import SwiftUI
import Logger
import WeatherKit

private enum AppMode {
    case unitTesting
    case regular
}

@main
struct EstonianWeatherApp: App {

    // MARK: - Properties

    private let appMode: AppMode
    private let weatherModel: WeatherModel
    private let userDefaults: UserDefaults
    private let ratingService: AppStoreRatingService

    // MARK: - Initialization

    init() {
        let isUnitTesting = ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
        self.appMode = isUnitTesting ? .unitTesting : .regular
        self.weatherModel = Self.weatherModel()
        self.userDefaults = .standard
        self.ratingService = .init(logger: PrintLogger(moduleName: "ratingService"))
    }

    // MARK: - Body

    var body: some Scene {
        WindowGroup {
            switch self.appMode {
            case .unitTesting:
                Text(R.string.localizable.unitTestingMode())
            case .regular:
                tabbarView()
            }
        }
    }

    // MARK: - Private methods

    private func tabbarView() -> TabbarView {
        TabbarView(
            forecastListView: ForecastListView(
                viewModel: ForecastListViewModel(model:self.weatherModel)
            ),
            settingsView: SettingsView(
                viewModel: SettingsViewModel(ratingService: self.ratingService)
            )
        )
    }

    private func storeVersionAndBuildNumberToUserDefaults() {
        if let version = Bundle.main.string(for: .bundleShortVersionString) {
            self.userDefaults.set(version, forKey: "version_preference")
        }

        if let build: String = Bundle.main.string(for: .bundleVersion) {
            self.userDefaults.set(build, forKey: "build_preference")
        }
    }

    private static func weatherModel() -> WeatherModel {
        NetwokWeatherModel(
            weatherLocale: WeatherLocale(locale: .current) ?? .english,
            responseParser: SWXMLResponseParser(),
            networkClient: URLSessionNetworkClient()
        )
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

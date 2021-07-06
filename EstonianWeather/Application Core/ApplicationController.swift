//
//  ApplicationController.swift
//  EstonianWeather
//
//  Created by Andrius Shiaulis on 02.03.2020.
//  Copyright © 2020 Andrius Shiaulis. All rights reserved.
//

import Combine
import UIKit
import CoreData
import Logger
import WeatherKit

final class ApplicationController {

    // MARK: - Properties

    let model: WeatherModel
    let ratingService: AppStoreRatingService

    private let widgetService: WidgetService
    private let userDefaults: UserDefaults

    private var disposables: Set<AnyCancellable> = []

    // MARK: - Initialization

    init() {
        self.widgetService = .init()
        self.ratingService = .init(logger: PrintLogger(moduleName: "ratingService"))
        self.userDefaults = .standard
        self.model = NetwokWeatherModel(
            weatherLocale: WeatherLocale(locale: .current) ?? .english,
            responseParser: SWXMLResponseParser(),
            networkClient: URLSessionNetworkClient())

        self.ratingService.incrementLauchCounter()

        storeVersionAndBuildNumberToUserDefaults()
    }

    private func storeVersionAndBuildNumberToUserDefaults() {
        if let version = Bundle.main.string(for: .bundleShortVersionString) {
            self.userDefaults.set(version, forKey: "version_preference")
        }

        if let build: String = Bundle.main.string(for: .bundleVersion) {
            self.userDefaults.set(build, forKey: "build_preference")
        }
    }

}

extension WeatherLocale {
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

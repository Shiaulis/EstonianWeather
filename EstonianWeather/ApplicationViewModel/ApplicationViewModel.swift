//
//  ApplicationViewModel.swift
//  EstonianWeather
//
//  Created by Andrius Shiaulis on 24.10.2020.
//

import Foundation

protocol ApplicationViewModel: SettingsApplicationViewModel {
    var applicationMode: ApplicationMode { get }

    func forecastDataProvider() -> DataProvider

    func isFeatureEnabled(_ featureFlag: FeatureFlag) -> Bool
}

protocol SettingsApplicationViewModel {
    var appLocalization: AppLocalization { get }
    func openApplicationSettings()
}

final class MockApplicationViewModel: ApplicationViewModel {

    var applicationMode: ApplicationMode = .swiftUI
    var appLocalization: AppLocalization = .english

    func forecastDataProvider() -> DataProvider { .init() }
    func openApplicationSettings() {}
    func isFeatureEnabled(_ featureFlag: FeatureFlag) -> Bool { false }
}

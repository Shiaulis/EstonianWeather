//
//  ApplicationViewModel.swift
//  EstonianWeather
//
//  Created by Andrius Shiaulis on 24.10.2020.
//

import Foundation
import CoreData

protocol ApplicationViewModel: SettingsApplicationViewModel {
    var applicationMode: ApplicationMode { get }
    var syncStatus: SyncStatus { get }
    var viewContext: NSManagedObjectContext { get }

    func forecastDataProvider() -> DataProvider
    func isFeatureEnabled(_ featureFlag: FeatureFlag) -> Bool
}

protocol SettingsApplicationViewModel {
    var appLocalization: AppLocalization { get }
    func openApplicationSettings()
    func openDisclaimerURL()
}

final class MockApplicationViewModel: ApplicationViewModel {

    var viewContext: NSManagedObjectContext = .init(concurrencyType: .mainQueueConcurrencyType)
    var syncStatus: SyncStatus = .failed("error")
    var applicationMode: ApplicationMode = .swiftUI
    var appLocalization: AppLocalization = .english

    func forecastDataProvider() -> DataProvider { .init() }
    func openApplicationSettings() {}
    func isFeatureEnabled(_ featureFlag: FeatureFlag) -> Bool { false }
    func openDisclaimerURL() {}
}

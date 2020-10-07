//
//  SettingsService.swift
//  EstonianWeather
//
//  Created by Andrius Shiaulis on 04.10.2020.
//

import Foundation
import UIKit

final class SettingsService {

    let appLocalization: AppLocalization
    private let userDefaults: UserDefaults
    private let coreDataStack: CoreDataStack

    init(userDefaults: UserDefaults = .standard, coreDataStack: CoreDataStack = .init(), locale: Locale = .current) {
        self.userDefaults = userDefaults
        self.coreDataStack = coreDataStack
        self.appLocalization = AppLocalization(locale: locale) ?? .english

        checkAndExecuteSettings()
        setVersionAndBuildNumber()
    }

    func checkAndExecuteSettings() {
        if self.userDefaults.bool(forKey: SettingsBundleKeys.Reset) {
            self.userDefaults.set(false, forKey: SettingsBundleKeys.Reset)
            let appDomain: String? = Bundle.main.bundleIdentifier
            self.userDefaults.removePersistentDomain(forName: appDomain!)
            self.coreDataStack.recreateDatabase()
        }
    }

    func setVersionAndBuildNumber() {
        if let version: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String {
            self.userDefaults.set(version, forKey: "version_preference")
        }
        if let build: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String {
            self.userDefaults.set(build, forKey: "build_preference")
        }
    }

    func openApplicationSettings() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {
            assertionFailure("Unable to construct settings URL")
            return
        }

        UIApplication.shared.open(settingsURL, options: [:])
    }

}

extension SettingsService {

    private struct SettingsBundleKeys {
        static let Reset = "RESET_APP_KEY"
        static let BuildVersionKey = "build_preference"
        static let AppVersionKey = "version_preference"
    }

}

private extension AppLocalization {

    init?(locale: Locale) {
        switch locale.languageCode {
        case "en": self = .english
        case "ru": self = .russian
        case "et": self = .estonian
        case "uk": self = .ukrainian

        default:
            assertionFailure("Locale \(locale.languageCode ?? "") is not implemented")
            return nil
        }
    }
}

//
//  SettingsService.swift
//  EstonianWeather
//
//  Created by Andrius Shiaulis on 04.10.2020.
//

import Foundation

/// This service provide information for settings in globad device settings. Values are taken from Settings.bundle
final class SettingsService {

    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults

        checkAndExecuteSettings()
        setVersionAndBuildNumber()
    }

    func checkAndExecuteSettings() {
        if self.userDefaults.bool(forKey: SettingsBundleKeys.Reset) {
            self.userDefaults.set(false, forKey: SettingsBundleKeys.Reset)
            let appDomain: String? = Bundle.main.bundleIdentifier
            self.userDefaults.removePersistentDomain(forName: appDomain!)
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

}

extension SettingsService {

    private struct SettingsBundleKeys {
        static let Reset = "RESET_APP_KEY"
        static let BuildVersionKey = "build_preference"
        static let AppVersionKey = "version_preference"
    }

}

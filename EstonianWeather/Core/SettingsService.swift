//
//  SettingsService.swift
//  EstonianWeather
//
//  Created by Andrius Shiaulis on 04.10.2020.
//

import Foundation

final class SettingsService {

    private let userDefaults: UserDefaults
    private let coreDataStack: CoreDataStack

    init(userDefaults: UserDefaults, coreDataStack: CoreDataStack) {
        self.userDefaults = userDefaults
        self.coreDataStack = coreDataStack

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

}

extension SettingsService {

    private struct SettingsBundleKeys {
        static let Reset = "RESET_APP_KEY"
        static let BuildVersionKey = "build_preference"
        static let AppVersionKey = "version_preference"
    }

}

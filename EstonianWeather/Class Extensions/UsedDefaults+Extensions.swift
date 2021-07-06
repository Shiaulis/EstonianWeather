//
//  UsedDefaults+Extensions.swift
//  EstonianWeather
//
//  Created by Andrius Siaulis on 06.07.2021.
//

import Foundation

// swiftlint:disable identifier_name
extension UserDefaults {

    enum Keys: String {
        // used for rating service
        case processCompletedCount, lastVersionPromptedForReview

        // used for settings
        case version_preference, build_preference
    }

    // MARK: - Getters

    func integer(for key: Keys) -> Int {
        self.integer(forKey: key.rawValue)
    }

    func string(for key: Keys) -> String? {
        self.string(forKey: key.rawValue)
    }

    // MARK: - Setters

    func set(_ integerValue: Int, for key: Keys) {
        self.set(integerValue, forKey: key.rawValue)
    }

    func set(_ stringValue: String, for key: Keys) {
        self.set(stringValue, forKey: key.rawValue)
    }

}
// swiftlint:enable identifier_name

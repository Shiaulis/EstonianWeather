//
//  FeatureFlagService.swift
//  EstonianWeather
//
//  Created by Andrius Shiaulis on 24.10.2020.
//

import Foundation

enum FeatureFlag: String {
    case observations

    fileprivate var key: String { self.rawValue }
}

protocol FeatureFlagStorage {
    func value(for feature: FeatureFlag) -> Bool?
}

final class FeatureFlagService {

    static private(set) var shared: FeatureFlagService = {
        FeatureFlagService(storage: RuntimeFeatureFlagStorage())
    }()

    private let storage: FeatureFlagStorage

    init(storage: FeatureFlagStorage) {
        self.storage = storage
    }

    func isEnabled(_ featureFlag: FeatureFlag) -> Bool {
        self.storage.value(for: featureFlag) ?? false
    }

    private func fetchValue(for key: String, from storage: FeatureFlagStorage) {

    }
}

final class RuntimeFeatureFlagStorage: FeatureFlagStorage {

    func value(for feature: FeatureFlag) -> Bool? {
        switch feature {
        case .observations:
            return false
        }
    }
}

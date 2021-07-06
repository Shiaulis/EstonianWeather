//
//  Bundle+Extensions.swift
//  EstonianWeather
//
//  Created by Andrius Siaulis on 06.07.2021.
//

import Foundation

public extension Bundle {

    enum Key: String {
        case bundleShortVersionString = "CFBundleShortVersionString"
        case bundleVersion = "CFBundleVersion"
    }

    func string(for key: Key) -> String? {
        self.object(forInfoDictionaryKey: key.rawValue) as? String
    }

}

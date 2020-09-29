//
//  AppLocalization.swift
//  EstonianWeather
//
//  Created by Andrius Shiaulis on 22.01.2020.
//  Copyright © 2020 Andrius Shiaulis. All rights reserved.
//

import Foundation

enum AppLocalization {

    // MARK: - Cases

    case english, russian, estonian

    // MARK: - Properties

    var languageCode: String {
        switch self {
        case .english: return "en"
        case .estonian: return "et"
        case .russian: return "ru"
        }
    }

    // MARK: - Initialization

    init?(locale: Locale) {
        switch locale.languageCode {
        case "en": self = .english
        case "ru": self = .russian
        case "et": self = .estonian

        default:
            assertionFailure("Locale is not implemented")
            return nil
        }
    }
}

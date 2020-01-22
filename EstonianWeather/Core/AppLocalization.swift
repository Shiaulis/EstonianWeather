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

    var sourceLink: URL {
        let link: String
        switch self {
        case .english:
            link = "http://www.ilmateenistus.ee/ilma_andmed/xml/forecast.php?lang=eng"
        case .estonian:
            link = "http://www.ilmateenistus.ee/ilma_andmed/xml/forecast.php"
        case .russian:
            link = "http://www.ilmateenistus.ee/ilma_andmed/xml/forecast.php?lang=rus"
        }

        return URL(string: link)!
    }

    var languageCode: String {
        switch self {
        case .english: return "en"
        case .estonian: return "et"
        case .russian: return "ru"
        }
    }

    // MARK: - Initialization

    init(locale: Locale) {
        switch locale.languageCode {
        case "en": self = .english
        case "ru": self = .russian
        case "et": self = .estonian

        default:
            assertionFailure("Locale is not implemented")
            self = .english
        }
    }
}

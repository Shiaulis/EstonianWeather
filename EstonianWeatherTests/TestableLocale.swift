//
//  TestableLocale.swift
//  EstonianWeatherTests
//
//  Created by Andrius Shiaulis on 10.10.2020.
//

import Foundation
@testable import EstonianWeather

enum TestableLocale: String {
    case english, estonian, russian, ukrainian

    static let current: TestableLocale = .init(from: .current)

    private init(from locale: Locale) {
        switch locale.languageCode {
        case "en": self = .english
        case "et": self = .estonian
        case "ru": self = .russian
        case "uk": self = .ukrainian
        default: fatalError("Language doesn't supported")
        }
    }

    var appLocalization: AppLocalization {
        switch self {
        case .english: return .english
        case .estonian: return .estonian
        case .russian: return .russian
        case .ukrainian: return .ukrainian
        }
    }
}

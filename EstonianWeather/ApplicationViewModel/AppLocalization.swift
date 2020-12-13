//
//  AppLocalization.swift
//  EstonianWeather
//
//  Created by Andrius Shiaulis on 22.01.2020.
//  Copyright © 2020 Andrius Shiaulis. All rights reserved.
//

import Foundation

enum AppLocalization: CaseIterable {

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

    var localizedString: String? { AppLocalization.locale.localizedString(forLanguageCode: self.languageCode) }

    var locale: Locale { AppLocalization.locale }
    static private(set) var current: AppLocalization = .english

    private static var locale: Locale = .current

    // MARK: - Init

    init(locale: Locale) {
        switch locale.languageCode {
        case "en":
            self = .english
            AppLocalization.locale = locale
        case "ru":
            self = .russian
            AppLocalization.locale = locale
        case "et":
            self = .estonian
            AppLocalization.locale = locale

        default:
            AppLocalization.locale = .init(identifier: "en")
            self = .english
        }

        AppLocalization.current = self
    }

}

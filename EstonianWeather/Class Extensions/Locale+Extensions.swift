//
//  Locale+Extensions.swift
//  EstonianWeather
//
//  Created by Andrius Shiaulis on 27.12.2020.
//

import Foundation

extension Locale {

    var localizedLanguageName: String {
        guard let languageCode = self.languageCode else {
            assertionFailure("Absense of language code is not expected")
            return ""
        }
        guard let languageName = self.localizedString(forLanguageCode: languageCode) else {
            assertionFailure("Is it possible to not find language name?")
            return ""
        }

        return languageName
    }

}

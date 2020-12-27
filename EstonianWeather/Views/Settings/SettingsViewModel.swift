//
//  SettingsViewModel.swift
//  EstonianWeather
//
//  Created by Andrius Shiaulis on 22.01.2020.
//  Copyright © 2020 Andrius Shiaulis. All rights reserved.
//

import UIKit

final class SettingsViewModel {

    // MARK: - Properties

    var currentLanguageName: String { self.locale.localizedString(forLanguageCode: self.locale.languageCode ?? "") ?? "" }

    let sourceDisclaimerText: String = R.string.localizable.sourceDisclaimer()
    let urlDescription: String = "www.ilmateenindus.ee"
    let sourceDisclaimerURL: URL = .sourceDisclaimerURL

    let iconDisclaimerText = R.string.localizable.iconDisclaimer()
    let iconURLDescription: String = "www.flaticon.com"
    let iconDisclaimerURL: URL = .iconDisclaimerURL

    private let locale: Locale = .current

    func openApplicationSettings() {
        UIApplication.shared.open(URL.settings, options: [:])
    }

    func openSourceDisclaimerURL() {
        UIApplication.shared.open(.sourceDisclaimerURL, options: [:])
    }
}

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

    var currentLanguageName: String { self.localization.localizedString ?? "" }

    let sourceDisclaimerText: String = R.string.localizable.sourceDisclaimer()
    let urlDescription: String = "www.ilmateenindus.ee"
    var sourceDisclaimerURL: URL { .sourceDisclaimerURL(for: self.localization) }

    let iconDisclaimerText = R.string.localizable.iconDisclaimer()
    let iconURLDescription: String = "www.flaticon.com"
    let iconDisclaimerURL: URL = .iconDisclaimerURL

    private let localization: AppLocalization

    init(localization: AppLocalization) {
        self.localization = localization
    }

    func openApplicationSettings() {
        UIApplication.shared.open(URL.settings, options: [:])
    }

    func openSourceDisclaimerURL() {
        UIApplication.shared.open(URL.sourceDisclaimerURL(for: self.localization), options: [:])
    }
}

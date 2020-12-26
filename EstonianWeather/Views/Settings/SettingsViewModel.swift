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

    var currentLanguageName: String { self.appViewModel.appLocalization.localizedString ?? "" }

    let sourceDisclaimerText: String = R.string.localizable.sourceDisclaimer()
    let urlDescription: String = "www.ilmateenindus.ee"
    var sourceDisclaimerURL: URL { Resource.URL.sourceDisclaimerURL(for: self.appViewModel.appLocalization) }

    let iconDisclaimerText = R.string.localizable.iconDisclaimer()
    let iconURLDescription: String = "www.flaticon.com"
    var iconDisclaimerURL: URL { Resource.URL.iconDisclaimerURL() }

    private let appViewModel: ApplicationViewModel

    init(appViewModel: ApplicationViewModel) {
        self.appViewModel = appViewModel
    }

    func openApplicationSettings() {
        self.appViewModel.openApplicationSettings()
    }

    func openSourceDisclaimerURL() {
        self.appViewModel.openSourceDisclaimerURL()
    }
}

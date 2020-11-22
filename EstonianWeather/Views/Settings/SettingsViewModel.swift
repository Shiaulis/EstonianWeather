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
    var disclaimerText: String { NSLocalizedString("source_disclaimer", comment: "") }
    var urlDescription: String { "https://ilmateenindus.ee" }

    var disclaimerURL: URL { Resource.URL.disclaimerURL(for: self.appViewModel.appLocalization) }

    private let appViewModel: ApplicationViewModel

    init(appViewModel: ApplicationViewModel) {
        self.appViewModel = appViewModel
    }

    func openApplicationSettings() {
        self.appViewModel.openApplicationSettings()
    }

    func openDisclaimerURL() {
        self.appViewModel.openDisclaimerURL()
    }
}

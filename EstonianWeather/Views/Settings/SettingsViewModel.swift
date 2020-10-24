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

    var currentLanguageName: String {
        self.appViewModel.appLocalization.localizedString ?? ""
    }

    private let appViewModel: ApplicationViewModel

    init(appViewModel: ApplicationViewModel) {
        self.appViewModel = appViewModel
    }

    func openApplicationSettings() {
        self.appViewModel.openApplicationSettings()
    }
}

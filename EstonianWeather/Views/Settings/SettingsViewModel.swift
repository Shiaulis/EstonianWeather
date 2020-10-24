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
        self.settingsService.appLocalization.localizedString ?? ""
    }

    private let settingsService: SettingsService

    init(settingsService: SettingsService = .init()) {
        self.settingsService = settingsService
    }

    func openApplicationSettings() {
        self.settingsService.openApplicationSettings()
    }
}

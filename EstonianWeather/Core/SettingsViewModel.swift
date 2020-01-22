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
        Locale.current.localizedString(forLanguageCode: "en") ?? ""
    }

    private let settingsURL = URL(string: UIApplication.openSettingsURLString)

    func openApplicationSettings() {
        guard let settingsURL = self.settingsURL else { return }
        UIApplication.shared.open(settingsURL, options: [:])
    }
}

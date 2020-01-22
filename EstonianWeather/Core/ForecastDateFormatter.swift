//
//  ForecastDateFormatter.swift
//  EstonianWeather
//
//  Created by Andrius Shiaulis on 22.01.2020.
//  Copyright © 2020 Andrius Shiaulis. All rights reserved.
//

import Foundation

final class ForecastDateFormatter {

    // MARK: - Properties

    private let locale: Locale

    // MARK: - Initialization

    init(locale: Locale) {
        self.locale = locale
    }

    // MARK: - Public

    func humanReadableDescription(for date: Date?) -> String? {
        guard let date = date else { return nil }

        let formatter: DateFormatter = .init()
        formatter.locale = self.locale
        formatter.timeStyle = .none
        formatter.dateStyle = .short
        formatter.doesRelativeDateFormatting = true

        let description = formatter.string(from: date)

        guard let firstCharacter = description.first else { return nil }
        guard firstCharacter.isLetter else { return nil }

        return description.capitalized
    }

    func dateString(from date: Date?) -> String? {
        guard let date = date else { return nil }

        let formatter: DateFormatter = .init()
        formatter.locale = self.locale
        formatter.setLocalizedDateFormatFromTemplate("dMMMM")

        return formatter.string(from: date)
    }

}

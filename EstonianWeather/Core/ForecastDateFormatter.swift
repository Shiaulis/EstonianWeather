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

    func humanReadableDescription(for date: Date?, calendar: Calendar = .current) -> String? {
        guard let date = date else { return nil }

        guard var humanReadableDescription = string(from: date, calendar: calendar, locale: self.locale) else { return nil }

        if let description = textDescription(from: date, calendar: calendar, locale: self.locale) {
            humanReadableDescription += ", \(description)"
        }

        return humanReadableDescription
    }

    func shortReadableDescription(for date: Date?, calendar: Calendar = .current) -> String? {
        guard let date = date else { return nil }

        let formatter: DateFormatter = .init()
        formatter.locale = locale
        formatter.calendar = calendar
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        formatter.doesRelativeDateFormatting = true

        return formatter.string(from: date)
    }

    private func textDescription(from date: Date, calendar: Calendar, locale: Locale) -> String? {
        let formatter: DateFormatter = .init()
        formatter.locale = locale
        formatter.calendar = calendar
        formatter.timeStyle = .none
        formatter.dateStyle = .short
        formatter.doesRelativeDateFormatting = true

        let description = formatter.string(from: date)

        guard let firstCharacter = description.first else { return nil }
        guard firstCharacter.isLetter else { return nil }

        return description.capitalized
    }

    private func string(from date: Date, calendar: Calendar, locale: Locale) -> String? {
        let formatter: DateFormatter = .init()
        formatter.locale = self.locale
        formatter.calendar = calendar
        formatter.setLocalizedDateFormatFromTemplate("dMMMM")

        return formatter.string(from: date)
    }

}

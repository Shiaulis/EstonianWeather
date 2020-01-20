//
//  ForecastController.swift
//  EstonianWeather
//
//  Created by Andrius Shiaulis on 17.01.2020.
//  Copyright © 2020 Andrius Shiaulis. All rights reserved.
//

import Foundation

final class ForecastController {

    // MARK: - Properties

    // MARK: - Init

    func displayItem(for forecast: Forecast) -> ForecastDisplayItem {
        .init(
            naturalDateDescription: "Today",
            date: dateString(from: forecast.forecastDate),
            dayParts: [forecast.night, forecast.day].compactMap { dayPartDisplayItem(for: $0) }
        )
    }

    // MARK: - Private

    private func dayPartDisplayItem(for dayPartForecast: DayPartForecast?) -> ForecastDisplayItem.DayPartForecastDisplayItem? {
        guard let dayPartForecast = dayPartForecast else { return nil }

        return ForecastDisplayItem.DayPartForecastDisplayItem(
            type: dayPartForecast.type ?? "",
            weatherIconName: weatherIconName(for: dayPartForecast.phenomenon) ?? "",
            temperatureRange: temperatureRangeSting(
                min: dayPartForecast.tempmin?.intValue,
                max: dayPartForecast.tempmax?.intValue) ?? "",
            description: dayPartForecast.text ?? "",
            places: dayPartForecast.places?
                .compactMap { placeDisplayItem(for: $0) } ?? []
        )
    }

    private func placeDisplayItem(for place: Place?) -> ForecastDisplayItem.DayPartForecastDisplayItem.PlaceDisplayItem? {
        guard let place = place else { return nil }

        return ForecastDisplayItem.DayPartForecastDisplayItem.PlaceDisplayItem(
            name: place.name ?? "",
            weatherIconName: weatherIconName(for: place.phenomenon) ?? "",
            temperature: temperatureRangeSting(
                min: place.tempmin?.intValue,
                max: place.tempmax?.intValue) ?? ""
        )
    }

    private func temperatureRangeSting(min: Int?, max: Int?) -> String? {
        switch (min, max) {
        case (.none, .some(let max)): return temperatureString(for: max)
        case (.some(let min), .none): return temperatureString(for: min)
        case (.none, .none): return nil
        case (.some(let min), .some(let max)): return "\(temperatureString(for: min))…\(temperatureString(for: max))"
        }
    }

    private func temperatureString(for value: Int) -> String {
        switch value {
        case 1...: return "+\(String(describing: value))"
        case 0: return "0"
        case (Int.min..<0): return "–\(String(describing: abs(Int32(value))))"
        default:
            assertionFailure("Should be unreachable")
            return ""
        }
    }

    private func dateString(from date: Date?) -> String {
        guard let date = date else { return "" }
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.setLocalizedDateFormatFromTemplate("dMMMM")
        
        return formatter.string(from: date)
    }

    private func weatherIconName(for phenomenon: Phenomenon?) -> String? {
        guard let phenomenon = phenomenon else { return nil }

        let weatherType = WeatherType(phenomenon: phenomenon)

        return weatherType?.imageName
    }
}

//
//  ForecastDataProvider.swift
//  EstonianWeather
//
//  Created by Andrius Shiaulis on 17.01.2020.
//  Copyright © 2020 Andrius Shiaulis. All rights reserved.
//

import Foundation
import CoreData
import Combine

final class ForecastDataProvider {

    // MARK: - Properties

    private let formatter: ForecastDateFormatter = .init(locale: .current)

    // MARK: - Public

    func provide(with context: NSManagedObjectContext, for localization: AppLocalization) -> Result<[ForecastDisplayItem], Error> {
        let request: NSFetchRequest<Forecast> = NSFetchRequest<Forecast>(entityName: "Forecast")

        request.predicate = .init(format:"%K = %@",
                                  #keyPath(Forecast.languageCode),
                                  localization.languageCode)

        request.sortDescriptors = [
            .init(key: #keyPath(Forecast.forecastDate), ascending: true)
        ]

        let result: [Forecast]
        do {
            result = try context.fetch(request)
        }
        catch {
            return .failure(error)
        }

        let displayItems = result.map { self.displayItem(for: $0) }

        return .success(displayItems)
    }

    // MARK: - Private

    private func displayItem(for forecast: Forecast) -> ForecastDisplayItem {
        .init(
            naturalDateDescription: self.formatter.humanReadableDescription(for: forecast.forecastDate) ?? "",
            dayParts: [forecast.night, forecast.day].compactMap { dayPartDisplayItem(for: $0) }
        )
    }

    private func dayPartDisplayItem(for dayPartForecast: DayPartForecast?) -> ForecastDisplayItem.DayPartForecastDisplayItem? {
        guard let dayPartForecast = dayPartForecast else { return nil }

        return ForecastDisplayItem.DayPartForecastDisplayItem(
            type: dayPartForecast.type?.capitalized ?? "",
            weatherIconName: weatherIconName(for: dayPartForecast.phenomenon) ?? "",
            weatherDescription: dayPartForecast.phenomenon?.name ?? "",
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
        let string: String
        switch (min, max) {
        case (.none, .some(let max)): string = temperatureString(for: max)
        case (.some(let min), .none): string = temperatureString(for: min)
        case (.none, .none): return nil
        case (.some(let min), .some(let max)): string = "\(temperatureString(for: min))…\(temperatureString(for: max))"
        }

        return "\(string) ℃"
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

    func weatherIconName(for phenomenon: Phenomenon?) -> String? {
        guard let phenomenon = phenomenon else { return nil }

        let weatherType = WeatherType(phenomenon: phenomenon)

        return weatherType?.imageName
    }
}

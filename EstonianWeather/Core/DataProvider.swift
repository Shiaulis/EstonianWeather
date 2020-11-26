//
//  DataProvider.swift
//  EstonianWeather
//
//  Created by Andrius Shiaulis on 17.01.2020.
//  Copyright © 2020 Andrius Shiaulis. All rights reserved.
//

import Foundation
import CoreData
import Combine

final class DataProvider {

    // MARK: - Properties

    private let formatter: ForecastDateFormatter = .init(localization: .current)

    // MARK: - Public

    func provideObservations(with context: NSManagedObjectContext) -> Result<[ObservationDisplayItem], Error> {
        let request: NSFetchRequest<Observation> = Observation.fetchRequest()
        request.sortDescriptors = [.init(key: #keyPath(Observation.stationName), ascending: true)]

        let result: [Observation]
        do {
            result = try context.fetch(request)
        }
        catch {
            return .failure(error)
        }

        let displayItems = result.map { self.displayItem(for: $0) }

        return .success(displayItems)
    }

    func provideForecast(with context: NSManagedObjectContext, for localization: AppLocalization) -> Result<[ForecastDisplayItem], Error> {
        let request: NSFetchRequest<Forecast> = Forecast.fetchRequest()
        request.predicate = .init(format:"%K = %@", #keyPath(Forecast.languageCode), localization.languageCode)
        request.sortDescriptors = [.init(key: #keyPath(Forecast.forecastDate), ascending: true)]

        var result: [Forecast]?
        var contextError: Swift.Error?
        context.performAndWait {
            do {
                result = try context.fetch(request)
            }
            catch {
                contextError = error
            }
        }

        if let contextError = contextError {
            return .failure(contextError)
        }

        let displayItems = result?.compactMap { self.displayItem(for: $0) } ?? []

        return .success(displayItems)
    }

    // MARK: - Private

    private func displayItem(for observation: Observation) -> ObservationDisplayItem {
        .init(name: observation.stationName ?? "")
    }

    private func displayItem(for forecast: Forecast) -> ForecastDisplayItem {
        .init(
            naturalDateDescription: self.formatter.humanReadableDescription(for: forecast.forecastDate) ?? "",
            shortDateDescription: self.formatter.shortReadableDescription(for: forecast.forecastDate) ?? "",
            day: dayPartDisplayItem(
                for: forecast.day,
                shortDateDescription: self.formatter.shortReadableDescription(for: forecast.forecastDate) ?? ""
            ),
            night: dayPartDisplayItem(
                for: forecast.night,
                shortDateDescription: self.formatter.shortReadableDescription(for: forecast.forecastDate) ?? ""
            )
        )
    }

    private func dayPartDisplayItem(
        for dayPartForecast: DayPartForecast?,
        shortDateDescription: String = "") -> ForecastDisplayItem.DayPartForecastDisplayItem? {
        guard let dayPartForecast = dayPartForecast else { return nil }

        return ForecastDisplayItem.DayPartForecastDisplayItem(
            shortDateDescription: shortDateDescription,
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
        case (.some(let min), .some(let max)): string = "\(temperatureString(for: min)) | \(temperatureString(for: max))"
        }

        return string
    }

    private func temperatureString(for value: Int) -> String {
        switch value {
        case 1...: return "\(String(describing: value))°"
        case 0: return "0°"
        case (Int.min..<0): return "-\(String(describing: abs(Int32(value))))°"
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

//
//  DataMapper.swift
//  EstonianWeather
//
//  Created by Andrius Shiaulis on 12.01.2020.
//  Copyright © 2020 Andrius Shiaulis. All rights reserved.
//

import Foundation
import CoreData

final class DataMapper {

    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func performMapping(_ documentToMap: EWDocument) {
        map(documentToMap)

        self.context.perform {
            do {
                try self.context.save()
            }
            catch {
                assertionFailure()
            }
        }
    }

    private func map(_ documentToMap: EWDocument) {
        let forecastResponse = ForecastResponse(context: self.context)
        forecastResponse.date = documentToMap.serviceInfo.date
        forecastResponse.language = documentToMap.serviceInfo.languageCode

        guard let forecastsToMap = documentToMap.forecasts else { return }

        var mappedForecasts: [Forecast] = []
        for forecastToMap in forecastsToMap {
            let mappedForecast = map(forecastToMap)
            mappedForecasts.append(mappedForecast)
        }

        forecastResponse.forecasts = NSSet(array: mappedForecasts)
    }

    private func existingForecast(for forecastToMap: EWDocument.EWForecast) -> Forecast? {
        guard let requestedDate = forecastToMap.date else { return nil }

        let request: NSFetchRequest<Forecast> = Forecast.fetchRequest()
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(Forecast.date), requestedDate as NSDate)

        return fetchFromContext(request: request)
    }

    private func existingPhenomenon(for phenomenonToMap: EWDocument.EWForecast.EWPhenomenon) -> Phenomenon? {
        let request: NSFetchRequest<Phenomenon> = Phenomenon.fetchRequest()
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(Phenomenon.name), phenomenonToMap.rawValue)

        return fetchFromContext(request: request)
    }

    private func map(_ forecastToMap: EWDocument.EWForecast) -> Forecast {
        // We use existing (fetched by the same date) or create a new one
        let mappedForecast = existingForecast(for: forecastToMap) ?? Forecast(context: self.context)
        mappedForecast.date = forecastToMap.date

        // Delete previous if they were existed
        // All winds and places should also be deleted
        // according to core data delete rules
        if let nightToDelete = mappedForecast.night {
            self.context.delete(nightToDelete)
        }

        if let dayToDelete = mappedForecast.day {
            self.context.delete(dayToDelete)
        }

        
        if let nigthToMap = forecastToMap.night {
            let mappedNight = map(nigthToMap)
            mappedForecast.night = mappedNight
        }

        if let dayToMap = forecastToMap.day {
            let mappedDay = map(dayToMap)
            mappedForecast.day = mappedDay
        }

        return mappedForecast
    }

    private func map(_ dayPartForecastToMap: EWDocument.EWForecast.EWDayPartForecast) -> DayPartForecast {
        let mappedDayPartForecast = DayPartForecast(context: self.context)

        mappedDayPartForecast.type = dayPartForecastToMap.type.rawValue
        mappedDayPartForecast.phenomenon = map(dayPartForecastToMap.phenomenon)
        mappedDayPartForecast.sea = dayPartForecastToMap.sea
        mappedDayPartForecast.peipsi = dayPartForecastToMap.peipsi
        mappedDayPartForecast.tempmax = .init(int: dayPartForecastToMap.tempmax)
        mappedDayPartForecast.tempmin = .init(int: dayPartForecastToMap.tempmin)

        
        var mappedPlaces: Set<Place> = []
        for placeToMap in dayPartForecastToMap.places {
            mappedPlaces.insert(map(placeToMap))
        }

        var mappedWinds: Set<Wind> = []
        for windToMap in dayPartForecastToMap.winds {
            mappedWinds.insert(map(windToMap))
        }

        mappedDayPartForecast.places = mappedPlaces as NSSet
        mappedDayPartForecast.winds = mappedWinds as NSSet

        return mappedDayPartForecast
    }

    private func map(_ phenomenonToMap: EWDocument.EWForecast.EWPhenomenon?) -> Phenomenon? {
        guard let phenomenonToMap = phenomenonToMap else { return nil }

        if let existing = existingPhenomenon(for: phenomenonToMap) {
            return existing
        }
        else {
            let phenomenonToAdd = Phenomenon(context: self.context)
            phenomenonToAdd.name = phenomenonToMap.rawValue
            return phenomenonToAdd
        }
    }

    private func map(_ placeToMap: EWDocument.EWForecast.EWDayPartForecast.EWPlace) -> Place {
        let mappedPlace = Place(context: self.context)
        mappedPlace.name = placeToMap.name
        mappedPlace.phenomenon = map(placeToMap.phenomenon)
        mappedPlace.tempmin = .init(int: placeToMap.tempmin)
        mappedPlace.tempmax = .init(int: placeToMap.tempmax)

        return mappedPlace
    }

    private func map(_ windToMap: EWDocument.EWForecast.EWDayPartForecast.EWWind) -> Wind {
        let mappedWind = Wind(context: self.context)
        mappedWind.name = windToMap.name
        mappedWind.speedmin = .init(int: windToMap.speedmin)
        mappedWind.speedmax = .init(int: windToMap.speedmax)
        mappedWind.gust = windToMap.gust
        mappedWind.direction = windToMap.direction

        return mappedWind
    }

    private func fetchFromContext<T>(request: NSFetchRequest<T>) -> T? {
        var result: [T]?
        self.context.performAndWait {
            do {
                result = try self.context.fetch(request)
            }
            catch {
                assertionFailure()
            }
        }

        return result?.first
    }
}


private extension Int16 {
    init(int: Int?) {
        guard let int = int else {
            self = 0
            return
        }

        self.init(truncatingIfNeeded: int)
    }
}

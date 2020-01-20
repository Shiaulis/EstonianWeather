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

    func performMapping(_ forecastsToMap: [EWForecast]) {
        map(forecastsToMap)

        self.context.perform {
            do {
                try self.context.save()
            }
            catch {
                assertionFailure()
            }
        }
    }

    private func map(_ forecastsToMap: [EWForecast]) {
        var mappedForecasts: [Forecast] = []
        for forecastToMap in forecastsToMap {
            let mappedForecast = map(forecastToMap)
            mappedForecast.receivedDate = forecastToMap.dateReceived
            mappedForecast.languageCode = forecastToMap.language?.rawValue
            mappedForecasts.append(mappedForecast)
        }
    }

    private func existingForecast(for forecastToMap: EWForecast) -> Forecast? {
        guard let requestedDate = forecastToMap.forecastDate else { return nil }

        let request: NSFetchRequest<Forecast> = Forecast.fetchRequest()
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(Forecast.forecastDate), requestedDate as NSDate)

        return fetchFromContext(request: request)
    }

    private func existingPhenomenon(for phenomenonToMap: EWForecast.EWPhenomenon) -> Phenomenon? {
        let request: NSFetchRequest<Phenomenon> = Phenomenon.fetchRequest()
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(Phenomenon.name), phenomenonToMap.rawValue)
        request.includesPendingChanges = true

        return fetchFromContext(request: request)
    }

    private func map(_ forecastToMap: EWForecast) -> Forecast {
        // We use existing (fetched by the same date) or create a new one
        let mappedForecast = existingForecast(for: forecastToMap) ?? Forecast(context: self.context)
        mappedForecast.forecastDate = forecastToMap.forecastDate

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

    private func map(_ dayPartForecastToMap: EWForecast.EWDayPartForecast) -> DayPartForecast {
        let mappedDayPartForecast = DayPartForecast(context: self.context)

        mappedDayPartForecast.type = dayPartForecastToMap.type.rawValue
        mappedDayPartForecast.phenomenon = map(dayPartForecastToMap.phenomenon)
        mappedDayPartForecast.sea = dayPartForecastToMap.sea
        mappedDayPartForecast.peipsi = dayPartForecastToMap.peipsi
        mappedDayPartForecast.tempmax = NSNumber(int: dayPartForecastToMap.tempmax)
        mappedDayPartForecast.tempmin = NSNumber(int: dayPartForecastToMap.tempmin)

        
        var mappedPlaces: Set<Place> = []
        for placeToMap in dayPartForecastToMap.places {
            mappedPlaces.insert(map(placeToMap))
        }

        var mappedWinds: Set<Wind> = []
        for windToMap in dayPartForecastToMap.winds {
            mappedWinds.insert(map(windToMap))
        }

        mappedDayPartForecast.places = mappedPlaces
        mappedDayPartForecast.winds = mappedWinds

        return mappedDayPartForecast
    }

    private func map(_ phenomenonToMap: EWForecast.EWPhenomenon?) -> Phenomenon? {
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

    private func map(_ placeToMap: EWForecast.EWDayPartForecast.EWPlace) -> Place {
        let mappedPlace = Place(context: self.context)
        mappedPlace.name = placeToMap.name
        mappedPlace.phenomenon = map(placeToMap.phenomenon)
        mappedPlace.tempmin = NSNumber(int: placeToMap.tempmin)
        mappedPlace.tempmax = NSNumber(int: placeToMap.tempmax)

        return mappedPlace
    }

    private func map(_ windToMap: EWForecast.EWDayPartForecast.EWWind) -> Wind {
        let mappedWind = Wind(context: self.context)
        mappedWind.name = windToMap.name
        mappedWind.speedmin = NSNumber(int: windToMap.speedmin)
        mappedWind.speedmax = NSNumber(int: windToMap.speedmax)
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


private extension NSNumber {

    convenience init?(int: Int?) {
        guard let int = int else {
            return nil
        }

        self.init(value: int)
    }
}

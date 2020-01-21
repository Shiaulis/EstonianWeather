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

    enum Error: Swift.Error {
        case emptyResponse, nonValidData, nonValidEntityDescription
    }

    func performMapping(_ forecastsToMap: [EWForecast], context: NSManagedObjectContext, completionHandler: ((Swift.Error?) -> Void)? = nil) {
        context.perform {
            do {
                try self.map(forecastsToMap, context: context)
                try context.save()
                completionHandler?(nil)
            }
            catch {
                completionHandler?(error)
            }
        }
    }

    private func map(_ forecastsToMap: [EWForecast], context: NSManagedObjectContext) throws {
        var mappedForecasts: [Forecast] = []
        for forecastToMap in forecastsToMap {
            let mappedForecast = try map(forecastToMap, context: context)
            mappedForecast.receivedDate = forecastToMap.dateReceived
            mappedForecast.languageCode = forecastToMap.language?.rawValue
            mappedForecasts.append(mappedForecast)
        }
    }

    private func existingForecast(for forecastToMap: EWForecast, context: NSManagedObjectContext) throws -> Forecast {
        guard let requestedDate = forecastToMap.forecastDate else {
            throw DataMapper.Error.nonValidData
        }

        let request: NSFetchRequest<Forecast> = Forecast.fetchRequest()
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(Forecast.forecastDate), requestedDate as NSDate)

        return try fetch(request: request)
    }

    private func existingPhenomenon(for phenomenonToMap: EWForecast.EWPhenomenon) throws -> Phenomenon {
        let request: NSFetchRequest<Phenomenon> = Phenomenon.fetchRequest()
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(Phenomenon.name), phenomenonToMap.rawValue)
        request.includesPendingChanges = true

        return try fetch(request: request)
    }

    private func map(_ forecastToMap: EWForecast, context: NSManagedObjectContext) throws -> Forecast {
        // We use existing (fetched by the same date) or create a new one
        let mappedForecast: Forecast
        do {
            mappedForecast = try existingForecast(for: forecastToMap, context: context)
        }
        catch DataMapper.Error.emptyResponse {
            mappedForecast = try create(in: context)
        }

        mappedForecast.forecastDate = forecastToMap.forecastDate

        // Delete previous if they were existed
        // All winds and places should also be deleted
        // according to core data delete rules
        if let nightToDelete = mappedForecast.night {
            context.delete(nightToDelete)
        }

        if let dayToDelete = mappedForecast.day {
            context.delete(dayToDelete)
        }

        
        if let nigthToMap = forecastToMap.night {
            let mappedNight = try map(nigthToMap, context: context)
            mappedForecast.night = mappedNight
        }

        if let dayToMap = forecastToMap.day {
            let mappedDay = try map(dayToMap, context: context)
            mappedForecast.day = mappedDay
        }

        return mappedForecast
    }

    private func map(_ dayPartForecastToMap: EWForecast.EWDayPartForecast, context: NSManagedObjectContext) throws -> DayPartForecast {
        let mappedDayPartForecast: DayPartForecast = try create(in: context)

        mappedDayPartForecast.type = dayPartForecastToMap.type.rawValue
        mappedDayPartForecast.phenomenon = try map(dayPartForecastToMap.phenomenon, context: context)
        mappedDayPartForecast.sea = dayPartForecastToMap.sea
        mappedDayPartForecast.peipsi = dayPartForecastToMap.peipsi
        mappedDayPartForecast.tempmax = NSNumber(int: dayPartForecastToMap.tempmax)
        mappedDayPartForecast.tempmin = NSNumber(int: dayPartForecastToMap.tempmin)

        
        var mappedPlaces: Set<Place> = []
        for placeToMap in dayPartForecastToMap.places {
            mappedPlaces.insert(try map(placeToMap, context: context))
        }

        var mappedWinds: Set<Wind> = []
        for windToMap in dayPartForecastToMap.winds {
            mappedWinds.insert(try map(windToMap, context: context))
        }

        mappedDayPartForecast.places = mappedPlaces
        mappedDayPartForecast.winds = mappedWinds

        return mappedDayPartForecast
    }

    private func map(_ phenomenonToMap: EWForecast.EWPhenomenon?, context: NSManagedObjectContext) throws -> Phenomenon? {
        guard let phenomenonToMap = phenomenonToMap else { return nil }
        do {
            return try existingPhenomenon(for: phenomenonToMap)
        } catch DataMapper.Error.emptyResponse {
            let phenomenonToAdd: Phenomenon = try create(in: context)
            phenomenonToAdd.name = phenomenonToMap.rawValue
            return phenomenonToAdd
        }
    }

    private func map(_ placeToMap: EWForecast.EWDayPartForecast.EWPlace, context: NSManagedObjectContext) throws -> Place {
        let mappedPlace: Place = try create(in: context)
        mappedPlace.name = placeToMap.name
        mappedPlace.phenomenon = try map(placeToMap.phenomenon, context: context)
        mappedPlace.tempmin = NSNumber(int: placeToMap.tempmin)
        mappedPlace.tempmax = NSNumber(int: placeToMap.tempmax)

        return mappedPlace
    }

    private func map(_ windToMap: EWForecast.EWDayPartForecast.EWWind, context: NSManagedObjectContext) throws -> Wind {
        let mappedWind: Wind = try create(in: context)
        mappedWind.name = windToMap.name
        mappedWind.speedmin = NSNumber(int: windToMap.speedmin)
        mappedWind.speedmax = NSNumber(int: windToMap.speedmax)
        mappedWind.gust = windToMap.gust
        mappedWind.direction = windToMap.direction

        return mappedWind
    }

    private func fetch<T>(request: NSFetchRequest<T>) throws -> T {
        guard let object = try request.execute().first else {
            throw DataMapper.Error.emptyResponse
        }

        return object
    }

    private func create<T: NSManagedObject>(in context: NSManagedObjectContext) throws -> T {
        let entityName = String(describing: T.self)
        guard let entityDescription = NSEntityDescription.entity(forEntityName: entityName, in: context) else {
            throw DataMapper.Error.nonValidEntityDescription
        }

        return T(entity: entityDescription, insertInto: context)
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

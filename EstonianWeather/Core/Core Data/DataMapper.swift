//
//  DataMapper.swift
//  EstonianWeather
//
//  Created by Andrius Shiaulis on 12.01.2020.
//  Copyright © 2020 Andrius Shiaulis. All rights reserved.
//

import Foundation
import CoreData
import Combine

protocol DataMapper {
    func performForecastMapping(_ forecastsToMap: [EWForecast], context: NSManagedObjectContext) throws -> [Forecast]
    func performObservationMapping(observationsToMap: [EWObservation], context: NSManagedObjectContext) throws -> [Observation]

    func removeAllForecasts(from context: NSManagedObjectContext, olderThan cutOffDate: Date) throws
    func removeAllObservations(from context: NSManagedObjectContext, olderThan cutOffDate: Date) throws
}

extension Publisher where Output == [EWForecast] {
    func mapForecast(using mapper: DataMapper, in context: NSManagedObjectContext) -> AnyPublisher<[Forecast], Swift.Error> {
        self
            .tryMap { forecasts in
                try mapper.performForecastMapping(forecasts, context: context)
            }
            .eraseToAnyPublisher()
    }

    func removeForecastOlderThan(_ date: Date, using dataMapper: DataMapper, in context: NSManagedObjectContext) -> AnyPublisher<[EWForecast], Swift.Error> {
        self
            .tryMap { forecasts in
                try dataMapper.removeAllForecasts(from: context, olderThan: date)
                return forecasts
            }
            .eraseToAnyPublisher()
    }
}

extension Publisher where Output == [EWObservation] {
    func mapObservations(using mapper: DataMapper, in context: NSManagedObjectContext) -> AnyPublisher<[Observation], Swift.Error> {
        self
            .tryMap { observation in
                try mapper.performObservationMapping(observationsToMap: observation, context: context)
            }
            .eraseToAnyPublisher()
    }

    func removeObservationsOlderThan(_ date: Date, using dataMapper: DataMapper, in context: NSManagedObjectContext) -> AnyPublisher<[EWObservation], Swift.Error> {
        self
            .tryMap { stations in
                try dataMapper.removeAllObservations(from: context, olderThan: date)
                return stations
            }
            .eraseToAnyPublisher()
    }
}

final class CoreDataMapper: DataMapper {

    private let logger: Logger

    init(logger: Logger) {
        self.logger = logger
    }

    enum Error: Swift.Error {
        case emptyResponse, nonValidData, nonValidEntityDescription
    }

    func removeAllForecasts(from context: NSManagedObjectContext, olderThan cutOffDate: Date) throws {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Forecast.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K < %@", #keyPath(Forecast.forecastDate), cutOffDate as NSDate)
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        var contextError: Swift.Error?

        do {
            try context.execute(batchDeleteRequest)
        }
        catch {
            contextError = error
        }

        if let contextError = contextError {
            throw contextError
        }
    }

    func removeAllObservations(from context: NSManagedObjectContext, olderThan cutOffDate: Date) throws {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Observation.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K < %@", #keyPath(Observation.observationDate), cutOffDate as NSDate)
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        var contextError: Swift.Error?

        do {
            try context.execute(batchDeleteRequest)
        }
        catch {
            contextError = error
        }

        if let contextError = contextError {
            throw contextError
        }
    }

    func performForecastMapping(_ forecastsToMap: [EWForecast], context: NSManagedObjectContext) throws -> [Forecast] {
        var contextError: Swift.Error?
        var mappedForecasts: [Forecast] = []
        context.performAndWait {
            do {
                mappedForecasts = try self.map(forecastsToMap, context: context)
                try context.save()
            }
            catch {
                contextError = error
            }
        }

        if let contextError = contextError {
            throw contextError
        }

        return mappedForecasts
    }

    func performObservationMapping(observationsToMap: [EWObservation], context: NSManagedObjectContext) throws -> [Observation] {
        var contextError: Swift.Error?
        var mappedObservations: [Observation] = []
        context.performAndWait {
            do {
                mappedObservations = try self.map(observationsToMap, context: context)
                try context.save()
            }
            catch {
                contextError = error
            }
        }

        if let contextError = contextError {
            throw contextError
        }

        return mappedObservations
    }

    private func map(_ observationsToMap: [EWObservation], context: NSManagedObjectContext) throws -> [Observation] {
        var mappedObservations: [Observation] = []
        for observationToMap in observationsToMap {
            let mappedObservation = try map(observationToMap, context: context)
            mappedObservations.append(mappedObservation)
        }

        return mappedObservations
    }

    private func map(_ forecastsToMap: [EWForecast], context: NSManagedObjectContext) throws -> [Forecast] {
        var mappedForecasts: [Forecast] = []
        for forecastToMap in forecastsToMap {
            let mappedForecast = try map(forecastToMap, context: context)
            mappedForecast.receivedDate = forecastToMap.dateReceived
            mappedForecast.languageCode = forecastToMap.languageCode
            mappedForecasts.append(mappedForecast)
        }

        return mappedForecasts
    }

    private func map(_ observationToMap: EWObservation, context: NSManagedObjectContext) throws -> Observation {
        // We use existing (fetched by the same name) or create a new one
        let mappedObservation: Observation
        do {
            mappedObservation = try existingObservation(for: observationToMap, context: context)
        }
        catch Error.emptyResponse {
            mappedObservation = try create(in: context)
        }

        mappedObservation.observationDate = observationToMap.observationDate
        mappedObservation.airPressure = observationToMap.airPressure
        mappedObservation.airTemperature = NSNumber(double: observationToMap.airTemperature)
        mappedObservation.latitude = NSNumber(double: observationToMap.latitude)
        mappedObservation.longitude = NSNumber(double: observationToMap.longitude)
        mappedObservation.phenomenon = try map(observationToMap.phenomenon, context: context)
        mappedObservation.precipitations = observationToMap.precipitations
        mappedObservation.relativeHumidity = NSNumber(double: observationToMap.relativeHumidity)
        mappedObservation.stationName = observationToMap.stationName
        mappedObservation.uvIndex = NSNumber(double: observationToMap.uvIndex)
        mappedObservation.visibility = observationToMap.visibility
        mappedObservation.waterLevel = observationToMap.waterLevel
        mappedObservation.waterlLevelEH2000 = observationToMap.waterlLevelEH2000
        mappedObservation.waterTemperature = NSNumber(double: observationToMap.waterTemperature)
        if let wind = observationToMap.wind {
            mappedObservation.wind = try map(wind, context: context)
        }
        mappedObservation.wmoCode = observationToMap.wmoCode

        return mappedObservation
    }

    private func existingObservation(for observationToMap: EWObservation, context: NSManagedObjectContext) throws -> Observation {
        guard let requestedName = observationToMap.stationName else {
            throw Error.nonValidData
        }

        let request: NSFetchRequest<Observation> = Observation.fetchRequest()
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(Observation.stationName), requestedName)

        return try fetch(request: request)
    }

    private func existingForecast(for forecastToMap: EWForecast, context: NSManagedObjectContext) throws -> Forecast {
        guard let requestedDate = forecastToMap.forecastDate else {
            throw Error.nonValidData
        }

        let request: NSFetchRequest<Forecast> = Forecast.fetchRequest()
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(Forecast.forecastDate), requestedDate as NSDate)

        return try fetch(request: request)
    }

    private func existingPhenomenon(for phenomenonToMap: EWPhenomenon) throws -> Phenomenon {
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
        catch Error.emptyResponse {
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

        if let nightToMap = forecastToMap.night {
            let mappedNight = try map(nightToMap, context: context)
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
        mappedDayPartForecast.text = dayPartForecastToMap.text
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

    private func map(_ phenomenonToMap: EWPhenomenon?, context: NSManagedObjectContext) throws -> Phenomenon? {
        guard let phenomenonToMap = phenomenonToMap else { return nil }
        do {
            return try existingPhenomenon(for: phenomenonToMap)
        }
        catch Error.emptyResponse {
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

    private func map(_ windToMap: EWWind, context: NSManagedObjectContext) throws -> Wind {
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
            throw Error.emptyResponse
        }

        return object
    }

    private func create<T: NSManagedObject>(in context: NSManagedObjectContext) throws -> T {
        let entityName = String(describing: T.self)
        guard let entityDescription = NSEntityDescription.entity(forEntityName: entityName, in: context) else {
            throw Error.nonValidEntityDescription
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

    convenience init?(double: Double?) {
        guard let double = double else {
            return nil
        }

        self.init(value: double)
    }
}

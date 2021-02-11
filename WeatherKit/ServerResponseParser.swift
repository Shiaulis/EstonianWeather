//
//  Parser.swift
//  WeatherKit
//
//  Created by Andrius Shiaulis on 17.01.2021.
//

import Foundation
import CoreData
import SWXMLHash
import HelperKit

// swiftlint:disable identifier_name
private enum Element: String {

    // forecast
    case forecasts, forecast, night, day, phenomenon, tempmin, tempmax, text, place, name, wind, direction, speedmin, speedmax, gust, sea, peipsi

    // observations
    case observations, station, wmocode, longitude, latitude, visibility, precipitations, airpressure, relativehumidity, airtemperature
    case winddirection, windspeed, windspeedmax, waterlevel, waterlevel_eh2000, watertemperature, uvindex

    init?(_ name: String) {
        self.init(rawValue: name)
    }
}
// swiftlint:enable identifier_name

protocol ServerResponseParser {
    func parse(data: Data, storeTo context: NSManagedObjectContext) throws
}

final class SWXMLParser {

    private let languageCode: String
    private let logger: Logger
    private let dateFormatter: DateFormatter

    init(languageCode: String, logger: Logger = PrintLogger()) {
        self.languageCode = languageCode
        self.logger = logger
        self.dateFormatter = .init()
        self.dateFormatter.locale = .init(identifier: "et-EE")
        self.dateFormatter.dateFormat = "yyyy-MM-dd"
    }

}

extension SWXMLParser: ServerResponseParser {

    func parse(data: Data, storeTo context: NSManagedObjectContext) throws {
        self.logger.log(information: "Parsing started", module: .dataParser)
        let xml = SWXMLHash.lazy(data)
        do {
            _ = try self.forecasts(from: xml, context: context)
            self.logger.log(information: "Parsing finished", module: .dataParser)
        }
        catch {
            self.logger.log(message: "Parsing failed", error: error, module: .dataParser)
            throw error
        }
    }

}

// MARK: - NSManagedObject from XMLIndexer

extension SWXMLParser {

    private func forecasts(from indexer: XMLIndexer, context: NSManagedObjectContext) throws -> [Forecast] {
        try indexer[.forecasts][.forecast].all.map { try forecast(from: $0, context: context) }
    }

    private func forecast(from indexer: XMLIndexer, context: NSManagedObjectContext) throws -> Forecast {
        let forecastDate = try dateAttribute(from: indexer)
        let mappedForecast: Forecast
        do {
            mappedForecast = try existingForecast(for: forecastDate, context: context)
        }
        catch NSManagedObjectContext.Error.noObjectFoundInDatabase {
            mappedForecast = try .create(in: context)
        }
        catch Error.forecastDateNotFound {
            mappedForecast = try .create(in: context)
            mappedForecast.languageCode = self.languageCode
            mappedForecast.forecastDate = forecastDate
        }

        mappedForecast.night = try dayPartForecast(from: indexer[.night], context: context)
        mappedForecast.night?.type = NSLocalizedString("Night", comment: "forecast part type")

        mappedForecast.day = try dayPartForecast(from: indexer[.day], context: context)
        mappedForecast.day?.type = NSLocalizedString("Day", comment: "forecast part type")

        return mappedForecast
    }

    private func dayPartForecast(from indexer: XMLIndexer, context: NSManagedObjectContext) throws -> DayPartForecast {
        let dayPartForecast: DayPartForecast = try .create(in: context)
        dayPartForecast.type = NSLocalizedString("Night", comment: "forecast part type")
        dayPartForecast.phenomenon = phenomenon(from: indexer[.phenomenon], context: context)
        dayPartForecast.tempmin = nsNumberValue(from: indexer[.tempmin])
        dayPartForecast.tempmax = nsNumberValue(from: indexer[.tempmax])
        dayPartForecast.text = indexer[.text].element?.text

        let placesArray: [Place] = indexer[.place].all.compactMap { place(from: $0, context: context) }
        dayPartForecast.places = Set(placesArray)

        let windsArray: [Wind] = indexer[.wind].all.compactMap { wind(from: $0, context: context) }
        dayPartForecast.winds = Set(windsArray)

        dayPartForecast.sea = stringValue(from: indexer[.sea])
        dayPartForecast.peipsi = stringValue(from: indexer[.peipsi])

        return dayPartForecast
    }

    // Since place is not critical data we do not throw its absense
    // otherwise it would abort parsing process
    private func place(from indexer: XMLIndexer, context: NSManagedObjectContext) -> Place? {
        let place: Place
        do {
            place = try .create(in: context)
        }
        catch {
            let error = Error.elementNotFound(identifier: Element.place.rawValue)
            self.logger.log(message: "This case is not expected", error: error, module: .dataParser)
            return nil
        }
        place.name = indexer[.name].element?.text
        place.phenomenon = phenomenon(from: indexer[.phenomenon], context: context)
        place.tempmin = nsNumberValue(from: indexer[.tempmin])
        place.tempmax = nsNumberValue(from: indexer[.tempmax])

        return place
    }

    private func wind(from indexer: XMLIndexer, context: NSManagedObjectContext) -> Wind? {
        let wind: Wind
        do {
            wind = try .create(in: context)
        }
        catch {
            let error = Error.elementNotFound(identifier: Element.place.rawValue)
            self.logger.log(message: "This case is not expected", error: error, module: .dataParser)
            return nil
        }
        wind.name = indexer[.name].element?.text
        wind.direction = indexer[.direction].element?.text
        wind.speedmin = nsNumberValue(from: indexer[.speedmin])
        wind.speedmax = nsNumberValue(from: indexer[.speedmax])

        return wind
    }

    private func nsNumberValue(from indexer: XMLIndexer) -> NSNumber? {
        guard let stringValue = stringValue(from: indexer) else { return nil }
        guard let integerValue = Int(stringValue) else { return nil }
        return NSNumber(value: integerValue)
    }

    private func stringValue(from indexer: XMLIndexer) -> String? { indexer.element?.text }

    private func dateAttribute(from indexer: XMLIndexer) throws -> Date {
        guard let dateString = indexer.element?.attribute(by: "date")?.text else {
            throw Error.forecastDateNotFound
        }

        guard let date = self.dateFormatter.date(from: dateString) else {
            throw Error.forecastDateNotFound
        }

        return date
    }

    // Since phenomenon is not critical data we do not throw its absense
    // otherwise it would abort parsing process
    private func phenomenon(from indexer: XMLIndexer, context: NSManagedObjectContext) -> Phenomenon? {
        guard let phenomenonString = indexer.element?.text else {
            let error = Error.elementNotFound(identifier: "phenomenon")
            self.logger.log(message: "This case is not expected", error: error, module: .dataParser)
            return nil
        }

        do {
            return try existingPhenomenon(for: phenomenonString, context: context)
        }
        catch NSManagedObjectContext.Error.noObjectFoundInDatabase {
            do {
                let phenomenonToAdd: Phenomenon = try .create(in: context)
                phenomenonToAdd.name = phenomenonString
                return phenomenonToAdd
            }
            catch {
                self.logger.log(message: "This case is not expected", error: error, module: .dataParser)
                return nil
            }
        }
        catch {
            self.logger.log(message: "This case is not expected", error: error, module: .dataParser)
            return nil
        }
    }

}

// MARK: - Fetching existing entities from context

extension SWXMLParser {

    private func existingForecast(for date: Date, context: NSManagedObjectContext) throws -> Forecast {
        let request: NSFetchRequest<Forecast> = Forecast.fetchRequest()
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "%K == %@", #keyPath(Forecast.forecastDate), date as NSDate),
            NSPredicate(format: "%K == %@", #keyPath(Forecast.languageCode), self.languageCode)
        ])

        return try context.fetch(request: request)
    }

    private func existingPhenomenon(for name: String, context: NSManagedObjectContext) throws -> Phenomenon {
        let request: NSFetchRequest<Phenomenon> = Phenomenon.fetchRequest()
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(Phenomenon.name), name)
        request.includesPendingChanges = true

        return try context.fetch(request: request)
    }

}

// MARK: - Error type

extension SWXMLParser {

    enum Error: Swift.Error {
        case elementNotFound(identifier: String)
        case forecastDateNotFound
    }

}

private extension XMLIndexer {

    subscript(element: Element) -> XMLIndexer {
        do {
            return try self.byKey(element.rawValue)
        }
        catch let error as IndexingError {
            return .xmlError(error)
        }
        catch {
            return .xmlError(IndexingError.key(key: element.rawValue))
        }
    }
}

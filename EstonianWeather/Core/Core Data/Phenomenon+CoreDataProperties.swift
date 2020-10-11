//
//  Phenomenon+CoreDataProperties.swift
//  EstonianWeather
//
//  Created by Andrius Shiaulis on 10.10.2020.
//
//

import Foundation
import CoreData


extension Phenomenon {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Phenomenon> {
        return NSFetchRequest<Phenomenon>(entityName: "Phenomenon")
    }

    @NSManaged public var name: String?
    @NSManaged public var dayPartForecasts: NSSet?
    @NSManaged public var places: NSSet?
    @NSManaged public var stations: NSSet?

}

// MARK: Generated accessors for dayPartForecasts
extension Phenomenon {

    @objc(addDayPartForecastsObject:)
    @NSManaged public func addToDayPartForecasts(_ value: DayPartForecast)

    @objc(removeDayPartForecastsObject:)
    @NSManaged public func removeFromDayPartForecasts(_ value: DayPartForecast)

    @objc(addDayPartForecasts:)
    @NSManaged public func addToDayPartForecasts(_ values: NSSet)

    @objc(removeDayPartForecasts:)
    @NSManaged public func removeFromDayPartForecasts(_ values: NSSet)

}

// MARK: Generated accessors for places
extension Phenomenon {

    @objc(addPlacesObject:)
    @NSManaged public func addToPlaces(_ value: Place)

    @objc(removePlacesObject:)
    @NSManaged public func removeFromPlaces(_ value: Place)

    @objc(addPlaces:)
    @NSManaged public func addToPlaces(_ values: NSSet)

    @objc(removePlaces:)
    @NSManaged public func removeFromPlaces(_ values: NSSet)

}

// MARK: Generated accessors for stations
extension Phenomenon {

    @objc(addStationsObject:)
    @NSManaged public func addToStations(_ value: Station)

    @objc(removeStationsObject:)
    @NSManaged public func removeFromStations(_ value: Station)

    @objc(addStations:)
    @NSManaged public func addToStations(_ values: NSSet)

    @objc(removeStations:)
    @NSManaged public func removeFromStations(_ values: NSSet)

}

extension Phenomenon : Identifiable {

}

//
//  Phenomenon+CoreDataProperties.swift
//  EstonianWeather
//
//  Created by Andrius Shiaulis on 12.10.2020.
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
    @NSManaged public var observations: NSSet?

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

// MARK: Generated accessors for observations
extension Phenomenon {

    @objc(addObservationsObject:)
    @NSManaged public func addToObservations(_ value: Observation)

    @objc(removeObservationsObject:)
    @NSManaged public func removeFromObservations(_ value: Observation)

    @objc(addObservations:)
    @NSManaged public func addToObservations(_ values: NSSet)

    @objc(removeObservations:)
    @NSManaged public func removeFromObservations(_ values: NSSet)

}

extension Phenomenon: Identifiable {

}

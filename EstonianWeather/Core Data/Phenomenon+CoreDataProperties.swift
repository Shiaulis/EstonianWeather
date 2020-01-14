//
//  Phenomenon+CoreDataProperties.swift
//  EstonianWeather
//
//  Created by Andrius Shiaulis on 13.01.2020.
//  Copyright © 2020 Andrius Shiaulis. All rights reserved.
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

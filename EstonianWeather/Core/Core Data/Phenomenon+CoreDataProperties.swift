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
    @NSManaged public var dayPartForecasts: Set<DayPartForecast>?
    @NSManaged public var places: Set<Place>?

}

// MARK: Generated accessors for dayPartForecasts
extension Phenomenon {

    @objc(addDayPartForecastsObject:)
    @NSManaged public func addToDayPartForecasts(_ value: DayPartForecast)

    @objc(removeDayPartForecastsObject:)
    @NSManaged public func removeFromDayPartForecasts(_ value: DayPartForecast)

    @objc(addDayPartForecasts:)
    @NSManaged public func addToDayPartForecasts(_ values: Set<DayPartForecast>)

    @objc(removeDayPartForecasts:)
    @NSManaged public func removeFromDayPartForecasts(_ values: Set<DayPartForecast>)

}

// MARK: Generated accessors for places
extension Phenomenon {

    @objc(addPlacesObject:)
    @NSManaged public func addToPlaces(_ value: Place)

    @objc(removePlacesObject:)
    @NSManaged public func removeFromPlaces(_ value: Place)

    @objc(addPlaces:)
    @NSManaged public func addToPlaces(_ values: Set<Place>)

    @objc(removePlaces:)
    @NSManaged public func removeFromPlaces(_ values: Set<Place>)

}

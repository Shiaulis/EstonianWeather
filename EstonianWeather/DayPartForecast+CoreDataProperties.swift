//
//  DayPartForecast+CoreDataProperties.swift
//  EstonianWeather
//
//  Created by Andrius Shiaulis on 13.01.2020.
//  Copyright © 2020 Andrius Shiaulis. All rights reserved.
//
//

import Foundation
import CoreData


extension DayPartForecast {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DayPartForecast> {
        return NSFetchRequest<DayPartForecast>(entityName: "DayPartForecast")
    }

    @NSManaged public var peipsi: String?
    @NSManaged public var sea: String?
    @NSManaged public var tempmax: Int16
    @NSManaged public var tempmin: Int16
    @NSManaged public var text: String?
    @NSManaged public var type: String?
    @NSManaged public var dayForecast: Forecast?
    @NSManaged public var nightForecast: Forecast?
    @NSManaged public var phenomenon: Phenomenon?
    @NSManaged public var places: NSSet?
    @NSManaged public var winds: NSSet?

}

// MARK: Generated accessors for places
extension DayPartForecast {

    @objc(addPlacesObject:)
    @NSManaged public func addToPlaces(_ value: Place)

    @objc(removePlacesObject:)
    @NSManaged public func removeFromPlaces(_ value: Place)

    @objc(addPlaces:)
    @NSManaged public func addToPlaces(_ values: NSSet)

    @objc(removePlaces:)
    @NSManaged public func removeFromPlaces(_ values: NSSet)

}

// MARK: Generated accessors for winds
extension DayPartForecast {

    @objc(addWindsObject:)
    @NSManaged public func addToWinds(_ value: Wind)

    @objc(removeWindsObject:)
    @NSManaged public func removeFromWinds(_ value: Wind)

    @objc(addWinds:)
    @NSManaged public func addToWinds(_ values: NSSet)

    @objc(removeWinds:)
    @NSManaged public func removeFromWinds(_ values: NSSet)

}

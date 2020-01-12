//
//  Place+CoreDataProperties.swift
//  EstonianWeather
//
//  Created by Andrius Shiaulis on 12.01.2020.
//  Copyright © 2020 Andrius Shiaulis. All rights reserved.
//
//

import Foundation
import CoreData


extension Place {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Place> {
        return NSFetchRequest<Place>(entityName: "Place")
    }

    @NSManaged public var name: String?
    @NSManaged public var tempmax: Int16
    @NSManaged public var tempmin: Int16
    @NSManaged public var datePartForecast: NSSet?
    @NSManaged public var phenomenon: Phenomenon?

}

// MARK: Generated accessors for datePartForecast
extension Place {

    @objc(addDatePartForecastObject:)
    @NSManaged public func addToDatePartForecast(_ value: DayPartForecast)

    @objc(removeDatePartForecastObject:)
    @NSManaged public func removeFromDatePartForecast(_ value: DayPartForecast)

    @objc(addDatePartForecast:)
    @NSManaged public func addToDatePartForecast(_ values: NSSet)

    @objc(removeDatePartForecast:)
    @NSManaged public func removeFromDatePartForecast(_ values: NSSet)

}

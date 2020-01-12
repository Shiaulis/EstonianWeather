//
//  Wind+CoreDataProperties.swift
//  EstonianWeather
//
//  Created by Andrius Shiaulis on 12.01.2020.
//  Copyright © 2020 Andrius Shiaulis. All rights reserved.
//
//

import Foundation
import CoreData


extension Wind {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Wind> {
        return NSFetchRequest<Wind>(entityName: "Wind")
    }

    @NSManaged public var name: String?
    @NSManaged public var direction: String?
    @NSManaged public var speedmin: Int16
    @NSManaged public var speedmax: Int16
    @NSManaged public var gust: String?
    @NSManaged public var datePartForecast: NSSet?

}

// MARK: Generated accessors for datePartForecast
extension Wind {

    @objc(addDatePartForecastObject:)
    @NSManaged public func addToDatePartForecast(_ value: DayPartForecast)

    @objc(removeDatePartForecastObject:)
    @NSManaged public func removeFromDatePartForecast(_ value: DayPartForecast)

    @objc(addDatePartForecast:)
    @NSManaged public func addToDatePartForecast(_ values: NSSet)

    @objc(removeDatePartForecast:)
    @NSManaged public func removeFromDatePartForecast(_ values: NSSet)

}

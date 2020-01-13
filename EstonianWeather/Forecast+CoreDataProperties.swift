//
//  Forecast+CoreDataProperties.swift
//  EstonianWeather
//
//  Created by Andrius Shiaulis on 13.01.2020.
//  Copyright © 2020 Andrius Shiaulis. All rights reserved.
//
//

import Foundation
import CoreData


extension Forecast {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Forecast> {
        return NSFetchRequest<Forecast>(entityName: "Forecast")
    }

    @NSManaged public var date: Date?
    @NSManaged public var day: DayPartForecast?
    @NSManaged public var responses: NSSet?
    @NSManaged public var night: DayPartForecast?

}

// MARK: Generated accessors for responses
extension Forecast {

    @objc(addResponsesObject:)
    @NSManaged public func addToResponses(_ value: ForecastResponse)

    @objc(removeResponsesObject:)
    @NSManaged public func removeFromResponses(_ value: ForecastResponse)

    @objc(addResponses:)
    @NSManaged public func addToResponses(_ values: NSSet)

    @objc(removeResponses:)
    @NSManaged public func removeFromResponses(_ values: NSSet)

}

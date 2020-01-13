//
//  ForecastResponse+CoreDataProperties.swift
//  EstonianWeather
//
//  Created by Andrius Shiaulis on 13.01.2020.
//  Copyright © 2020 Andrius Shiaulis. All rights reserved.
//
//

import Foundation
import CoreData


extension ForecastResponse {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ForecastResponse> {
        return NSFetchRequest<ForecastResponse>(entityName: "ForecastResponse")
    }

    @NSManaged public var date: Date?
    @NSManaged public var language: String?
    @NSManaged public var forecasts: NSSet?

}

// MARK: Generated accessors for forecasts
extension ForecastResponse {

    @objc(addForecastsObject:)
    @NSManaged public func addToForecasts(_ value: Forecast)

    @objc(removeForecastsObject:)
    @NSManaged public func removeFromForecasts(_ value: Forecast)

    @objc(addForecasts:)
    @NSManaged public func addToForecasts(_ values: NSSet)

    @objc(removeForecasts:)
    @NSManaged public func removeFromForecasts(_ values: NSSet)

}

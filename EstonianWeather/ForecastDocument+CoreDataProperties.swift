//
//  ForecastDocument+CoreDataProperties.swift
//  EstonianWeather
//
//  Created by Andrius Shiaulis on 12.01.2020.
//  Copyright © 2020 Andrius Shiaulis. All rights reserved.
//
//

import Foundation
import CoreData


extension ForecastDocument {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ForecastDocument> {
        return NSFetchRequest<ForecastDocument>(entityName: "ForecastDocument")
    }

    @NSManaged public var forecasts: NSSet?

}

// MARK: Generated accessors for forecasts
extension ForecastDocument {

    @objc(addForecastsObject:)
    @NSManaged public func addToForecasts(_ value: Forecast)

    @objc(removeForecastsObject:)
    @NSManaged public func removeFromForecasts(_ value: Forecast)

    @objc(addForecasts:)
    @NSManaged public func addToForecasts(_ values: NSSet)

    @objc(removeForecasts:)
    @NSManaged public func removeFromForecasts(_ values: NSSet)

}

//
//  Forecast+CoreDataProperties.swift
//  EstonianWeather
//
//  Created by Andrius Shiaulis on 12.01.2020.
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
    @NSManaged public var night: DayPartForecast?
    @NSManaged public var day: DayPartForecast?
    @NSManaged public var forecastDocument: ForecastDocument?

}

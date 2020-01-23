//
//  Forecast+CoreDataProperties.swift
//  EstonianWeather
//
//  Created by Andrius Shiaulis on 20.01.2020.
//  Copyright © 2020 Andrius Shiaulis. All rights reserved.
//
//

import Foundation
import CoreData

extension Forecast {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Forecast> {
        return NSFetchRequest<Forecast>(entityName: "Forecast")
    }

    @NSManaged public var forecastDate: Date?
    @NSManaged public var languageCode: String?
    @NSManaged public var receivedDate: Date?
    @NSManaged public var day: DayPartForecast?
    @NSManaged public var night: DayPartForecast?

}

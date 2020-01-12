//
//  DayPartForecast+CoreDataProperties.swift
//  EstonianWeather
//
//  Created by Andrius Shiaulis on 12.01.2020.
//  Copyright © 2020 Andrius Shiaulis. All rights reserved.
//
//

import Foundation
import CoreData


extension DayPartForecast {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DayPartForecast> {
        return NSFetchRequest<DayPartForecast>(entityName: "DayPartForecast")
    }

    @NSManaged public var type: String?
    @NSManaged public var tempmin: Int16
    @NSManaged public var tempmax: Int16
    @NSManaged public var text: String?
    @NSManaged public var sea: String?
    @NSManaged public var peipsi: String?
    @NSManaged public var places: Place?
    @NSManaged public var winds: Wind?
    @NSManaged public var phenomenon: Phenomenon?
    @NSManaged public var nightForecast: Forecast?
    @NSManaged public var dayForecast: Forecast?

}

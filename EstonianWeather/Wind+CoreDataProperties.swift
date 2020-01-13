//
//  Wind+CoreDataProperties.swift
//  EstonianWeather
//
//  Created by Andrius Shiaulis on 13.01.2020.
//  Copyright © 2020 Andrius Shiaulis. All rights reserved.
//
//

import Foundation
import CoreData


extension Wind {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Wind> {
        return NSFetchRequest<Wind>(entityName: "Wind")
    }

    @NSManaged public var direction: String?
    @NSManaged public var gust: String?
    @NSManaged public var name: String?
    @NSManaged public var speedmax: Int16
    @NSManaged public var speedmin: Int16
    @NSManaged public var datePartForecast: DayPartForecast?

}

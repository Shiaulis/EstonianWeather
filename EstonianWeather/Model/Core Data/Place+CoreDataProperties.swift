//
//  Place+CoreDataProperties.swift
//  EstonianWeather
//
//  Created by Andrius Shiaulis on 18.01.2020.
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
    @NSManaged public var tempmax: NSNumber?
    @NSManaged public var tempmin: NSNumber?
    @NSManaged public var datePartForecast: DayPartForecast?
    @NSManaged public var phenomenon: Phenomenon?

}

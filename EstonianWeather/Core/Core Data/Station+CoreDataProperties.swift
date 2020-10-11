//
//  Station+CoreDataProperties.swift
//  EstonianWeather
//
//  Created by Andrius Shiaulis on 10.10.2020.
//
//

import Foundation
import CoreData


extension Station {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Station> {
        return NSFetchRequest<Station>(entityName: "Station")
    }

    @NSManaged public var name: String?
    @NSManaged public var wmoCode: String?
    @NSManaged public var longitude: NSNumber?
    @NSManaged public var latitude: NSNumber?
    @NSManaged public var visibility: NSObject?
    @NSManaged public var precipitations: String?
    @NSManaged public var airPressure: String?
    @NSManaged public var relativeHumidity: NSNumber?
    @NSManaged public var airTemperature: NSNumber?
    @NSManaged public var waterLevel: String?
    @NSManaged public var waterlLevelEH2000: String?
    @NSManaged public var waterTemperature: NSNumber?
    @NSManaged public var uvIndex: NSNumber?
    @NSManaged public var observation: Observation?
    @NSManaged public var phenomenon: Phenomenon?
    @NSManaged public var wind: Wind?

}

    extension Station : Identifiable {

}

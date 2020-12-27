//
//  Observation+CoreDataProperties.swift
//  EstonianWeather
//
//  Created by Andrius Shiaulis on 12.10.2020.
//
//

import Foundation
import CoreData

extension Observation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Observation> {
        return NSFetchRequest<Observation>(entityName: "Observation")
    }

    @NSManaged public var airPressure: String?
    @NSManaged public var airTemperature: NSNumber?
    @NSManaged public var latitude: NSNumber?
    @NSManaged public var longitude: NSNumber?
    @NSManaged public var stationName: String?
    @NSManaged public var precipitations: String?
    @NSManaged public var relativeHumidity: NSNumber?
    @NSManaged public var uvIndex: NSNumber?
    @NSManaged public var visibility: String?
    @NSManaged public var waterLevel: String?
    @NSManaged public var waterlLevelEH2000: String?
    @NSManaged public var waterTemperature: NSNumber?
    @NSManaged public var wmoCode: String?
    @NSManaged public var observationDate: Date?
    @NSManaged public var phenomenon: Phenomenon?
    @NSManaged public var wind: Wind?

}

extension Observation: Identifiable {

}

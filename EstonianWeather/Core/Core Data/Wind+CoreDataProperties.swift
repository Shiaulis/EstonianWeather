//
//  Wind+CoreDataProperties.swift
//  EstonianWeather
//
//  Created by Andrius Shiaulis on 10.10.2020.
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
    @NSManaged public var speedmax: NSNumber?
    @NSManaged public var speedmin: NSNumber?
    @NSManaged public var speed: NSNumber?
    @NSManaged public var datePartForecast: DayPartForecast?
    @NSManaged public var stations: NSSet?

}

// MARK: Generated accessors for stations
extension Wind {

    @objc(addStationsObject:)
    @NSManaged public func addToStations(_ value: Station)

    @objc(removeStationsObject:)
    @NSManaged public func removeFromStations(_ value: Station)

    @objc(addStations:)
    @NSManaged public func addToStations(_ values: NSSet)

    @objc(removeStations:)
    @NSManaged public func removeFromStations(_ values: NSSet)

}

extension Wind : Identifiable {

}

//
//  Observation+CoreDataProperties.swift
//  EstonianWeather
//
//  Created by Andrius Shiaulis on 10.10.2020.
//
//

import Foundation
import CoreData


extension Observation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Observation> {
        return NSFetchRequest<Observation>(entityName: "Observation")
    }

    @NSManaged public var stations: NSSet?

}

// MARK: Generated accessors for stations
extension Observation {

    @objc(addStationsObject:)
    @NSManaged public func addToStations(_ value: Station)

    @objc(removeStationsObject:)
    @NSManaged public func removeFromStations(_ value: Station)

    @objc(addStations:)
    @NSManaged public func addToStations(_ values: NSSet)

    @objc(removeStations:)
    @NSManaged public func removeFromStations(_ values: NSSet)

}

extension Observation : Identifiable {

}

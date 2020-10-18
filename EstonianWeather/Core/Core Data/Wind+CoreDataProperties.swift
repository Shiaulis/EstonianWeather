//
//  Wind+CoreDataProperties.swift
//  EstonianWeather
//
//  Created by Andrius Shiaulis on 12.10.2020.
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
    @NSManaged public var speed: NSNumber?
    @NSManaged public var speedmax: NSNumber?
    @NSManaged public var speedmin: NSNumber?
    @NSManaged public var datePartForecast: DayPartForecast?
    @NSManaged public var observations: NSSet?

}

// MARK: Generated accessors for observations
extension Wind {

    @objc(addObservationsObject:)
    @NSManaged public func addToObservations(_ value: Observation)

    @objc(removeObservationsObject:)
    @NSManaged public func removeFromObservations(_ value: Observation)

    @objc(addObservations:)
    @NSManaged public func addToObservations(_ values: NSSet)

    @objc(removeObservations:)
    @NSManaged public func removeFromObservations(_ values: NSSet)

}

extension Wind : Identifiable {

}

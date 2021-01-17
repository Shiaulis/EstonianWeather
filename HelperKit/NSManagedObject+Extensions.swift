//
//  NSManagedObject+Extensions.swift
//  HelperKit
//
//  Created by Andrius Shiaulis on 17.01.2021.
//

import CoreData

public extension NSManagedObject {

    static func create<T: NSManagedObject>(in context: NSManagedObjectContext) throws -> T {
        let entityName = String(describing: T.self)
        guard let entityDescription = NSEntityDescription.entity(forEntityName: entityName, in: context) else {
            throw Error.unableToCreateDatabaseObject(name: entityName)
        }

        return T(entity: entityDescription, insertInto: context)
    }

}

public extension NSManagedObject {

    enum Error: Swift.Error {
        case unableToCreateDatabaseObject(name: String)
    }

}

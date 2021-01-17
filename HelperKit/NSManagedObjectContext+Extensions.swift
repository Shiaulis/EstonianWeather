//
//  NSManagedObjectContext+Extensions.swift
//  HelperKit
//
//  Created by Andrius Shiaulis on 17.01.2021.
//

import CoreData

public extension NSManagedObjectContext {

    func fetch<T>(request: NSFetchRequest<T>) throws -> T {
        var objects: [T]?
        var fetchError: Swift.Error?
        self.performAndWait {
            do {
                objects = try self.fetch(request)
            }
            catch {
                fetchError = error
            }
        }

        if let fetchError = fetchError {
            throw fetchError
        }

        guard let object = objects?.first else {
            throw Error.noObjectFoundInDatabase
        }

        return object
    }
}

public extension NSManagedObjectContext {

    enum Error: Swift.Error {
        case noObjectFoundInDatabase
    }

}

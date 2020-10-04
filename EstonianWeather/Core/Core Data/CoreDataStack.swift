//
//  CoreDataStack.swift
//  EstonianWeather
//
//  Created by Andrius Shiaulis on 12.01.2020.
//  Copyright © 2020 Andrius Shiaulis. All rights reserved.
//

import Foundation
import CoreData

struct AppGroup {
    static let defaultGroupIdentifier = "group.shiaulis.EstonianWeather"
}

final class CoreDataStack {

    private(set) var persistentContainer: NSPersistentContainer
    private static let databaseName = "EstonianWeather"
    private let storeURL = URL.storeURL(for: AppGroup.defaultGroupIdentifier, databaseName: CoreDataStack.databaseName)

    init() {
        self.persistentContainer = .init(name: CoreDataStack.databaseName)
        initialize()
    }

    private func initialize() {
        self.persistentContainer = .init(name: CoreDataStack.databaseName)
        let storeDescription = NSPersistentStoreDescription(url: self.storeURL)
        self.persistentContainer.persistentStoreDescriptions.append(storeDescription)
        self.persistentContainer.loadPersistentStores { _, error in
            if error != nil {
                assertionFailure()
            }
        }
    }

    func recreateDatabase() {
        do {
            try self.persistentContainer.persistentStoreCoordinator.destroyPersistentStore(at: self.storeURL, ofType: "sqlite", options: nil)
        }
        catch {
            fatalError("Failed to destroy persistent store. Error: \(error.localizedDescription)")
        }

        initialize()
    }
}

private extension URL {

    /// Returns a URL for the given app group and database pointing to the sqlite database.
    static func storeURL(for appGroup: String, databaseName: String) -> URL {
        guard let fileContainer = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroup) else {
            fatalError("Shared file container could not be created.")
        }

        return fileContainer.appendingPathComponent("\(databaseName).sqlite")
    }
}

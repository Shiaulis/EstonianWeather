//
//  NSPersistentContainer+testContext.swift
//  EstonianWeatherTests
//
//  Created by Andrius Shiaulis on 21.01.2020.
//  Copyright © 2020 Andrius Shiaulis. All rights reserved.
//

import CoreData

extension NSPersistentContainer {
    static func createContainerForTesting() -> NSPersistentContainer {

        let modelURL = Bundle.main.url(forResource: "EstonianWeather", withExtension: "momd")!
        let model = NSManagedObjectModel(contentsOf: modelURL)!
        let container = NSPersistentContainer(name: "EstonianWeatherTests", managedObjectModel: model)
        let description = container.persistentStoreDescriptions.first!
        description.url = URL(fileURLWithPath: "/dev/null")

        container.loadPersistentStores { (_, error) in
            guard let error = error as NSError? else { return }
            fatalError("###\(#function): Failed to load persistent stores: \(error)")
        }

        return container
    }

}

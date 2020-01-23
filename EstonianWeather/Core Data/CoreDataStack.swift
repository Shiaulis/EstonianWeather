//
//  CoreDataStack.swift
//  EstonianWeather
//
//  Created by Andrius Shiaulis on 12.01.2020.
//  Copyright © 2020 Andrius Shiaulis. All rights reserved.
//

import Foundation
import CoreData

final class CoreDataStack {

    let persistentContainer: NSPersistentContainer

    init() {
        self.persistentContainer = .init(name: "EstonianWeather")
        self.persistentContainer.loadPersistentStores { _, error in
            if error != nil {
                assertionFailure()
            }
        }
    }
}

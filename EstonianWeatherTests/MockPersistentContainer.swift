//
//  MockPersistentContainer.swift
//  EstonianWeatherTests
//
//  Created by Andrius Shiaulis on 21.01.2020.
//  Copyright © 2020 Andrius Shiaulis. All rights reserved.
// swiftlint:disable force_try

import Foundation
import CoreData

enum MockPersistentContainerError: Error {
    case unableToInsertObjectError
    case incorrectDescriptionTypeError
}

final class MockPersistentContainer: NSPersistentContainer {

    private var insertedEntities: [String] = []

    // MARK: - Initialization -

    init(name: String = "MockPersistentContainer") {
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.main])!
        super.init(name: name, managedObjectModel: managedObjectModel)

        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = false

        self.persistentStoreDescriptions = [description]
    }

    func start() {
        start { result in
            if case .failure(let error) = result {
                fatalError("Unable to start Mock Persistent Container. Error: \(error)")
            }
        }
    }

    func start(completion: @escaping (Result<NSPersistentStoreDescription, Error>) -> Void) {
        self.loadPersistentStores { description, error in

            guard description.type == NSInMemoryStoreType else {
                completion(.failure(MockPersistentContainerError.incorrectDescriptionTypeError))
                return
            }

            if let error = error {
                completion(.failure(error))
            }

            completion(.success(description))
        }
    }

    func flushData() {
        for entityName in self.insertedEntities {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            let objs = try! self.viewContext.fetch(fetchRequest)

            for case let obj as NSManagedObject in objs {
                self.viewContext.delete(obj)
            }

            try! self.viewContext.save()
        }

        self.insertedEntities.removeAll()
    }

    @discardableResult
    func addObject<T>(updateParametersBlock: (T) -> Void) throws -> T where T: NSManagedObject {
        guard let insertedObject = NSEntityDescription.insertNewObject(forEntityName: T.className, into: self.viewContext) as? T else {
            throw MockPersistentContainerError.unableToInsertObjectError
        }

        updateParametersBlock(insertedObject)

        self.insertedEntities.append(T.className)

        return insertedObject
    }

    @discardableResult
    func addEmptyObject<T>() throws -> T where T: NSManagedObject {
        return try addObject { _ in }
    }

    func object(with objectID: NSManagedObjectID) throws -> NSManagedObject {
        return try self.viewContext.existingObject(with: objectID)
    }

    func deletedObjects<T>() -> [T] {
        return self.viewContext.deletedObjects.compactMap { $0 as? T }
    }
}

// MARK: - Private

private extension NSObject {

    @objc class var className: String {
        return String(describing: self)
    }

}

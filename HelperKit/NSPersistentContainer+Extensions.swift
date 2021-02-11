//
//  NSPersistentContainer+Extensions.swift
//  HelperKit
//
//  Created by Andrius Shiaulis on 18.01.2021.
//

import CoreData

public extension NSPersistentContainer {

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

    @discardableResult
    func addObject<T: NSManagedObject>(updateParametersBlock: (T) -> Void) throws -> T {
        guard let insertedObject = NSEntityDescription.insertNewObject(forEntityName: T.className, into: self.viewContext) as? T else {
            throw Error.unableToInsertObject
        }

        updateParametersBlock(insertedObject)

        return insertedObject
    }

    @discardableResult
    func addEmptyObject<T: NSManagedObject>() throws -> T {
        try addObject { _ in }
    }

    func object<T: NSManagedObject>(with objectID: NSManagedObjectID) throws -> T {
        if let object = try self.viewContext.existingObject(with: objectID) as? T {
            return object
        }
        else {
            throw Error.wrongEntityType
        }
    }

    func deletedObjects<T: NSManagedObject>() -> [T] {
        self.viewContext.deletedObjects.compactMap { $0 as? T }
    }

    func fetchObjects<T: NSManagedObject>(where predicates: [NSPredicate] = []) throws -> [T] {
        let fetchRequest = NSFetchRequest<T>(entityName: T.className)
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)

        var objects: [T] = []
        objects = try self.viewContext.fetch(fetchRequest)

        return objects
    }


}

extension NSPersistentContainer {

    enum Error: Swift.Error {
        case unableToInsertObject, wrongEntityType
    }
}

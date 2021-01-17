//
//  Bundle+Extensions.swift
//  WeatherKitTests
//
//  Created by Andrius Shiaulis on 17.01.2021.
//

import Foundation

public extension Bundle {

    func data(for resource: Resource) -> Data? {
        guard let url = self.url(forResource: resource.name, withExtension: resource.nameExtension) else {
            fatalError("Unable to find resource \(resource.name).\(resource.nameExtension)")
        }

        let data: Data
        do {
            data = try Data(contentsOf: url)
        }
        catch {
            fatalError("Unable to generate data for resource \(resource.name).\(resource.nameExtension)")
        }

        return data
    }
}

public extension Bundle {
    struct Resource {
        let name: String
        let nameExtension: String

        public init(name: String, nameExtension: String) {
            self.name = name
            self.nameExtension = nameExtension
        }
    }
}

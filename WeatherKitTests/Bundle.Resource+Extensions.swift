//
//  Bundle.Resource+Extensions.swift
//  WeatherKitTests
//
//  Created by Andrius Shiaulis on 17.01.2021.
//

import HelperKit

extension Bundle.Resource {
    static let testForecast: Bundle.Resource = .init(name: "TestForecast", nameExtension: "xml")
    static let testObservations: Bundle.Resource = .init(name: "TestObservations", nameExtension: "xml")
}

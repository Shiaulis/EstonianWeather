//
//  EndpointTests.swift
//  EstonianWeatherTests
//
//  Created by Andrius Shiaulis on 06.10.2020.
//

import XCTest
@testable import EstonianWeather

final class EndpointTests: XCTestCase {

    func test_forecastEndpoint_generateURLWithoutThrowing() {
        XCTAssertNoThrow(Endpoint.forecast(for: .current))
    }

    func test_forecastEndpoint_returnsCorrectURLForEachLocale() throws {
        let generatedURLString = try Endpoint.forecast().generateURL().absoluteString

        switch TestableLocale.current {
        case .english: XCTAssertEqual(generatedURLString, "https://ilmateenistus.ee/ilma_andmed/xml/forecast.php?lang=eng")
        case .russian: XCTAssertEqual(generatedURLString, "https://ilmateenistus.ee/ilma_andmed/xml/forecast.php?lang=rus")
        case .estonian: XCTAssertEqual(generatedURLString, "https://ilmateenistus.ee/ilma_andmed/xml/forecast.php?lang=est")
        case .anyOther: XCTAssertEqual(generatedURLString, "https://ilmateenistus.ee/ilma_andmed/xml/forecast.php?lang=eng")
        }
    }

    func test_observationEndpoint_generateURLWithoutThrowing() {
        XCTAssertNoThrow(try Endpoint.observations().generateURL())
    }

    func test_observationEndpoint_returnsCorrectURLForEachLocale() throws {
        let generatedURLString = try Endpoint.observations().generateURL().absoluteString

        XCTAssertEqual(generatedURLString, "https://ilmateenistus.ee/ilma_andmed/xml/observations.php")
    }
}

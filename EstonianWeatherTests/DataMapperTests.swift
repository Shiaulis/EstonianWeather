//
//  DataMapperTests.swift
//  EstonianWeatherTests
//
//  Created by Andrius Shiaulis on 13.01.2020.
//  Copyright © 2020 Andrius Shiaulis. All rights reserved.
//

import XCTest
import CoreData
@testable import EstonianWeather

class DataMapperTests: XCTestCase {

    // MARK: - Properties
    private var container: NSPersistentContainer!

    private lazy var ewForecasts: [EWForecast] = {
        let parser = WeatherParser()
        let bundle = Bundle(for: WeatherParserTests.self)
        let url = bundle.url(forResource: "TestForecast", withExtension: "xml")!
        let data = try! Data(contentsOf: url)

        let parseResult = parser.parse(data: data)

        return try! parseResult.get()
    }()

    private var sut: DataMapper!
    private var completionExpectation: XCTestExpectation!

    override func setUp() {
        super.setUp()
        self.container = NSPersistentContainer.createContainerForTesting()
        self.sut = DataMapper()
    }

    override func tearDown() {
        self.sut = nil
        self.container = nil
        self.completionExpectation = nil
        super.tearDown()
    }

    func testMapper_whenAddData_containCorrectAmountOfForecasts() throws {
        // when
        whenPerformMapping()

        // then
        wait(for: [self.completionExpectation], timeout: 100)
        let fetchRequest: NSFetchRequest<Forecast> = Forecast.fetchRequest()
        let result = try XCTUnwrap(try? self.container.viewContext.fetch(fetchRequest))
        XCTAssertEqual(result.count, 4)
    }

    func testMapper_whenAddSameDocumentTwice_containCorrectAmountOfForecasts() throws {
        // when
        whenPerformMapping()
        wait(for: [self.completionExpectation], timeout: 1)
        whenPerformMapping()
        wait(for: [self.completionExpectation], timeout: 1)

        // then
        let fetchRequest :NSFetchRequest<Forecast> = Forecast.fetchRequest()
        let result = try XCTUnwrap(try? self.container.viewContext.fetch(fetchRequest))
        XCTAssertEqual(result.count, 4)
    }

    // MARK: - When

    private func whenPerformMapping() {
        self.completionExpectation = expectation(description: "mapping completed")
        self.sut.performMapping(self.ewForecasts, context: self.container.viewContext) {
            if let error = $0 {
                XCTFail("Failed to perform mapping. Error: \(error.localizedDescription)")
            }

            self.completionExpectation.fulfill()
            self.completionExpectation = nil
        }
    }

}

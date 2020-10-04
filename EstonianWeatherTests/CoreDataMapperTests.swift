//
//  CoreDataMapperTests.swift
//  EstonianWeatherTests
//
//  Created by Andrius Shiaulis on 13.01.2020.
//  Copyright © 2020 Andrius Shiaulis. All rights reserved.
//  swiftlint:disable force_try

import XCTest
import CoreData
@testable import EstonianWeather

class CoreDataMapperTests: XCTestCase {

    // MARK: - Properties
    private var container: NSPersistentContainer!

    private lazy var ewForecasts: [EWForecast] = {
        let parser: WeatherParser = XMLWeatherParser()
        let bundle = Bundle(for: WeatherParserTests.self)
        let url = bundle.url(forResource: "TestForecast", withExtension: "xml")!
        let data = try! Data(contentsOf: url)

        let parseResult = parser.parse(data: data, receivedDate: Date(), languageCode: "ru")

        return try! parseResult.get()
    }()

    private var sut: CoreDataMapper!
    private var completionExpectation: XCTestExpectation!

    override func setUp() {
        super.setUp()
        self.container = NSPersistentContainer.createContainerForTesting()
        self.sut = CoreDataMapper(logger: PrintLogger())
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
        let fetchRequest: NSFetchRequest<Forecast> = Forecast.fetchRequest()
        let result = try XCTUnwrap(try? self.container.viewContext.fetch(fetchRequest))
        XCTAssertEqual(result.count, 4)
    }

    func testMapper_whenAddSameDocumentTwice_containCorrectAmountOfForecasts() throws {
        // when
        whenPerformMapping()
        whenPerformMapping()

        // then
        let fetchRequest: NSFetchRequest<Forecast> = Forecast.fetchRequest()
        let result = try XCTUnwrap(try? self.container.viewContext.fetch(fetchRequest))
        XCTAssertEqual(result.count, 4)
    }

    // MARK: - When

    private func whenPerformMapping() {
        do {
            _ = try self.sut.performMapping(self.ewForecasts, context: self.container.viewContext)
        }
        catch {
            XCTFail("Failed to perform mapping. Error: \(error.localizedDescription)")
        }
    }

}

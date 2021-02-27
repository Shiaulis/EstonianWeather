//
//  CoreDataMapperTests.swift
//  EstonianWeatherTests
//
//  Created by Andrius Shiaulis on 13.01.2020.
//  Copyright © 2020 Andrius Shiaulis. All rights reserved.
//  swiftlint:disable force_try

import XCTest
import CoreData
import Logger
@testable import EstonianWeather

final class CoreDataMapperTests: XCTestCase {

    // MARK: - Properties
    private var container: NSPersistentContainer!

    private var ewForecasts: [EWForecast]!

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
        // given
        try givenCorrectEWForecasts()

        // when
        whenPerformMapping()

        // then
        let fetchRequest: NSFetchRequest<Forecast> = Forecast.fetchRequest()
        let result = try XCTUnwrap(try? self.container.viewContext.fetch(fetchRequest))
        XCTAssertEqual(result.count, 4)
    }

    func testMapper_whenAddSameDocumentTwice_containCorrectAmountOfForecasts() throws {
        // given
        try givenCorrectEWForecasts()

        // when
        whenPerformMapping()
        whenPerformMapping()

        // then
        let fetchRequest: NSFetchRequest<Forecast> = Forecast.fetchRequest()
        let result = try XCTUnwrap(try? self.container.viewContext.fetch(fetchRequest))
        XCTAssertEqual(result.count, 4)
    }

    // MARK: - Given

    private func givenCorrectEWForecasts() throws {
        let parser: ServerResponseParser = ServerResponseXMLParser()
        let bundle = Bundle(for: Self.self)
        let url = bundle.url(forResource: "TestForecast", withExtension: "xml")!
        let data = try! Data(contentsOf: url)

        self.ewForecasts = try parser.parse(forecastData: data, receivedDate: Date(), languageCode: "ru").get()
    }

    // MARK: - When

    private func whenPerformMapping() {
        do {
            _ = try self.sut.performForecastMapping(self.ewForecasts, context: self.container.viewContext)
        }
        catch {
            XCTFail("Failed to perform mapping. Error: \(error.localizedDescription)")
        }
    }

}

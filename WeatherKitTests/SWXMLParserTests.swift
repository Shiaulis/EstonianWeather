//
//  SWXMLParserTests.swift
//  WeatherKitTests
//
//  Created by Andrius Shiaulis on 17.01.2021.
//

import XCTest
import CoreData
@testable import WeatherKit

final class SWXMLParserTests: XCTestCase {

    // MARK: - Properties

    private var sut: SWXMLParser!
    private var data: Data!
    private var container: NSPersistentContainer!
    private var context: NSManagedObjectContext!

    // MARK: - Setup and teardown

    override func setUp() {
        super.setUp()
        self.container = NSPersistentContainer.createContainerForTesting()
        self.context = self.container.newBackgroundContext()
        self.sut = SWXMLParser(languageCode: "en")
    }

    override func tearDown() {
        self.sut = nil
        self.data = nil
        self.context = nil
        self.container = nil
        super.tearDown()
    }

    // MARK: - Tests

    func testParser_correctData_noThrow() throws {
        givenCorrectData()

        XCTAssertNoThrow(try whenParsing())
    }

    func testParser_whenCorrectData_thenReceiveCorrectForecastCount() throws {
        givenCorrectData()

        try whenParsing()

        let forecasts: [Forecast] = try self.container.fetchObjects()
        XCTAssertEqual(forecasts.count, 4)
    }

    func testParser_whenCorrectData_thenReceiveCorrectForecastDates() throws {
        givenCorrectData()
        let expectedDateStrings = ["2021-01-18", "2021-01-19", "2021-01-20", "2021-01-21"]

        try whenParsing()

        let forecasts: [Forecast] = try self.container.fetchObjects()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"

        let forecastDateStrings = forecasts.map { dateFormatter.string(from: $0.forecastDate!) }

        XCTAssertEqual(forecastDateStrings, expectedDateStrings)
    }

    // MARK: - Given

    private func givenCorrectData() {
        self.data = Bundle(for: Self.self).data(for: .testForecast)
    }

    // MARK: - When

    private func whenParsing() throws {
        try self.sut.parse(data: self.data, storeTo: self.context)
        try self.context.save()
    }

}

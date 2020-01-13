//
//  WeatherParserTests.swift
//  EstonianWeatherTests
//
//  Created by Andrius Shiaulis on 12.01.2020.
//  Copyright © 2020 Andrius Shiaulis. All rights reserved.
//

import XCTest
@testable import EstonianWeather

private let defaultTimeout: TimeInterval = 1000

class WeatherParserTests: XCTestCase {

    // MARK: - Properties

    var sut: WeatherParser!
    var data: Data!
    var parseExpectation: XCTestExpectation!
    var receivedError: WeatherParser.Error!
    var receivedDocument: EWDocument!

    // MARK: - Setup and teardown

    override func setUp() {
        super.setUp()
        self.sut = WeatherParser()
    }

    override func tearDown() {
        self.sut = nil
        self.data = nil
        self.parseExpectation = nil
        self.receivedError = nil
        self.receivedDocument = nil
        super.tearDown()
    }

    // MARK: - Tests

    func testParser_whenParseWithCorrectData_receivedXMLDocument() {
        // given
        givenCorrectData()

        // when
        whenParse()

        // then
        XCTAssertNotNil(self.receivedDocument)
    }

    func testParser_whenParseWithIncorrectData_receivedError() throws {
        // given
        givenNilData()

        // when
        whenParse()

        // then
        XCTAssertEqual(self.receivedError, .incorrectInputData)
    }

    func testParser_whenParseCorrectData_receivedForecasts() {
        // given
        givenCorrectData()

        // when
        whenParse()

        // then
        XCTAssertEqual(self.receivedDocument.forecasts?.count, 4)
    }

    // MARK: - Given
    private func givenCorrectData() {
        let bundle = Bundle(for: WeatherParserTests.self)
        let url = bundle.url(forResource: "TestForecast", withExtension: "xml")!
        self.data = try? Data(contentsOf: url)
    }

    private func givenNilData() {
        self.data = nil
    }

    // MARK: - When
    private func whenParse() {
        let serviceInfo = EWDocument.ServiceInfo(date: Date(), languageCode: "en")
        let parseResult = self.sut.parse(data: self.data, serviceInfo: serviceInfo)

        switch parseResult {
        case .success(let document): self.receivedDocument = document
        case .failure(let error): self.receivedError = error
        }
    }
}

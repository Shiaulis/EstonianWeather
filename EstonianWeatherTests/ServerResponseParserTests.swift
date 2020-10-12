//
//  ServerResponseParserTests.swift
//  EstonianWeatherTests
//
//  Created by Andrius Shiaulis on 12.01.2020.
//  Copyright © 2020 Andrius Shiaulis. All rights reserved.
//

import XCTest
@testable import EstonianWeather

final class ServerResponseParserTests: XCTestCase {

    // MARK: - Properties

    private var sut: ServerResponseParser!
    private var data: Data!
    private var parseExpectation: XCTestExpectation!
    private var receivedError: Error!
    private var receivedForecasts: [EWForecast]!
    private var receivedObservations: [EWObservation]!

    // MARK: - Setup and teardown

    override func setUp() {
        super.setUp()
        self.sut = ServerResponseXMLParser()
    }

    override func tearDown() {
        self.sut = nil
        self.data = nil
        self.parseExpectation = nil
        self.receivedError = nil
        self.receivedForecasts = nil
        super.tearDown()
    }

    // MARK: - Forecast parsing tests

    func testParser_whenParseForecastWithCorrectData_receivedXMLDocument() {
        // given
        givenCorrectForecastData()

        // when
        whenParseForecast()

        // then
        XCTAssertNotNil(self.receivedForecasts)
    }

    func testParser_whenParseForecastWithIncorrectData_receivedError() throws {
        // given
        givenNilData()

        // when
        whenParseForecast()

        // then
        XCTAssertEqual(self.receivedError as? ServerResponseXMLParser.Error, ServerResponseXMLParser.Error.incorrectInputData)
    }

    func testParser_whenParseForecastCorrectData_receivedForecasts() {
        // given
        givenCorrectForecastData()

        // when
        whenParseForecast()

        // then
        XCTAssertEqual(self.receivedForecasts?.count, 4)
    }

    // MARK: - Oservations parsing tests

    func testParser_whenParseObservationsWithCorrectData_receivedXMLDocument() {
        // given
        givenCorrectObservationsData()

        // when
        whenParseObservations()

        // then
        XCTAssertNotNil(self.receivedObservations)
    }

    func testParser_whenParseObservationsWithIncorrectData_receivedError() throws {
        // given
        givenNilData()

        // when
        whenParseObservations()

        // then
        XCTAssertEqual(self.receivedError as? ServerResponseXMLParser.Error, ServerResponseXMLParser.Error.incorrectInputData)
    }

    func testParser_whenParseObservationsCorrectData_receivedForecasts() {
        // given
        givenCorrectObservationsData()

        // when
        whenParseObservations()

        // then
        XCTAssertEqual(self.receivedObservations?.count, 105)
    }

    // MARK: - Given

    private func givenCorrectForecastData() {
        let bundle = Bundle(for: ServerResponseParserTests.self)
        let url = bundle.url(forResource: "TestForecast", withExtension: "xml")!
        self.data = try? Data(contentsOf: url)
    }

    private func givenCorrectObservationsData() {
        let bundle = Bundle(for: ServerResponseParserTests.self)
        let url = bundle.url(forResource: "TestObservations", withExtension: "xml")!
        self.data = try? Data(contentsOf: url)
    }

    private func givenNilData() {
        self.data = nil
    }

    // MARK: - When

    private func whenParseForecast() {
        let parseResult = self.sut.parse(forecastData: self.data, receivedDate: Date(), languageCode: "ru")

        switch parseResult {
        case .success(let forecasts): self.receivedForecasts = forecasts
        case .failure(let error): self.receivedError = error
        }
    }

    private func whenParseObservations() {
        let parseResult = self.sut.parse(observationData: self.data, receivedDate: Date())

        switch parseResult {
        case .success(let observations): self.receivedObservations = observations
        case .failure(let error): self.receivedError = error
        }
    }
}

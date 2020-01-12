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

    func testParser_whenParseWithCorrectData_completionCalled() {
        // given
        givenCorrectData()

        // when
        whenParse()

        // then
        let result = XCTWaiter.wait(for: self.parseExpectation)
        XCTAssertEqual(result, .completed)
    }

    func testParser_whenParseWithIncorrectData_completionCalled() {
        // given
        givenNilData()

        // when
        whenParse()

        // then
        let result = XCTWaiter.wait(for: self.parseExpectation)
        XCTAssertEqual(result, .completed)
    }

    func testParser_whenParseWithCorrectData_receivedXMLDocument() {
        // given
        givenCorrectData()

        // when
        whenParse()

        // then
        wait(for: self.parseExpectation)
        XCTAssertNotNil(self.receivedDocument)
    }

    func testParser_whenParseWithIncorrectData_receivedError() throws {
        // given
        givenNilData()

        // when
        whenParse()

        // then
        wait(for: self.parseExpectation)
        XCTAssertEqual(self.receivedError, .incorrectInputData)
    }

    func testParser_whenParseCorrectData_receivedForecasts() {
        // given
        givenCorrectData()

        // when
        whenParse()

        // then
        wait(for: self.parseExpectation)
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
        self.parseExpectation = expectation(description: "Parse completion gets called")

        self.sut.parse(data: self.data) { result in
            switch result {
            case .success(let document): self.receivedDocument = document
            case .failure(let error): self.receivedError = error
            }

            self.parseExpectation.fulfill()
        }

    }
}

extension XCTestCase {
    func wait(for expectation: XCTestExpectation) {
        wait(for: [expectation], timeout: defaultTimeout)
    }
}

extension XCTWaiter {
    static func wait(for expectation: XCTestExpectation) -> XCTWaiter.Result {
        wait(for: [expectation], timeout: defaultTimeout)
    }

}

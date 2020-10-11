//
//  ForecastDateFormatterTests.swift
//  EstonianWeatherTests
//
//  Created by Andrius Shiaulis on 22.01.2020.
//  Copyright © 2020 Andrius Shiaulis. All rights reserved.
//

import Foundation
import XCTest
@testable import EstonianWeather

final class ForecastDateFormatterTests: XCTestCase {

    // MARK: - Properties

    private var sut: ForecastDateFormatter!

    // MARK: - Setup and teardown

    override func setUp() {
        super.setUp()
        self.sut = .init(locale: .current)
    }

    override func tearDown() {
        self.sut = nil
        super.tearDown()
    }

    // MARK: - Tests

    func testFormatter_whenRequestHumanReadableStringForToday_returnsCorrectValue() {
        let today = Date()

        let receivedDescription = self.sut.humanReadableDescription(for: today)
        // then
        switch TestableLocale.current {
        case .english: XCTAssertEqual(receivedDescription, "\(expectedString(from: today)), Today")
        case .estonian: XCTAssertEqual(receivedDescription, "\(expectedString(from: today)), Täna")
        case .russian: XCTAssertEqual(receivedDescription, "\(expectedString(from: today)), Сегодня")
        case .ukrainian: XCTAssertEqual(receivedDescription, "\(expectedString(from: today)), Сьогодні")
        }
    }

    func testFormatter_whenRequestHumanReadableStringForTomorrow_returnsCorrectValue() {
        let today = Date()
        let tomorrow = today.addingTimeInterval(24 * 60 * 60)

        let receivedDescription = self.sut.humanReadableDescription(for: tomorrow)
        switch TestableLocale.current {
        case .english: XCTAssertEqual(receivedDescription, "\(expectedString(from: tomorrow)), Tomorrow")
        case .estonian: XCTAssertEqual(receivedDescription, "\(expectedString(from: tomorrow)), Homme")
        case .russian: XCTAssertEqual(receivedDescription, "\(expectedString(from: tomorrow)), Завтра")
        case .ukrainian: XCTAssertEqual(receivedDescription, "\(expectedString(from: tomorrow)), Завтра")
        }
    }

    private func expectedString(from date: Date) -> String {
        let formatter: DateFormatter = .init()
        formatter.setLocalizedDateFormatFromTemplate("MMMMd")
        return formatter.string(from: date)
    }

}

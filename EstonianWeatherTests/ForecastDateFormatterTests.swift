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
        switch Locale.current.languageCode {
        case "en": XCTAssertEqual(receivedDescription, "\(expectedString(from: today)), Today")
        case "et": XCTAssertEqual(receivedDescription, "Täna")
        case "ru": XCTAssertEqual(receivedDescription, "Сегодня")
        default: fatalError("Language doesn't supported")
        }
    }

    func testFormatter_whenRequestHumanReadableStringForTomorrow_returnsCorrectValue() {
        let today = Date()
        let tomorrow = today.addingTimeInterval(24 * 60 * 60)

        let receivedDescription = self.sut.humanReadableDescription(for: tomorrow)
        switch Locale.current.languageCode {
        case "en": XCTAssertEqual(receivedDescription, "\(expectedString(from: tomorrow)), Tomorrow")
        case "et": XCTAssertEqual(receivedDescription, "Homme")
        case "ru": XCTAssertEqual(receivedDescription, "Завтра")
        default: fatalError("Language doesn't supported")
        }
    }

    func testFormatter_whenRequestHumanReadableStringForDayAfterTomorrow_returnsNil() {
//        // given
//        givenDayAfterTomorrow()
//
//        // when
//        whenHumanReadableDescriptionRequested()
//
//        // then
//        switch Locale.current.languageCode {
//        case "en": XCTAssertEqual(self.receivedDateDescription, nil)
//        case "et": XCTAssertEqual(self.receivedDateDescription, nil)
//        case "ru": XCTAssertEqual(self.receivedDateDescription, nil)
//        default: fatalError("Language doesn't supported")
//        }
    }

    // MARK: - Dates

    private func januaryFirstMorning() -> Date! {
        var components = DateComponents()
        components.year = 2020
        components.month = 1
        components.day = 1
        components.hour = 8
        components.minute = 0
        components.timeZone = TimeZone(abbreviation: "EEST")
        components.calendar = .current
        return components.date!
    }

    private func expectedString(from date: Date) -> String {
        let formatter: DateFormatter = .init()
        formatter.setLocalizedDateFormatFromTemplate("MMMMd")
        return formatter.string(from: date)
    }

}

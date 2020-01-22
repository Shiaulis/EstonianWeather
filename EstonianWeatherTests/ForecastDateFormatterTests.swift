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
    private var givenDate: Date!
    private var receivedDateDescription: String?

    // MARK: - Setup and teardown

    override func setUp() {
        super.setUp()
        self.sut = .init(locale: .current)
    }

    override func tearDown() {
        self.receivedDateDescription = nil
        self.givenDate = nil
        self.sut = nil
        super.tearDown()
    }

    // MARK: - Tests

    func testFormatter_whenRequestHumanReadableStringForToday_returnsCorrectValue() {
        // given
        givenToday()

        // when
        whenHumanReadableDescriptionRequested()

        // then
        switch Locale.current.languageCode {
        case "en": XCTAssertEqual(self.receivedDateDescription, "Today")
        case "et": XCTAssertEqual(self.receivedDateDescription, "Täna")
        case "ru": XCTAssertEqual(self.receivedDateDescription, "Сегодня")
        default: fatalError("Language doesn't supported")
        }
    }

    func testFormatter_whenRequestHumanReadableStringForTomorrow_returnsCorrectValue() {
        // given
        givenTomorrow()

        // when
        whenHumanReadableDescriptionRequested()

        // then
        switch Locale.current.languageCode {
        case "en": XCTAssertEqual(self.receivedDateDescription, "Tomorrow")
        case "et": XCTAssertEqual(self.receivedDateDescription, "Homme")
        case "ru": XCTAssertEqual(self.receivedDateDescription, "Завтра")
        default: fatalError("Language doesn't supported")
        }
    }

    func testFormatter_whenRequestHumanReadableStringForDayAfterTomorrow_returnsNil() {
        // given
        givenDayAfterTomorrow()

        // when
        whenHumanReadableDescriptionRequested()

        // then
        switch Locale.current.languageCode {
        case "en": XCTAssertEqual(self.receivedDateDescription, nil)
        case "et": XCTAssertEqual(self.receivedDateDescription, nil)
        case "ru": XCTAssertEqual(self.receivedDateDescription, nil)
        default: fatalError("Language doesn't supported")
        }
    }


    // MARK: - Given

    private func givenToday() {
        self.givenDate = Date()
    }

    private func givenTomorrow() {
        let calendar: Calendar = .current
        self.givenDate = calendar.date(byAdding: .day, value: 1, to: Date())
    }

    private func givenDayAfterTomorrow() {
        let calendar: Calendar = .current
        self.givenDate = calendar.date(byAdding: .day, value: 2, to: Date())
    }

    // MARK: - When

    private func whenHumanReadableDescriptionRequested() {
        self.receivedDateDescription = self.sut.humanReadableDescription(for: self.givenDate)
    }

}

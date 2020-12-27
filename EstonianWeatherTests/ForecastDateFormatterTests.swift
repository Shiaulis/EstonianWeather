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
        self.sut = .init(localization: .english)
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
        case .english: XCTAssertEqual(receivedDescription?.byWords.last, "Today")
        case .estonian: XCTAssertEqual(receivedDescription?.byWords.last, "Täna")
        case .russian: XCTAssertEqual(receivedDescription?.byWords.last, "Сегодня")
        case .anyOther: XCTAssertEqual(receivedDescription?.byWords.last, "Today")
        }
    }

    func testFormatter_whenRequestHumanReadableStringForTomorrow_returnsCorrectValue() {
        let today = Date()
        let tomorrow = today.addingTimeInterval(24 * 60 * 60)

        let receivedDescription = self.sut.humanReadableDescription(for: tomorrow)
        switch TestableLocale.current {
        case .english: XCTAssertEqual(receivedDescription?.byWords.last, "Tomorrow")
        case .estonian: XCTAssertEqual(receivedDescription?.byWords.last, "Homme")
        case .russian: XCTAssertEqual(receivedDescription?.byWords.last, "Завтра")
        case .anyOther: XCTAssertEqual(receivedDescription?.byWords.last, "Tomorrow")
        }
    }

    private func expectedString(from date: Date) -> String {
        let formatter: DateFormatter = .init()
        formatter.setLocalizedDateFormatFromTemplate("MMMMd")
        return formatter.string(from: date)
    }

}

private extension StringProtocol { // for Swift 4 you need to add the constrain `where Index == String.Index`
    var byWords: [SubSequence] {
        var byWords: [SubSequence] = []
        enumerateSubstrings(in: startIndex..., options: .byWords) { _, range, _, _ in
            byWords.append(self[range])
        }
        return byWords
    }
}

//
//  EstonianWeatherUITests.swift
//  EstonianWeatherUITests
//
//  Created by Andrius Shiaulis on 28.09.2020.
//

import XCTest

final class EstonianWeatherUITests: XCTestCase {

    private lazy var app = XCUIApplication()

    struct ExpectedStrings {
        static func navigationTitle(for locale: TestableLocale) -> String {
            switch locale {
            case .english: return "4 Days Forecast"
            case .estonian: return "4 päeva"
            case .russian: return "Прогноз на 4 дня"
            case .anyOther: return "4 Days Forecast"
            }
        }
    }

    private var navigationBarTitle: XCUIElement {
        self.app.navigationBars.firstMatch.staticTexts.firstMatch
    }

    override func setUp() {
        super.setUp()
        self.app.launch()
    }

    func test_defaultScreen_correctNavigationTitle() throws {
        XCTAssertEqual(
            self.navigationBarTitle.label,
            ExpectedStrings.navigationTitle(for: .current),
            "Unexpected navigation bar title for \(TestableLocale.current.rawValue) locale"
            )
    }

    func testLaunchPerformance() throws {
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}

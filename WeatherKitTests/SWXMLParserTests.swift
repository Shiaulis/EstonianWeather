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

    private var data: Data!
    private var sut: SWXMLParser!
    private var container: NSPersistentContainer!

    override func setUp() {
        super.setUp()
        self.container = NSPersistentContainer.createContainerForTesting()
        self.sut = SWXMLParser(context: self.container.newBackgroundContext(), languageCode: "en")
    }

    override func tearDown() {
        self.sut = nil
        self.data = nil
        self.container = nil
        super.tearDown()
    }

    func testParser_correctData_notThrow() throws {
        provideCorrectData()

        XCTAssertNoThrow(try self.sut.parse(data: self.data))
    }

    private func provideCorrectData() {
        self.data = Bundle(for: Self.self).data(for: .testForecast)
    }
}

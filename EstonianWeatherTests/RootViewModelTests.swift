//
//  RootViewModelTests.swift
//  EstonianWeatherTests
//
//  Created by Andrius Shiaulis on 13.01.2020.
//  Copyright © 2020 Andrius Shiaulis. All rights reserved.
//

import XCTest
import CoreData
@testable import EstonianWeather

class RootViewModelTests: XCTestCase {

    // MARK: - Properties
    var sut: RootViewMolel!

    // MARK: - Setup and teardown

    override func setUp() {
        super.setUp()

        self.sut = RootViewMolel()
    }

    override func tearDown() {
        self.sut = nil

        super.tearDown()
    }

    // MARK: - Tests

//    func testViewModel_whenFetch_receivedData() {
//        // given
//        let exp = expectation(description: "completion gets called")
//
//        // when
//        var receivedData: Data?
//        self.sut.fetch { result in
//            receivedData = try! result.get()
//            exp.fulfill()
//        }
//
//        // then
//        wait(for: [exp], timeout: 100)
//        XCTAssertNotNil(receivedData)
//    }

}

//
//  WeatherModelTests.swift
//  WeatherModelTests
//
//  Created by Andrius Shiaulis on 17.01.2021.
//

import XCTest
@testable import WeatherKit

final class WeatherModelTests: XCTestCase {

    private var sut: WeatherModel!

    override func setUp() {
        super.setUp()
        self.sut = .init()
    }

}

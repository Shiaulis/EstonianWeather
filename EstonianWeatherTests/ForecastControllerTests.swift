//
//  ForecastControllerTests.swift
//  EstonianWeatherTests
//
//  Created by Andrius Shiaulis on 17.01.2020.
//  Copyright © 2020 Andrius Shiaulis. All rights reserved.
//

import XCTest
import CoreData
@testable import EstonianWeather

final class ForecastControllerTests: XCTestCase {

    // MARK: - Properties
    private var container: NSPersistentContainer!
    private var forecast: Forecast!
    private var sut: ForecastController!
    private var displayItem: ForecastDisplayItem!

    // MARK: - Setup and teardown

    override func setUp() {
        super.setUp()
        self.container = createContainer()
        self.forecast = .init(context: self.container.viewContext)
        self.sut = ForecastController()
    }

    override func tearDown() {
        self.displayItem = nil
        self.sut = nil
        self.forecast = nil
        self.container = nil
        super.tearDown()
    }

    // MARK: - Tests forecast display item

    func testController_whenCreateDisplayItem_containCorrectDateString() {
        // given
        let expectedDate = "January 17"
        let givenDate = day(forDay: 17, month: 01)
        self.forecast.date = givenDate

        // when
        whenCreateDisplayItem()

        // then
        XCTAssertEqual(self.displayItem.date, expectedDate)
    }

    func testController_whenCreateDisplayItem_containCorrectNumberOfDayParts() {
        // given
        givenForecastWithDayAndNight()

        // when
        whenCreateDisplayItem()

        // then
        XCTAssertEqual(self.displayItem.dayParts.count, 2)
    }

    // MARK: - Tests day part display item

    func testController_whenCreateDayPartDisplayItem_containCorrectTempRangeString() {
        // given
        givenForecastWithDayAndNight()
        let minTemperature = -5
        let maxTemperature = 5
        let expectedSting = "–\(abs(minTemperature))…+\(maxTemperature)"
        self.forecast.night?.tempmin = NSNumber(value: minTemperature)
        self.forecast.night?.tempmax = NSNumber(value: maxTemperature)

        // when
        whenCreateDisplayItem()

        // then
        XCTAssertEqual(self.displayItem.dayParts.first?.temperatureRange, expectedSting)
    }

    func testController_whenCreateDayPartDisplayItem_containCorrectDescription() {
        // given
        givenForecastWithDayAndNight()
        let expectedDescription = String.loremIpsum
        self.forecast.night?.text = expectedDescription

        // when
        whenCreateDisplayItem()

        // then
        XCTAssertEqual(self.displayItem.dayParts.first?.description, expectedDescription)
    }

    func testController_whenCreateDayPartDisplayItem_containCorrectNumberOfPlaces() {
        // given
        givenForecastWithNigthContainTwoPlaces()

        // when
        whenCreateDisplayItem()

        // then
        XCTAssertEqual(self.displayItem.dayParts.first?.places.count, 2)
    }

    func testController_whenCreatePlaceDisplayItem_containCorrectName() {
        // given
        givenForecastWithNigthContainTwoPlaces()
        let expectedPlaceName = "Pärnu"
        self.forecast.night?.places?.first?.name = expectedPlaceName

        // when
        whenCreateDisplayItem()

        // then
        XCTAssertEqual(self.displayItem.dayParts.first?.places.first?.name, expectedPlaceName)
    }

    func testController_whenCreatePlaceDisplayItem_containCorrectTemperatureRange() {
        // given
        givenForecastWithNigthContainTwoPlaces()
        let minTemperature = -5
        let maxTemperature = 5
        let expectedSting = "–\(abs(minTemperature))…+\(maxTemperature)"
        self.forecast.night?.places?.first?.tempmin = NSNumber(value: minTemperature)
        self.forecast.night?.places?.first?.tempmax = NSNumber(value: maxTemperature)

        // when
        whenCreateDisplayItem()

        // then
        XCTAssertEqual(self.displayItem.dayParts.first?.places.first?.temperature, expectedSting)
    }

    func testController_whenCreatePlaceDisplayItem_containCorrectMinTemperature() {
        // given
        givenForecastWithNigthContainTwoPlaces()
        let minTemperature = -5
        let expectedSting = "–\(abs(minTemperature))"
        self.forecast.night?.places?.first?.tempmin = NSNumber(value: minTemperature)

        // when
        whenCreateDisplayItem()

        // then
        XCTAssertEqual(self.displayItem.dayParts.first?.places.first?.temperature, expectedSting)
    }


    // MARK: - Given

    private func givenForecastWithDayAndNight() {
        self.forecast.day = .init(context: self.container.viewContext)
        self.forecast.night = .init(context: self.container.viewContext)
    }

    private func givenForecastWithNigthContainTwoPlaces() {
        let places: [Place] = [
            .init(context: self.container.viewContext),
            .init(context: self.container.viewContext)
        ]

        self.forecast.night = .init(context: self.container.viewContext)
        self.forecast.night?.places = Set(places)
    }

    // MARK: - When

    private func whenCreateDisplayItem() {
        self.displayItem = self.sut.displayItem(for: self.forecast)
    }

    // MARK: - Private

    private func day(forDay day: Int, month: Int) -> Date {
        var components = DateComponents()
        components.day = day
        components.month = month

        return Calendar.current.date(from: components)!
    }

    private func createContainer() -> NSPersistentContainer {
        let container = NSPersistentContainer(name: "EstonianWeather")
        let description = container.persistentStoreDescriptions.first!
        description.url = URL(fileURLWithPath: "/dev/null")

        container.loadPersistentStores { (_, error) in
            guard let error = error as NSError? else { return }
            fatalError("###\(#function): Failed to load persistent stores: \(error)")
        }

        return container
    }

}

private extension String {
    static let loremIpsum =
    """
Lorem Ipsum คือ เนื้อหาจำลองแบบเรียบๆ ที่ใช้กันในธุรกิจงานพิมพ์หรืองานเรียงพิมพ์ มันได้กลายมาเป็นเนื้อหาจำลองมาตรฐานของธุรกิจดังกล่าวมาตั้งแต่ศตวรรษที่ 16 เมื่อเครื่องพิมพ์โนเนมเครื่องหนึ่งนำรางตัวพิมพ์มาสลับสับตำแหน่งตัวอักษรเพื่อทำหนังสือตัวอย่าง Lorem Ipsum อยู่ยงคงกระพันมาไม่ใช่แค่เพียงห้าศตวรรษ แต่อยู่มาจนถึงยุคที่พลิกโฉมเข้าสู่งานเรียงพิมพ์ด้วยวิธีทางอิเล็กทรอนิกส์ และยังคงสภาพเดิมไว้อย่างไม่มีการเปลี่ยนแปลง มันได้รับความนิยมมากขึ้นในยุค ค.ศ. 1960 เมื่อแผ่น Letraset วางจำหน่ายโดยมีข้อความบนนั้นเป็น Lorem Ipsum และล่าสุดกว่านั้น คือเมื่อซอฟท์แวร์การทำสื่อสิ่งพิมพ์ (Desktop Publishing) อย่าง Aldus PageMaker ได้รวมเอา Lorem Ipsum เวอร์ชั่นต่างๆ เข้าไว้ในซอฟท์แวร์ด้วย
"""
}

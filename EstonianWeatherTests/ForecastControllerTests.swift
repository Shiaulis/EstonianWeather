//
//  ForecastControllerTests.swift
//  EstonianWeatherTests
//
//  Created by Andrius Shiaulis on 17.01.2020.
//  Copyright © 2020 Andrius Shiaulis. All rights reserved.
//  swiftlint:disable force_try

import XCTest
import CoreData
@testable import EstonianWeather

final class ForecastControllerTests: XCTestCase {

    // MARK: - Properties
    private var container: NSPersistentContainer!
    private var locale: Locale!
    private var forecast: Forecast!
    private var sut: ForecastDataProvider!
    private var displayItems: [ForecastDisplayItem]!
    private var firstDisplayItem: ForecastDisplayItem! { self.displayItems.first }

    private var localization: AppLocalization { .init(locale: self.locale) }

    // MARK: - Setup and teardown

    override func setUp() {
        super.setUp()
        self.container = NSPersistentContainer.createContainerForTesting()
        self.locale = .current
        self.forecast = try! create(in: self.container.viewContext)
        self.forecast.languageCode = localization.languageCode
        self.sut = ForecastDataProvider()
    }

    override func tearDown() {
        self.displayItems = nil
        self.sut = nil
        self.forecast = nil
        self.locale = nil
        self.container = nil
        super.tearDown()
    }

    // MARK: - Tests forecast display item

    func testProvider_whenProvide_returnSuccess() {
        XCTAssertNoThrow(try self.sut.provide(with: self.container.viewContext, for: self.localization).get())
    }

    func testProvider_whenProvide_returnsForecastCorrectDateString() {
        // given
        let expectedDate = "17. January"
        let givenDate = day(forDay: 17, month: 01)
        self.forecast.forecastDate = givenDate

        // when
        whenRequestDisplayItems()

        // then
        XCTAssertEqual(self.firstDisplayItem.date, expectedDate)
    }

    func testProvider_whenProvide_returnsCorrectNumberOfDayParts() {
        // given
        givenForecastWithDayAndNight()

        // when
        whenRequestDisplayItems()

        // then
        XCTAssertEqual(self.firstDisplayItem.dayParts.count, 2)
    }

    // MARK: - Tests day part display item

    func testProvider_whenProvide_returnsCorrectTempRangeString() {
        // given
        givenForecastWithDayAndNight()
        let minTemperature = -5
        let maxTemperature = 5
        let expectedSting = "–\(abs(minTemperature))…+\(maxTemperature) ℃"
        self.forecast.night?.tempmin = NSNumber(value: minTemperature)
        self.forecast.night?.tempmax = NSNumber(value: maxTemperature)

        // when
        whenRequestDisplayItems()

        // then
        XCTAssertEqual(self.firstDisplayItem.dayParts.first?.temperatureRange, expectedSting)
    }

    func testProvider_whenProvide_returnsCorrectDescription() {
        // given
        givenForecastWithDayAndNight()
        let expectedDescription = String.loremIpsum
        self.forecast.night?.text = expectedDescription

        // when
        whenRequestDisplayItems()

        // then
        XCTAssertEqual(self.firstDisplayItem.dayParts.first?.description, expectedDescription)
    }

    func testProvider_whenProvide_returnsCorrectNumberOfPlaces() {
        // given
        givenForecastWithNigthContainTwoPlaces()

        // when
        whenRequestDisplayItems()

        // then
        XCTAssertEqual(self.firstDisplayItem.dayParts.first?.places.count, 2)
    }

    func testProvider_whenProvide_returnsCorrectName() {
        // given
        givenForecastWithNigthContainTwoPlaces()
        let expectedPlaceName = "Pärnu"
        self.forecast.night?.places?.first?.name = expectedPlaceName

        // when
        whenRequestDisplayItems()

        // then
        XCTAssertEqual(self.firstDisplayItem.dayParts.first?.places.first?.name, expectedPlaceName)
    }

    func testProvider_whenProvide_returnsCorrectTemperatureRange() {
        // given
        givenForecastWithNigthContainTwoPlaces()
        let minTemperature = -5
        let maxTemperature = 5
        let expectedSting = "–\(abs(minTemperature))…+\(maxTemperature) ℃"
        self.forecast.night?.places?.first?.tempmin = NSNumber(value: minTemperature)
        self.forecast.night?.places?.first?.tempmax = NSNumber(value: maxTemperature)

        // when
        whenRequestDisplayItems()

        // then
        XCTAssertEqual(self.firstDisplayItem.dayParts.first?.places.first?.temperature, expectedSting)
    }

    func testProvider_whenProvide_returnsCorrectMinTemperature() {
        // given
        givenForecastWithNigthContainTwoPlaces()
        let minTemperature = -5
        let expectedSting = "–\(abs(minTemperature)) ℃"
        self.forecast.night?.places?.first?.tempmin = NSNumber(value: minTemperature)

        // when
        whenRequestDisplayItems()

        // then
        XCTAssertEqual(self.firstDisplayItem.dayParts.first?.places.first?.temperature, expectedSting)
    }

    // MARK: - Given

    private func givenForecastWithDayAndNight() {
        self.forecast.day = try! create(in: self.container.viewContext)
        self.forecast.night = try! create(in: self.container.viewContext)
    }

    private func givenForecastWithNigthContainTwoPlaces() {
        let places: [Place] = [
            try! create(in: self.container.viewContext),
            try! create(in: self.container.viewContext)
        ]

        self.forecast.night = try! create(in: self.container.viewContext)
        self.forecast.night?.places = Set(places)
    }

    // MARK: - When

    private func whenRequestDisplayItems() {
        self.displayItems = try! self.sut.provide(with: self.container.viewContext, for: self.localization).get()
    }

    // MARK: - Private

    private func day(forDay day: Int, month: Int) -> Date {
        var components = DateComponents()
        components.day = day
        components.month = month

        return Calendar.current.date(from: components)!
    }

    private func create<T: NSManagedObject>(in context: NSManagedObjectContext) throws -> T {
        let entityName = String(describing: T.self)
        guard let entityDescription = NSEntityDescription.entity(forEntityName: entityName, in: context) else {
            throw DataMapper.Error.nonValidEntityDescription
        }

        return T(entity: entityDescription, insertInto: context)
    }

}

//swiftlint:disable line_length
private extension String {
    static let loremIpsum =
    """
Lorem Ipsum คือ เนื้อหาจำลองแบบเรียบๆ ที่ใช้กันในธุรกิจงานพิมพ์หรืองานเรียงพิมพ์ มันได้กลายมาเป็นเนื้อหาจำลองมาตรฐานของธุรกิจดังกล่าวมาตั้งแต่ศตวรรษที่ 16 เมื่อเครื่องพิมพ์โนเนมเครื่องหนึ่งนำรางตัวพิมพ์มาสลับสับตำแหน่งตัวอักษรเพื่อทำหนังสือตัวอย่าง Lorem Ipsum อยู่ยงคงกระพันมาไม่ใช่แค่เพียงห้าศตวรรษ แต่อยู่มาจนถึงยุคที่พลิกโฉมเข้าสู่งานเรียงพิมพ์ด้วยวิธีทางอิเล็กทรอนิกส์ และยังคงสภาพเดิมไว้อย่างไม่มีการเปลี่ยนแปลง มันได้รับความนิยมมากขึ้นในยุค ค.ศ. 1960 เมื่อแผ่น Letraset วางจำหน่ายโดยมีข้อความบนนั้นเป็น Lorem Ipsum และล่าสุดกว่านั้น คือเมื่อซอฟท์แวร์การทำสื่อสิ่งพิมพ์ (Desktop Publishing) อย่าง Aldus PageMaker ได้รวมเอา Lorem Ipsum เวอร์ชั่นต่างๆ เข้าไว้ในซอฟท์แวร์ด้วย
"""
}
//swiftlint:enable line_length

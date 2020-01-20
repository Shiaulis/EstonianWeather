//
//  DataMapperTests.swift
//  EstonianWeatherTests
//
//  Created by Andrius Shiaulis on 13.01.2020.
//  Copyright © 2020 Andrius Shiaulis. All rights reserved.
//

import XCTest
import CoreData
@testable import EstonianWeather

class DataMapperTests: XCTestCase {

    // MARK: - Properties
    private var container: NSPersistentContainer!

    private lazy var ewDocument: EWDocument = {
        let parser = WeatherParser()
        let bundle = Bundle(for: WeatherParserTests.self)
        let url = bundle.url(forResource: "TestForecast", withExtension: "xml")!
        let data = try! Data(contentsOf: url)

        var receivedDocument: EWDocument?
        let serviceInfo = EWDocument.ServiceInfo(date: Date(), languageCode: "en")
        let parseResult = parser.parse(data: data, serviceInfo: serviceInfo)

        return try! parseResult.get()
    }()

    private var sut: DataMapper!

    override func setUp() {
        super.setUp()
        self.container = createContainer()
        self.sut = DataMapper(context: self.container.viewContext)
    }

    override func tearDown() {
        self.sut = nil
        self.container = nil
        super.tearDown()
    }

    func testMapper_whenAddData_containCorrectAmountOfForecasts() throws {
        // when
        self.sut.performMapping(self.ewDocument)

        // then
        let fetchRequest :NSFetchRequest<Forecast> = Forecast.fetchRequest()
        let result = try XCTUnwrap(try? self.container.viewContext.fetch(fetchRequest))
        XCTAssertEqual(result.count, 4)
    }

    func testMapper_whenAddSameDocumentTwice_containCorrectAmountOfForecasts() throws {
        // when
        self.sut.performMapping(self.ewDocument)
        self.sut.performMapping(self.ewDocument)

        // then
        let fetchRequest :NSFetchRequest<Forecast> = Forecast.fetchRequest()
        let result = try XCTUnwrap(try? self.container.viewContext.fetch(fetchRequest))
        XCTAssertEqual(result.count, 4)
    }

//    func testPerformanceExample() {
//        self.measure {
//            self.sut.performMapping(self.ewDocument)
//        }
//    }

    // MARK: - Private

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

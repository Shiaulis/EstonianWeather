//
//  Model.swift
//  EstonianWeather
//
//  Created by Andrius Shiaulis on 23.12.2020.
//

import Foundation
import Combine
import CoreData
import Logger

protocol Model {
    var currentForecasts: [ForecastDisplayItem] { get }

    func provideForecasts(result: @escaping (Result<[ForecastDisplayItem], Error>) -> Void)
}

final class ApplicationModel: Model {

    var currentForecasts: [ForecastDisplayItem] {
        do {
            return try self.dataProvider.provideForecast(with: self.context, for: .current).get()
        }
        catch {
            assertionFailure()
            return []
        }
    }

    private var disposables: Set<AnyCancellable> = []

    private let context: NSManagedObjectContext
    private let mapper: DataMapper
    private let networkClient: NetworkClient
    private let parser: ServerResponseParser
    private let dataProvider: DataProvider
    private let locale: Locale

    init(persistenceService: PersistenceService, locale: Locale = .current) {
        self.context = persistenceService.persistentContainer.viewContext
        self.context.mergePolicy = NSMergePolicy(merge: .overwriteMergePolicyType)
        self.locale = locale
        let logger = PrintLogger(moduleName: "ApplicationModel")
        self.mapper = CoreDataMapper(logger: logger)
        self.networkClient = URLSessionNetworkClient()
        self.parser = ServerResponseXMLParser(logger: logger)
        self.dataProvider = DataProvider(formatter: ForecastDateFormatter(locale: locale))
    }

    func provideForecasts(result: @escaping (Result<[ForecastDisplayItem], Error>) -> Void) {
        var receivedForecastDisplayItems: [ForecastDisplayItem] = []
        let publishers = [requestAndMapForecastPublisher(for: self.locale)]

        Publishers
            .MergeMany(publishers)
            .removeForecastOlderThan(Date(), using: self.mapper, in: self.context)
            .mapForecast(using: self.mapper, in: context)
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .finished:
                    WidgetService().notifyWidgetsAboutUpdates()
                    result(.success(receivedForecastDisplayItems))

                case .failure(let error):
                    result(.failure(error))
                }
            }
            receiveValue: { value in
                receivedForecastDisplayItems = value.map { self.dataProvider.displayItem(for: $0) }
            }
            .store(in: &self.disposables)

    }

    private func requestAndMapForecastPublisher(for locale: Locale) -> AnyPublisher<[EWForecast], Swift.Error> {
        let endpoint = Endpoint.forecast(for: locale)
        let today = Date()

        return self.networkClient.requestPublisher(for: endpoint)
            // TODOx: Should validate response code as well
            .map { $0.data }
            .parseForecast(using: self.parser, date: today, languageCode: locale.languageCode ?? "")
    }

}

final class MockModel: Model {

    var currentForecasts: [ForecastDisplayItem] { [] }

    func provideForecasts(result: @escaping (Result<[ForecastDisplayItem], Error>) -> Void) {
        result(.success([.test1, .test2, .test3]))
    }

}

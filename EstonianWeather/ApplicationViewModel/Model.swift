//
//  Model.swift
//  EstonianWeather
//
//  Created by Andrius Shiaulis on 23.12.2020.
//

import Foundation
import Combine
import CoreData

protocol Model {
    func provideForecasts(result: @escaping (Result<[ForecastDisplayItem], Error>) -> Void)
}

final class ApplicationModel: Model {

    private var disposables: Set<AnyCancellable> = []

    private let context: NSManagedObjectContext
    private let appLocalization: AppLocalization
    private let mapper: DataMapper
    private let networkClient: NetworkClient
    private let parser: ServerResponseParser
    private let dataProvider: DataProvider

    init(context: NSManagedObjectContext, appLocalization: AppLocalization) {
        self.context = context
        self.appLocalization = appLocalization
        self.context.mergePolicy = NSMergePolicy(merge: .overwriteMergePolicyType)
        let logger = PrintLogger()
        self.mapper = CoreDataMapper(logger: logger)
        self.networkClient = URLSessionNetworkClient()
        self.parser = ServerResponseXMLParser(logger: logger)
        self.dataProvider = DataProvider()
    }

    func provideForecasts(result: @escaping (Result<[ForecastDisplayItem], Error>) -> Void) {
        var receivedForecastDisplayItems: [ForecastDisplayItem] = []
        let publishers = [requestAndMapForecastPublisher(for: self.appLocalization)]

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

    private func requestAndMapForecastPublisher(for localization: AppLocalization) -> AnyPublisher<[EWForecast], Swift.Error> {
        let endpoint = Endpoint.forecast(for: localization)
        let today = Date()

        return self.networkClient.requestPublisher(for: endpoint)
            // TODOx: Should validate response code as well
            .map { $0.data }
            .parseForecast(using: self.parser, date: today, languageCode: localization.languageCode)
    }

}

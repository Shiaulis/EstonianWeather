//
//  WidgetForercastProvider.swift
//  EstonianWeatherWidgetExtension
//
//  Created by Andrius Shiaulis on 11.10.2020.
//

import WidgetKit
import Combine

struct ForecastEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    let displayItems: [ForecastDisplayItem]

    init(displayItems: [ForecastDisplayItem] = [], date: Date, configuration: ConfigurationIntent) {
        self.displayItems = displayItems
        self.date = date
        self.configuration = configuration
    }

    static let test: ForecastEntry = .init(displayItems: [.test1, .test1, .test2, .test2], date: Date(), configuration: ConfigurationIntent())
}

final class WidgetForercastProvider: IntentTimelineProvider {

    private let coreDataStack = CoreDataStack()
    private let localization = AppLocalization(locale: .current)
    private let provider: DataProvider = .init()
    private let networkClient: NetworkClient = URLSessionNetworkClient()
    private let parser: ServerResponseParser = ServerResponseXMLParser()
    private let mapper: DataMapper
    private let logger: Logger
    private var disposables: Set<AnyCancellable> = []

    init() {
        self.logger = PrintLogger()
        self.mapper = CoreDataMapper(logger: self.logger)
    }

    func placeholder(in context: Context) -> ForecastEntry {
        ForecastEntry(date: Date(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (ForecastEntry) -> Void) {
        let displayItems = fetchForecasts()
        let entry = ForecastEntry(displayItems: displayItems, date: Date(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<ForecastEntry>) -> Void) {
        requestAndMapForecasts { [weak self] in
            guard let self = self else { return }
            let displayItems = self.fetchForecasts()
            let entry = ForecastEntry(displayItems: displayItems, date: Date(), configuration: configuration)

            let timeline = Timeline(entries: [entry], policy: .atEnd)
            completion(timeline)
        }
    }

    private func fetchForecasts() -> [ForecastDisplayItem] {
        let result = self.provider.provideForecast(
            with: self.coreDataStack.persistentContainer.viewContext,
            for: self.localization)

        return (try? result.get()) ?? []
    }

    private func requestAndMapForecasts(result: @escaping () -> Void) {
        let context = self.coreDataStack.persistentContainer.viewContext
        let publishers = [requestAndMapForecastPublisher(for: self.localization)]
        Publishers
            .MergeMany(publishers)
            .removeForecastOlderThan(Date(), using: self.mapper, in: context)
            .mapForecast(using: self.mapper, in: context)
            .sink { completion in
                switch completion {
                case .finished:
                    self.logger.logNotImplemented(functionality: "Data request completion", module: .mainViewModel)
                    // should we somehow notify UI about this state?
                case .failure:
                    assertionFailure()
                }

                result()
            }
            receiveValue: { value in
                print(value)
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

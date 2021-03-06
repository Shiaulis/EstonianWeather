//
//  WidgetForercastProvider.swift
//  EstonianWeatherWidgetExtension
//
//  Created by Andrius Shiaulis on 11.10.2020.
//

import WidgetKit
import Combine
import WeatherKit

struct ForecastEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    let displayItems: [ForecastDisplayItem]

    init(displayItems: [ForecastDisplayItem] = [], date: Date, configuration: ConfigurationIntent) {
        self.displayItems = displayItems
        self.date = date
        self.configuration = configuration
    }

    static let test: ForecastEntry = .init(displayItems: [.test1, .test3, .test2, .test2], date: Date(), configuration: ConfigurationIntent())
}

final class WidgetForercastProvider: IntentTimelineProvider {

    private let model: WeatherModel
    private var lastFetchedDisplayItems: [ForecastDisplayItem] = []

    private var disposables: Set<AnyCancellable> = []

    init() {
        self.model = NetwokWeatherModel(
            weatherLocale: .english,
            responseParser: SWXMLResponseParser(logger: .init(subsystem: .widget, category: .weatherModel)),
            networkClient: URLSessionNetworkClient()
        )
    }

    func placeholder(in context: Context) -> ForecastEntry {
        ForecastEntry(displayItems: [.test1, .test2, .test3], date: Date(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (ForecastEntry) -> Void) {
        let entry = ForecastEntry(displayItems: self.lastFetchedDisplayItems, date: Date(), configuration: ConfigurationIntent())
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<ForecastEntry>) -> Void) {
        requestAndMapForecasts(for: configuration) { entry in
            completion(.init(entries: [entry], policy: .atEnd))
        }
    }

    private func requestAndMapForecasts(for configuration: ConfigurationIntent, completion: @escaping (ForecastEntry) -> Void) {
        async {
            do {
                self.lastFetchedDisplayItems = try await self.model.forecasts()
                completion(.init(displayItems: self.lastFetchedDisplayItems, date: Date(), configuration: configuration))
            }
            catch {
                completion(.init(displayItems: [], date: Date(), configuration: configuration))
            }
        }
    }

}

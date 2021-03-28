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
    let displayItems: [WeatherKit.ForecastDisplayItem]

    init(displayItems: [WeatherKit.ForecastDisplayItem] = [], date: Date, configuration: ConfigurationIntent) {
        self.displayItems = displayItems
        self.date = date
        self.configuration = configuration
    }

    static let test: ForecastEntry = .init(displayItems: [.test1, .test3, .test2, .test2], date: Date(), configuration: ConfigurationIntent())
}

final class WidgetForercastProvider: IntentTimelineProvider {

    private let model: WeatherKit.WeatherModel
    private var syncStatus: SyncStatus = .ready

    private var disposables: Set<AnyCancellable> = []

    init() {
        self.model = WeatherKit.NetwokWeatherModel(
            weatherLocale: .english,
            responseParser: WeatherKit.SWXMLResponseParser(),
            networkClient: WeatherKit.URLSessionNetworkClient()
        )
    }

    func placeholder(in context: Context) -> ForecastEntry {
        ForecastEntry(displayItems: [.test1, .test2, .test3], date: Date(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (ForecastEntry) -> Void) {
        let entry = ForecastEntry(displayItems: currentForecastsFromDatabase(), date: Date(), configuration: ConfigurationIntent())
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<ForecastEntry>) -> Void) {
        requestAndMapForecasts(for: configuration) { entry in
            completion(.init(entries: [entry], policy: .atEnd))
        }
    }

    private func currentForecastsFromDatabase() -> [WeatherKit.ForecastDisplayItem] {
        self.model.currentForecasts
    }

    private func requestAndMapForecasts(for configuration: ConfigurationIntent, completion: @escaping (ForecastEntry) -> Void) {
        self.syncStatus = .syncing
        self.model.provideForecasts { result in
            switch result {
            case .success(let forecastDisplayItems):
                self.syncStatus = .synced(Date())
                completion(.init(displayItems: forecastDisplayItems, date: Date(), configuration: configuration))
            case .failure(let error):
                self.syncStatus = .failed(error.localizedDescription)
                completion(.init(displayItems: [], date: Date(), configuration: configuration))
            }
        }
    }

}

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

    static let test: ForecastEntry = .init(displayItems: [.test1, .test3, .test2, .test2], date: Date(), configuration: ConfigurationIntent())
}

final class WidgetForercastProvider: IntentTimelineProvider {

    private let coreDataStack: CoreDataStack
    private let model: Model
    private var syncStatus: SyncStatus = .ready

    private var disposables: Set<AnyCancellable> = []

    init() {
        self.coreDataStack = CoreDataStack()
        self.model = ApplicationModel(context: self.coreDataStack.persistentContainer.viewContext, appLocalization: .init(locale: .current))
    }

    func placeholder(in context: Context) -> ForecastEntry {
        ForecastEntry(date: Date(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (ForecastEntry) -> Void) {
        requestAndMapForecasts(for: configuration) { entry in
            completion(entry)
        }
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<ForecastEntry>) -> Void) {
        requestAndMapForecasts(for: configuration) { entry in
            completion(.init(entries: [entry], policy: .atEnd))
        }
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

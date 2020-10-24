//
//  WidgetForercastProvider.swift
//  EstonianWeatherWidgetExtension
//
//  Created by Andrius Shiaulis on 11.10.2020.
//

import WidgetKit

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

struct WidgetForercastProvider: IntentTimelineProvider {

    private let coreDataStack = CoreDataStack()
    private let localization = AppLocalization(locale: .current) ?? .english
    private let provider: ForecastDataProvider = .init()

    func placeholder(in context: Context) -> ForecastEntry {
        ForecastEntry(date: Date(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (ForecastEntry) -> Void) {
        let displayItems = fetchForecasts()
        let entry = ForecastEntry(displayItems: displayItems, date: Date(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<ForecastEntry>) -> Void) {
        let displayItems = fetchForecasts()
        let entry = ForecastEntry(displayItems: displayItems, date: Date(), configuration: configuration)

        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }

    private func fetchForecasts() -> [ForecastDisplayItem] {
        let result = self.provider.provide(
            with: self.coreDataStack.persistentContainer.viewContext,
            for: self.localization)

        return (try? result.get()) ?? []
    }
}

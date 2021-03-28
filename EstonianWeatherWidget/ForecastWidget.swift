//
//  ForecastWidget.swift
//  ForecastWidget
//
//  Created by Andrius Shiaulis on 05.10.2020.
//

import WidgetKit
import SwiftUI
import Intents

struct ForecastWidget: Widget {
    let kind: String = "ForecastWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: WidgetForercastProvider()) { entry in
            EstonianWeatherWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Forecast Widget")
        .description("Check Estonian weather forecast.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct EstonianWeatherWidget_Previews: PreviewProvider {
    static var previews: some View {
        EstonianWeatherWidgetEntryView(entry: ForecastEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}

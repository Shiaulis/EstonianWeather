//
//  ForecastWidgetEntryVIew.swift
//  EstonianWeatherWidgetExtension
//
//  Created by Andrius Shiaulis on 11.10.2020.
//

import SwiftUI
import WidgetKit

struct EstonianWeatherWidgetEntryView: View {
    var entry: ForecastEntry

    var body: some View {
        ZStack {
            Color.black
            VStack(spacing: 2) {
                HeaderView()
                HStack(spacing: 2) {
                    ForEach(self.entry.displayItems) { displayItem in
                        // replace test item
                        ForecastWeatherDayView(displayItem: displayItem.day ?? .test)
                    }
                }

            }
        }
    }
}

private struct HeaderView: View {

    var body: some View {
        ZStack {
            Color(Resource.Color.appRose)
                .layoutPriority(-1)
            HStack {
                Spacer()
                Text("Estonian Weather Forecast")
                    .foregroundColor(.white)
                    .padding(6)
                Spacer()
            }
        }

    }
}

struct ForecastWeatherDayView: View {
    let displayItem: ForecastDisplayItem.DayPartForecastDisplayItem

    var body: some View {
        ZStack {
            Color(UIColor(red: 0.97, green: 0.95, blue: 0.94, alpha: 1.00))
            VStack {
                HStack {
                    Spacer()
                    Text(self.displayItem.shortDateDescription)
                        .font(.system(size: 12))
                    Spacer()
                }
                Spacer()
                Image(systemName: self.displayItem.weatherIconName)
                    .font(.system(size: 30))
                Spacer()
                Text(self.displayItem.temperatureRange)
                    .font(.system(size: 12))
            }
            .padding(.init(top: 16, leading: 4, bottom: 16, trailing: 4))
            .foregroundColor(.black)
        }
    }
}

struct ForecastWidgetEntryVIew_Previews: PreviewProvider {
    static var previews: some View {
        EstonianWeatherWidgetEntryView(entry: .test)
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}

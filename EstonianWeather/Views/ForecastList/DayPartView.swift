//
//  DayPartView.swift
//  EstonianWeather
//
//  Created by Andrius Shiaulis on 18.01.2020.
//  Copyright © 2020 Andrius Shiaulis. All rights reserved.
//

import SwiftUI
import WeatherKit

private extension DayPartForecastDisplayItem.DayPartType {
    var name: String {
        switch self {
        case .day: return R.string.localizable.day()
        case .night: return R.string.localizable.night()
        }
    }
}

struct DayPartView: View {

    let item: WeatherKit.DayPartForecastDisplayItem

    var body: some View {
        VStack {
            DayPartTitleView(title: self.item.type.name)
            PrimaryForecastView(
                temperatureRange: self.item.temperatureRange ?? "",
                weatherDescription: self.item.weatherDescription ?? "",
                weatherIconName: self.item.weatherIconName ?? ""
            )
            SecondaryForecastView(descriptionText: self.item.description ?? "")
        }
    }
}

struct DayPartView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DayPartView(item: DayPartForecastDisplayItem.test)
                .previewLayout(.fixed(width: 414, height: 200))
            DayPartView(item: DayPartForecastDisplayItem.test)
                .previewLayout(.fixed(width: 414, height: 200))
                .environment(\.colorScheme, .dark)
        }
    }
}

struct DayPartTitleView: View {
    let title: String

    var body: some View {
        HStack {
            Text(self.title)
                .font(.headline)
            Spacer()
        }
    }
}

struct PrimaryForecastView: View {
    let temperatureRange: String
    let weatherDescription: String
    let weatherIconName: String

    var body: some View {
        VStack {
            HStack {
                Text(self.temperatureRange)
                    .font(.largeTitle)
                VStack {
                    Image(systemName: self.weatherIconName)
                        .font(.largeTitle)

                }
                Spacer()
            }
//            HStack {
//                Text(self.weatherDescription)
//                    .font(.caption2)
//                Spacer()
//            }
        }
    }
}

struct SecondaryForecastView: View {
    let descriptionText: String

    var body: some View {
        VStack {
            Text(self.descriptionText)
                .multilineTextAlignment(.leading)
                .font(.caption)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

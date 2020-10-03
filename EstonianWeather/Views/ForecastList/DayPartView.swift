//
//  DayPartView.swift
//  EstonianWeather
//
//  Created by Andrius Shiaulis on 18.01.2020.
//  Copyright © 2020 Andrius Shiaulis. All rights reserved.
//

import SwiftUI

struct DayPartView: View {

    let item: ForecastDisplayItem.DayPartForecastDisplayItem

    var body: some View {
        VStack {
            DayPartTitleView(title: self.item.type)
            PrimaryForecastView(
                temperatureRange: self.item.temperatureRange,
                weatherDescription: self.item.weatherDescription,
                weatherIconName: self.item.weatherIconName
            )
            SecondaryForecastView(descriptionText: self.item.description)
        }
    }
}

struct DayPartView_Previews: PreviewProvider {
    static var previews: some View {
        DayPartView(item: ForecastDisplayItem.DayPartForecastDisplayItem.test)
            .previewLayout(.fixed(width: 414, height: 150))
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
        HStack {
            Text(self.temperatureRange)
                .font(.title)
            Spacer()
            VStack {
                Image(systemName: self.weatherIconName)
                    .font(.largeTitle)
                Text(self.weatherDescription)
                    .font(.caption2)
            }

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

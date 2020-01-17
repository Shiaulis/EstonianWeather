//
//  RootView.swift
//  EstonianWeather
//
//  Created by Andrius Shiaulis on 12.01.2020.
//  Copyright © 2020 Andrius Shiaulis. All rights reserved.
//

import SwiftUI

struct RootView: View {

    @State var forecast: ForecastDisplayItem

    var body: some View {
        VStack {
            HStack {
                Text("Today")
                    .font(Font.body.weight(.bold))
                Text(self.forecast.date)
                    .font(Font.body.weight(.regular))
                Spacer()
            }

            VStack {
                ForEach(self.forecast.dayParts, id: \.id) { dayPart in
                    VStack {
                        HStack {
                            Text(dayPart.type)
                            Spacer()
                        }

                        HStack {
                            Spacer()
                            Image(dayPart.weatherIconName)
                                .resizable()
                                .frame(width: 64, height: 64)
                            Spacer()
                            Text(dayPart.temperatureRange)
                                .font(.largeTitle)
                            Spacer()
                        }

                        Text(dayPart.description)
                            .fixedSize(horizontal: false, vertical: true)
                            .font(.caption)

                        ForEach(dayPart.places, id: \.id) { place in
                            HStack {
                                Spacer()
                                Text(place.name)
                                Spacer()
                                Image(place.weatherIconName)
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                Spacer()
                                Text(place.temperature)
                                Spacer()
                            }
                        }
                    }
                }
            }
        }
        .padding(.horizontal)
    }
}

struct ForecastDisplayItem: Identifiable {
    let id = UUID()
    let date: String
    let dayParts: [DayPartForecastDisplayItem]

    static var test: ForecastDisplayItem {
        ForecastDisplayItem(
            date: "17 January",
            dayParts: [
                .init(
                    type: "Night",
                    weatherIconName: "015-rain-1",
                    temperatureRange: "–2…+3",
                    description: "Partly cloudy. At first locally some rain. West wind 5-11, on coasts in gusts 15, at first on northern coast up to 18 m/s. Air temperature -2..+3∞C. Slippery roads!",
                    places: [
                        .init(
                            name: "Harku",
                            weatherIconName: "015-rain-1",
                            temperature: "+1"
                        ),
                        .init(
                            name: "Jõhvi",
                            weatherIconName: "015-rain-1",
                            temperature: "+1"
                        )
                    ]
                )
            ]
        )
    }

    struct DayPartForecastDisplayItem: Identifiable {
        let id = UUID()
        let type: String
        let weatherIconName: String
        let temperatureRange: String
        let description: String
        let places: [PlaceDisplayItem]

        struct PlaceDisplayItem: Identifiable {
            let id = UUID()
            let name: String
            let weatherIconName: String
            let temperature: String
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {

        RootView(forecast: ForecastDisplayItem.test)
    }
}

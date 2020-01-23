//
//  ForecastDisplayItem.swift
//  EstonianWeather
//
//  Created by Andrius Shiaulis on 18.01.2020.
//  Copyright © 2020 Andrius Shiaulis. All rights reserved.
//

import Foundation

struct ForecastDisplayItem: Identifiable {

    let id = UUID()
    let naturalDateDescription: String
    let date: String
    let dayParts: [DayPartForecastDisplayItem]

    struct DayPartForecastDisplayItem: Identifiable {
        let id = UUID()
        let type: String
        let weatherIconName: String
        let weatherDescription: String
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

extension ForecastDisplayItem {
    static var test: ForecastDisplayItem {
        .init(
            naturalDateDescription: "Today",
            date: "17 January",
            dayParts: [
                ForecastDisplayItem.DayPartForecastDisplayItem.test,
                ForecastDisplayItem.DayPartForecastDisplayItem.test2
            ]
        )
    }
}

extension ForecastDisplayItem.DayPartForecastDisplayItem {

    static var test: ForecastDisplayItem.DayPartForecastDisplayItem {
        .init(
            type: "Night",
            weatherIconName: "rain",
            weatherDescription: "Moderate showwwwer",
            temperatureRange: "–20…+30 ℃",
            description:
            """
            Partly cloudy. At first locally some rain. West wind 5-11,
            on coasts in gusts 15, at first on northern coast up to 18 m/s.
            Air temperature -2..+3∞C. Slippery roads!
            """,
            places: [
                ForecastDisplayItem.DayPartForecastDisplayItem.PlaceDisplayItem.test1,
                ForecastDisplayItem.DayPartForecastDisplayItem.PlaceDisplayItem.test2
            ]
        )
    }

    static var test2: ForecastDisplayItem.DayPartForecastDisplayItem {
        .init(
            type: "Day",
            weatherIconName: "rain",
            weatherDescription: "Rain",
            temperatureRange: "–2…+3",
            description:
            """
            Partly cloudy. At first locally some rain. West wind 5-11,
            on coasts in gusts 15, at first on northern coast up to 18 m/s.
            Air temperature -2..+3∞C. Slippery roads!
            """,
            places: [
                ForecastDisplayItem.DayPartForecastDisplayItem.PlaceDisplayItem.test1,
                ForecastDisplayItem.DayPartForecastDisplayItem.PlaceDisplayItem.test2
            ]
        )
    }

}

extension ForecastDisplayItem.DayPartForecastDisplayItem.PlaceDisplayItem {

    static var test1: ForecastDisplayItem.DayPartForecastDisplayItem.PlaceDisplayItem {
        .init(
            name: "Harku",
            weatherIconName: "rain",
            temperature: "+1"
        )
    }

    static var test2: ForecastDisplayItem.DayPartForecastDisplayItem.PlaceDisplayItem {
        .init(
            name: "Jõhvi",
            weatherIconName: "rain",
            temperature: "+1"
        )
    }

}

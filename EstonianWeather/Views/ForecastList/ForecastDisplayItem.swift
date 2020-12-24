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
    let shortDateDescription: String
    var dayParts: [DayPartForecastDisplayItem] { [self.night, self.day].compactMap { $0 } }
    let day: DayPartForecastDisplayItem?
    let night: DayPartForecastDisplayItem?

    struct DayPartForecastDisplayItem: Identifiable {
        let id = UUID()
        let shortDateDescription: String
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
    static var test1: ForecastDisplayItem {
        .init(
            naturalDateDescription: "Today, 17 January",
            shortDateDescription: "Послезавтра",
            day: ForecastDisplayItem.DayPartForecastDisplayItem.test2,
            night: ForecastDisplayItem.DayPartForecastDisplayItem.test
        )
    }

    static var test2: ForecastDisplayItem {
        .init(
            naturalDateDescription: "19 January",
            shortDateDescription: "19.01",
            day: ForecastDisplayItem.DayPartForecastDisplayItem.test2,
            night: ForecastDisplayItem.DayPartForecastDisplayItem.test
        )
    }

    static var test3: ForecastDisplayItem {
        .init(
            naturalDateDescription: "19 January",
            shortDateDescription: "19.01",
            day: ForecastDisplayItem.DayPartForecastDisplayItem.test3,
            night: ForecastDisplayItem.DayPartForecastDisplayItem.test
        )
    }
}

extension ForecastDisplayItem.DayPartForecastDisplayItem {

    static var test: ForecastDisplayItem.DayPartForecastDisplayItem {
        .init(
            shortDateDescription: "Today",
            type: "Night",
            weatherIconName: "cloud.sun.bolt.fill",
            weatherDescription: "Moderate showwwwer",
            temperatureRange: "-20 | 30",
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
            shortDateDescription: "Today",
            type: "Day",
            weatherIconName: "cloud.sun.bolt.fill",
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

    static var test3: ForecastDisplayItem.DayPartForecastDisplayItem {
        .init(
            shortDateDescription: "Послезавтра",
            type: "Day",
            weatherIconName: "cloud.sun.bolt.fill",
            weatherDescription: "Rain",
            temperatureRange: "–20|+30",
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

    static var test4: ForecastDisplayItem.DayPartForecastDisplayItem {
        .init(
            shortDateDescription: "Послезавтра",
            type: "Day",
            weatherIconName: "cloud.sun.bolt.fill",
            weatherDescription: "Rain",
            temperatureRange: "–20|+30",
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
            weatherIconName: "cloud.sun.bolt.fill",
            temperature: "+1"
        )
    }

    static var test2: ForecastDisplayItem.DayPartForecastDisplayItem.PlaceDisplayItem {
        .init(
            name: "Jõhvi",
            weatherIconName: "cloud.sun.bolt.fill",
            temperature: "+1"
        )
    }

}

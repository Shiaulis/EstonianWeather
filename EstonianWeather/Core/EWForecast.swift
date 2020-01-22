//
//  EWDocument.swift
//  EstonianWeather
//
//  Created by Andrius Shiaulis on 12.01.2020.
//  Copyright © 2020 Andrius Shiaulis. All rights reserved.
//

import Foundation

struct EWForecast {
    var forecastDate: Date?
    var dateReceived: Date?
    var languageCode: String?
    var night: EWDayPartForecast?
    var day: EWDayPartForecast?

    struct EWDayPartForecast {
        var type: EWDayPartType
        var phenomenon: EWPhenomenon?
        var tempmin: Int?
        var tempmax: Int?
        var text: String?
        var places: [EWPlace] = []
        var winds: [EWWind] = []
        var sea: String?
        var peipsi: String?

        enum EWDayPartType: String {
            case day, night
        }

        struct EWPlace {
            var name: String?
            var phenomenon: EWPhenomenon?
            var tempmin: Int?
            var tempmax: Int?
        }

        struct EWWind {
            var name: String?
            var direction: String?
            var speedmin: Int?
            var speedmax: Int?
            var gust: String?
        }

    }

    enum EWPhenomenon: String {
        case clear = "Clear"
        case fewClouds = "Few clouds"
        case variableClouds = "Variable clouds"
        case cloudyWithClearSpells = "Cloudy with clear spells"
        case cloudy  = "Cloudy"
        case lightSnowShower = "Light snow shower"
        case moderateSnowShower = "Moderate snow shower"
        case heavySnowShower = "Heavy snow shower"
        case lightShower = "Light shower"
        case moderateShower = "Moderate shower"
        case heavyShower = "Heavy shower"
        case lightRain = "Light rain"
        case moderateRain = "Moderate rain"
        case heavyRain = "Heavy rain"
        case riskOfGlaze = "Risk of glaze"
        case lightSleet = "Light sleet"
        case moderateSleet = "Moderate sleet"
        case lightSnowfall = "Light snowfall"
        case moderateSnowfall = "Moderate snowfall"
        case heavySnowfall = "Heavy snowfall"
        case snowstorm = "Snowstorm"
        case driftingSnow = "Drifting snow"
        case hail = "Hail"
        case mist = "Mist"
        case fog = "Fog"
        case thunder = "Thunder"
        case thunderstorm = "Thunderstorm"
    }
}

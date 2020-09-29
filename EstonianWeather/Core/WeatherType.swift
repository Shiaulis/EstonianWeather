//
//  WeatherType.swift
//  EstonianWeather
//
//  Created by Andrius Shiaulis on 17.01.2020.
//  Copyright © 2020 Andrius Shiaulis. All rights reserved.
//

import Foundation

enum WeatherType: String {

    // MARK: - Properties

    var imageName: String? {
        switch self {
        case .clear:
            return "sun.max.fill"
        case .fewClouds:
            return "cloud.sun.fill"
        case .variableClouds:
            return "cloud.sun.fill"
        case .cloudyWithClearSpells:
            return "cloud.sun.fill"
        case .cloudy:
            return "smoke.fill"
        case .lightSnowShower:
            return "cloud.snow.fill"
        case .moderateSnowShower:
            return "cloud.snow.fill"
        case .heavySnowShower:
            return "cloud.snow.fill"
        case .lightShower:
            return "cloud.drizzle.fill"
        case .moderateShower:
            return "cloud.rain.fill"
        case .heavyShower:
            return "cloud.heavyrain.fill"
        case .lightRain:
            return "cloud.drizzle.fill"
        case .moderateRain:
            return "cloud.rain.fill"
        case .heavyRain:
            return "cloud.heavyrain.fill"
        case .riskOfGlaze:
            return "thermometer.snowflake"
        case .lightSleet:
            return "cloud.sleet.fill"
        case .moderateSleet:
            return "cloud.sleet.fill"
        case .lightSnowfall:
            return "cloud.snow.fill"
        case .moderateSnowfall:
            return "cloud.snow.fill"
        case .heavySnowfall:
            return "cloud.snow.fill"
        case .snowstorm:
            return "cloud.snow.fill"
        case .driftingSnow:
            return "cloud.snow.fill"
        case .hail:
            return "cloud.hail.fill"
        case .mist:
            return "cloud.fog.fill"
        case .fog:
            return "cloud.fog.fill"
        case .thunder:
            return "wind"
        case .thunderstorm:
            return "wind"
        }
    }

    // MARK: - Init

    init?(phenomenon: Phenomenon) {
        guard let name = phenomenon.name else { return nil }
        self.init(rawValue: name)
    }

    // MARK: - Cases

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

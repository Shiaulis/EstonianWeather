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
            return "sun.max"
        case .fewClouds:
            return "cloud.sun"
        case .variableClouds:
            return "cloud.sun"
        case .cloudyWithClearSpells:
            return "cloud.sun"
        case .cloudy:
            return "smoke"
        case .lightSnowShower:
            return "cloud.snow"
        case .moderateSnowShower:
            return "cloud.snow"
        case .heavySnowShower:
            return "cloud.snow"
        case .lightShower:
            return "cloud.drizzle"
        case .moderateShower:
            return "cloud.rain"
        case .heavyShower:
            return "cloud.heavyrain"
        case .lightRain:
            return "cloud.drizzle"
        case .moderateRain:
            return "cloud.rain"
        case .heavyRain:
            return "cloud.heavyrain"
        case .riskOfGlaze:
            return "thermometer.snowflake"
        case .lightSleet:
            return "cloud.sleet"
        case .moderateSleet:
            return "cloud.sleet"
        case .lightSnowfall:
            return "cloud.snow"
        case .moderateSnowfall:
            return "cloud.snow"
        case .heavySnowfall:
            return "cloud.snow"
        case .snowstorm:
            return "cloud.snow"
        case .driftingSnow:
            return "cloud.snow"
        case .hail:
            return "cloud.hail"
        case .mist:
            return "cloud.fog"
        case .fog:
            return "cloud.fog"
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
    case cloudy = "Cloudy"
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

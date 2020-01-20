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
        case .lightShower: return "015-rain-1"
        default: return nil
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

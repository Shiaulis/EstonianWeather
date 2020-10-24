//
//  EWObservation.swift
//  EstonianWeather
//
//  Created by Andrius Shiaulis on 10.10.2020.
//

import Foundation

struct EWObservation {
    var stationName: String?
    var wmoCode: String?
    var longitude: Double?
    var latitude: Double?
    var phenomenon: EWPhenomenon?
    var visibility: String?
    var precipitations: String?
    var airPressure: String?
    var relativeHumidity: Double?
    var airTemperature: Double?
    var wind: EWWind?
    var waterLevel: String?
    var waterlLevelEH2000: String?
    var waterTemperature: Double?
    var uvIndex: Double?
    var observationDate: Date?
}

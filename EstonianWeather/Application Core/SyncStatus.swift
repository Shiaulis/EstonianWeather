//
//  SyncStatus.swift
//  EstonianWeather
//
//  Created by Andrius Shiaulis on 23.12.2020.
//

import Foundation
import WeatherKit

enum SyncStatus {
    case ready(dislayItems: [ForecastDisplayItem])
    case refreshing
    case failed(errorMessage: String)
}

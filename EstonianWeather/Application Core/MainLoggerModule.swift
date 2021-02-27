//
//  MainLoggerModule.swift
//  EstonianWeather
//
//  Created by Andrius Shiaulis on 27.02.2021.
//

import Foundation
import Logger

public enum MainLoggerModule: LoggerModule {
    case dataParser, mainViewModel, dataMapper, ratingService, purchases

    public var name: String {
        switch self {
        case MainLoggerModule.dataParser: return "🔎 Data Parser"
        case .mainViewModel: return "🧑‍🔧 Main View Model"
        case .dataMapper: return "💿 Data Mapper"
        case .ratingService: return "✨ Rating Service"
        case .purchases: return "💰 Purchases"
        }
    }
}

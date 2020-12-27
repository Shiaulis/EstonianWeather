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

    }

}

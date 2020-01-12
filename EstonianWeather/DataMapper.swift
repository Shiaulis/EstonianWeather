//
//  DataMapper.swift
//  EstonianWeather
//
//  Created by Andrius Shiaulis on 12.01.2020.
//  Copyright © 2020 Andrius Shiaulis. All rights reserved.
//

import Foundation
import CoreData

final class DataMapper {

    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func performMapping(_ documentToMap: EWDocument) {

        map(documentToMap)

        self.context.perform {
            do {
                try self.context.save()
            }
            catch {
                assertionFailure()
            }
        }
    }

    private func map(_ documentToMap: EWDocument) {
        let document = ForecastDocument(context: self.context)

        guard let forecastsToMap = documentToMap.forecasts else { return }

        var mappedForecasts: [Forecast] = []
        for forecastToMap in forecastsToMap {
            let mappedForecast = map(forecastToMap)
            mappedForecasts.append(mappedForecast)
        }

        document.forecasts = NSSet(array: mappedForecasts)
    }

    private func map(_ forecastToMap: EWDocument.EWForecast) -> Forecast {
        let mappedForecast = Forecast(context: self.context)
        mappedForecast.date = forecastToMap.date

        if let nigthToMap = forecastToMap.night {
            let mappedNight = map(nigthToMap)
            mappedForecast.night = mappedNight
        }

        if let dayToMap = forecastToMap.day {
            let mappedDay = map(dayToMap)
            mappedForecast.day = mappedDay
        }

        return mappedForecast
    }

    private func map(_ dayPartForecastToMap: EWDocument.EWForecast.EWDayPartForecast) -> DayPartForecast {
        let mappedDayPartForecast = DayPartForecast(context: self.context)

        mappedDayPartForecast.type = dayPartForecastToMap.type.rawValue


        return mappedDayPartForecast
    }

    private func map(_ phenomemonToMap: EWDocument.EWForecast.EWPhenomenon) -> Phenomenon {
        let mappedPhenomenon = Phenomenon(context: self.context)
        mappedPhenomenon.name = phenomemonToMap.
    }
}

//
//  ServerResponseParser.swift
//  EstonianWeather
//
//  Created by Andrius Shiaulis on 12.01.2020.
//  Copyright © 2020 Andrius Shiaulis. All rights reserved.
//

import Foundation
import Combine

protocol ServerResponseParser {
    func parse(forecastData: Data?, receivedDate: Date?, languageCode: String?) -> Result<[EWForecast], Swift.Error>
    func parse(observationsData: Data?, receivedDate: Date?) -> Result<EWObservation, Swift.Error>
}

extension Publisher where Output == Data {

    func parseForecast(using parser: ServerResponseParser, date: Date, languageCode: String) -> AnyPublisher<[EWForecast], Swift.Error> {
        self
            .tryMap { data in
                try parser.parse(forecastData: data, receivedDate: date, languageCode: languageCode).get()
            }
            .eraseToAnyPublisher()
    }

    func parseObservations(using parser: ServerResponseParser, date: Date) -> AnyPublisher<EWObservation, Swift.Error> {
        self
            .tryMap { data in
                try parser.parse(observationsData: data, receivedDate: date).get()
            }
            .eraseToAnyPublisher()
    }

}

final class ServerResponseXMLParser: NSObject, ServerResponseParser {

    // MARK: - Properties

    private var forecasts: [EWForecast]?
    private var currentForecast: EWForecast!
    private var currentDayPartForecast: EWForecast.EWDayPartForecast!
    private var currentParsedElement: Element!
    private var currentParsedElementText: String!
    private var currentPlace: EWForecast.EWDayPartForecast.EWPlace!
    private var currentWind: EWWind!

    private var observartion: EWObservation?
    private var currentStation: EWObservation.EWStation?

    private var ownError: ServerResponseXMLParser.Error?

    private var receivedDate: Date?
    private var receivedLanguageCode: String?
    private var isParsing = false

    private let logger: Logger

    init(logger: Logger = PrintLogger()) {
        self.logger = logger
    }

    // MARK: - Public

    func parse(observationsData: Data?, receivedDate: Date? = nil) -> Result<EWObservation, Swift.Error> {
        guard self.isParsing == false else {
            let error: Error = .attemptToRunMultipleParsing
            self.logger.log(message: "Not expected multiple parsing", error: error, module: .dataParser)
            return .failure(error)
        }

        self.isParsing = true

        guard let data = observationsData else {
            let error: Error = .incorrectInputData
            return .failure(error)
        }

        let xmlParser = configureParser(with: data)
        logParsingStarted(for: data)
        let success = xmlParser.parse()
        self.isParsing = false

        if let observationToReturn = self.observartion {
            self.observartion = nil
            self.receivedDate = nil

            if success {
                self.logger.log(successState: "Parsing finished successfully", module: .dataParser)
                return .success(observationToReturn)
            }
        }

        if let error = xmlParser.parserError {
            return .failure(ServerResponseXMLParser.Error.xmlError(error as NSError))
        }

        if let error = self.ownError {
            return .failure(error)
        }

        return .failure(ServerResponseXMLParser.Error.unknownError)
    }

    func parse(forecastData: Data?, receivedDate: Date? = nil, languageCode: String? = nil) -> Result<[EWForecast], Swift.Error> {
        guard self.isParsing == false else {
            let error: Error = .attemptToRunMultipleParsing
            self.logger.log(message: "Not expected multiple parsing", error: error, module: .dataParser)
            return .failure(error)
        }

        self.isParsing = true

        guard let data = forecastData else {
            let error: Error = .incorrectInputData
            return .failure(error)
        }

        let xmlParser = configureParser(with: data)
        self.forecasts = []
        self.receivedDate = receivedDate
        self.receivedLanguageCode = languageCode
        logParsingStarted(for: data)
        let success = xmlParser.parse()
        self.isParsing = false

        if let forecastsToReturn = self.forecasts {
            self.forecasts = nil
            self.receivedDate = nil
            self.receivedLanguageCode = nil

            if success {
                self.logger.log(successState: "Parsing finished successfully", module: .dataParser)
                return .success(forecastsToReturn)
            }
        }

        if let error = xmlParser.parserError {
            return .failure(ServerResponseXMLParser.Error.xmlError(error as NSError))
        }

        if let error = self.ownError {
            return .failure(error)
        }

        return .failure(ServerResponseXMLParser.Error.unknownError)
    }

    // MARK: - Private

    private func configureParser(with data: Data) -> XMLParser {
        let xmlParser = XMLParser(data: data)
        xmlParser.delegate = self

        return xmlParser
    }

    private func logParsingStarted(for data: Data) {
        let dataCount = data.count
        let receivedDateString = self.receivedDate?.dateShortString() ?? "???"
        let receivedLanguageCodeString = self.receivedLanguageCode ?? "???"
        let logString =
            "Parsing started for data with length \(dataCount), received date \"\(receivedDateString)\", language code \"\(receivedLanguageCodeString)\""

        self.logger.log(information: logString, module: .dataParser)
    }

}

// MARK: - XMLParserDelegate

extension ServerResponseXMLParser: XMLParserDelegate {

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch self.currentParsedElement {
        case .phenomenon, .tempmin, .tempmax, .text, .name, .direction, .speedmin, .speedmax, .sea, .peipsi,
        .wmocode, .longitude, .latitude, .visibility, .precipitations, .airpressure, .relativehumidity, .airtemperature,
        .waterlevel, .waterlevel_eh2000, .watertemperature, .uvindex, .winddirection, .windspeed, .windspeedmax:
            if self.currentParsedElement != nil {
                self.currentParsedElementText += string
            }
        case .none, .forecasts, .forecast, .night, .day, .place, .wind, .gust: break
        case .observations, .station: break
        }
    }

    func parser(_ parser: XMLParser, didStartElement elementName: String,
                namespaceURI: String?, qualifiedName qName: String?,
                attributes attributeDict: [String: String] = [:]) {
        let element = Element(elementName)
        switch element {
        case .forecast:
            self.currentForecast = EWForecast()
            self.currentForecast.forecastDate = parseForecastDate(from: attributeDict)
        case .night:
            self.currentDayPartForecast = .init(type: .night)
        case .day:
            self.currentDayPartForecast = .init(type: .day)
        case .phenomenon, .tempmin, .tempmax, .text, .name, .direction, .speedmin, .speedmax, .gust, .sea, .peipsi,
        .wmocode, .longitude, .latitude, .visibility, .precipitations, .airpressure, .relativehumidity, .airtemperature,
        .waterlevel, .waterlevel_eh2000, .watertemperature, .uvindex:
            self.currentParsedElementText = ""
        case .winddirection, .windspeed, .windspeedmax:
            self.currentParsedElementText = ""
            if self.currentStation?.wind == nil {
                self.currentStation?.wind = .init()
            }
        case .place:
            self.currentPlace = .init()
        case .wind:
            self.currentWind = .init()
        case .forecasts:
            break
        case .observations:
            assert(self.observartion == nil)
            self.observartion = EWObservation()
        case .station:
            assert(self.currentStation == nil)
            self.currentStation = EWObservation.EWStation()

            if self.observartion?.stations == nil {
                self.observartion?.stations = []
            }
        case .none:
            self.logger.log(information: "⚠️ Unknown element detected with name \"\(elementName)\"", module: .dataParser)
        }

        self.currentParsedElement = element
    }

    //swiftlint:disable cyclomatic_complexity
    //swiftlint:disable function_body_length
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        switch Element(elementName) {
        case .forecasts, .observations:
            break
        case .forecast:
            self.currentForecast.dateReceived = self.receivedDate
            self.currentForecast.languageCode = self.receivedLanguageCode
            self.forecasts?.append(self.currentForecast)
            self.currentForecast = nil
        case .night:
            self.currentForecast.night = self.currentDayPartForecast
        case .day:
            self.currentForecast.day = self.currentDayPartForecast
        case .phenomenon:
            let phenomenon = EWPhenomenon(rawValue: self.currentParsedElementText)

            if self.currentPlace != nil {
                self.currentPlace.phenomenon = phenomenon
            }
            else if self.currentDayPartForecast != nil {
                self.currentDayPartForecast.phenomenon = phenomenon
            }
            else if self.currentStation != nil {
                self.currentStation?.phenomenon = phenomenon
            }
        case .tempmin:
            let tempmin = Int(self.currentParsedElementText)
            if self.currentPlace != nil {
                self.currentPlace.tempmin = tempmin
            }
            else if self.currentDayPartForecast != nil {
                self.currentDayPartForecast.tempmin = tempmin
            }

        case .tempmax:
            let tempmax = Int(self.currentParsedElementText)
            if self.currentPlace != nil {
                self.currentPlace.tempmax = tempmax
            }
            else if self.currentDayPartForecast != nil {
                self.currentDayPartForecast.tempmax = tempmax
            }

        case .text:
            if self.currentDayPartForecast != nil {
                self.currentDayPartForecast.text = self.currentParsedElementText
            }

        case .place:
            self.currentDayPartForecast.places.append(self.currentPlace)
            self.currentPlace = nil

        case .name:
            if self.currentPlace != nil {
                self.currentPlace.name = self.currentParsedElementText
            }
            else if self.currentWind != nil {
                self.currentWind.name = self.currentParsedElementText
            }
            else if self.currentStation != nil {
                self.currentStation?.name = self.currentParsedElementText
            }
        case .wind:
            self.currentDayPartForecast.winds.append(self.currentWind)
            self.currentWind = nil

        case .direction:
            if self.currentWind != nil {
                self.currentWind.direction = self.currentParsedElementText
            }

        case .speedmin:
            let speed = Int(self.currentParsedElementText)
            if self.currentWind != nil {
                self.currentWind.speedmin = speed
            }

        case .speedmax:
            let speed = Int(self.currentParsedElementText)
            if self.currentWind != nil {
                self.currentWind.speedmax = speed
            }

        case .gust:
            if self.currentWind != nil {
                self.currentWind.gust = self.currentParsedElementText
            }

        case .sea:
            if self.currentDayPartForecast != nil {
                self.currentDayPartForecast.sea = self.currentParsedElementText
            }

        case .peipsi:
            if self.currentDayPartForecast != nil {
                self.currentDayPartForecast.peipsi = self.currentParsedElementText
            }
        case .station:
            assert(self.currentStation != nil)
            if let currentStation = self.currentStation {
                self.observartion?.stations?.append(currentStation)
            }
            self.currentStation = nil
        case .wmocode:
            if self.currentStation != nil {
                self.currentStation?.wmoCode = self.currentParsedElementText
            }
        case .longitude:
            if self.currentStation != nil {
                self.currentStation?.longitude = Double(self.currentParsedElementText)
            }
        case .latitude:
            if self.currentStation != nil {
                self.currentStation?.latitude = Double(self.currentParsedElementText)
            }
        case .visibility:
            if self.currentStation != nil {
                self.currentStation?.visibility = self.currentParsedElementText
            }
        case .precipitations:
            if self.currentStation != nil {
                self.currentStation?.precipitations = self.currentParsedElementText
            }
        case .airpressure:
            if self.currentStation != nil {
                self.currentStation?.airPressure = self.currentParsedElementText
            }
        case .relativehumidity:
            if self.currentStation != nil {
                self.currentStation?.relativeHumidity = Double(self.currentParsedElementText)
            }
        case .airtemperature:
            if self.currentStation != nil {
                self.currentStation?.airTemperature = Double(self.currentParsedElementText)
            }
        case .winddirection:
            if self.currentStation != nil {
                self.currentStation?.wind?.direction = self.currentParsedElementText
            }
        case .windspeed:
            if self.currentStation != nil {
                self.currentStation?.wind?.speed = Int(self.currentParsedElementText)
            }
        case .windspeedmax:
            if self.currentStation != nil {
                self.currentStation?.wind?.speedmax = Int(self.currentParsedElementText)
            }
        case .waterlevel:
            if self.currentStation != nil {
                self.currentStation?.waterLevel = self.currentParsedElementText
            }
        case .waterlevel_eh2000:
            if self.currentStation != nil {
                self.currentStation?.waterlLevelEH2000 = self.currentParsedElementText
            }
        case .watertemperature:
            if self.currentStation != nil {
                self.currentStation?.waterTemperature = Double(self.currentParsedElementText)
            }
        case .uvindex:
            if self.currentStation != nil {
                self.currentStation?.uvIndex = Double(self.currentParsedElementText)
            }

        case .none: break
        }

        self.currentParsedElement = nil
        self.currentParsedElementText = nil
    }
    //swiftlint:enable cyclomatic_complexity
    //swiftlint:enable function_body_length

    private func parseForecastDate(from attributes: [String: String]) -> Date? {
        guard let dateString = attributes["date"] else { return nil }

        let dateFormatter = DateFormatter()
        dateFormatter.locale = .init(identifier: "et-EE")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: dateString)
    }

}

// MARK: - Types

extension ServerResponseXMLParser {

    enum Error: Swift.Error, Equatable {
        case incorrectInputData
        case xmlError(NSError)
        case attemptToRunMultipleParsing
        case unknownError
    }

    //swiftlint:disable identifier_name
    private enum Element: String {

        // forecast
        case forecasts, forecast, night, day, phenomenon, tempmin, tempmax, text, place, name, wind, direction, speedmin, speedmax, gust, sea, peipsi

        // observations
        case observations, station, wmocode, longitude, latitude, visibility, precipitations, airpressure, relativehumidity, airtemperature
        case winddirection, windspeed, windspeedmax, waterlevel, waterlevel_eh2000, watertemperature, uvindex

        init?(_ name: String) {
            self.init(rawValue: name)
        }
    }
    //swiftlint:enable identifier_name

}

private extension Date {
    func dateShortString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"

        return formatter.string(from: self)
    }
}

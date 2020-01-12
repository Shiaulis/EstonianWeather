//
//  WeatherParser.swift
//  EstonianWeather
//
//  Created by Andrius Shiaulis on 12.01.2020.
//  Copyright © 2020 Andrius Shiaulis. All rights reserved.
//

import Foundation

final class WeatherParser: NSObject {

    enum Element: String {

        case forecasts, forecast, night, day, phenomenon, tempmin, tempmax, text, place, name, wind, direction, speedmin, speedmax, gust, sea, peipsi

        init?(_ name: String) {
            self.init(rawValue: name)
        }
    }

    // MARK: - Properties

    private var document: EWDocument!
    private var currentForecast: EWDocument.EWForecast!
    private var currentDayPartForecast: EWDocument.EWForecast.EWDayPartForecast!
    private var currentParsedElement: Element!
    private var currentParsedElementText: String!
    private var currentPlace: EWDocument.EWForecast.EWDayPartForecast.EWPlace!
    private var currentWind: EWDocument.EWForecast.EWDayPartForecast.EWWind!
    private var ownError: WeatherParser.Error?

    func parse(data: Data?, completion: (Result<EWDocument, Error>) -> Void) {
        guard let data = data else {
            completion(.failure(.incorrectInputData))
            return
        }

        let xmlParser = configureParser(with: data)
        let success = xmlParser.parse()

        if success {
            completion(.success(self.document))
        }
        else {
            if let error = xmlParser.parserError {
                completion(.failure(.xmlError(error as NSError)))
            }
            else if let error = self.ownError {
                completion(.failure(error))
            }
            else {
                completion(.failure(.unknownError))
            }
        }

        self.document = nil
    }

    private func configureParser(with data: Data) -> XMLParser {
        let xmlParser = XMLParser(data: data)
        xmlParser.delegate = self

        return xmlParser
    }
}

extension WeatherParser: XMLParserDelegate {

    func parserDidStartDocument(_ parser: XMLParser) {
        self.document = EWDocument()
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch self.currentParsedElement {
        case .forecasts, .forecast, .night, .day, .place, .wind, .gust: break
        case .phenomenon, .tempmin, .tempmax, .text, .name, .direction, .speedmin, .speedmax, .sea, .peipsi:
            if self.currentParsedElement != nil {
                self.currentParsedElementText += string
            }

        case .none: break
        }
    }

    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        let element = Element(elementName)
        switch element {
        case .forecasts:
            self.document.forecasts = []
        case .forecast:
            self.currentForecast = EWDocument.EWForecast()
            self.currentForecast.date = parseForecastDate(from: attributeDict)
        case .night:
            self.currentDayPartForecast = .init(type: .night)
        case .day:
            self.currentDayPartForecast = .init(type: .day)
        case .phenomenon, .tempmin, .tempmax, .text, .name, .direction, .speedmin, .speedmax, .gust, .sea, .peipsi:
            self.currentParsedElementText = ""
        case .place:
            self.currentPlace = .init()
        case .wind:
            self.currentWind = .init()
        case .none:
            break
        }

        self.currentParsedElement = element
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        switch Element(elementName) {
        case .forecasts:
            break
        case .forecast:
            self.document.forecasts!.append(self.currentForecast)
            self.currentForecast = nil
        case .night:
            self.currentForecast.night = self.currentDayPartForecast
        case .day:
            self.currentForecast.day = self.currentDayPartForecast
        case .phenomenon:
            let phenomenon = EWDocument.EWForecast.EWPhenomenon(rawValue: self.currentParsedElementText)

            if self.currentPlace != nil {
                self.currentPlace.phenomenon = phenomenon
            }
            else if self.currentDayPartForecast != nil {
                self.currentDayPartForecast.phenomenon = phenomenon
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

        case .none: break
        }

        self.currentParsedElement = nil
        self.currentParsedElementText = nil
    }

    private func parseForecastDate(from attributes: [String: String]) -> Date? {
        guard let dateString = attributes["date"] else { return nil }

        let dateFormatter = DateFormatter()
        dateFormatter.locale = .init(identifier: "et-EE")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: dateString)
    }

}

extension WeatherParser {
    enum Error: Swift.Error, Equatable {
        case incorrectInputData
        case xmlError(NSError)
        case unknownError
    }
}

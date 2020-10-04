//
//  Endpoint.swift
//  EstonianWeather
//
//  Created by Andrius Shiaulis on 29.09.2020.
//

import Foundation

struct Endpoint {
    static let scheme = "http"
    static let host = "ilmateenistus.ee"

    let path: String
    let urlQueryItems: [URLQueryItem]?
    let method: Method

    private init(path: String,
                 urlQueryItems: [URLQueryItem]? = nil,
                 method: Method = .post) {
        self.path = path
        self.urlQueryItems = urlQueryItems
        self.method = method
    }

}

extension Endpoint {

    enum Method: String {
        case post = "POST"
        var string: String { self.rawValue }
    }

    enum Error: Swift.Error {
        case badURL
    }

}

extension Endpoint {

    // https://www.ilmateenistus.ee/ilma_andmed/xml/forecast.php?lang=rus

    static func forecast(for localization: AppLocalization) -> Endpoint {
        .init(
            path: "/ilma_andmed/xml/forecast.php",
            urlQueryItems: [.init(name: "lang", value: localization.queryItemLanguageCode())],
            method: .post
        )
    }
}

private extension AppLocalization {
    func queryItemLanguageCode() -> String {
        switch self {
        case .english: return "eng"
        case .estonian: return "est"
        case .russian: return "rus"
        case .ukrainian: return "eng"
        }
    }
}

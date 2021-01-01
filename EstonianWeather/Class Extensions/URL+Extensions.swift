//
//  URL+Extensions.swift
//  EstonianWeather
//
//  Created by Andrius Shiaulis on 21.11.2020.
//

import Foundation
import UIKit

extension URL {

    static let settings = URL(string: UIApplication.openSettingsURLString)!
    static let email = URL(string: "mailto:shiaulis@gmail.com")!

    static var sourceDisclaimerURL: URL {
        switch Locale.current.languageCode {
        case "en": return URL(string: "https://www.ilmateenistus.ee/?lang=en")!
        case "ru": return URL(string: "https://www.ilmateenistus.ee/?lang=ru")!
        case "et": return URL(string: "https://www.ilmateenistus.ee/?lang=et")!
        default: return URL(string: "https://www.ilmateenistus.ee/?lang=en")!
        }
    }

}

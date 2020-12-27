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
    static let iconDisclaimerURL = URL(string: "https://www.flaticon.com/authors/freepik")!
    static let email = URL(string: "mailto:shiaulis@gmail.com")!

    static func sourceDisclaimerURL(for localization: AppLocalization) -> URL {
        switch localization {
        case .english: return URL(string: "https://www.ilmateenistus.ee/?lang=en")!
        case .estonian: return URL(string: "https://www.ilmateenistus.ee/?lang=et")!
        case .russian: return URL(string: "https://www.ilmateenistus.ee/?lang=ru")!
        }
    }

}

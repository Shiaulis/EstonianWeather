//
//  Resource.swift
//  EstonianWeather
//
//  Created by Andrius Shiaulis on 21.11.2020.
//

import Foundation
import UIKit

struct Resource {
    struct URL {
        static let settings = Foundation.URL(string: UIApplication.openSettingsURLString)!

        static func disclaimerURL(for localization: AppLocalization) -> Foundation.URL {
            switch localization {
            case .english: return Foundation.URL(string: "https://www.ilmateenistus.ee/?lang=en")!
            case .estonian: return Foundation.URL(string: "https://www.ilmateenistus.ee/?lang=et")!
            case .russian: return Foundation.URL(string: "https://www.ilmateenistus.ee/?lang=ru")!
            case .ukrainian: return Foundation.URL(string: "https://www.ilmateenistus.ee/?lang=en")!
            }
        }

        static let email = Foundation.URL(string: "mailto:shiaulis@gmail.com")!
    }

    struct Color {
        static let appRose = UIColor(red: 0.90, green: 0.53, blue: 0.53, alpha: 1.00)
    }
}

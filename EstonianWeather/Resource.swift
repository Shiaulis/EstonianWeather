//
//  Resource.swift
//  EstonianWeather
//
//  Created by Andrius Shiaulis on 21.11.2020.
//

import Foundation
import UIKit

struct Resource {
    struct Address {
        static let settings = URL(string: UIApplication.openSettingsURLString)!

        static func disclaimerURL(for localization: AppLocalization) -> URL {
            switch localization {
            case .english: return URL(string: "https://www.ilmateenistus.ee/?lang=en")!
            case .estonian: return URL(string: "https://www.ilmateenistus.ee/?lang=et")!
            case .russian: return URL(string: "https://www.ilmateenistus.ee/?lang=ru")!
            case .ukrainian: return URL(string: "https://www.ilmateenistus.ee/?lang=en")!
            }
        }
    }

    struct Color {
        static let appRose = UIColor(red: 0.90, green: 0.53, blue: 0.53, alpha: 1.00)
    }
}

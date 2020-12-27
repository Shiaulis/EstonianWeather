//
//  UIColor+Extensions.swift
//  EstonianWeather
//
//  Created by Andrius Shiaulis on 27.12.2020.
//

import UIKit

extension UIColor {

    static let appRose = UIColor.dynamicColor(
        light: UIColor(red: 0.90, green: 0.53, blue: 0.53, alpha: 1.00),
        dark: UIColor(red: 0.90, green: 0.53, blue: 0.53, alpha: 1.00)
    )

    static func dynamicColor(light: UIColor, dark: UIColor) -> UIColor {
        UIColor { $0.userInterfaceStyle == .dark ? dark : light }
    }

}

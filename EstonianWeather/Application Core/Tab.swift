//
//  Tab.swift
//  EstonianWeather
//
//  Created by Andrius Siaulis on 10.07.2021.
//

import Foundation

enum Tab: Int, CaseIterable, Identifiable {

    var id: RawValue { self.rawValue }

    case forecastList, settings

    var title: String {
        switch self {
        case .forecastList: return R.string.localizable.forecast()
        case .settings: return R.string.localizable.settings()
        }
    }

    var imageName: String {
        switch self {
        case .forecastList: return "cloud.sun"
        case .settings: return "gear"
        }
    }

    var indexPath: IndexPath {
            .init(row: self.rawValue, section: 0)
    }
}

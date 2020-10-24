//
//  WidgetService.swift
//  EstonianWeather
//
//  Created by Andrius Shiaulis on 24.10.2020.
//

import Foundation
import WidgetKit

final class WidgetService {

    func notifyWidgetsAboutUpdates() {
        WidgetCenter.shared.reloadAllTimelines()
    }

}

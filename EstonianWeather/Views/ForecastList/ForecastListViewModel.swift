//
//  ForecastListViewModel.swift
//  EstonianWeather
//
//  Created by Andrius Shiaulis on 03.10.2020.
//

import Foundation

protocol ForecastListViewModel: ObservableObject {
    var displayItems: [ForecastDisplayItem] { get }
    func openApplicationSettings()

}

final class MockForecastListViewModel: ForecastListViewModel {

    let displayItems: [ForecastDisplayItem] = [ForecastDisplayItem.test1]
    func openApplicationSettings() {}

}

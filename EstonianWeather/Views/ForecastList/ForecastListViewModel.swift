//
//  ForecastListViewModel.swift
//  EstonianWeather
//
//  Created by Andrius Shiaulis on 03.10.2020.
//

import Foundation

protocol ForecastListViewModel: ObservableObject {
    var displayItems: [ForecastDisplayItem] { get }
    var bannerData: BannerData { get }
    var syncStatus: SyncStatus { get }
    func openApplicationSettings()

}

final class MockForecastListViewModel: ForecastListViewModel {
    let syncStatus: SyncStatus = .failed("Error")
    let displayItems: [ForecastDisplayItem] = [ForecastDisplayItem.test1]
    let bannerData: BannerData = .init(title: "test", detail: "test", type: .error)
    func openApplicationSettings() {}

}

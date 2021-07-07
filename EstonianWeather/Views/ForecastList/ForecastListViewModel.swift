//
//  ForecastListViewModel.swift
//  EstonianWeather
//
//  Created by Andrius Shiaulis on 13.01.2020.
//  Copyright © 2020 Andrius Shiaulis. All rights reserved.
//

import Foundation
import Combine
import CoreData
import UIKit
import WeatherKit

final class ForecastListViewModel: ObservableObject {

    enum SyncStatus {
        case ready(dislayItems: [ForecastDisplayItem])
        case refreshing
        case failed(errorMessage: String)
    }

    @Published private(set) var syncStatus: SyncStatus = .refreshing

    private let model: WeatherModel
    private var disposables: Set<AnyCancellable> = []

    init(model: WeatherModel) {
        self.model = model

        async { await fetchRemoteForecasts() }
        subscribeForNotifications()
    }

    @MainActor
    func fetchRemoteForecasts() async {
        do {
            let displayItems = try await self.model.forecasts()
            self.syncStatus = .ready(dislayItems: displayItems)
        }
        catch {
            self.syncStatus = .failed(errorMessage: error.localizedDescription)
        }
    }

    private func subscribeForNotifications() {
        NotificationCenter
            .default
            .publisher(for: UIApplication.significantTimeChangeNotification)
            .sink { _ in
                async { [weak self] in await self?.fetchRemoteForecasts() }
            }
            .store(in: &self.disposables)
    }

}

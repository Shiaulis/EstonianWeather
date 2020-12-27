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

final class ForecastListViewModel: ObservableObject {

    @Published private(set) var displayItems: [ForecastDisplayItem] = []
    @Published private(set) var shouldShowSyncStatus: Bool = false
    @Published private(set) var syncStatus: SyncStatus = .ready {
        didSet {
            switch self.syncStatus {
            case .synced: self.shouldShowSyncStatus = false
            default: self.shouldShowSyncStatus = self.displayItems.isEmpty
            }
        }

    }

    private let model: Model
    private var disposables: Set<AnyCancellable> = []

    init(model: Model) {
        self.model = model

        fetchRemoteForecasts()
        subscribeForNotifications()
    }

    private func fetchRemoteForecasts() {
        self.syncStatus = .syncing
        self.model.provideForecasts { result in
            switch result {
            case .success(let forecastDisplayItems):
                self.displayItems = forecastDisplayItems
                self.syncStatus = .synced(Date())
            case .failure(let error):
                self.syncStatus = .failed(error.localizedDescription)
            }
        }
    }

    private func subscribeForNotifications() {
        NotificationCenter
            .default
            .publisher(for: UIApplication.didBecomeActiveNotification)
            .sink { [weak self] _ in
                self?.fetchRemoteForecasts()
            }
            .store(in: &self.disposables)

        NotificationCenter
            .default
            .publisher(for: UIApplication.significantTimeChangeNotification)
            .sink { [weak self] _ in
                self?.fetchRemoteForecasts()
            }
            .store(in: &self.disposables)
    }

}

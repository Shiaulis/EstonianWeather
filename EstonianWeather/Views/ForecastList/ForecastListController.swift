//
//  ForecastListController.swift
//  EstonianWeather
//
//  Created by Andrius Shiaulis on 13.01.2020.
//  Copyright © 2020 Andrius Shiaulis. All rights reserved.
//

import Foundation
import Combine
import CoreData
import UIKit

final class ForecastListController: ForecastListViewModel {

    @Published var bannerData: BannerData = BannerData(title: "", detail: "", type: .error)
    @Published var syncStatus: SyncStatus = .ready

    @Published var displayItems: [ForecastDisplayItem] = []
    private var disposables: Set<AnyCancellable> = []
    private let dataProvider: DataProvider
    private let appViewModel: ApplicationViewModel

    private let model: Model

    init(dataProvider: DataProvider = .init(), appViewModel: ApplicationViewModel) {
        self.dataProvider = dataProvider
        self.appViewModel = appViewModel
        self.syncStatus = self.appViewModel.syncStatus

        self.model = self.appViewModel.model

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

    func openApplicationSettings() {
        self.appViewModel.openApplicationSettings()
    }

    private func subscribeForNotifications() {
        NotificationCenter
            .default
            .publisher(for: UIApplication.didBecomeActiveNotification)
            .sink { [weak self] _ in
                self?.fetchRemoteForecasts()
            }
            .store(in: &self.disposables)
    }

}

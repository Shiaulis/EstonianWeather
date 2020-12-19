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

enum SyncStatus {
    case ready
    case syncing
    case synced(String)
    case failed(String)
}

final class ForecastListController: ForecastListViewModel {

    @Published var bannerData: BannerData = BannerData(title: "", detail: "", type: .error)
    @Published var syncStatus: SyncStatus = .synced("") {
        didSet {
            let context = self.appViewModel.viewContext
            let displayItems = try? self.dataProvider.provideForecast(
                with: context,
                for: self.appViewModel.appLocalization
            ).get()

            self.displayItems = displayItems ?? []
        }
    }

    @Published var displayItems: [ForecastDisplayItem] = []
    private var disposables: Set<AnyCancellable> = []
    private let dataProvider: DataProvider
    private let appViewModel: ApplicationViewModel

    init(dataProvider: DataProvider = .init(), appViewModel: ApplicationViewModel) {
        self.dataProvider = dataProvider
        self.appViewModel = appViewModel
        self.syncStatus = self.appViewModel.syncStatus

        listenForData()
    }

    func openApplicationSettings() {
        self.appViewModel.openApplicationSettings()
    }

    private func listenForData() {
        NotificationCenter.default
            .publisher(for: .syncStatusDidChange)
            .receive(on: RunLoop.main)
            .sink(receiveValue: { _ in
                self.syncStatus = self.appViewModel.syncStatus
            })
            .store(in: &self.disposables)
    }
}

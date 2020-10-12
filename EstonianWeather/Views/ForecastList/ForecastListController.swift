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

    @Published var displayItems: [ForecastDisplayItem] = []
    private var disposables: Set<AnyCancellable> = []
    private let dataProvider: DataProvider
    private let settingsService: SettingsService

    init(dataProvider: DataProvider = .init(), settingsService: SettingsService = .init()) {
        self.dataProvider = dataProvider
        self.settingsService = settingsService

        listenForData()
    }

    func openApplicationSettings() {
        self.settingsService.openApplicationSettings()
    }

    private func listenForData() {
        NotificationCenter.default
            .publisher(for: .NSManagedObjectContextDidSave)
            .tryMap { notification in
                guard let context = notification.object as? NSManagedObjectContext else { fatalError() }
                return try self.dataProvider.provideForecast(
                    with: context,
                    for: self.settingsService.appLocalization
                ).get()
            }
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { _ in }) { displayItems in
                self.displayItems = displayItems
            }
            .store(in: &self.disposables)
    }
}

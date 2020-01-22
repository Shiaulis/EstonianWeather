//
//  RootViewModel.swift
//  EstonianWeather
//
//  Created by Andrius Shiaulis on 13.01.2020.
//  Copyright © 2020 Andrius Shiaulis. All rights reserved.
//

import Foundation
import Combine
import CoreData

final class RootViewMolel: ObservableObject {

    @Published var displayItems: [ForecastDisplayItem] = []
    private var disposables: Set<AnyCancellable> = []
    private let dataProvider: ForecastDataProvider
    private let localization: AppLocalization

    init(dataProvider: ForecastDataProvider) {
        self.dataProvider = dataProvider
        self.localization = AppLocalization(locale: Locale.current)

        listenForData()
    }

    private func listenForData() {
        NotificationCenter.default
            .publisher(for: .NSManagedObjectContextDidSave)
            .tryMap { notification in
                guard let context = notification.object as? NSManagedObjectContext else { fatalError() }
                return try self.dataProvider.provide(
                    with: context,
                    for: self.localization
                ).get()
            }
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { _ in }) { displayItems in
                self.displayItems = displayItems
            }
            .store(in: &self.disposables)
    }
}

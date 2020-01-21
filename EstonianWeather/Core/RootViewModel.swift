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

    init(dataProvider: ForecastDataProvider) {
        NotificationCenter.default
            .publisher(for: .NSManagedObjectContextDidSave)
            .tryMap { notification in
                guard let context = notification.object as? NSManagedObjectContext else { fatalError() }
                return try dataProvider.provide(with: context).get() }
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { _ in }) { displayItems in
                self.displayItems = displayItems
            }
            .store(in: &self.disposables)
    }

}

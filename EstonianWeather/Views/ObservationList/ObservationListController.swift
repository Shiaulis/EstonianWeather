//
//  ObservationListController.swift
//  EstonianWeather
//
//  Created by Andrius Shiaulis on 17.10.2020.
//

import Foundation
import Combine
import CoreData

final class ObservationListController: ObservationListViewModel {

    private let dataProvider: DataProvider
    private var disposables: Set<AnyCancellable> = []

    init(dataProvider: DataProvider = .init()) {
        self.dataProvider = dataProvider

        listenForData()
    }

    @Published var displayItems: [ObservationDisplayItem] = []

    private func listenForData() {
        NotificationCenter.default
            .publisher(for: .NSManagedObjectContextDidSave)
            .tryMap { notification in
                guard let context = notification.object as? NSManagedObjectContext else { fatalError() }
                return try self.dataProvider.provideObservations(with: context).get()
            }
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { _ in }) { displayItems in
                self.displayItems = displayItems
            }
            .store(in: &self.disposables)
    }

}

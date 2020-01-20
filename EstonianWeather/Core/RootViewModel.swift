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
    private let context = CoreDataStack().persistentContainer.viewContext

    var networkPublisher: AnyPublisher<(data: Data, response: URLResponse), URLError> {
        let url = URL(string: "http://www.ilmateenistus.ee/ilma_andmed/xml/forecast.php?lang=eng")!
        let session  = URLSession.shared
        return session.dataTaskPublisher(for: url)
        .eraseToAnyPublisher()
    }

    func fetch() {
        self.networkPublisher
            .map {
                WeatherParser().parse(data: $0.data, requestDate: Date(), requestedLanguageCode: "en")
            }
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: {
            print("received completion", $0)
        }) {
            guard let value = try? $0.get() else { return }
            DataMapper(context: self.context).performMapping(value)

            guard let items = self.fetchFromPersistentLayer() else { return }
            self.displayItems = items
        }
        .store(in: &disposables)
    }


    private func fetchFromPersistentLayer() -> [ForecastDisplayItem]? {
        let request: NSFetchRequest<Forecast> = Forecast.fetchRequest()

        request.sortDescriptors = [.init(key: #keyPath(Forecast.forecastDate), ascending: true)]

        guard let result = try? self.context.fetch(request) else { return nil }

        let controller = ForecastController()
        let displayItems = result.map { controller.displayItem(for: $0) }

        return displayItems
    }
}

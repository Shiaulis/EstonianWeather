//
//  MainService.swift
//  EstonianWeather
//
//  Created by Andrius Shiaulis on 21.01.2020.
//  Copyright © 2020 Andrius Shiaulis. All rights reserved.
//

import Foundation
import Combine

final class MainService {

    private var disposables: Set<AnyCancellable> = []
    private let context = CoreDataStack().persistentContainer.viewContext

    init() {
        let url = URL(string: "http://www.ilmateenistus.ee/ilma_andmed/xml/forecast.php?lang=eng")!

        URLSession.shared
            .dataTaskPublisher(for: url)
            .map {
                WeatherParser().parse(data: $0.data, requestDate: Date(), requestedLanguageCode: "en")
        }
        .receive(on: RunLoop.main)
        .sink(receiveCompletion: { _ in
        }) {
            guard let value = try? $0.get() else { return }
            DataMapper(context: self.context).performMapping(value)
        }
        .store(in: &self.disposables)
    }

}

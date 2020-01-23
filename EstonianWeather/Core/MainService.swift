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

    // MARK: - Properties

    private var disposables: Set<AnyCancellable> = []
    private let persistentContainer = CoreDataStack().persistentContainer
    private let parser = WeatherParser()
    private let mapper = DataMapper()
    private let localization: AppLocalization
    private var url: URL { self.localization.sourceLink }

    private lazy var networkDataPublisher: AnyPublisher<Data, URLError> = {
        URLSession.shared
            .dataTaskPublisher(for: self.url)
            .map { $0.data }
            .eraseToAnyPublisher()
    }()

    // MARK: - Initialization

    init() {
        let locale = Locale.current
        self.localization = AppLocalization(locale: locale)

        requestAndMapData()
    }

    private func requestAndMapData() {
        self.networkDataPublisher
            .map {
                self.parser.parse(data: $0, receivedDate: Date(), languageCode: self.localization.languageCode)
            }
        .sink(receiveCompletion: { _ in }) {
            guard let value = try? $0.get() else { return }
            let context = self.persistentContainer.newBackgroundContext()
            self.mapper.performMapping(value, context: context) { error in
                if let error = error {
                    assertionFailure("Error: \(error.localizedDescription)")
                }
            }
        }
        .store(in: &self.disposables)
    }

}

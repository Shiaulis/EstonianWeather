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
    private let parser: WeatherParser = XMLWeatherParser()
    private let mapper: DataMapper = CoreDataMapper()
    private let localization: AppLocalization
    private let logger: Logger = PrintLogger()
    private let networkClient: NetworkClient = URLSessionNetworkClient()

    // MARK: - Initialization

    init() {
        let locale = Locale.current
        self.localization = AppLocalization(locale: locale) ?? .english

        requestAndMapData()
    }

    private func requestAndMapData() {
        let endpoint = Endpoint.forecast(for: self.localization)
        self.networkClient.requestPublisher(for: endpoint)
            // TODOx: Should validate response code as well
            .map { $0.data }
            .parse(using: self.parser, date: Date(), languageCode: self.localization.languageCode)
            .map(using: self.mapper, in: self.persistentContainer.newBackgroundContext())
            .sink(receiveCompletion: { _ in
                self.logger.logNotImplemented(functionality: "Data request completion", module: .mainService)
            }, receiveValue: { _ in })
            .store(in: &self.disposables)
    }

}

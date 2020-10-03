//
//  MainService.swift
//  EstonianWeather
//
//  Created by Andrius Shiaulis on 21.01.2020.
//  Copyright © 2020 Andrius Shiaulis. All rights reserved.
//

import Foundation
import UIKit
import Combine

final class MainService {

    // MARK: - Properties

    private let defaultRequestsInterval: TimeInterval = 60 * 60

    private var disposables: Set<AnyCancellable> = []
    private var timerDisposable: AnyCancellable?
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
        setTimerForRequests(with: self.defaultRequestsInterval)

        subscribeForNotifications()
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

    private func setTimerForRequests(with interval: TimeInterval) {
        self.requestAndMapData()
        self.timerDisposable =
        Timer
            .publish(every: interval, on: RunLoop.main, in: .default)
            .sink { _ in self.requestAndMapData() }
    }

    private func subscribeForNotifications() {
        NotificationCenter
            .default
            .publisher(for: UIApplication.didEnterBackgroundNotification, object: self)
            .sink { _ in
                self.timerDisposable = nil
            }
            .store(in: &self.disposables)

        NotificationCenter
            .default
            .publisher(for: UIApplication.didBecomeActiveNotification, object: self)
            .sink { _ in
                self.setTimerForRequests(with: self.defaultRequestsInterval)
            }
            .store(in: &self.disposables)
    }

}

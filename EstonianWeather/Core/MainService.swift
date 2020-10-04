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
import CoreData

final class MainService {

    // MARK: - Properties

    private let defaultRequestsInterval: TimeInterval = 60 * 60

    private var disposables: Set<AnyCancellable> = []
    private var timerDisposable: AnyCancellable?

    private let coreDataStack: CoreDataStack
    private var persistentContainer: NSPersistentContainer { self.coreDataStack.persistentContainer }
    private let settingsService: SettingsService
    private let parser: WeatherParser = XMLWeatherParser()
    private lazy var mapper: DataMapper = { CoreDataMapper(logger: self.logger) }()
    private let localization: AppLocalization
    private let logger: Logger = PrintLogger()
    private let networkClient: NetworkClient = URLSessionNetworkClient()

    // MARK: - Initialization

    init() {
        let locale = Locale.current
        self.localization = AppLocalization(locale: locale) ?? .english
        self.coreDataStack = .init()
        self.settingsService = .init(userDefaults: .standard, coreDataStack: self.coreDataStack)
        setTimerForRequests(with: self.defaultRequestsInterval)

        subscribeForNotifications()
    }

    private func requestAndMapData() {
        let endpoint = Endpoint.forecast(for: self.localization)
        let today = Date()
        let context = self.persistentContainer.newBackgroundContext()
        self.networkClient.requestPublisher(for: endpoint)
            // TODOx: Should validate response code as well
            .map { $0.data }
            .parse(using: self.parser, date: today, languageCode: self.localization.languageCode)
            .removeForecastOlderThan(today, using: self.mapper, in: context)
            .map(using: self.mapper, in: context)
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

//
//  AppStoreRatingService.swift
//  EstonianWeather
//
//  Created by Andrius Shiaulis on 30.12.2020.
//

import Foundation
import StoreKit
import Logger

final class AppStoreRatingService {

    private let logger: Logger

    init(logger: Logger = PrintLogger()) {
        self.logger = logger
    }

    func incrementLauchCounter() {
        // If the count has not yet been stored, this will return 0
        var count = UserDefaults.standard.integer(forKey: UserDefaultsKeys.processCompletedCountKey)
        count += 1
        UserDefaults.standard.set(count, forKey: UserDefaultsKeys.processCompletedCountKey)

        self.logger.log(information: "Application launched \(count) time(s)", module: MainLoggerModule.ratingService)
    }

    func makeAttemptToShowRating(in windowScene: UIWindowScene) {
        // Get the current bundle version for the app
        let infoDictionaryKey = kCFBundleVersionKey as String
        guard let currentVersion = Bundle.main.object(forInfoDictionaryKey: infoDictionaryKey) as? String
            else { fatalError("Expected to find a bundle version in the info dictionary") }

        let lastVersionPromptedForReview = UserDefaults.standard.string(forKey: UserDefaultsKeys.lastVersionPromptedForReviewKey)
        let count = UserDefaults.standard.integer(forKey: UserDefaultsKeys.processCompletedCountKey)
        // Has the process been completed several times and the user has not already been prompted for this version?
        if count >= 4 && currentVersion != lastVersionPromptedForReview {
            let twoSecondsFromNow = DispatchTime.now() + 2.0
            DispatchQueue.main.asyncAfter(deadline: twoSecondsFromNow) {
                SKStoreReviewController.requestReview(in: windowScene)
                UserDefaults.standard.set(currentVersion, forKey: UserDefaultsKeys.lastVersionPromptedForReviewKey)
                self.logger.log(information: "Made request to show rating", module: MainLoggerModule.ratingService)
            }
        }
    }
}

extension AppStoreRatingService {

    private struct UserDefaultsKeys {
        static let processCompletedCountKey = "processCompletedCount"
        static let lastVersionPromptedForReviewKey = "lastVersionPromptedForReview"
    }

}

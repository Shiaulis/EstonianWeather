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

    init(logger: Logger = PrintLogger(moduleName: "AppStoreRatingService")) {
        self.logger = logger
    }

    func incrementLauchCounter() {
        // If the count has not yet been stored, this will return 0
        var count = UserDefaults.standard.integer(forKey: UserDefaultsKeys.processCompletedCountKey)
        count += 1
        UserDefaults.standard.set(count, forKey: UserDefaultsKeys.processCompletedCountKey)

        self.logger.log(information: "Application launched \(count) time(s)")
    }

    func makeAttemptToShowRating(in windowScene: UIWindowScene) {
        // Get the current bundle version for the app
        guard let currentVersion = Bundle.main.string(for: .bundleVersion) else {
            assertionFailure("Expected to find a bundle version in the info dictionary")
            return
        }

        let lastVersionPromptedForReview = UserDefaults.standard.string(forKey: UserDefaultsKeys.lastVersionPromptedForReviewKey)
        let count = UserDefaults.standard.integer(forKey: UserDefaultsKeys.processCompletedCountKey)
        // Has the process been completed several times and the user has not already been prompted for this version?
        if count >= 4 && currentVersion != lastVersionPromptedForReview {
            let twoSecondsFromNow = DispatchTime.now() + 2.0
            DispatchQueue.main.asyncAfter(deadline: twoSecondsFromNow) {
                SKStoreReviewController.requestReview(in: windowScene)
                UserDefaults.standard.set(currentVersion, forKey: UserDefaultsKeys.lastVersionPromptedForReviewKey)
                self.logger.log(information: "Made request to show rating")
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

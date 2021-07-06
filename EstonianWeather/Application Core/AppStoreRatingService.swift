//
//  AppStoreRatingService.swift
//  EstonianWeather
//
//  Created by Andrius Shiaulis on 30.12.2020.
//

import Foundation
import StoreKit
import OSLog

final class AppStoreRatingService {

    private let logger = Logger(category: .ratingService)
    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }

    func incrementLauchCounter() {
        // If the count has not yet been stored, this will return 0
        var count = self.userDefaults.integer(for: .processCompletedCount)
        count += 1
        self.userDefaults.set(count, for: .processCompletedCount)

        self.logger.debug("Application launched \(count) time(s)")
    }

    func makeAttemptToShowRating(in windowScene: UIWindowScene) {
        // Get the current bundle version for the app
        guard let currentVersion = Bundle.main.string(for: .bundleVersion) else {
            self.logger.faultAndAssert("Expected to find a bundle version in the info dictionary")
            return
        }

        let lastVersionPromptedForReview = self.userDefaults.string(for: .lastVersionPromptedForReview)
        let count = self.userDefaults.integer(for: .processCompletedCount)

        // Has the process been completed several times and the user has not already been prompted for this version?
        if count >= 4 && currentVersion != lastVersionPromptedForReview {
            let twoSecondsFromNow = DispatchTime.now() + 2.0
            DispatchQueue.main.asyncAfter(deadline: twoSecondsFromNow) {
                SKStoreReviewController.requestReview(in: windowScene)
                self.userDefaults.set(currentVersion, for: .lastVersionPromptedForReview)
                self.logger.info("Made request to show rating")
            }
        }
    }

}

// This file contains the fastlane.tools configuration
// You can find the documentation at https://docs.fastlane.tools
//
// For a list of all available actions, check out
//
//     https://docs.fastlane.tools/actions
//

import Foundation

final class Fastfile: LaneFile {
    func betaLane() {
        desc("Push a new beta build to TestFlight")
        buildApp(scheme: "EstonianWeather")
        uploadToTestflight(
            username: "shiaulis@gmail.com",
            distributeExternal: true,
            groups: ["External Testers"]
        )
    }

    func uploadMinorBuildLane() {
        desc("Push a new build to the Appstore Connect")
        ensureGitStatusClean()
        let buildNumber = incrementBuildNumber()

        let newVersion = incrementVersionNumber(
            bumpType: "minor"
        )

        commitVersionBump(
            message: "Version bump to \(newVersion)(\(buildNumber))",
            xcodeproj: "EstonianWeather.xcodeproj"
        )

        buildApp(
            scheme: "EstonianWeather"
        )

        uploadToTestflight(
            username: "shiaulis@gmail.com",
            distributeExternal: true,
            groups: ["External Testers"]
        )

        uploadToAppStore(
            username: "shiaulis@gmail.com",
            appVersion: newVersion,
            overwriteScreenshots: true,
            teamName: "Andrius Shiaulis",
            app: "com.shiaulis.EstonianWeather"
        )
        
    }
}

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
        ensureGitStatusClean()
        bumpAndCommitNewVersion()
        buildApp(scheme: "EstonianWeather")
        uploadToTestflight(username: "shiaulis@gmail.com")
    }

    func releaseLane() {
        desc("Push a new release build to the App Store")
        ensureGitStatusClean()
        let buildNumber = incrementBuildNumber()

        let newVersion = incrementVersionNumber(bumpType: "patch")
        commitVersionBump(
            message: "Version bump to \(newVersion)(\(buildNumber))",
            xcodeproj: "EstonianWeather.xcodeproj"
        )
        buildApp(scheme: "EstonianWeather")
        uploadToAppStore(
            username: "shiaulis@gmail.com",
            appVersion: newVersion,
            overwriteScreenshots: true,
            teamName: "Andrius Shiaulis",
            app: "com.shiaulis.EstonianWeather"
        )
        
    }
}

extension Fastfile {

    private func bumpAndCommitNewVersion() {
        ensureGitStatusClean()
        let buildNumber = incrementBuildNumber(xcodeproj: "EstonianWeather.xcodeproj")
        let newVersion = incrementVersionNumber(bumpType: "patch")
        commitVersionBump(
            message: "Version bump to \(newVersion)(\(buildNumber)",
            xcodeproj: "EstonianWeather.xcodeproj"
        )
    }
}

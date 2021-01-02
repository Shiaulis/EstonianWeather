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

    func uploadBetaBuildLane() {
        desc("Increase build number and release it to current testers in TestFlight")
        ensureGitStatusClean()
        let versionNumber = getVersionNumber(target: "EstonianWeather")
        buildApp(scheme: "EstonianWeather")
        let buildNumber = incrementBuildNumber()


        let newVersion = "\(versionNumber)(\(buildNumber))"
        let bumpVersionTitle = "Version bump to \(newVersion)"
        commitVersionBump(
            message: bumpVersionTitle,
            xcodeproj: "EstonianWeather.xcodeproj",
            force: true
        )

        addGitTag(
            tag: "v.\(newVersion)"
        )

        uploadToTestflight(
            username: "shiaulis@gmail.com",
            changelog: "Minor fixes",
            distributeExternal: true,
            groups: ["External Testers"],
            teamName: "Andrius Shiaulis"
        )

        createPullRequest(
            apiToken: "b0f75f1e8474c3ae03a7bc7fba379938d5207cef",
            repo: "shiaulis/EstonianWeather",
            title: bumpVersionTitle
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

    func uploadMetadataLane() {
        uploadToAppStore(
            username: "shiaulis@gmail.com",
            appIdentifier: "com.shiaulis.EstonianWeather",
            skipAppVersionUpdate: true,
            overwriteScreenshots: true,
            teamName: "Andrius Shiaulis",
            app: "com.shiaulis.EstonianWeather"
        )
    }
}

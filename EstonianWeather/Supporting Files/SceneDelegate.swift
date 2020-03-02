//
//  SceneDelegate.swift
//  EstonianWeather
//
//  Created by Andrius Shiaulis on 12.01.2020.
//  Copyright © 2020 Andrius Shiaulis. All rights reserved.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    private lazy var isUnitTesting = ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
    private let shouldUseSwiftUI: Bool = true
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Unit tests
        guard !self.isUnitTesting else { return }

        guard let windowScene = scene as? UIWindowScene else { return }
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
            let applicationController = appDelegate.applicationController else { return }
        self.window = UIWindow(windowScene: windowScene)

        self.window?.rootViewController = RootViewController(applicationViewModel: applicationController)

        self.window?.makeKeyAndVisible()
    }

}

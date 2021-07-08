//
//  SceneDelegate.swift
//  EstonianWeather
//
//  Created by Andrius Siaulis on 10.07.2021.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private let rootViewModel: RootViewModel = .init()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        self.window = window

        window.rootViewController = RootViewController(viewModel: self.rootViewModel)
        window.makeKeyAndVisible()
    }

}

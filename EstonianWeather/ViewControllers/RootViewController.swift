//
//  RootViewController.swift
//  EstonianWeather
//
//  Created by Andrius Shiaulis on 02.03.2020.
//  Copyright © 2020 Andrius Shiaulis. All rights reserved.
//

import UIKit
import SwiftUI

enum ApplicationMode {
    case unitTests, uiKit, swiftUI
}

protocol ApplicationViewModel {
    var applicationMode: ApplicationMode { get }
    func forecastDataProvider() -> ForecastDataProvider
}

final class RootViewController: UIViewController {

    // MARK: - Properties

    private let applicationViewModel: ApplicationViewModel

    private lazy var swiftUIViewController: UIViewController = {
        let dataProvider = self.applicationViewModel.forecastDataProvider()
        let viewModel = RootViewMolel(dataProvider: dataProvider)
        let rootView = RootView(viewModel: viewModel)
        let viewController = UIHostingController(rootView: rootView)
        viewController.view.translatesAutoresizingMaskIntoConstraints = false

        return viewController
    }()

    private lazy var uiKitViewController: UIViewController = {
        UIViewController()
    }()

    // MARK: - Initialization

    init(applicationViewModel: ApplicationViewModel) {
        self.applicationViewModel = applicationViewModel
        super.init(nibName: nil, bundle: nil)

        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private

    private func setup() {
        let rootView: UIView
        switch self.applicationViewModel.applicationMode {
        case .unitTests: return
        case .swiftUI: rootView = self.swiftUIViewController.view
        case .uiKit: rootView = self.uiKitViewController.view
        }

        self.view.addSubview(rootView)

        NSLayoutConstraint.activate([
            rootView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            rootView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            rootView.topAnchor.constraint(equalTo: self.view.topAnchor),
            rootView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])

    }

}

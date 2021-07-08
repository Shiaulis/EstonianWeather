//
//  RootViewController.swift
//  EstonianWeather
//
//  Created by Andrius Siaulis on 10.07.2021.
//

import UIKit
import SwiftUI
import Combine

final class RootViewController: UISplitViewController {

    // MARK: - Properties

    private let viewModel: RootViewModel
    private var disposables: Set<AnyCancellable> = []

    // MARK: - Init

    init(viewModel: RootViewModel) {
        self.viewModel = viewModel
        super.init(style: .doubleColumn)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View controller life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.primaryBackgroundStyle = .sidebar
        self.preferredDisplayMode = .oneBesideSecondary
        self.preferredSplitBehavior = .tile
        self.preferredPrimaryColumnWidthFraction = 0.3

        self.viewModel.$selectedTab
            .sink { [weak self] selectedTab in
                guard let self = self else { return }
                switch selectedTab {
                case .forecastList: self.setViewController(self.forecastListViewController(), for: .secondary)
                case .settings: self.setViewController(self.settingsViewController(), for: .secondary)
                }
            }
            .store(in: &self.disposables)

        self.setViewController(sidebarViewController(), for: .primary)
        self.setViewController(tabbarViewController(), for: .compact)
    }

    // MARK: - Private methods

    private func sidebarViewController() -> UIViewController {
        let sidebar = SidebarViewController(viewModel: self.viewModel)
        return UINavigationController(rootViewController: sidebar)
    }

    private func tabbarViewController() -> UIViewController {
        let tabbarView = TabbarView(viewModel: self.viewModel)
        return UIHostingController(rootView: tabbarView)
    }

    private func forecastListViewController() -> UIViewController {
        let forecastListView = ForecastListView(viewModel: self.viewModel.forecastListViewModel)
        let hosting = UIHostingController(rootView: forecastListView)
        let navigation = UINavigationController(rootViewController: hosting)
        navigation.navigationBar.prefersLargeTitles = true
        return navigation
    }

    private func settingsViewController() -> UIViewController {
        let settingsView = SettingsView(viewModel: self.viewModel.settingsViewModel)
        let hosting = UIHostingController(rootView: settingsView)
        let navigation = UINavigationController(rootViewController: hosting)
        navigation.navigationBar.prefersLargeTitles = true
        return navigation
    }

}

//
//  SidebarViewController.swift
//  EstonianWeather
//
//  Created by Andrius Siaulis on 10.07.2021.
//

import UIKit
import Combine

protocol SidebarViewModel {
    var selectedTabPublisher: AnyPublisher<Tab, Never> { get }
    func select(_ tab: Tab)
}

final class SidebarViewController: UICollectionViewController {

    private typealias DataSource = UICollectionViewDiffableDataSource<SidebarSection, Tab>
    private enum SidebarSection: Int { case main }

    // MARK: - Properties

    private let viewModel: SidebarViewModel
    private var dataSource: DataSource!
    private var disposables: Set<AnyCancellable> = []

    // MARK: - Init

    init(viewModel: SidebarViewModel) {
        self.viewModel = viewModel
        super.init(collectionViewLayout: Self.createLayout())
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View controller life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureDataSource()
        applyInitialSnapshot()
        self.title = "Eesti Ilm"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.clearsSelectionOnViewWillAppear = false

        self.viewModel.selectedTabPublisher
            .sink { [weak self] selectedTab in
                guard let self = self else { return }
                let selectedIndexPath = selectedTab.indexPath
                let currentSelection = self.collectionView.indexPathsForSelectedItems ?? []
                // We need to prevent from selection of already selected row
                guard !currentSelection.contains(selectedIndexPath) else { return }
                self.collectionView.selectItem(at: selectedIndexPath, animated: true, scrollPosition: .init(rawValue: 0))
            }
            .store(in: &self.disposables)
    }

    // MARK: - Private methods

    private func configureDataSource() {
        let rowRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Tab> {
            (cell, _, tab) in

            var contentConfiguration = UIListContentConfiguration.sidebarSubtitleCell()
            contentConfiguration.text = tab.title
            contentConfiguration.image = UIImage(systemName: tab.imageName)
            cell.contentConfiguration = contentConfiguration
        }

        self.dataSource = DataSource(collectionView: self.collectionView) {
            (collectionView, indexPath, tab) -> UICollectionViewCell in
            collectionView.dequeueConfiguredReusableCell(using: rowRegistration, for: indexPath, item: tab)
        }
    }

    private func applyInitialSnapshot() {
        self.dataSource.apply(snapshot(), to: .main, animatingDifferences: false)
    }

    private func snapshot() -> NSDiffableDataSourceSectionSnapshot<Tab> {
        var snapshot = NSDiffableDataSourceSectionSnapshot<Tab>()
        let items: [Tab] = Tab.allCases

        snapshot.append(items)
        return snapshot
    }

    // MARK: - Private static methods

    private static func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout() { (_, layoutEnvironment) -> NSCollectionLayoutSection? in
            var configuration = UICollectionLayoutListConfiguration(appearance: .sidebar)
            configuration.showsSeparators = false
            let section = NSCollectionLayoutSection.list(using: configuration, layoutEnvironment: layoutEnvironment)
            return section
        }

        return layout
    }

}

extension SidebarViewController: UISplitViewControllerDelegate {

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedTab = self.dataSource.itemIdentifier(for: indexPath) else { return }
        self.viewModel.select(selectedTab)
    }
}

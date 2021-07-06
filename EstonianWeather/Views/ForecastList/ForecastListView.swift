//
//  ForecastListView.swift
//  EstonianWeather
//
//  Created by Andrius Shiaulis on 12.01.2020.
//  Copyright © 2020 Andrius Shiaulis. All rights reserved.
//

import SwiftUI
import WeatherKit

struct ForecastListView: View {

    // MARK: - Properties

    @ObservedObject var viewModel: ForecastListViewModel

    // MARK: - Body

    var body: some View {
        NavigationView {
            ZStack {
                if self.viewModel.shouldShowSyncStatus {
                    ListPlaceholder(status: self.viewModel.syncStatus)
                }
                else {
                    Form {
                            ForEach(self.viewModel.displayItems) { displayItem in
                                Section(header: Text(displayItem.naturalDateDescription).font(.headline)) {
                                    ForEach(displayItem.dayParts) { dayPart in
                                        DayPartView(item: dayPart)
                                    }
                                }
                            }
                        }
                }
            }
            .navigationTitle(R.string.localizable.fourDayForecast())
        }
    }

}

struct ListPlaceholder: View {
    let status: SyncStatus

    private var description: String {
        switch status {
        case .synced:
            assertionFailure("We do not expect to take this status description")
            return ""
        case .syncing:
            return " \(R.string.localizable.loading())"
        case .failed(let errorDescription):
            return R.string.localizable.failedToSyncError() + " " + errorDescription
        case .ready:
            return R.string.localizable.ready()
        }
    }

    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Text(self.description)
                    .font(.headline)
                    .foregroundColor(.gray)
                Spacer()
            }
            Spacer()
        }
    }
}

struct SyncStatusView: View {
    let status: SyncStatus

    private var color: Color {
        switch status {
        case .synced: return .white
        case .syncing: return .white
        case .failed: return .white
        case .ready: return .white
        }
    }

    private var description: String {
        switch status {
        case .synced(let syncDate):
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .medium
            formatter.doesRelativeDateFormatting = true
            let prefix = "✅ \(R.string.localizable.synced()) "
            return prefix + formatter.string(from: syncDate)
        case .syncing:
            return " 🔄 \(R.string.localizable.loading)"
        case .failed(let errorDescription):
            return R.string.localizable.failedToSyncError() + " " + errorDescription
        case .ready:
            return R.string.localizable.ready()
        }
    }

    var body: some View {
        HStack {
            Spacer()
            Text(self.description)
                .foregroundColor(self.color)
                .font(.caption2)
                .padding(.bottom, 4)
            Spacer()
        }
    }
}

struct SettingsButton: View {

    private let tapped: () -> Void

    init(_ tapped: @escaping () -> Void) {
        self.tapped = tapped
    }

    var body: some View {
        Button(action: self.tapped) {
            Image(systemName: "gear")
        }
    }
}

extension Color {
    static let topBackgroundGradient: Color = .init("topBackgroundGradient")
    static let bottomBackgroundGradient: Color = .init("bottomBackgroundGradient")
    static let topBarColor: Color = .init("topBarColor")
    static let bottomBarColor: Color = .init("bottomBarColor")
}

extension UIColor {
    static let topBackgroundGradient: UIColor = .init(.topBackgroundGradient)
    static let bottomBackgroundGradient: UIColor = .init(.bottomBackgroundGradient)
    static let topBarColor: UIColor = .init(.topBarColor)
    static let bottomBarColor: UIColor = .init(.bottomBarColor)
}

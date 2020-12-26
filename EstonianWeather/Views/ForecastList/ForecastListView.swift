//
//  ForecastListView.swift
//  EstonianWeather
//
//  Created by Andrius Shiaulis on 12.01.2020.
//  Copyright © 2020 Andrius Shiaulis. All rights reserved.
//

import SwiftUI

struct ForecastListView<ViewModel: ForecastListViewModel>: View {

    // MARK: - Properties

    @ObservedObject var viewModel: ViewModel

    // MARK: - Body

    var body: some View {
        NavigationView {
            ZStack {
                if self.viewModel.shouldShowSyncStatus {
                    ListPlaceholder(status: self.viewModel.syncStatus)
                }
                else {
                    ScrollView {
                        if self.viewModel.shouldShowSyncStatus {

                        }
                        else {
                            LazyVStack {
                                ForEach(self.viewModel.displayItems) { displayItem in
                                    ForecastView(item: displayItem)
                                }
                            }
                            .padding()
                        }
                    }
                }
            }
            .navigationTitle(R.string.localizable.fourDaysForecast())
            .navigationBarColor(backgroundColor: Resource.Color.appRose, tintColor: .white)
        }
    }

}

struct ListPlaceholder: View {
    let status: SyncStatus

    private var description: String {
        switch status {
        case .synced: return ""
//            let formatter = DateFormatter()
//            formatter.dateStyle = .medium
//            formatter.timeStyle = .medium
//            formatter.doesRelativeDateFormatting = true
//            let prefix = "✅ \(R.string.localizable.synced()) "
//            return prefix + formatter.string(from: syncDate)
        case .syncing:
            return " \(R.string.localizable.syncing())"
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
            return " 🔄 \(R.string.localizable.syncing())"
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
        .background(Color(Resource.Color.appRose))
    }
}

struct ForecastListView_Previews: PreviewProvider {
    static var previews: some View {
        ForecastListView(viewModel: MockForecastListViewModel())
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

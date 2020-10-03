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
            ScrollView {
                LazyVStack {
                    ForEach(self.viewModel.displayItems) { displayItem in
                        ForecastView(item: displayItem)
                    }
                }
            }
            .navigationTitle("4 Days Forecast")
        }
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

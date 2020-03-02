//
//  ForecastListView.swift
//  EstonianWeather
//
//  Created by Andrius Shiaulis on 12.01.2020.
//  Copyright © 2020 Andrius Shiaulis. All rights reserved.
//

import SwiftUI

struct ForecastListView: View {

    // MARK: - Properties

    @ObservedObject var viewModel: ForecastListViewModel

    // MARK: - Initialization

    init(viewModel: ForecastListViewModel = .init(dataProvider: ForecastDataProvider())) {
        self.viewModel = viewModel
        // For now this is the only way to remove separators in list
        UITableView.appearance().separatorStyle = .none
    }

    // MARK: - Body

    var body: some View {
        NavigationView {
            List(self.viewModel.displayItems) { item in
                ForecastView(item: item)
                    .padding(.horizontal)
                        .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 0.5)
                            .shadow(radius: 2)
                    )

            }
            .navigationBarItems(trailing:
                SettingsButton(self.viewModel.openApplicationSettings)
            )
        .navigationBarTitle(Text("Forecast"))
        }
    }

}

struct ForecastListView_Previews: PreviewProvider {
    static var previews: some View {
        ForecastListView()
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
//
//  RootView.swift
//  EstonianWeather
//
//  Created by Andrius Shiaulis on 12.01.2020.
//  Copyright © 2020 Andrius Shiaulis. All rights reserved.
//

import SwiftUI

struct RootView: View {

    // MARK: - Properties

    @ObservedObject var viewModel: RootViewMolel = RootViewMolel(dataProvider: ForecastDataProvider())

    // MARK: - Initialization

    init() {
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
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

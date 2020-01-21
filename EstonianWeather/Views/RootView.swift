//
//  RootView.swift
//  EstonianWeather
//
//  Created by Andrius Shiaulis on 12.01.2020.
//  Copyright © 2020 Andrius Shiaulis. All rights reserved.
//

import SwiftUI

struct RootView: View {

    @ObservedObject var viewModel: RootViewMolel = RootViewMolel(dataProvider: ForecastDataProvider())

    var body: some View {
        List(self.viewModel.displayItems) { item in
            ForecastView(item: item)
                .padding(.horizontal)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}

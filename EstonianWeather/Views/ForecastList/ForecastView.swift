//
//  ForecastView.swift
//  EstonianWeather
//
//  Created by Andrius Shiaulis on 18.01.2020.
//  Copyright © 2020 Andrius Shiaulis. All rights reserved.
//

import SwiftUI

struct ForecastView: View {

    private let item: ForecastDisplayItem

    init(item: ForecastDisplayItem) {
        self.item = item
    }

    var body: some View {
        ZStack {
            VStack {
                ForEach(self.item.dayParts) { dayPart in
                    DayPartView(item: dayPart)
                }
            }
            .padding(.vertical)
        }
    }
}

struct ForecastView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ForecastView(item: ForecastDisplayItem.test1)
                .environment(\.colorScheme, .light)
                .previewLayout(.fixed(width: 313, height: 400))
            ForecastView(item: ForecastDisplayItem.test2)
                .environment(\.colorScheme, .dark)
                .previewLayout(.fixed(width: 313, height: 400))
        }
    }
}

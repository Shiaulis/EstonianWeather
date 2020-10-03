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
                HStack {
                    Text(self.item.naturalDateDescription)
                    Spacer()
                }
                .font(.headline)

                VStack {
                    DayPartView(item: self.item.dayParts[0])
                    DayPartView(item: self.item.dayParts[1])
                }
            }
            .padding(.vertical)
        }
    }
}

struct ForecastView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ForecastView(item: ForecastDisplayItem.test)
                .environment(\.colorScheme, .light)
                .previewLayout(.fixed(width: 313, height: 600))
            ForecastView(item: ForecastDisplayItem.test)
                .environment(\.colorScheme, .dark)
                .previewLayout(.fixed(width: 313, height: 600))
        }
    }
}

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
        VStack {
            HStack {
                Text(self.item.naturalDateDescription)
                Text(self.item.date)
                Spacer()
            }
            .font(.headline)

            Divider()

            VStack {
                DayPartView(item: self.item.dayParts[0])
                Divider()
                    .padding()
                DayPartView(item: self.item.dayParts[1])
            }
        }
        .padding(.vertical)
    }
}

struct ForecastView_Previews: PreviewProvider {
    static var previews: some View {
        ForecastView(item: ForecastDisplayItem.test)
            .previewLayout(.fixed(width: 414, height: 600))
    }
}

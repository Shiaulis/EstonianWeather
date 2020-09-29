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
                    Text(self.item.date)
                    Spacer()
                }
                .font(.headline)
                .padding(.vertical)

                VStack {
                    DayPartView(item: self.item.dayParts[0])
                        .padding()
                    DayPartView(item: self.item.dayParts[1])
                        .padding()
                }
            }
            .padding(.vertical)
            .foregroundColor(.white)
        }
    }
}

struct ForecastView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            LinearGradient(
                gradient: .init(colors: [
                    .topBackgroundGradient,
                    .bottomBackgroundGradient
                ]),
                startPoint: .topTrailing,
                endPoint: .bottomLeading
            )
            ForecastView(item: ForecastDisplayItem.test)
        }
            .previewLayout(.fixed(width: 313, height: 600))
    }
}

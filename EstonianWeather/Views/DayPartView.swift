//
//  DayPartView.swift
//  EstonianWeather
//
//  Created by Andrius Shiaulis on 18.01.2020.
//  Copyright © 2020 Andrius Shiaulis. All rights reserved.
//

import SwiftUI

struct DayPartView: View {

    let item: ForecastDisplayItem.DayPartForecastDisplayItem

    var body: some View {
        VStack {
            HStack {
                VStack {
                    Text(self.item.type)
                        .font(.headline)
                    Image(systemName: self.item.weatherIconName)
                        .resizable()
                        .frame(width: 64, height: 64)
                    Text(self.item.weatherDescription)
                        .font(.caption)
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                    .lineLimit(2)
                        .layoutPriority(-1)
                    Text(self.item.temperatureRange)
                        .font(.headline)
                }
                .padding(.trailing)

                VStack {
                    Text(self.item.description)
                        .multilineTextAlignment(.leading)
                        .font(.caption)
                        .layoutPriority(1)
                }
            }
        }

        // For now places won't be shown
        //            ForEach(item.places, id: \.id) { place in
        //                PlaceView(place: place)
        //            }

    }
}

struct DayPartView_Previews: PreviewProvider {
    static var previews: some View {
        DayPartView(item: ForecastDisplayItem.DayPartForecastDisplayItem.test)
        .previewDevice("iPhone SE")
//            .previewLayout(.fixed(width: 414, height: 300))
    }
}

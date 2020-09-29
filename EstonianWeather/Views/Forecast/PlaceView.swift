//
//  PlaceView.swift
//  EstonianWeather
//
//  Created by Andrius Shiaulis on 18.01.2020.
//  Copyright © 2020 Andrius Shiaulis. All rights reserved.
//

import SwiftUI

struct PlaceView: View {

    let place: ForecastDisplayItem.DayPartForecastDisplayItem.PlaceDisplayItem

    var body: some View {
        HStack {
            Spacer()
            Text(place.name)
            Spacer()
            Image(place.weatherIconName)
                .resizable()
                .frame(width: 20, height: 20)
            Text(place.temperature)
                .padding(.horizontal)
        }
    }
}

struct PlaceView_Previews: PreviewProvider {
    static var previews: some View {
        PlaceView(place: ForecastDisplayItem.DayPartForecastDisplayItem.PlaceDisplayItem.test1)
        .previewLayout(.fixed(width: 300, height: 150))
    }
}

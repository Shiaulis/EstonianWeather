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
        ZStack {
            VisualEffectView(effect: UIBlurEffect(style: .extraLight))
                .opacity(0.5)
                .cornerRadius(30)
            VStack {
                VStack {
                    HStack {
                        Text(self.item.type)
                            .font(.headline)
                        Spacer()
                    }
                    HStack {
                        VStack {
                            Text(self.item.temperatureRange)
                            .font(.title)
                            Text(self.item.weatherDescription)
                                .font(.caption2)
                                .lineLimit(2)
                        }
                        Spacer()
                        VStack {
                            Image(systemName: self.item.weatherIconName)
                                .renderingMode(.original)
                                .font(.largeTitle)

                        }

                    }
                }

                VStack {
                    Text(self.item.description)
                        .multilineTextAlignment(.leading)
                        .font(.caption)
                        .layoutPriority(1)
                }
            }
            .padding()
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
//        .previewDevice("iPhone SE")
            .previewLayout(.fixed(width: 414, height: 150))
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

struct VisualEffectView: UIViewRepresentable {
    var effect: UIVisualEffect?
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView { UIVisualEffectView() }
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) { uiView.effect = effect }
}

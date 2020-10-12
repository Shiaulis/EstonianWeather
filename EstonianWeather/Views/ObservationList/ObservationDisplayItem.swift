//
//  ObservationDisplayItem.swift
//  EstonianWeather
//
//  Created by Andrius Shiaulis on 12.10.2020.
//

import Foundation

struct ObservationDisplayItem: Identifiable {
    let id = UUID()
    let name: String

}

extension ObservationDisplayItem {
    static var test: ObservationDisplayItem {
        .init(
            name: "Tallinn-Harku"
        )
    }
}

/*
 <name>Tallinn-Harku</name>
 <wmocode>26038</wmocode>
 <longitude>24.602891666624284</longitude>
 <latitude>59.398122222355134</latitude>
 <phenomenon>Variable clouds</phenomenon>
 <visibility>35.0</visibility>
 <precipitations>0</precipitations>
 <airpressure>1016.7</airpressure>
 <relativehumidity>86</relativehumidity>
 <airtemperature>10.8</airtemperature>
 <winddirection>200</winddirection>
 <windspeed>2.9</windspeed>
 <windspeedmax>4.2</windspeedmax>        <waterlevel></waterlevel>        <waterlevel_eh2000></waterlevel_eh2000>
 <watertemperature></watertemperature>
 <uvindex>1</uvindex>

 */

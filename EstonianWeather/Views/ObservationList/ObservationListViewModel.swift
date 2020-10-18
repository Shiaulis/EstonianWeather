//
//  ObservationListViewModel.swift
//  EstonianWeather
//
//  Created by Andrius Shiaulis on 16.10.2020.
//

import Foundation

protocol ObservationListViewModel: ObservableObject {
    var displayItems: [ObservationDisplayItem] { get }
}

final class MockObservationListViewModel: ObservationListViewModel {

    let displayItems: [ObservationDisplayItem] = [ObservationDisplayItem.test]

}

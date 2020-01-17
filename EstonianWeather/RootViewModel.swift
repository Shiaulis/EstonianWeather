//
//  RootViewModel.swift
//  EstonianWeather
//
//  Created by Andrius Shiaulis on 13.01.2020.
//  Copyright © 2020 Andrius Shiaulis. All rights reserved.
//

import Foundation
import Combine

final class RootViewMolel {

    private var disposables: Set<AnyCancellable> = []
    private(set) var data: Data?

    var networkPublisher: AnyPublisher<(data: Data, response: URLResponse), URLError> {
        let url = URL(string: "http://www.ilmateenistus.ee/ilma_andmed/xml/forecast.php?lang=eng")!
        let session  = URLSession.shared
        return session.dataTaskPublisher(for: url)
        .eraseToAnyPublisher()
    }

    func fetch(completion: @escaping (Result<Data, Error>) -> Void) {
        networkPublisher.sink(receiveCompletion: {
            print("received completion", $0)
        }) {
            completion(.success($0.data))
        }
        .store(in: &disposables)
    }

}

//
//  NetworkClient.swift
//  EstonianWeather
//
//  Created by Andrius Shiaulis on 29.09.2020.
//

import Foundation
import Combine

protocol NetworkClient {
    func requestPublisher(for endpoint: Endpoint) -> AnyPublisher<(data: Data, response: URLResponse), Swift.Error>
}

final class URLSessionNetworkClient: NSObject {

    private let urlSession = URLSession.shared

}

extension URLSessionNetworkClient: NetworkClient {

    func requestPublisher(for endpoint: Endpoint) -> AnyPublisher<(data: Data, response: URLResponse), Swift.Error> {
        let request: URLRequest
        do {
            request = try  endpoint.generateRequest()
        }
        catch {
            return Fail<(data: Data, response: URLResponse), Swift.Error>(error: error)
                .eraseToAnyPublisher()
        }
        return self.urlSession.dataTaskPublisher(for: request)
            .mapError { Error.dataTaskError(urlError: $0) }
            .eraseToAnyPublisher()
    }

    enum Error: Swift.Error {
        case noDataFoundInResponse
        case dataTaskError(urlError: URLError)
    }

}

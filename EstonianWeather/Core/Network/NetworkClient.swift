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

private extension Endpoint {

    func generateURL() throws -> URL {
        var components = URLComponents()
        components.scheme = Endpoint.scheme
        components.host = Endpoint.host
        components.path = self.path
        components.queryItems = self.urlQueryItems

        guard let url = components.url else { throw Error.badURL }

        return url
    }

    func generateRequest() throws -> URLRequest {
        var request = URLRequest(url: try generateURL())
        request.httpMethod = self.method.string
        request.setValue("application/x-www-form-urlencoded;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        return request
    }

}

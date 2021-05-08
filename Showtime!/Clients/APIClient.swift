//
//  APIClient.swift
//  Showtime!
//
//  Created by Scott Nicholes on 4/23/21.
//

import Foundation
import Combine

struct APIClient {
    struct Response<T> {
        let values: Array<T>
        let response: URLResponse
    }
    
    func request<T: Decodable>(_ request: URLRequest) -> AnyPublisher<Response<T>, Error> {
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .tryMap { result -> Response<T> in
                let values = try JSONDecoder().decode(Array<T>.self, from: result.data)
                return Response(values: values, response: result.response)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

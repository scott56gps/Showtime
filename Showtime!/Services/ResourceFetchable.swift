//
//  ResourceFetchable.swift
//  Showtime!
//
//  Created by Scott Nicholes on 6/19/21.
//

import Combine
import Foundation

protocol ResourceFetchable {
    func fetchURLAndDecode<T: Decodable>(url: URL, parameters: [String : String]?) -> AnyPublisher<T, Error>
    func constructURLWithComponents(url: URL, parameters: [String : String]?) -> URL?
}

extension ResourceFetchable {
    func fetchURLAndDecode<T: Decodable>(url: URL, parameters: [String : String]? = nil) -> AnyPublisher<T, Error>  {
        guard let requestUrl = constructURLWithComponents(url: url, parameters: parameters) else {
            return Fail(error: MovieRetrievalError.invalidEndpoint).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: requestUrl)
            .tryMap { result -> Data in
                guard let response = result.response as? HTTPURLResponse, response.statusCode == 200 else {
                    throw MovieRetrievalError.invalidResponse
                }
                
                return result.data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func constructURLWithComponents(url: URL, parameters: [String : String]?) -> URL? {
        guard !url.absoluteString.isEmpty else {
            return nil
        }
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return nil
        }
        
        var queryItems: [URLQueryItem] = []
        if let parameters = parameters {
            queryItems.append(contentsOf: parameters.map { URLQueryItem(name: $0.key, value: $0.value) })
        }
        
        urlComponents.queryItems = queryItems
        guard let requestUrl = urlComponents.url else {
            return nil
        }
        
        return requestUrl
    }
}

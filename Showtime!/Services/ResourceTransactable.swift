//
//  ResourceTransactable.swift
//  Showtime!
//
//  Created by Scott Nicholes on 6/19/21.
//

import Combine
import Foundation

protocol ResourceTransactable {
    func fetchResource(url: URL, headers: [String : String]?, urlParameters: [String : String]?) -> AnyPublisher<Data, Error>
    func postResource(url: URL, resource: Data, headers: [String : String]?, parameters: [String : String]?) -> AnyPublisher<Data, Error>
}

extension ResourceTransactable {
    func fetchResource(url: URL, headers: [String : String]? = nil, urlParameters: [String : String]? = nil) -> AnyPublisher<Data, Error> {
        guard let request = constructURLRequestWithComponents(url: url, method: "GET", headers: headers, urlParameters: urlParameters) else {
            return Fail(error: TransactionError.invalidRequest).eraseToAnyPublisher()
        }
        
        return publisherForRequest(request: request)
    }
    
    func postResource(url: URL, resource: Data, headers: [String : String]? = nil, parameters: [String : String]? = nil) -> AnyPublisher<Data, Error> {
        // Construct the request to this URL
        guard var request = constructURLRequestWithComponents(url: url, method: "POST", headers: headers, urlParameters: parameters) else {
            return Fail(error: TransactionError.invalidRequest).eraseToAnyPublisher()
        }
        
        request.httpBody = resource
        return publisherForRequest(request: request)
    }
    
    private func publisherForRequest(request: URLRequest) -> AnyPublisher<Data, Error> {
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { result -> Data in
                guard let response = result.response as? HTTPURLResponse, response.statusCode == 200 else {
                    throw TransactionError.invalidResponse
                }
                
                return result.data
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    private func constructURLRequestWithComponents(url: URL, method: String, headers: [String : String]?, urlParameters: [String : String]?) -> URLRequest? {
        guard let urlWithComponents = constructURLWithComponents(url: url, parameters: urlParameters) else {
            return nil
        }
        
        var request = URLRequest(url: urlWithComponents)
        request.httpMethod = method
        request.allHTTPHeaderFields = headers
        
        return request
    }
    
    private func constructURLWithComponents(url: URL, parameters: [String : String]?) -> URL? {
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

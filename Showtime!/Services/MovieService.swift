//
//  MovieService.swift
//  Showtime!
//
//  Created by Scott Nicholes on 5/8/21.
//

import Foundation
import SwiftUI
import Combine

struct MovieService {
    private let apiKey = "PUT API KEY HERE"
//    private let baseAPIURLString = "http://localhost:8000/" // Uncomment for Simulator Dev
    private let baseAPIURLString = "http://e50c0cacd1fb.ngrok.io/" // Uncomment for On-Device Dev
    
    func getMovies(from endpoint: MovieListEndpoint, completion: @escaping (Result<[Movie], MovieRetrievalError>) -> ()) -> AnyCancellable? {
        guard let url = URL(string: "\(baseAPIURLString)\(endpoint.rawValue)") else {
            completion(.failure(.invalidEndpoint))
            return nil
        }
        
        return fetchURLToType(url: url, completion: completion)
    }
    
    private func fetchURLToType<T: Decodable>(url: URL, parameters: [String : String]? = nil, completion: @escaping (Result<T, MovieRetrievalError>) -> ()) -> AnyCancellable? {
        guard !url.absoluteString.isEmpty else {
            completion(.failure(.invalidEndpoint))
            return nil
        }
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            completion(.failure(.invalidEndpoint))
            return nil
        }
        
        var queryItems: [URLQueryItem] = []
//        queryItems = [URLQueryItem(name: "api_key", value: apiKey)]
        if let parameters = parameters {
            queryItems.append(contentsOf: parameters.map { URLQueryItem(name: $0.key, value: $0.value) })
        }
        
        urlComponents.queryItems = queryItems
        guard let requestUrl = urlComponents.url else {
            completion(.failure(.invalidEndpoint))
            return nil
        }
        
        return URLSession.shared.dataTaskPublisher(for: requestUrl)
            .tryMap { result -> T in
                guard let response = result.response as? HTTPURLResponse, response.statusCode == 200 else {
                    completion(.failure(.invalidResponse))
                    throw MovieRetrievalError.invalidResponse
                }
                
                return try JSONDecoder().decode(T.self, from: result.data)
            }
            .receive(on: DispatchQueue.main)
//            .replaceEmpty(with: nil)
//            .replaceError(with: nil)
            .sink(receiveCompletion: { result in
                switch result {
                case .failure(let error):
                    print("Error \(error)")
                    completion(.failure(.apiError))
                case .finished:
                    print("Publisher is finished")
                }
            }) { result in
                completion(.success(result))
            }
    }
}

enum MovieListEndpoint: String {
    case watchlist
    
    var description: String {
        switch self {
            case .watchlist:
                return "Watchlist"
            }
    }
}

enum MovieRetrievalError: String, Error {
    case apiError
    case invalidEndpoint
    case invalidResponse
    case noData
    case serializationError
    
    var localizedDescription: String {
        switch self {
            case .apiError: return "Failed to fetch data"
            case .invalidEndpoint: return "Invalid endpoint"
            case .invalidResponse: return "Invalid response"
            case .noData: return "No data retrieved"
            case .serializationError: return "Failed to decode data"
        }
    }
    
    var errorHumanReadable: [String : Any] {
        [NSLocalizedDescriptionKey: localizedDescription]
    }
}

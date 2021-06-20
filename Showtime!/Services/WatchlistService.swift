//
//  MovieService.swift
//  Showtime!
//
//  Created by Scott Nicholes on 5/8/21.
//

import SwiftUI
import Combine

struct WatchlistService: ResourceFetchable {
//    private let baseAPIURLString = "http://localhost:8000/" // Uncomment for Simulator Dev
    private let baseAPIURLString = "http://e5f1266d6c36.ngrok.io" // Uncomment for On-Device Dev
    
    func getWatchlist() -> AnyPublisher<WatchlistResponse, Error> {
        guard let url = URL(string: "\(baseAPIURLString)/watchlist") else {
            return Fail(error: MovieRetrievalError.invalidEndpoint).eraseToAnyPublisher()
        }
        
        return fetchResource(url: url)
            .decode(type: WatchlistResponse.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
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

//
//  MovieService.swift
//  Showtime!
//
//  Created by Scott Nicholes on 5/8/21.
//

import SwiftUI
import Combine

struct WatchlistService: ResourceTransactable {
    private let baseAPIURLString = "https://ancient-sierra-46110.herokuapp.com/watchlist"
    
    func getWatchlist() -> AnyPublisher<[Movie], Error> {
        guard let url = URL(string: baseAPIURLString) else {
            return Fail(error: TransactionError.invalidEndpoint).eraseToAnyPublisher()
        }
        
        return fetchResource(url: url)
            .decode(type: [Movie].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func postToWatchlist(movie: Movie) -> AnyPublisher<Movie, Error> {
        guard let url = URL(string: baseAPIURLString) else {
            return Fail(error: TransactionError.invalidEndpoint).eraseToAnyPublisher()
        }
        
        guard let jsonMovie = try? JSONEncoder().encode(movie) else {
            return Fail(error: TransactionError.invalidRequest).eraseToAnyPublisher()
        }
        
        return postResource(url: url, resource: jsonMovie, headers: ["Content-Type" : "application/json"])
            .decode(type: Movie.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}

enum TransactionError: String, Error {
    case apiError
    case invalidEndpoint
    case invalidRequest
    case invalidResponse
    case noData
    case serializationError
    
    var localizedDescription: String {
        switch self {
        case .apiError: return "Failed to fetch data"
        case .invalidRequest: return "Invalid request"
        case .invalidResponse: return "Invalid response"
        case .invalidEndpoint: return "Invalid endpoint"
        case .noData: return "No data retrieved"
        case .serializationError: return "Failed to decode data"
        }
    }
    
    var errorHumanReadable: [String : Any] {
        [NSLocalizedDescriptionKey: localizedDescription]
    }
}

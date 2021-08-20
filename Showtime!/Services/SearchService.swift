//
//  SearchService.swift
//  Showtime!
//
//  Created by Scott Nicholes on 6/15/21.
//

import Foundation
import Combine

struct SearchService: ResourceTransactable {
    private let tmdbApiKey = ""
    private let tmdbBaseUrl = "https://api.themoviedb.org/3"
    
    func searchMovies(query: String) -> AnyPublisher<MovieSearchResponse, Error> {
        guard let url = URL(string: "\(tmdbBaseUrl)/search/movie") else {
            return Fail(error: TransactionError.invalidEndpoint).eraseToAnyPublisher()
        }
        
        if tmdbApiKey.isEmpty {
            print("API Key is empty")
            return Fail(error: TransactionError.invalidEndpoint).eraseToAnyPublisher()
        }
        
        return fetchResource(url: url, urlParameters: [
            "api_key" : tmdbApiKey,
            "language" : "en-us",
            "include_adult" : "false",
            "region" : "US",
            "query" : query
        ])
        .decode(type: MovieSearchResponse.self, decoder: JSONDecoder())
        .eraseToAnyPublisher()
    }
}

//
//  SearchService.swift
//  Showtime!
//
//  Created by Scott Nicholes on 6/15/21.
//

import Foundation
import Combine

struct SearchService: ResourceTransactable {
    private let apiKey: String = ProcessInfo.processInfo.environment["search_movies_api_key"]!
    private let baseUrl: String = ProcessInfo.processInfo.environment["search_movies_base_url"]!
    
    func searchMovies(query: String) -> AnyPublisher<MovieSearchResponse, Error> {
        guard let url = URL(string: "\(baseUrl)/search/movie") else {
            return Fail(error: TransactionError.invalidEndpoint).eraseToAnyPublisher()
        }
        
        return fetchResource(url: url, urlParameters: [
            "api_key" : apiKey,
            "language" : "en-us",
            "include_adult" : "false",
            "region" : "US",
            "query" : query
        ])
        .decode(type: MovieSearchResponse.self, decoder: JSONDecoder())
        .eraseToAnyPublisher()
    }
}

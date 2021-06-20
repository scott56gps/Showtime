//
//  SearchService.swift
//  Showtime!
//
//  Created by Scott Nicholes on 6/15/21.
//

import Foundation
import Combine

struct SearchService: ResourceFetchable {
    private let tmdbApiKey = ""
    private let tmdbBaseUrl = "https://api.themoviedb.org/3"
    
    func searchMovies(query: String) -> AnyPublisher<MovieSearchResponse, Error> {
        print("In Search Movies")
        guard let url = URL(string: "\(tmdbBaseUrl)/search/movie") else {
            return Fail(error: MovieRetrievalError.invalidEndpoint).eraseToAnyPublisher()
        }
        
        if tmdbApiKey.isEmpty {
            print("API Key is empty")
            return Fail(error: MovieRetrievalError.invalidEndpoint).eraseToAnyPublisher()
        }
        
        return fetchURLAndDecode(url: url, parameters: [
            "api_key" : tmdbApiKey,
            "language" : "en-us",
            "include_adult" : "false",
            "region" : "US",
            "query" : query
        ])
    }
}

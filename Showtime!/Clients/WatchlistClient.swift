//
//  WatchlistAPI.swift
//  Showtime!
//
//  Created by Scott Nicholes on 4/23/21.
//

import Foundation
import Combine

enum WatchlistClient {
    static let apiClient = APIClient()
    static let baseUrl = URL(string: "http://localhost:8000/")!
}

enum WatchlistPath: String {
    case watchlist = "watchlist"
}

extension WatchlistClient {
    static func request(_ path: WatchlistPath) -> AnyPublisher<Array<Movie>, Error> {
        guard let components = URLComponents(url: baseUrl.appendingPathComponent(path.rawValue), resolvingAgainstBaseURL: true) else {
            fatalError("Could not construct URL Components")
        }
        // Uncomment below for a request to the MovieDB API
//        components.queryItems = [URLQueryItem(name: "api_key", value: "your api key here")]
        
        let request = URLRequest(url: components.url!)
        
        return apiClient.request(request)
            .map(\.values)
            .eraseToAnyPublisher()
    }
}

//
//  SearchMovieRequest.swift
//  Showtime
//
//  Created by Scott Nicholes on 1/31/22.
//

import Networker

struct SearchMovieRequest: Requestable {
    typealias ResultType = MovieSearchResponse
    var path: String = "/search/movie"
    var method: HTTPMethod = .get
    var contentType: String = "application/json"
    var body: [String : Any]? = nil
    var queryParams: [String : String]?
    var headers: [String : String]?
    
    init(queryParams: [String : String]) {
        self.queryParams = queryParams
    }
}

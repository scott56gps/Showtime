//
//  SubmitMovieToWatchlistRequest.swift
//  Showtime
//
//  Created by Scott Nicholes on 1/7/22.
//

import Networker

struct SubmitMovieToWatchlistRequest: Requestable {
    typealias ResultType = Movie
    var path = "/watchlist"
    var method: HTTPMethod = .post
    var contentType = "application/json"
    var body: [String : Any]?
    var headers: [String : String]? = ["Content-Type" : "application/json"]
    
    init(body: [String : Any]) {
        self.body = body
    }
}

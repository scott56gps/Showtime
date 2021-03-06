//
//  RetrieveWatchlist.swift
//  Showtime
//
//  Created by Scott Nicholes on 1/7/22.
//

import Networker

struct RetrieveWatchlistRequest: Requestable {
    typealias ResultType = [Movie]
    var path = "/watchlist"
    var method: HTTPMethod = .get
}

//
//  DeleteMovieRequest.swift
//  Showtime
//
//  Created by Scott Nicholes on 2/4/22.
//

import Foundation
import Networker

struct DeleteMovieRequest: Requestable {
    typealias ResultType = Movie
    var path: String
    var method: HTTPMethod = .delete
    
    init(_ id: Int) {
        path = "/watchlist/\(id)"
    }
}

//
//  DeleteMovieRequest.swift
//  Showtime
//
//  Created by Scott Nicholes on 2/4/22.
//

import Foundation
import Networker
import Combine

struct DeleteMovieRequest: Requestable {
    typealias ResultType = Int
    var path: String
    var method: HTTPMethod = .delete
    
    init(id: Int) {
        path = "/watchlist/\(id)"
    }
}

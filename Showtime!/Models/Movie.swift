//
//  Movie.swift
//  Showtime!
//
//  Created by Scott Nicholes on 4/23/21.
//

import Foundation

struct Movie: Codable {
    var title: String
    var posterUrl: URL?
    var isLiked: Bool
}

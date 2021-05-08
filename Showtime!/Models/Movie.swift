//
//  Movie.swift
//  Showtime!
//
//  Created by Scott Nicholes on 4/23/21.
//

import Foundation

struct Movie: Codable {
    var id: Int
    var title: String
    var posterUrl: String?
//    var isLiked: Bool
    
    enum CodingKeys: String, CodingKey {
        case posterUrl = "poster_url"
        case id
        case title
    }
}

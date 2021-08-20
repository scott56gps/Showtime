//
//  Movie.swift
//  Showtime!
//
//  Created by Scott Nicholes on 4/23/21.
//

import Foundation

struct Movie: Codable, Identifiable {
    var id: Int?
    var title: String
    var posterUrl: String?
    
    enum MovieCodingKeys: String, CodingKey {
        case posterUrl = "poster_url"
        case id
        case title
    }
    
    init(id: Int, title: String, posterUrl: String?) {
        self.id = id
        self.title = title
        self.posterUrl = posterUrl
    }
    
    init(from result: MovieResult) {
        self.title = result.title
        if let posterPath = result.posterPath {
            self.posterUrl = "http://image.tmdb.org/t/p/original\(posterPath)"
        }
    }
}

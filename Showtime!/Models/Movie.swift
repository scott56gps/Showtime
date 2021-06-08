//
//  Movie.swift
//  Showtime!
//
//  Created by Scott Nicholes on 4/23/21.
//

import Foundation

struct Movie: Codable, Identifiable {
    var id: Int
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
        self.id = result.id
        self.title = result.title
        self.posterUrl = result.posterPath
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: MovieCodingKeys.self)
        self.id = try values.decode(Int.self, forKey: .id)
        self.title = try values.decode(String.self, forKey: .title)
        self.posterUrl = try values.decode(String.self, forKey: .posterUrl)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: MovieCodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(posterUrl, forKey: .posterUrl)
    }
}

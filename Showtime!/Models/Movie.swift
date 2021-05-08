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
    var posterUrlString: String?
    var posterUrl: URL {
        return URL(string: posterUrlString ?? "")!
    }
    
    enum CodingKeys: String, CodingKey {
        case posterUrlString = "poster_url"
        case id
        case title
        case posterUrl = "poster_url_object"
    }
    
    init(id: Int, title: String, posterUrlString: String?) {
        self.id = id
        self.title = title
        self.posterUrlString = posterUrlString
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        title = try values.decode(String.self, forKey: .title)
        posterUrlString = try values.decode(String?.self, forKey: .posterUrlString)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(posterUrlString, forKey: .posterUrlString)
        try container.encode(posterUrl, forKey: .posterUrl)
    }
}

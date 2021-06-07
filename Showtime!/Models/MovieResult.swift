//
//  MovieResult.swift
//  Showtime!
//
//  Created by Scott Nicholes on 6/7/21.
//

import Foundation

struct MovieResult: Codable, Identifiable {
    var id: Int
    var title: String
    var posterPath: String?
    
    init(id: Int, title: String, posterPath: String?) {
        self.id = id
        self.title = title
        self.posterPath = posterPath
    }
    
    enum MovieResultCodingKeys: String, CodingKey {
        case id
        case title
        case posterPath = "poster_path"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: MovieResultCodingKeys.self)
        
        self.id = try values.decode(Int.self, forKey: .id)
        self.title = try values.decode(String.self, forKey: .title)
        self.posterPath = try values.decode(String?.self, forKey: .posterPath)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: MovieResultCodingKeys.self)
        
        try container.encode(self.id, forKey: .id)
        try container.encode(self.title, forKey: .title)
        try container.encode(self.posterPath, forKey: .posterPath)
    }
}

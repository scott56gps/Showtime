//
//  MovieSearchResponse.swift
//  junk_SearchBar
//
//  Created by Scott Nicholes on 5/18/21.
//

struct MovieSearchResponse: Codable {
    let page: Int
    let results: [Movie]
}

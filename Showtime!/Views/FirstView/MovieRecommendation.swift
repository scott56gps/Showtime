//
//  MovieRecommendation.swift
//  Showtime
//
//  Created by Scott Nicholes on 12/3/21.
//

import SwiftUI

struct MovieRecommendation: View {
    var body: some View {
        MovieCard(movie: Movie(id: 555, title: "Tommy Boy", posterUrl: "https://www.google.com/"))
    }
}

struct MovieRecommendation_Previews: PreviewProvider {
    static var previews: some View {
        MovieRecommendation()
    }
}

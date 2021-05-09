//
//  MovieCarouselView.swift
//  Showtime!
//
//  Created by Scott Nicholes on 5/8/21.
//

import SwiftUI

struct MovieCarouselView: View {
    var movies: [Movie]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .top, spacing: 16) {
                ForEach(movies) { movie in
                    MovieCard(movie: movie)
                }
            }
        }
    }
}

struct MovieCarouselView_Previews: PreviewProvider {
    static var previews: some View {
        MovieCarouselView(movies: [Movie(id: 0, title: "Tommy Boy", posterUrlString: nil)])
    }
}

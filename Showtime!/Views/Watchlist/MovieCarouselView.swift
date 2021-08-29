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
        HStack(alignment: .center, spacing: 16) {
            ForEach(movies) { movie in
                MovieCard(movie: movie)
                    .frame(width: UIScreen.main.bounds.width - 32, alignment: .center)
                    .cornerRadius(10)
            }
        }
        .padding()
        .modifier(HStackSnapCarousel(items: movies.count, itemWidth: UIScreen.main.bounds.width - 32, itemSpacing: 16))
    }
}

struct MovieCarouselView_Previews: PreviewProvider {
    static var previews: some View {
        MovieCarouselView(movies: [Movie(id: 0, title: "Tommy Boy", posterUrl: nil)])
    }
}

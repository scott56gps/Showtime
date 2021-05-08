//
//  MovieCard.swift
//  Showtime!
//
//  Created by Scott Nicholes on 5/8/21.
//

import SwiftUI
import Combine

struct MovieCard: View {
    let movie: Movie
    @ObservedObject var imageLoader = ImageLoader()
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(movie.title)
            ZStack {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                
                if imageLoader.image != nil {
                    Image(uiImage: imageLoader.image!)
                        .resizable()
                } else {
                    Image(systemName: "square")
                }
            }
            .cornerRadius(8)
            .shadow(radius: 4)
        }
        .onAppear {
            imageLoader.load(with: movie.posterUrl)
        }
    }
}

struct MovieCard_Previews: PreviewProvider {
    static var previews: some View {
        MovieCard(movie: Movie(id: 0, title: "Tommy Boy", posterUrlString: nil), imageLoader: ImageLoader())
    }
}

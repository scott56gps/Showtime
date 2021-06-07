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
    @StateObject var imageViewModel = ImageViewModel()
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(movie.title)
                .frame(maxWidth: .infinity, alignment: .center)
            
//            Image("Tommy Boy") // For testing
//                .resizable()
//                .aspectRatio(contentMode: .fit)
            if imageViewModel.image != nil {
                Image(uiImage: imageViewModel.image!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                Image(systemName: "square")
            }
        }
        .padding()
        .onAppear {
            if let posterPath = movie.posterUrl {
                imageViewModel.load(posterPath)
            }
        }
    }
}

struct MovieCard_Previews: PreviewProvider {
    static var previews: some View {
        MovieCard(movie: Movie(id: 0, title: "Tommy Boy", posterPath: nil, posterUrl: nil), imageViewModel: ImageViewModel(image: UIImage(named: "Tommy Boy")))
    }
}

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
                .padding()
                .frame(maxWidth: .infinity, alignment: .center)

            if imageViewModel.image != nil {
                Image(uiImage: imageViewModel.image!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                Spacer()
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
        MovieCard(movie: Movie(id: 0, title: "Tommy Boy", posterUrl: nil), imageViewModel: ImageViewModel(image: UIImage(named: "Tommy Boy")))
    }
}

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
    var inCollection = false
    @StateObject var imageViewModel = ImageViewModel()
    
    var body: some View {
        VStack(alignment: inCollection ? .leading : .center) {
            Text(movie.title)
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity)
            
            if imageViewModel.image != nil {
                GeometryReader { geo in
                    Image(uiImage: imageViewModel.image!)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: geo.size.width, maxHeight: geo.size.height - 30, alignment: .center)
                        .cornerRadius(12)
                }
            } else {
                Spacer()
            }
        }
        .onAppear {
            if let posterPath = movie.posterUrl {
                imageViewModel.loadImage(posterPath)
            }
        }
    }
}

struct MovieCard_Previews: PreviewProvider {
    static var previews: some View {
        MovieCard(movie: Movie(id: 0, title: "Tommy Boy", posterUrl: nil), imageViewModel: ImageViewModel(image: UIImage(named: "Tommy Boy")))
    }
}

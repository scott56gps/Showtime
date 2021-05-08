//
//  WatchlishViewModel.swift
//  Showtime!
//
//  Created by Scott Nicholes on 4/23/21.
//

import Foundation
import Combine
import SwiftUI

class WatchlistViewModel: ObservableObject {
    @Published private var movie: Movie = Movie(id: 0, title: "Placeholder")
    var cancellationToken: AnyCancellable?
    
    // The properties of the ViewModel are accessible to the View, and
    //  thus should only be applicable to the View
    var title: String = ""
    var poster = URLImage(imageUrl: "")
//    var isLiked: Bool {
//        get { movie.isLiked }
//        set { movie.isLiked = newValue }
//    }
    
    init() {
        getWatchlist()
    }
}

extension WatchlistViewModel {
    // Subscriber Implementation
    func getWatchlist() {
        cancellationToken = WatchlistClient.request(.watchlist)
            .mapError { (error) -> Error in
                print(error)
                return error
            }
            .sink(receiveCompletion: { _ in
                print("Completed Request")
            }, receiveValue: { [self] in
                movie = $0[0]
                title = movie.title
//                getPoster(movie)
                poster = URLImage(imageUrl: movie.posterUrl ?? "")
            })
    }
    
//    func getPoster(_ movie: Movie) {
//        var returnImage: Image = Image(systemName: "square")
//
//        guard let url = movie.posterUrl else {
//            self.poster = returnImage
//            return
//        }
//        cancellationToken = PosterImageClient.request(url)
//            .mapError { (error) -> Error in
//                print(error)
//                return error
//            }
//            .sink(receiveCompletion: { _ in
//                print("Completed Poster Request")
//            }, receiveValue: { self.poster = Image(uiImage: $0) })
//    }
}

final class ImageLoader: ObservableObject {
    @Published public var imageData: Data
    
    init(url imageUrl: String) {
        self.imageData = Data()
        
        guard let url = URL(string: imageUrl) else { return }
        PosterImageClient.request(imageUrl)
            .mapError { (error) -> Error in
                print(error)
                return error
            }
            .sink(receiveCompletion: { _ in
                print("Completed Image Loader Request")
            }, receiveValue: { self.imageData = $0.pngData() ?? Data() })
    }
}

struct URLImage: View {
    @ObservedObject var loader: ImageLoader
    
    init(imageUrl: String) {
        loader = ImageLoader(url: imageUrl)
    }
    
    var body: some View {
        Image(uiImage: ((loader.imageData.isEmpty ? UIImage(systemName: "square") : UIImage(data: loader.imageData) ?? UIImage(systemName: "square"))!))
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
}

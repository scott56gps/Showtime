//
//  WatchlishViewModel.swift
//  Showtime!
//
//  Created by Scott Nicholes on 4/23/21.
//

import Foundation
import Combine

class WatchlistViewModel: ObservableObject {
    @Published private var movie: Movie = Movie(title: "Placeholder", isLiked: false)
    var cancellationToken: AnyCancellable?
    
    // The properties of the ViewModel are accessible to the View, and
    //  thus should only be applicable to the View
    var title: String {
        movie.title
    }
    var poster: String {
        // magic to get poster image from the model's posterUrl
        "Stilus Fantasticus"
    }
    var isLiked: Bool {
        get { movie.isLiked }
        set { movie.isLiked = newValue }
    }
    
    init() {
        getWatchlist()
    }
}

extension WatchlistViewModel {
    // Subscriber Implementation
    func getWatchlist() {
        cancellationToken = WatchlistAPI.request(.watchlist)
            .mapError { (error) -> Error in
                print(error)
                return error
            }
            .sink(receiveCompletion: { _ in
                print("Completed Request")
            }, receiveValue: { self.movie = $0.movie })
    }
}

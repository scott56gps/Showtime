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
    @Published var movies: [Movie]?
    private let movieService: MovieService
    
    // The properties of the ViewModel are accessible to the View, and
    //  thus should only be applicable to the View
    
    init(movieService: MovieService) {
        self.movieService = movieService
    }
    
    func loadWatchlist() {
        movieService.getMovies(from: .watchlist) { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                self.movies = response.movies
            case .failure(let error):
                // TODO: Handle Error
                print(error)
            }
        }
    }
}

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
    @Published var movies: [Movie] = []
    @Published var isLoading = false
    @Published var error: Error?
    private let movieService: WatchlistService
    private var subscriptionTokens = Set<AnyCancellable>()
    
    // The properties of the ViewModel are accessible to the View, and
    //  thus should only be applicable to the View
    
    init() {
        print("In View Model Initializer")
        self.movieService = WatchlistService()
    }
    
    func loadWatchlist() {
        isLoading = true
        movieService.getWatchlist()
            .sink(receiveCompletion: { result in
                switch result {
                case .failure(let error):
                    print("Error \(error)")
                    self.error = error
                case .finished:
                    print("Load Watchlist Publisher is finished")
                }
            }) { [weak self] result in
                guard let self = self else { return }
                
                self.isLoading = false
                self.movies = result
            }
            .store(in: &subscriptionTokens)
    }
    
    func saveMovieToWatchlist(movie: Movie) {
        isLoading = true
        movieService.postToWatchlist(movie: movie)
            .sink(receiveCompletion: { result in
                switch result {
                case .failure(let error):
                    print("Error \(error)")
                    self.error = error
                case .finished:
                    print("Save Movie Publisher is Finished")
                }
            }) { [weak self] createdMovie in
                guard let self = self else { return }
                self.isLoading = false
                self.movies.append(createdMovie)
            }
            .store(in: &subscriptionTokens)
    }
}

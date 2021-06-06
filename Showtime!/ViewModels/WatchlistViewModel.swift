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
    @Published var isLoading = false
    @Published var error: Error?
    private let movieService: MovieService
    private var subscriptionTokens = Set<AnyCancellable>()
    
    // The properties of the ViewModel are accessible to the View, and
    //  thus should only be applicable to the View
    
    init() {
        print("In View Model Initializer")
        self.movieService = MovieService()
//        loadWatchlist()
    }
    
    func loadWatchlist() {
//        cancellationToken = movieService.getMovies(from: .watchlist) { [weak self] (result) in
//            guard let self = self else { return }
//
//            switch result {
//            case .success(let response):
//                self.movies = response
//            case .failure(let error):
//                // TODO: Handle Error
//                print(error)
//            }
//        }
        self.movieService.getWatchlist()
            .sink(receiveCompletion: { result in
                switch result {
                case .failure(let error):
                    print("Error \(error)")
                    self.error = error
                case .finished:
                    print("Publisher is finished")
                }
            }) { [weak self] result in
                    guard let self = self else { return }
                    
                    self.isLoading = false
                    self.movies = result.movies
            }
            .store(in: &subscriptionTokens)
    }
}

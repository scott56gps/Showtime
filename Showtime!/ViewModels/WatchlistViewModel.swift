//
//  WatchlishViewModel.swift
//  Showtime!
//
//  Created by Scott Nicholes on 4/23/21.
//

import Foundation
import Combine
import SwiftUI
import Networker

class WatchlistViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    @Published var isLoading = false
    @Published var error: Error?
    private let apiClient = Networker(baseURL: "https://ancient-sierra-46110.herokuapp.com")
    private let watchlistService: WatchlistService
    private var subscriptionTokens = Set<AnyCancellable>()
    
    // The properties of the ViewModel are accessible to the View, and
    //  thus should only be applicable to the View
    
    init() {
        self.watchlistService = WatchlistService()
    }
    
    func loadWatchlist() {
        isLoading = true
        apiClient.dispatch(RetrieveWatchlistRequest())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] result in
                switch result {
                case .failure(let error):
                    print("Error \(error)")
                    self?.error = error
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] result in
                guard let self = self else { return }
                
                self.isLoading = false
                self.movies = result
            })
            .store(in: &subscriptionTokens)
    }
    
    func saveMovieToWatchlist(movie: Movie) {
        isLoading = true
        apiClient.dispatch(SubmitMovieToWatchlistRequest(body: movie.asDictionary))
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { result in
                switch result {
                case .failure(let error):
                    print("Error \(error)")
                    self.error = error
                case .finished:
                    break
                }
            }) { [weak self] createdMovie in
                guard let self = self else { return }
                self.isLoading = false
                self.movies.append(createdMovie)
            }
            .store(in: &subscriptionTokens)
    }
}

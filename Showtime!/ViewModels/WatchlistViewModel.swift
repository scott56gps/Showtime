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
import os

class WatchlistViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    @Published var isLoading = false
    @Published var error: Error?
    
    private let apiClient: Networker
    private var subscriptionTokens = Set<AnyCancellable>()
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "network")
    
    init() {
        guard let watchlistBaseUrl = Bundle.main.infoDictionary?["WATCHLIST_API_BASE_URL"] as? String else {
            logger.error("Could not initialize WatchlistViewModel because baseUrl was not found in app Info Property List")
            fatalError()
        }
        apiClient = Networker(baseURL: watchlistBaseUrl)
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
        apiClient.dispatch(SubmitMovieToWatchlistRequest(movie.asDictionary))
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
    
    func deleteMovie(movie: Movie) {
        isLoading = true
        guard let id = movie.id else {
            print("Could not delete movie because id was nil")
            return
        }
        
        apiClient.dispatch(DeleteMovieRequest(id: id))
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { result in
                switch result {
                case .failure(let error):
                    print("Error \(error)")
                    self.error = error
                case .finished:
                    break
                }
            }) { [weak self] deletedId in
                if let index = self?.movies.firstIndex(where: { movie in
                    movie.id == deletedId
                }) {
                    self?.movies.remove(at: index)
                }
                self?.isLoading = false
            }
            .store(in: &subscriptionTokens)
    }
}

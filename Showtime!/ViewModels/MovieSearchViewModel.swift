//
//  SearchViewModel.swift
//  junk_SearchBar
//
//  Created by Scott Nicholes on 5/12/21.
//

import Foundation
import SwiftUI
import Combine

class MovieSearchViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var movieResults: [MovieResult] = []
    @Published var isLoading = false
    @Published var error: Error?
    
    private var subscriptionToken: AnyCancellable?
    private var subscriptionTokens = Set<AnyCancellable>()
    let movieService: MovieService
    
    init(movieService: MovieService) {
        self.movieService = movieService
    }
    
    func beginObserving() {
        guard subscriptionToken == nil else { return }
        self.subscriptionToken = self.$searchText
            .map { [weak self] text in
                self?.movieResults.removeAll()
                self?.error = nil
                return text
            }
            .throttle(for: 1, scheduler: DispatchQueue.main, latest: true)
            .sink { [weak self] in self?.search(text: $0)}
    }
    
    func search(text: String) {
        self.movieResults.removeAll()
        self.error = nil
        
        guard !text.isEmpty else { return }
        self.isLoading = true
        self.movieService.searchMovies(query: text)
            .sink(receiveCompletion: { result in
                switch result {
                case .failure(let error):
                    print("Error \(error)")
                    self.error = error
                case .finished:
                    print("Publisher is finished")
                }
            }) { [weak self] result in
                guard let self = self, self.searchText == text else { return }
                
                self.isLoading = false
                self.movieResults = result.results
            }
            .store(in: &subscriptionTokens)
    }
    
    deinit {
        self.subscriptionToken?.cancel()
        self.subscriptionToken = nil
    }
    
}

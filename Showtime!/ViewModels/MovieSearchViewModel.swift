//
//  SearchViewModel.swift
//  junk_SearchBar
//
//  Created by Scott Nicholes on 5/12/21.
//

import Foundation
import SwiftUI
import Combine
import Networker

class MovieSearchViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var movieResults: [MovieResult] = []
    @Published var isLoading = false
    @Published var error: Error?
    @Published var foundMovie: Movie?
    
    private let apiClient: Networker
    private let apiKey: String? = ProcessInfo.processInfo.environment["search_movies_api_key"]
    private let baseUrl: String? = ProcessInfo.processInfo.environment["search_movies_base_url"]
    
    private var subscriptionToken: AnyCancellable?
    private var subscriptionTokens = Set<AnyCancellable>()
    
    init() {
        if let baseUrl = baseUrl {
            apiClient = Networker(baseURL: baseUrl)
        } else {
            print("Initializing MovieSearchViewModel with default baseUrl because environment var baseUrl was not found")
            apiClient = Networker(baseURL: "https://api.themoviedb.org/3")
        }
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
        guard let apiKey = apiKey else {
            print("Could not perform search because apiKey was not found")
            return
        }

        self.isLoading = true
        let queryParams = [
            "api_key" : apiKey,
            "language" : "en-us",
            "include_adult" : "false",
            "region" : "US",
            "query" : text
        ]
        
        apiClient.dispatch(SearchMovieRequest(queryParams: queryParams))
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { result in
                switch result {
                case .failure(let error):
                    print("Error \(error)")
                    self.error = error
                case .finished:
                    break
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

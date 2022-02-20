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
import os

class MovieSearchViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var movieResults: [MovieResult] = []
    @Published var isLoading = false
    @Published var error: Error?
    @Published var foundMovie: Movie?
    
    private let apiClient: Networker
    private let apiKey: String
    
    private var subscriptionToken: AnyCancellable?
    private var subscriptionTokens = Set<AnyCancellable>()
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "network")
    
    init() {
        guard let searchBaseUrl = Bundle.main.infoDictionary?["SEARCH_API_BASE_URL"] as? String else {
            logger.error("Could not initialize MovieSearchViewModel because baseUrl was not found in app Info Property List")
            fatalError()
        }
        guard let searchApiKey = Bundle.main.infoDictionary?["SEARCH_API_KEY"] as? String else {
            logger.error("Could not initialize MovieSearchViewModel because apiKey was not found in app Info Property List")
            fatalError()
        }
        apiClient = Networker(baseURL: searchBaseUrl)
        apiKey = searchApiKey
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

//
//  ContentView.swift
//  Showtime!
//
//  Created by Scott Nicholes on 4/23/21.
//

import SwiftUI

struct WatchlistView: View {
    // TODO: Convert MovieService invocation to a singleton that I pass through the initializer
    @ObservedObject var watchlistViewModel: WatchlistViewModel = WatchlistViewModel()
    @ObservedObject var searchViewModel = MovieSearchViewModel(movieService: MovieService())
    
    @State var searchBarIsSelected: Bool = false
    @State var foundMovie: Movie?
    
    var body: some View {
        VStack {
            if searchBarIsSelected {
                MovieSearchResultsPresenter(viewModel: searchViewModel, isPresented: $searchBarIsSelected)
            } else if !watchlistViewModel.movies.isEmpty {
                MovieCarouselView(movies: watchlistViewModel.movies)
            } else {
                Spacer()
                Text("Loading...")
                Spacer()
            }
            SearchBar(placeholder: "Add Movie", text: $searchViewModel.searchText, isSelected: $searchBarIsSelected)
        }
        .onAppear(perform: {
            searchViewModel.beginObserving()
            watchlistViewModel.loadWatchlist()
        })
    }
}

struct WatchlistView_Previews: PreviewProvider {
    static var previews: some View {
        WatchlistView()
    }
}

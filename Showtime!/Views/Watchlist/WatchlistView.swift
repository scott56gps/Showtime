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
    @ObservedObject var searchViewModel = MovieSearchViewModel(movieService: SearchService())
    
    @State var searchBarIsSelected: Bool = false
    @State var foundMovie: Movie?
    
    var body: some View {
        VStack {
            if searchBarIsSelected {
                MovieSearchResultsPresenter(viewModel: searchViewModel, isPresented: $searchBarIsSelected)
            } else if !watchlistViewModel.movies.isEmpty {
                MovieCarouselView(movies: watchlistViewModel.movies)
                    .onReceive(watchlistViewModel.$movies) { movie in
                        // ASYNC for Steps 1,2
                        // Step 1: Load the image asset for this movie from TMDB
                        
                        // Step 2: Save this movie in the watchlist database
                    }
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
        .onReceive(searchViewModel.$foundMovie) { foundMovie in
            if let movie = foundMovie {
                // Step 1: Put the movie onto the watchlist
                watchlistViewModel.movies.append(movie)
                
                // Step 2: Scroll the watchlist to the newly added movie - might be appropriate to pass the whole watchlistViewModel
                //  to MovieCarouselView and scroll itself in there
                
                print(movie)
            }
        }
    }
}

struct WatchlistView_Previews: PreviewProvider {
    static var previews: some View {
        WatchlistView()
    }
}

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
    
    @State var currentIndex = 0
    @State var searchBarIsSelected: Bool = false
    @State var foundMovie: Movie?
    
    var body: some View {
        VStack {
            if searchBarIsSelected {
                MovieSearchResultsPresenter(viewModel: searchViewModel, isPresented: $searchBarIsSelected)
            } else if !watchlistViewModel.movies.isEmpty {
                if watchlistViewModel.movies.count == 1 {
                        MovieCard(movie: watchlistViewModel.movies[0])
                            .padding()
                } else {
                    SnapCarousel(spacing: 36, index: $currentIndex, items: watchlistViewModel.movies) { movie in
                        GeometryReader { geo in
                            MovieCard(movie: movie, inCollection: true)
                                .frame(width: geo.size.width)
                                .padding(.horizontal)
                        }
                    }
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
                // ASYNC for Steps 3,4
                
                // Step 3: Save this movie in the watchlist database
            }
        }
    }
}

struct WatchlistView_Previews: PreviewProvider {
    static var previews: some View {
        WatchlistView()
    }
}

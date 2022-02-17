//
//  ContentView.swift
//  Showtime!
//
//  Created by Scott Nicholes on 4/23/21.
//

import SwiftUI

struct WatchlistView: View {
    @StateObject var watchlistViewModel = WatchlistViewModel()
    @StateObject var searchViewModel = MovieSearchViewModel()
    
    @State var currentIndex = 0
    @State var searchBarIsSelected: Bool = false
    @State var foundMovie: Movie?
    
    var body: some View {
        VStack {
            if searchBarIsSelected {
                MovieSearchResultsPresenter(viewModel: searchViewModel, isPresented: $searchBarIsSelected)
            } else if !watchlistViewModel.movies.isEmpty {
                if watchlistViewModel.movies.count == 1 {
                    MovieCard(movie: watchlistViewModel.movies[0], watchlistViewModel: watchlistViewModel)
                            .padding()
                } else {
                    SnapCarousel(spacing: 36, index: $currentIndex, items: watchlistViewModel.movies.reversed()) { movie in
                        GeometryReader { geo in
                            MovieCard(movie: movie, inCollection: true, watchlistViewModel: watchlistViewModel)
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
                DispatchQueue.main.async {
                    watchlistViewModel.saveMovieToWatchlist(movie: movie)
                }
            }
        }
    }
}

struct WatchlistView_Previews: PreviewProvider {
    static var previews: some View {
        WatchlistView()
    }
}

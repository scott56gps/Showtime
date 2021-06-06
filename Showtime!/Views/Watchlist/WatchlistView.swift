//
//  ContentView.swift
//  Showtime!
//
//  Created by Scott Nicholes on 4/23/21.
//

import SwiftUI

struct WatchlistView: View {
    @ObservedObject var viewModel: WatchlistViewModel = WatchlistViewModel()
    var body: some View {
        Group {
            if !viewModel.movies.isEmpty {
                MovieCarouselView(movies: viewModel.movies)
            } else {
                Text("Loading...")
            }
        }
        .onAppear(perform: {
            viewModel.loadWatchlist()
        })
    }
}

struct WatchlistView_Previews: PreviewProvider {
    static var previews: some View {
        WatchlistView()
    }
}

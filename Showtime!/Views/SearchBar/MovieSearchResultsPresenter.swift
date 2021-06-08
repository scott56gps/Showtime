//
//  ContentView.swift
//  junk_SearchBar
//
//  Created by Scott Nicholes on 5/12/21.
//

import SwiftUI

struct MovieSearchResultsPresenter: View {
    @ObservedObject var viewModel: MovieSearchViewModel
    
    var body: some View {
        if !viewModel.movieResults.isEmpty {
            ScrollViewReader { reader in
                ReversedScrollView(.vertical) {
                    LazyVStack(alignment: .leading, spacing: 12.0) {
                        ForEach(viewModel.movieResults.reversed()) { movie in
                            VStack(alignment: .leading, spacing: 6) {
                                Text(movie.title)
                                    .id(movie.id)
                                Divider()
                            }
                            .padding(.horizontal)
                        }
                    }
                    .onReceive(viewModel.$movieResults) { value in
                        if let targetMovie = value.first {
                            reader.scrollTo(targetMovie.id)
                        }
                    }
                }
            }
        } else {
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollViewReader { scrollProxy in
            MovieSearchResultsPresenter(viewModel: MovieSearchViewModel(movieService: MovieService()))
        }
    }
}

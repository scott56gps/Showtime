//
//  ContentView.swift
//  junk_SearchBar
//
//  Created by Scott Nicholes on 5/12/21.
//

import SwiftUI

struct MovieSearchView: View {
    @ObservedObject var viewModel = MovieSearchViewModel(movieService: MovieService())
    
    var body: some View {
        VStack() {
            if !viewModel.movies.isEmpty {
                ScrollViewReader { reader in
                    ReversedScrollView(.vertical) {
                        LazyVStack(alignment: .leading, spacing: 12.0) {
                            ForEach(viewModel.movies.reversed()) { movie in
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(movie.title)
                                        .id(movie.id)
                                    Divider()
                                }
                                .padding(.horizontal)
                            }
                        }
                        .onReceive(viewModel.$movies) { value in
                            if let targetMovie = value.first {
                                reader.scrollTo(targetMovie.id)
                            }
                        }
                    }
                }
            } else {
                Spacer()
            }
            SearchBar(placeholder: "Add Movie", text: $viewModel.searchText)
        }
        .onAppear() {
            viewModel.beginObserving()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MovieSearchView()
    }
}

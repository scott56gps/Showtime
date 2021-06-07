//
//  ContentView.swift
//  junk_SearchBar
//
//  Created by Scott Nicholes on 5/12/21.
//

import SwiftUI

struct MovieSearchResultsPresenter: View {
    var results: [MovieResult]
    
    var body: some View {
        if !results.isEmpty {
            ReversedScrollView(.vertical) {
                LazyVStack(alignment: .leading, spacing: 12.0) {
                    ForEach(results.reversed()) { movie in
                        VStack(alignment: .leading, spacing: 6) {
                            Text(movie.title)
                                .id(movie.id)
                            Divider()
                        }
                        .padding(.horizontal)
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
            MovieSearchResultsPresenter(results: [MovieResult(id: 1, title: "Tommy Boy", posterPath: nil)])
        }
    }
}

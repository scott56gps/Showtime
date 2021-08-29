//
//  ContentView.swift
//  junk_SearchBar
//
//  Created by Scott Nicholes on 5/12/21.
//

import SwiftUI

struct MovieSearchResultsPresenter: View {
    @ObservedObject var viewModel: MovieSearchViewModel
    @Binding var isPresented: Bool
    
    var body: some View {
        if !viewModel.movieResults.isEmpty {
            ScrollViewReader { reader in
                ReversedScrollView(.vertical) {
                    LazyVStack(alignment: .leading, spacing: 12.0) {
                        ForEach(viewModel.movieResults.reversed()) { movieResult in
                            HStack() {
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(movieResult.title)
                                        .id(movieResult.id)
                                    Divider()
                                }
                                .padding(.horizontal)
                                .contentShape(Rectangle())
                            }
                            .onTapGesture {
                                viewModel.foundMovie = Movie(from: movieResult)
                                isPresented = false
                                viewModel.searchText = ""
                                
                                // Hide the keyboard, if it is presented
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            }
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
    @State static var isPresented = true
    static var previews: some View {
        ScrollViewReader { scrollProxy in
            MovieSearchResultsPresenter(viewModel: MovieSearchViewModel(), isPresented: $isPresented)
        }
    }
}

//
//  ContentView.swift
//  Showtime!
//
//  Created by Scott Nicholes on 4/23/21.
//

import SwiftUI

struct WatchlistView: View {
    @ObservedObject var viewModel: WatchlistViewModel
    var body: some View {
        Text("Hola")
    }
}

struct WatchlistView_Previews: PreviewProvider {
    static var previews: some View {
        WatchlistView(viewModel: WatchlistViewModel(movieService: MovieService()))
    }
}

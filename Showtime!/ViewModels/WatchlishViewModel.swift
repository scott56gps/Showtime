//
//  WatchlishViewModel.swift
//  Showtime!
//
//  Created by Scott Nicholes on 4/23/21.
//

import Foundation
import SwiftUI

class WatchlistViewModel: ObservableObject {
    private let movie = Movie(title: "Rush Hour 2", isLiked: false)
    
    // The properties of the ViewModel are accessible to the View, and
    //  thus should only be applicable to the View
    var title: String {
        movie.title
    }
    var poster: String {
        // magic to get poster image from the model's posterUrl
        "Stilus Fantasticus"
    }
    var isLiked: Bool {
        movie.isLiked
    }
}

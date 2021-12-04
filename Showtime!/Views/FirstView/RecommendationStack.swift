//
//  RecommendationView.swift
//  Showtime
//
//  Created by Scott Nicholes on 12/3/21.
//

import SwiftUI

struct RecommendationStack: View {
    @State var currentIndex = 0
    
    var body: some View {
        VStack {
            Text("From Your Watchlist")
            SnapCarousel(spacing: -60, index: $currentIndex, items: [Movie(id: 555, title: "Tommy Boy", posterUrl: "hola"), Movie(id: 556, title: "Young Frankenstein", posterUrl: "hola.2")]) { item in
                MovieRecommendation()
            }
        }
    }
}

struct RecommendationView_Previews: PreviewProvider {
    static var previews: some View {
        RecommendationStack()
    }
}

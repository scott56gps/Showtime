//
//  RecommendationView.swift
//  Showtime
//
//  Created by Scott Nicholes on 12/3/21.
//

import SwiftUI

struct RecommendationView: View {
    @State var currentIndex = 0
    
    var body: some View {
        VStack {
            Text("From Your Watchlist")
        }
    }
}

struct RecommendationView_Previews: PreviewProvider {
    static var previews: some View {
        RecommendationView()
    }
}

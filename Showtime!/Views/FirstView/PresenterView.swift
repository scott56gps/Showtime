//
//  PresenterView.swift
//  Showtime
//
//  Created by Scott Nicholes on 12/3/21.
//

import SwiftUI

struct PresenterView: View {
    var body: some View {
        VStack {
            RecommendationStack()
                .frame(width: .infinity, height: 200, alignment: .top)
            Spacer()
        }
    }
}

struct PresenterView_Previews: PreviewProvider {
    static var previews: some View {
        PresenterView()
    }
}

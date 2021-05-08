//
//  AsyncImage.swift
//  Showtime!
//
//  Created by Scott Nicholes on 5/8/21.
//

import SwiftUI

struct AsyncImage<Placeholder: View>: View {
    @StateObject private var loader: ImageLoader
    private let placeholder: Placeholder
    private var content: some View {
        Group {
            if loader.image != nil {
                Image(uiImage: loader.image!)
            } else {
                placeholder
            }
        }
    }
    
    init(url: URL, @ViewBuilder placeholder: () -> Placeholder) {
        self.placeholder = placeholder()
        _loader = StateObject(wrappedValue: ImageLoader(url: url))
    }
    
    var body: some View {
        content.onAppear(perform: loader.load)
    }
}

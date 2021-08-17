//
//  SnapCarousel.swift
//  junk_HorizontalScroll
//
//  Created by Scott Nicholes on 8/3/21.
//

import SwiftUI

// Made generic in order to accept a List
struct SnapCarousel<Content: View, T: Identifiable>: View {
    var content: (T) -> Content
    var items: [T]
    
    @Binding var index: Int
    @GestureState var offset: CGFloat = 0
    @State var currentIndex: Int = 0
    
    var spacing: CGFloat
    var trailingSpace: CGFloat
    
    init(spacing: CGFloat = 15, trailingSpace: CGFloat = 100, index: Binding<Int>, items: [T], @ViewBuilder content: @escaping (T) -> Content) {
        self.spacing = spacing
        self.trailingSpace = trailingSpace
        self._index = index
        self.items = items
        self.content = content
    }
    
    var body: some View {
        GeometryReader { proxy in
            let width = (proxy.size.width - (trailingSpace - spacing))
            // The amount by which we are increasing for elements greater than the 0th.
            let adjustmentWidth = (trailingSpace / 2) - spacing
            
            HStack(spacing: spacing) {
                ForEach(items) { item in
                    content(item)
                        .frame(width: proxy.size.width - trailingSpace)
                }
            }
            .padding(.horizontal, spacing)
            .offset(x: (CGFloat(currentIndex) * -width) + (currentIndex != 0 ? adjustmentWidth : 0) + offset)
            .gesture(
                DragGesture()
                    .updating($offset, body: { value, out, _ in
                        // Out is the final value of the gesture.  We set out to be the width of how far we've traveled.
                        out = value.translation.width
                    })
                    .onEnded({ value in
                        let offsetX = value.translation.width
                        
                        // Convert the translation into a progress figure (0 to 1)
                        let progress = -offsetX / width
                        let roundedIndex = progress.rounded()
                        
                        // Here, we advance the index if roundedIndex is 1.  If rounded index is 0, the user did not swipe far enough, and so we keep the current index where it is at.
                        // max is used to set a threshold.  We only do this process up to the number of items we have.
                        currentIndex = max(min(currentIndex + Int(roundedIndex), items.count - 1), 0)
                        
                        currentIndex = index
                    })
                    .onChanged({ value in
                        let offsetX = value.translation.width
                        
                        // Convert the translation into a progress figure (0 to 1)
                        let progress = -offsetX / width
                        let roundedIndex = progress.rounded()
                        
                        // Here, we advance the index if roundedIndex is 1.  If rounded index is 0, the user did not swipe far enough, and so we keep the current index where it is at.
                        // max is used to set a threshold.  We only do this process up to the number of items we have.
                        index = max(min(currentIndex + Int(roundedIndex), items.count - 1), 0)
                    })
            )
        }
        // Animating when offset == 0
        .animation(.easeInOut, value: offset == 0)
    }
}

struct SnapCarousel_Previews: PreviewProvider {
    static var previews: some View {
        WatchlistView()
    }
}

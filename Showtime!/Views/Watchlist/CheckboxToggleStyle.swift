//
//  CheckboxToggleStyle.swift
//  Showtime!
//
//  Created by Scott Nicholes on 4/23/21.
//

import Foundation
import SwiftUI

struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Image(systemName: configuration.isOn ? "checkmark.square" : "square")
            .onTapGesture {
                configuration.isOn.toggle()
            }
    }
}

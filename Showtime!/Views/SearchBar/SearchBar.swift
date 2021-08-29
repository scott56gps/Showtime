//
//  SearchBar.swift
//  junk_SearchBar
//
//  Created by Scott Nicholes on 5/12/21.
//

import SwiftUI

struct SearchBar: UIViewRepresentable {
    let placeholder: String
    @Binding var text: String
    @Binding var isSelected: Bool
    
    func makeUIView(context: Context) -> UISearchBar {
        let searchBar = UISearchBar()
        searchBar.placeholder = placeholder
        searchBar.searchBarStyle = .minimal
        searchBar.enablesReturnKeyAutomatically = true
        searchBar.delegate = context.coordinator
        return searchBar
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text, isSelected: $isSelected)
    }
    
    func updateUIView(_ uiView: UISearchBar, context: Context) {
        uiView.text = text
    }
    
    class Coordinator: NSObject, UISearchBarDelegate {
        @Binding var text: String
        @Binding var isSelected: Bool
        
        init(text: Binding<String>, isSelected: Binding<Bool>) {
            _text = text
            _isSelected = isSelected
        }
        
        func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
            isSelected = true
            return true
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
        }
        
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            searchBar.resignFirstResponder()
        }
    }
}

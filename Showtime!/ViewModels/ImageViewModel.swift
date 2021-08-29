//
//  ImageLoader.swift
//  Showtime!
//
//  Created by Scott Nicholes on 5/8/21.
//

import SwiftUI
import Combine

class ImageViewModel: ObservableObject {
    @Published var image: UIImage?
    @Published var error: Error?
    private let imageService: ImageService
    private var subscriptionTokens = Set<AnyCancellable>()
    
    /**
     Initializer that supplies an optional initial image for debugging purposes.
     */
    init(image: UIImage? = nil) {
        self.image = image
        self.imageService = ImageService()
    }
    
    func loadImage(_ urlString: String) {
        if let url = URL(string: urlString) {
            imageService.fetchImage(from: url)
                .sink(receiveCompletion: { result in
                    switch result {
                    case .failure(let error):
                        print("Error \(error)")
                        self.error = error
                    case .finished:
                        break
                    }
                }) { [weak self] (result) in
                    guard let self = self else { return }
                    
                    self.image = result
                }
                .store(in: &subscriptionTokens)
        }
    }
}

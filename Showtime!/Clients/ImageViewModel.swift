//
//  ImageLoader.swift
//  Showtime!
//
//  Created by Scott Nicholes on 5/8/21.
//

import SwiftUI
import Combine
import Foundation

class ImageViewModel: ObservableObject {
    @Published var image: UIImage?
    private let imageService: ImageService
    private var cancellable: AnyCancellable?
    
    init() {
        self.imageService = ImageService()
    }
    
    deinit {
        cancel()
    }
    
    func load(with url: URL) {
        cancellable = imageService.fetchImage(from: url) { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case .success(let image):
                self.image = image
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    func cancel() {
        cancellable?.cancel()
    }
}

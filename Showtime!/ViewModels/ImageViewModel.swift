//
//  ImageLoader.swift
//  Showtime!
//
//  Created by Scott Nicholes on 5/8/21.
//

import SwiftUI
import Combine
import Networker

class ImageViewModel: ObservableObject {
    @Published var image: UIImage?
    @Published var error: Error?
    private let apiClient = Networker(baseURL: "")
    private var subscriptionTokens = Set<AnyCancellable>()
    
    /**
     Initializer that supplies an optional initial image for debugging purposes.
     */
    init(image: UIImage? = nil) {
        self.image = image
    }
    
    func loadImage(_ urlString: String) {
        apiClient.dispatchForFile(RetrieveImageRequest(path: urlString))
            .map { UIImage(contentsOfFile: $0.path) }
            .replaceError(with: UIImage(named: "Tommy Boy"))
            .receive(on: DispatchQueue.main)
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

//
//  ImageService.swift
//  Showtime!
//
//  Created by Scott Nicholes on 5/9/21.
//

import SwiftUI
import Combine

struct ImageService: ResourceFetchable {
    func fetchImage(from url: URL) -> AnyPublisher<UIImage, Error> {
        return fetchResource(url: url)
            .tryMap { data in
                guard let image = UIImage(data: data) else {
                    throw MovieRetrievalError.invalidResponse
                }
                return image
            }
            .eraseToAnyPublisher()
    }
}

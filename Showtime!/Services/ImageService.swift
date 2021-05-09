//
//  ImageService.swift
//  Showtime!
//
//  Created by Scott Nicholes on 5/9/21.
//

import Foundation
import SwiftUI
import Combine

struct ImageService {
    func fetchImage(from url: URL, parameters: [String : String]? = nil, completion: @escaping (Result<UIImage, MovieRetrievalError>) -> ()) -> AnyCancellable? {
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            completion(.failure(.invalidEndpoint))
            return nil
        }
        
        var queryItems: [URLQueryItem] = []
        if let parameters = parameters {
            queryItems.append(contentsOf: parameters.map { URLQueryItem(name: $0.key, value: $0.value) })
        }
        
        urlComponents.queryItems = queryItems
        guard let requestUrl = urlComponents.url else {
            completion(.failure(.invalidEndpoint))
            return nil
        }
        
        return URLSession.shared.dataTaskPublisher(for: requestUrl)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { result in
                switch result {
                case .failure(let error):
                    print("Error \(error)")
                case .finished:
                    print("Publisher is finished")
                }
            }) { result in
                completion(.success(result!))
            }
    }
}

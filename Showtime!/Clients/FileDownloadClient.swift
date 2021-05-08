//
//  FileDownloadClient.swift
//  Showtime!
//
//  Created by Scott Nicholes on 4/23/21.
//

import Foundation
import Combine
import SwiftUI

struct FileDownloadClient {
    struct Response<T> {
        let value: T
        let response: URLResponse
    }
    
    func request<T: UIImage>(_ request: URLRequest) -> AnyPublisher<Response<T>, Error> {
        return URLSession.shared
            .downloadTaskPublisher(for: request)
            .tryMap { result -> Response<T> in
                return Response(value: UIImage(contentsOfFile: result.url.path)! as! T, response: result.response)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

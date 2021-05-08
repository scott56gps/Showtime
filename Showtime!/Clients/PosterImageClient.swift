//
//  PosterImageClient.swift
//  Showtime!
//
//  Created by Scott Nicholes on 4/23/21.
//

import Foundation
import Combine
import SwiftUI

enum PosterImageClient {
    static let downloadClient = FileDownloadClient()
}

extension PosterImageClient {
    static func request(_ path: String) -> AnyPublisher<UIImage, Error> {
        // Check that the string is a vaild URL
        
        let request = URLRequest(url: URL(string: path)!)
        
        return downloadClient.request(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
}

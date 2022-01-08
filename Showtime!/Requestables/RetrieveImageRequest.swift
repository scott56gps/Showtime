//
//  RetrieveImageRequest.swift
//  Showtime
//
//  Created by Scott Nicholes on 1/7/22.
//

import Networker
import UIKit

struct RetrieveImageRequest: Requestable {
    typealias ResultType = URL
    var path: String
    var method: HTTPMethod = .get
    var contentType = ""
    var body: [String : Any]? = nil
    var headers: [String : String]? = nil
    
    init(path: String) {
        self.path = path
    }
}

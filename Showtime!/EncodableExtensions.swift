//
//  EncodableExtensions.swift
//  Showtime
//
//  Created by Scott Nicholes on 1/7/22.
//

import Foundation

extension Encodable {
    var asDictionary: [String : Any] {
        guard let data = try? JSONEncoder().encode(self) else { return [:] }
        guard let dictionary = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [String : Any] else {
            return [:]
        }
        return dictionary
    }
}

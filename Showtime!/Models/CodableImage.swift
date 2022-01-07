//
//  CodableImage.swift
//  Showtime
//
//  Created by Scott Nicholes on 1/7/22.
//

import SwiftUI

struct CodableImage: Codable {
    let imageData: Data?
    
    init(fromImage image: UIImage) throws {
        self.imageData = image.pngData()
    }
    
    func getImage() -> UIImage? {
        guard let imageData = imageData else {
            return nil
        }
        return UIImage(data: imageData)
    }
}

//
//  ServiceModel.swift
//  HSpace
//
//  Created by DEEBA on 19.07.20.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//

import Foundation
import UIKit
struct ServiceModel : Codable{
    var name : String?
    var image : Image?
}
struct Image: Codable{
    let imageData: Data?
    init(withImage image: UIImage) {
        self.imageData = image.pngData()
    }

    func getImage() -> UIImage? {
        guard let imageData = self.imageData else {
            return nil
        }
        let image = UIImage(data: imageData)
        
        return image
    }
}


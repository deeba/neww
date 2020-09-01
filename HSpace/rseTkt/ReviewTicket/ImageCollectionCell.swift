//
//  ImageCollectionCell.swift
//  AMTfm
//
//  Created by Serge Vysotsky on 05.06.2020.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//

import UIKit

final class ImageCollectionCell: UICollectionViewCell, ReusableView {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var deleteImageButton: UIButton!
    var deleteCompletion: (() -> Void)?
    
    @IBAction func deleteSelf() {
        deleteCompletion?()
    }
}

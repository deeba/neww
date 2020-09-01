//
//  BottomCollectionViewCell.swift
//  HSpace
//
//  Created by DEEBA on 19.07.20.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//
import UIKit

class BottomCollectionViewCell: UICollectionViewCell {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet weak var cardView: CardView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imageView.roundCornerWithMaskedCorners(corners: [.layerMaxXMaxYCorner,.layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMinXMaxYCorner,.layerMinXMinYCorner], radius: 10)
    }
    override var isSelected: Bool{
        didSet{
            self.cardView.backgroundColor = isSelected ? Colors.themeBlueLIGHT : .white
            self.imageView.tintColor = isSelected ? .white : .gray
            nameLabel.textColor = isSelected ? .white : .black
        }
    }
    func setupCollectionView(serviceData : ServiceModel){
        nameLabel.text = serviceData.name ?? ""
        nameLabel.textColor = .black
        imageView.image = serviceData.image?.getImage()
        self.imageView.tintColor = .gray
        self.cardView.backgroundColor = .white
        imageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
    }
}


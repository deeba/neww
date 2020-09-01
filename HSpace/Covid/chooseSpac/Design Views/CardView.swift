//
//  CardView.swift
//  HSpace
//
//  Created by DEEBA on 19.07.20.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class CardView: UIView {
    
    @IBInspectable var cornerRedius : CGFloat = 2
    @IBInspectable var shadowOffSetWidth : CGFloat = 0
    @IBInspectable var shadowOffSetHeight : CGFloat = 2
    @IBInspectable var shadowColor : UIColor = UIColor.black
    @IBInspectable var shadowOpacity : CGFloat = 0.5
    
    override func layoutSubviews() {
        layer.cornerRadius = cornerRedius
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOffset = CGSize(width: shadowOffSetWidth, height: shadowOffSetHeight)
        
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRedius)
        layer.shadowPath = shadowPath.cgPath
        
        layer.shadowOpacity = Float(shadowOpacity)
    }
    
}

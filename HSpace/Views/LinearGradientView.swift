//
//  LinearGradientView.swift
//  AMTfm
//
//  Created by Serge Vysotsky on 04.06.2020.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//

import UIKit

@IBDesignable
final class LinearGradientView: DesignableView {
    @IBInspectable var firstColor: UIColor?
    @IBInspectable var secondColor: UIColor?
    @IBInspectable var gradientStart: CGPoint = .zero
    @IBInspectable var gradientEnd: CGPoint = .zero
    
    private let gradientLayer = CAGradientLayer()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.removeFromSuperlayer()
        
        if let first = firstColor, let second = secondColor {
            gradientLayer.colors = [first.cgColor, second.cgColor]
        }
        
        gradientLayer.startPoint = gradientStart
        gradientLayer.endPoint = gradientEnd
        
        gradientLayer.frame = bounds
        layer.insertSublayer(gradientLayer, at: 0)
    }
}

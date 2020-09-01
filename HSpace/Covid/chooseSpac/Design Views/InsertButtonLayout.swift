//
//  InsertButtonLayout.swift
//  HSpace
//
//  Created by DEEBA on 19.07.20.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//
import Foundation
import UIKit

class InsertButtonLayout: UIButton {
    
    @IBInspectable override var borderWidth: CGFloat {
            set {
                layer.borderWidth = newValue
            }
            get {
                return layer.borderWidth
            }
        }
        
    @IBInspectable override var cornerRadius: CGFloat {
            set {
                
                layer.cornerRadius = newValue
            }
            get {
                return layer.cornerRadius
            }
        }
        
    @IBInspectable  override var borderColor: UIColor? {
            set {
                guard let uiColor = newValue else { return }
                layer.borderColor = uiColor.cgColor
            }
            get {
                guard let color = layer.borderColor else { return nil }
                return UIColor(cgColor: color)
            }
        }
    
    
    
}


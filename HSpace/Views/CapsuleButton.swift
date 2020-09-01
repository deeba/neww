//
//  CapsuleButton.swift
//  AMTfm
//
//  Created by Serge Vysotsky on 03.06.2020.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//

import UIKit

@IBDesignable
final class CapsuleButton: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        makeRound()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        makeRound()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        makeRound()
    }
    
    private func makeRound() {
        layer.cornerRadius = min(frame.width, frame.height) / 2
        clipsToBounds = true
    }
}

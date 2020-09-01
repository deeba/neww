//
//  ShadowDecoratedView.swift
//  AMTfm
//
//  Created by Serge Vysotsky on 03.06.2020.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//

import UIKit

@IBDesignable
final class ShadowDecoratedView: UIView {
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setup()
    }
    
    private func setup() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 3
        layer.cornerRadius = 8
    }
}

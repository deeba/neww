//
//  SelectLocationCells.swift
//  AMTfm
//
//  Created by Serge Vysotsky on 04.06.2020.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//

import UIKit

final class LocationCell: UITableViewCell, ReusableView {
    @IBOutlet weak var locationImageView: UIImageView!
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var overlayView: UIView!
}

final class SublocationCell: UITableViewCell, ReusableView {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var selectedIndicatorOuter: DesignableView!
    @IBOutlet weak var selectedIndicatorInner: DesignableView!
}

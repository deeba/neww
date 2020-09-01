//
//  asstSelLcnCells.swift
//  HelixSense
//
//  Created by DEEBA on 23.06.20.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//
import UIKit
import Foundation
final class asstSelLcn: UITableViewCell, ReusableView {
    
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var locationImageView: UIImageView!
}
final class asstSelSubLcn: UITableViewCell, ReusableView {
    
    @IBOutlet weak var selectedIndicatorOuter: DesignableView!
    @IBOutlet weak var selectedIndicatorInner: DesignableView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var edtLcn: UIImageView!
}

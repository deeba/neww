//
//  MyShiftsCell.swift
//  HelixSense
//
//  Created by DEEBA on 14.07.20.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//

import UIKit

class MyShiftsCell: UITableViewCell {
    
    @IBOutlet weak var leftMonthLbl: UILabel!
    @IBOutlet weak var leftDayLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!

        override func awakeFromNib() {
            super.awakeFromNib()
            // Initialization code
        }

        override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)

            // Configure the view for the selected state
        }

    }

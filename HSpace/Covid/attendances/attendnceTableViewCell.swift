//
//  attendnceTableViewCell.swift
//  HSpace
//
//  Created by DEEBA on 17.07.20.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//

import UIKit

class attendnceTableViewCell: UITableViewCell {
    @IBOutlet weak var lbl_date: UILabel!
    @IBOutlet weak var lbl_month: UILabel!
    
    @IBOutlet weak var lbl_planned: UILabel!
    @IBOutlet weak var lbl_dayAndTime: UILabel!
    @IBOutlet weak var lbl_RegularA: UILabel!
    
    
    @IBOutlet weak var lbl_actual: UILabel!
    @IBOutlet weak var lbl_actualDayTime: UILabel!
    @IBOutlet weak var lbl_actualRegualrA: UILabel!
    
    @IBOutlet weak var viewCellRound: UIView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

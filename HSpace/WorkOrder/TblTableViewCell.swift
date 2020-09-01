//
//  TblTableViewCell.swift
//  AMTfm
//
//  Created by DEEBA on 29.04.20.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//

import UIKit

class TblTableViewCell: UITableViewCell {

    @IBOutlet weak var LcnIm: UIImageView!
    @IBOutlet weak var Caus: UILabel!
    @IBOutlet weak var eqpNam: UILabel!
    @IBOutlet weak var ImgStts: UIImageView!
    @IBOutlet weak var lblstatus: UILabel!
    @IBOutlet weak var ImgTim: UIImageView!
    @IBOutlet weak var lblTim: UILabel!
    @IBOutlet weak var eqpLcn: UILabel!
    @IBOutlet weak var TmNam: UILabel!
    @IBOutlet weak var DisNam: UILabel!
    @IBOutlet weak var img: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

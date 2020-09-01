//
//  ItemTableViewCell.swift
//  HSpace
//
//  Created by DEEBA on 19.07.20.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//
import UIKit
//protocol ItemTableViewCellDelegate {
//    func selectLocationAction(cell: ItemTableViewCell, item: SubLocation)
//}
class ItemTableViewCell: UITableViewCell {
    @IBOutlet weak var catagoryTitle: UILabel!
    @IBOutlet weak var selectLocationButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
  
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

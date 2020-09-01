//
//  CollectionViewCell.swift
//  AMTfm
//
//  Created by DEEBA on 02.04.20.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//

import UIKit
protocol DataCollectionProtocol {
       
    func passDataNw(indx: Int)
    func passDataPndg(indx: Int)
    func passDataStr(indx: Int)
    func passDataDon(indx: Int)
       
   }
class CollectionViewCell: UICollectionViewCell {
    
    var delegate: DataCollectionProtocol?
    var index: IndexPath?
    @IBAction func Btoon(_ sender: Any) {
        delegate?.passDataNw(indx: (index!.row))
    }
    @IBAction func btnPnd(_ sender: Any) {
        delegate?.passDataPndg(indx: (index!.row))
    }
    @IBAction func btnStrt(_ sender: Any) {
        delegate?.passDataStr(indx: (index!.row))
    }
    @IBAction func btnDn(_ sender: Any) {
        delegate?.passDataDon(indx: (index!.row))
    }
    
    @IBOutlet weak var strt: UILabel!
    @IBOutlet weak var tmNam: UILabel!
    @IBOutlet weak var lblDn: UILabel!
    @IBOutlet weak var lblnw: UILabel!
    @IBOutlet weak var lblPndg: UILabel!
}

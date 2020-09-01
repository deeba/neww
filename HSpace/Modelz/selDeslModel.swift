//
//  selDeslModel.swift
//  AMTfm
//
//  Created by DEEBA on 21.05.20.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//

import Foundation
struct selDeselMdl
{
    var rowId:[Int] //chklstId
    var btnSuggsnId:[Int]
    var selcnNam:[String]
    var selcnSorNo:[Bool]
    init() {
          rowId  = []
          btnSuggsnId  = []
          selcnNam  = []
          selcnSorNo  = []
    }
}
var selDeslMdl = selDeselMdl()

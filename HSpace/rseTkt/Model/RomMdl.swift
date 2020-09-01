//
//  RomMdl.swift
//  AMTfm
//
//  Created by DEEBA on 05.06.20.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//

import Foundation
struct RomMdl
{
    var spacId:[String] //chklstId
    var spacNam:[String]
    var spacDisNam:[String]
    var spachasChild:[Bool]
    init() {
          spacId  = []
          spacNam  = []
          spacDisNam  = []
         spachasChild = []
    }
}
var romMdl = RomMdl()

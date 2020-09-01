//
//  usrRlrModl.swift
//  HelixSense
//
//  Created by DEEBA on 10.07.20.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//

import Foundation

struct usrRlrMdl
{
    var usrId:Int
    var usrRol:String
    var vndrId:Int //chklstId
    var vndrNam:String
    init() {
            usrId = 0
              usrRol = ""
              vndrId = 0 //chklstId
              vndrNam =  ""
    }
}
var usrRlrModl = usrRlrMdl()

//
//  chusStrtModel.swift
//  AMTfm
//
//  Created by DEEBA on 08.05.20.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//

import Foundation
struct chusStrtMdl
{
    var strEqp:String
    var strTim:String
    var ImgTim:String
    var idOrdr:String
    var mrFlg:Bool
    var dnemrFlg:Bool
    var idWO:Int
    var asstNam:String
    var mainTyp:String
    init() {
         strEqp = ""
         strTim = ""
         ImgTim = ""
        idOrdr = ""
        mrFlg = false
        dnemrFlg = false
        idWO = 0
        asstNam = ""
        mainTyp = ""
    }
}
var chsStrtMdl = chusStrtMdl()

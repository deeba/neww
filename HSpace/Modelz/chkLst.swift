//
//  chkLst.swift
//  AMTfm
//
//  Created by DEEBA on 18.05.20.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//

import Foundation
struct chkLstMdl
{
    var chkLstId:[String]
    var typ:[String]
    var Qustn:[String]
    var suggsn:[String]
    var selPhto:[Bool]
    //var selSuggsn:[String]
   // var Ans:[String]
   // var isSub:[String]
    //var syncStats:[Bool]
    init() {
          chkLstId  = []
          typ  = []
          Qustn  = []
          suggsn  = []
       //   rowId  = []
        //  selSuggsn = []
       //    Ans = []
      //     isSub  = []
           selPhto  = []
    }
}
var chkLstModl = chkLstMdl()

//
//  availableshftListMdl.swift
//  HSpace
//
//  Created by DEEBA on 20.08.20.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//

import Foundation
struct availableshftListMdl
{
    var duration:[Double]
    var id: [Int]
    var name:[String]
    var planned_in:[String]
    var planned_out:[String]
    var start_time:[Double]
    var ttlDis:[String]
    init() {
           duration  = []
           id  = []
           name  = []
           planned_in  = []
           planned_out  = []
           start_time  = []
           ttlDis  = []
    }
}
var availableshftListModl = availableshftListMdl()

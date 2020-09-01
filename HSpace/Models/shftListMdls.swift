//
//  shftListMdls.swift
//  HSpace
//
//  Created by DEEBA on 20.08.20.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//
import Foundation
struct shftListMdls
{
    var active: [Bool]
    var code: [String]
    var company_id:[String]
    var company_name:[String]
    var description: [String]
    var duration: [Double]
    var eg_grace: [Double]
    var id: [Int]
    var lc_grace: [Double]
    var start_time: [Double]
    var vendor_id: [String]
    var vendor_name: [String]
    init() {
            active = []
           code  = []
           company_id = []
           company_name = []
           description  = []
           duration  = []
           eg_grace  = []
           id  = []
           lc_grace  = []
           start_time  = []
           vendor_id  = []
           vendor_name  = []
    }
}
var shftListModls = shftListMdls()

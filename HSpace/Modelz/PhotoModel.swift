//
//  PhotoModel.swift
//  AMTfm
//
//  Created by DEEBA on 14.05.20.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//

import Foundation
struct PhtoMdl
{
    var guid:String
    var unq_id:Int
    var file_name:String
    var data_file_name:String
    var file_data:String
    var pathz:String
    var sync_status:Bool
    init() {
          guid = ""
          unq_id = 0
          file_name = ""
          data_file_name = ""
          file_data = ""
          pathz = ""
          sync_status = false
    }
}
var phtoMdl = PhtoMdl()

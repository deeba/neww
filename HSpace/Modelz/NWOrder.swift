//
//  NWOrder.swift
//  AMTfm
//
//  Created by DEEBA on 07.04.20.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//

import Foundation


struct Person:Codable {
    let cause: String
   let check_list_ids:[String]
   enum CodingKeys: String, CodingKey {
       case  cause = "cause",check_list_ids = "check_list_ids"
    }
}


//
//  newShftzMdl.swift
//  HSpace
//
//  Created by DEEBA on 08.08.20.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//

import Foundation
struct newShftzMdl {
    var id: String!
    var name : String!
    var strtTim : String!
    var endTim : String?
    var duratn : String!
    
    init() {
    }
    
    init(id: String? = nil, name: String? = nil, strtTim: String? = nil,endTim: String? = nil,duratn: String? = nil) {
        self.id = id ?? ""
        self.name = name ?? ""
        self.strtTim = strtTim ?? ""
        self.endTim = endTim ?? ""
        self.duratn = duratn ?? ""
    }
    
    init(dict: NSDictionary) {
        self.id = String(dict["id"] as? Int ?? 0)
        self.name = dict["name"] as? String ?? ""
        self.strtTim = dict["planned_in"] as? String ?? ""
        self.endTim = dict["planned_out"] as? String ?? ""
        self.duratn = dict["duration"] as? String ?? ""
    }
}

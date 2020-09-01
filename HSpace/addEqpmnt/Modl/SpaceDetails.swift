//
//  SpaceDetails.swift
//  HSpace
//
//  Created by DEEBA on 20.07.20.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//

import Foundation

struct SpaceDetails {
    var id: String!
    var name : String!
    var displayName : String!
    var type : String?
    var pathname : String!
    var countt: String!
    var statts : String!
    var employeeid: String!
    var employeeName: String!
    var availablestatus : String!
    var haveChilds = false
    
    init() {
    }
    
    init(id: String? = nil, name: String? = nil, displayName: String? = nil,type: String? = nil,pathname: String? = nil,countt: String? = nil,statts: String? = nil,employeeid: String? = nil,employeeName: String? = nil,availablestatus:String? = nil,haveChilds: Bool = false) {
        self.id = id ?? ""
        self.name = name ?? ""
        self.displayName = displayName ?? ""
        self.type = type ?? ""
        self.pathname = pathname ?? ""
        self.availablestatus = availablestatus ?? ""
        self.countt = countt ?? ""
        self.statts = statts ?? ""
        self.employeeid = employeeid ?? ""
        self.employeeName = employeeName ?? ""
        self.haveChilds = haveChilds
    }
    
    init(dict: NSDictionary) {
        self.id = String(dict["id"] as? Int ?? 0)
        self.name = dict["space_name"] as? String ?? ""
        self.displayName = dict["display_name"] as? String ?? ""
        self.type = dict["asset_categ_type"] as? String ?? ""
        self.pathname = dict["path_name"] as? String ?? ""
        self.availablestatus = String((dict["available_status"] as? Int ?? 0))
        self.countt = String(dict["count"] as? Int ?? 0)
        self.statts = dict["status"] as? String ?? ""
        self.employeeid = String(dict["employee_id"] as? Int ?? 0)
        self.employeeName = dict["employee_name"] as? String ?? ""
        self.haveChilds = (dict["is_parent"] as? Int ?? 0) == 1
    }
}

//
//  Equipment.swift
//  HSpace
//
//  Created by DEEBA on 20.07.20.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//

import Foundation

struct Equipment {
    var id: String?
    var location : String?
    var eqName : String?
    var eqNum : String?
    var num : String?
    var model : String?
    var team : String?
    var mtbf : String?
    var category : String?
    var code : String?
    var manuf : String?
    var date : String?
    var value : String?
    var vendor : String?
    var fromDate : String?
    var toDate : String?
    var type : String?
    var cost : String?
    var description : String?
    
    init() {
    }
    
    enum CodingKeys: String, CodingKey {
        case ID = "id"
        case LOCATION = "location"
        case EQNAME = "eqName"
        case EQNUM = "eqNum"
        case NUM = "num"
        case MODEL = "model"
        case TEAM = "team"
        case MTBF = "mtbf"
        case CATEGORY = "category"
        case CODE = "code"
        case MANUF = "manuf"
        case DATE = "date"
        case VALUE = "value"
        case VENDOR = "vendor"
        case FROMDATE = "fromDate"
        case TODATE = "toDate"
        case TYPE = "type"
        case COST = "cost"
        case DESCRIPTION = "description"
    }
}

extension Equipment: Decodable, Encodable {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(String.self, forKey: .ID)
        location = try? values.decode(String.self, forKey: .LOCATION)
        eqName = try? values.decode(String.self, forKey: .EQNAME)
        eqNum = try? values.decode(String.self, forKey: .EQNUM)
        num = try? values.decode(String.self, forKey: .NUM)
        model = try? values.decode(String.self, forKey: .MODEL)
        team = try? values.decode(String.self, forKey: .TEAM)
        mtbf = try? values.decode(String.self, forKey: .MTBF)
        category = try? values.decode(String.self, forKey: .CATEGORY)
        code = try? values.decode(String.self, forKey: .CODE)
        manuf = try? values.decode(String.self, forKey: .MANUF)
        date = try? values.decode(String.self, forKey: .DATE)
        value = try? values.decode(String.self, forKey: .VALUE)
        vendor = try? values.decode(String.self, forKey: .VENDOR)
        fromDate = try? values.decode(String.self, forKey: .FROMDATE)
        toDate = try? values.decode(String.self, forKey: .TODATE)
        type = try? values.decode(String.self, forKey: .TYPE)
        cost = try? values.decode(String.self, forKey: .COST)
        description = try? values.decode(String.self, forKey: .DESCRIPTION)
    }
    
    func encode(to encoder: Encoder) throws {
        var val = encoder.container(keyedBy: CodingKeys.self)
        try val.encode(id, forKey: .ID)
        try val.encode(location, forKey: .LOCATION)
        try val.encode(eqName, forKey: .EQNAME)
        try val.encode(eqNum, forKey: .EQNUM)
        try val.encode(num, forKey: .NUM)
        try val.encode(model, forKey: .MODEL)
        try val.encode(team, forKey: .TEAM)
        try val.encode(mtbf, forKey: .MTBF)
        try val.encode(category, forKey: .CATEGORY)
        try val.encode(code, forKey: .CODE)
        try val.encode(manuf, forKey: .MANUF)
        try val.encode(date, forKey: .DATE)
        try val.encode(value, forKey: .VALUE)
        try val.encode(vendor, forKey: .VENDOR)
        try val.encode(fromDate, forKey: .FROMDATE)
        try val.encode(toDate, forKey: .TODATE)
        try val.encode(type, forKey: .TYPE)
        try val.encode(cost, forKey: .COST)
        try val.encode(description, forKey: .DESCRIPTION)
    }
}

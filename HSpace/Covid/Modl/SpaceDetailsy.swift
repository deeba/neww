//
//  SpaceDetailsy.swift
//  HSpace
//
//  Created by DEEBA on 28.07.20.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//
import Foundation

struct SpaceDetailsy {
    var id: String!
    var name : String!
    var displayName : String!
    var type : String?
    var haveChilds = false
    
    init() {
    }
    
    init(id: String? = nil, name: String? = nil, displayName: String? = nil, haveChilds: Bool = false) {
        self.id = id
        self.name = name
        self.displayName = displayName
        self.haveChilds = haveChilds
    }
}

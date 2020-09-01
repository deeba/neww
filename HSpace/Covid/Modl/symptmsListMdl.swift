//
//  symptmsListMdl.swift
//  HSpace
//
//  Created by DEEBA on 24.07.20.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//
import Foundation

struct symptmsListMdl
{
    var display_name:[String]
    var expected_type:[Bool]
    var id:[Int]
    var mro_quest_grp_id:[Int]
    var mro_quest_grp_nam:[String]
    var type:[String]
    init() {
            display_name = []
            expected_type = []
            id = []
            mro_quest_grp_id = []
            mro_quest_grp_nam = []
            type = []
    }
}
var symptmsListModl = symptmsListMdl()

//
//  symptmsChecklist.swift
//  HSpace
//
//  Created by DEEBA on 27.07.20.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//
import Foundation
// MARK: - Checklist
struct symptmsChecklist: Codable {
    var  symptmsType, question,answer : String
    var symptmsId,syncStatus: Int
    enum CodingKeys: String, CodingKey {
        case symptmsId = "id"
        case symptmsType = "type"
        case question = "display_name"
        case syncStatus = "sync_status"
        case answer = "answer"
    }
}

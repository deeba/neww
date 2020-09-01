//
//  TicketData.swift
//  AMTfm
//
//  Created by Serge Vysotsky on 04.06.2020.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//

import UIKit

struct TicketData {
    var locationPath: [Location]
    var category: ProblemCategory?
    var subcategory: ProblemSubcategory?
}

struct ProblemCategory {
    let name: String
    let Id: String
}

struct ProblemSubcategory {
    let name: String
    let priority: Priority
    let duration: TimeInterval
    //let duration: String
    let Id: String
  var formattedTime: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .abbreviated
        return formatter.string(from: duration)!
    }
    
    enum Priority: String {
        case Low, Normal, High , Breakdown
        
        var title: String {
            rawValue.capitalized
        }
        
        var color: UIColor {
            switch self {
            case .Low:
                return #colorLiteral(red: 0.8321426511, green: 0.7214980721, blue: 0.12189693, alpha: 1)
            case .Normal:
                return #colorLiteral(red: 0.9980236888, green: 0.6173967719, blue: 0.01779552735, alpha: 1)
            case .High:
                return #colorLiteral(red: 0.8225761056, green: 0.1082296446, blue: 0.1085064784, alpha: 1)
            case .Breakdown:
                return #colorLiteral(red: 0.979391396, green: 0, blue: 0.007760578301, alpha: 1)
            }
        }
    }
}

enum Location: Equatable {
    indirect case branch(BranchingCategory, [Location])
    case floor(String)
    
    enum BranchingCategory: Equatable {
        case chambers(String)
        case blocks(String)
        case floors(String)
        
        var name: String {
            switch self {
            case let .chambers(name): return name
            case let .blocks(name): return name
            case let .floors(name): return name
            }
        }
    }
    
    var isFloor: Bool {
        switch self {
        case .floor:
            return true
        default:
            return false
        }
    }
    
    var name: String {
        switch self {
        case let .branch(branch, _): return branch.name
        case let .floor(name): return name
        }
    }
    
    var subcategories: [Location] {
        if case let .branch(_, categories) = self {
            return categories
        } else {
            return []
        }
    }
    
    var image: UIImage? {
        guard case let .branch(branch, _) = self else { return nil }
        switch branch {
        case .chambers:
            return UIImage(named: "global")
        case .blocks:
            return UIImage(named: "Zone")
        case .floors:
            return UIImage(named: "Row")
        }
    }
}

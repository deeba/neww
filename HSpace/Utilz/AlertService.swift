//
//  AlertService.swift
//  AMTfm
//
//  Created by DEEBA on 14.04.20.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//

import Foundation
import UIKit
class AlertService {
      func alert() -> AlertViewController {
            
            let storyboard = UIStoryboard(name: "AlertStoryboard", bundle: .main)
            
            let alertVC = storyboard.instantiateViewController(withIdentifier: "AlertVC") as! AlertViewController
            return alertVC
        }
    }

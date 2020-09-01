//
//  Loader.swift
//  HSpace
//
//  Created by DEEBA on 20.07.20.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//

import Foundation
import SVProgressHUD

class Loader {
    
    private init() {
    }
    
    static func show() {
        SVProgressHUD.setForegroundColor(Constants.Color.lightBlue)
        SVProgressHUD.setBackgroundColor(Constants.Color.lightBlue.withAlphaComponent(0.1))
        SVProgressHUD.resetOffsetFromCenter()
        SVProgressHUD.show()
        if !UIApplication.shared.isIgnoringInteractionEvents {
            UIApplication.shared.beginIgnoringInteractionEvents() //freeze app
        }
    }
    
    static func showProgress(progress:Float) {
        SVProgressHUD.setForegroundColor(Constants.Color.lightBlue)
        SVProgressHUD.setBackgroundColor(Constants.Color.lightBlue.withAlphaComponent(0.1))
        SVProgressHUD.resetOffsetFromCenter()
        SVProgressHUD.showProgress(progress)
        if !UIApplication.shared.isIgnoringInteractionEvents {
            UIApplication.shared.beginIgnoringInteractionEvents() //freeze app
        }
    }
    
    static func hide() {
        SVProgressHUD.dismiss()
        UIApplication.shared.endIgnoringInteractionEvents() //unfreeze app
    }
}

//
//  Alert.swift
//  HelixSense
//
//  Created by DEEBA on 06.07.20.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//

import Foundation
import UIKit
class Alert {
    
    private init() {
        
    }
    
    private static func getAlert(title: String?, message: String?) -> UIAlertController {
        return UIAlertController(title: title, message: message, preferredStyle: .alert)
    }
    
    static func show(_ title:String, _ message:String, _ actionName:String = "Ok") {
        let alert = getAlert(title: title, message: message)
        alert.addAction(UIAlertAction(title: actionName, style: .cancel, handler: nil))
        UIApplication.shared.windows.last?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    static func show(_ title:String, _ message:String, _ confirmAction:String = "Ok", onSelectConfirm:@escaping (Bool) -> Void) {
        let alert = getAlert(title: title, message: message)
        alert.addAction(UIAlertAction(title: confirmAction, style: .default, handler: { (_) in
            onSelectConfirm(true)
        }))
        UIApplication.shared.windows.last?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    static func show(_ title:String, _ message:String, _ cancelAction:String, _ confirmAction:String, onSelectConfirm:@escaping (Bool) -> Void) {
        let alert = getAlert(title: title, message: message)
        alert.addAction(UIAlertAction(title: cancelAction, style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: confirmAction, style: .default, handler: { (_) in
            onSelectConfirm(true)
        }))
        UIApplication.shared.windows.last?.rootViewController?.present(alert, animated: true, completion: nil)
    }
}

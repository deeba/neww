//
//  Globalz.swift
//  testz
//
//  Created by DEEBA on 04.03.20.
//  Copyright © 2020 DEEBA. All rights reserved.
//

import Foundation
import UIKit

class readWrite: NSObject {
   // read and write user default
    let userDefault = UserDefaults.standard
    // write
    func writeAnyData(key: String, value: Any){
        userDefault.set(value, forKey: key)
        userDefault.synchronize()
    }

    // read int values
    func readIntData(key: String) -> Int{
        if userDefault.object(forKey: key) == nil {
            return 0
        } else {
            return userDefault.integer(forKey: key)
        }
    }

    // read string values
    func readStringData(key: String) -> String{
        if userDefault.object(forKey: key) == nil {
            return ""
        } else {
            return userDefault.string(forKey: key)!
        }
    }
    // read bool value
    func readBoolData(key: String) -> Bool{
        if userDefault.object(forKey: key) == nil {
            return false
        } else {
            return userDefault.bool(forKey: key)
        }
    }

}

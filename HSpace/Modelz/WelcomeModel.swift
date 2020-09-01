//
//  WelcomeModel.swift
//  AMTfm
//
//  Created by DEEBA on 01.04.20.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//

import Foundation
class WelcomeModel: NSObject, NSCoding {
    var strPndgCnt : String = ""
    var strCompltdCnt : String = ""
    var strTmId : String = ""
    override init() {}
    init(strPndgCnt: String, strCompltdCnt: String, strTmId: String) {
            self.strPndgCnt = strPndgCnt
            self.strCompltdCnt = strCompltdCnt
            self.strTmId = strTmId
        }

        // MARK: - NSCoding
        required init(coder decoder: NSCoder) {
            strPndgCnt = decoder.decodeObject(forKey: "strPndgCnt") as! String
            strCompltdCnt = decoder.decodeObject(forKey: "strCompltdCnt") as! String
            strTmId = decoder.decodeObject(forKey: "strTmId") as! String
        }

        func encode(with aCoder: NSCoder) {
            aCoder.encode(strPndgCnt, forKey: "strPndgCnt")
            aCoder.encode(strCompltdCnt, forKey: "strCompltdCnt")
            aCoder.encode(strTmId, forKey: "strTmId")
        }
    }
class LocalStorage {
    
    static  let sharedInstance  = LocalStorage()
    private init() {}
 
    unowned private let ud = UserDefaults.standard
 
    // MARK: User
    func saveUser(welcomeModel: WelcomeModel){
        let obj = NSKeyedArchiver.archivedData(withRootObject: welcomeModel)
        ud.set(obj, forKey: "welcomeModel")
    }
    
    
    func getUser() ->  WelcomeModel {
        if let userObject = ud.data(forKey: "welcomeModel"){
            return NSKeyedUnarchiver.unarchiveObject(with: userObject) as! WelcomeModel
        }
        else{
            fatalError("userObject does not exist in the local record.")
        }
    }
}
/*class SaveUtil {
    static func saveLessons(welcomeModel: WelcomeModel) {

        let data = NSKeyedArchiver.archivedData(withRootObject: welcomeModel)
        UserDefaults.standard.set(data, forKey: "welcomeModel")
    }

    static func loadLessons() -> WelcomeModel?  {
        let data = UserDefaults.standard.data(forKey: "welcomeModel")
        return try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data!) as? WelcomeModel
    }
}*/

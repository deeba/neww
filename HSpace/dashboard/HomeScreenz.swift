//
// satheesh@dcs.kf.in HomeScreen.swift
//  AMTfm
//
//  Created by DEEBA on 23.03.20.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//

import UIKit
import Foundation
import SwiftyJSON

import SQLite3
@available(iOS 10.0, *)
class HomeScreenz: UIViewController {

    var db:OpaquePointer? = nil
    let instanceOfWOrder = WOglobal()

    let interNt = Internt()
    let instanceOfUser = readWrite()
    
    @IBAction func workOrdr(_ sender: Any) {
        ConstrctDta(Tkn:self.instanceOfUser.readStringData(key: "accessTokenz") )
       
    }
   
    @IBAction func btnSide(_ sender: UIButton) {
SJSwiftSideMenuController.toggleLeftSideMenu()
    }
    
    @IBOutlet weak var lblEmp: UITextField!
    
    @IBAction func btnHCard(_ sender: UIButton) {
        let raiseTicket = UIStoryboard(name: "HCardStoryboard", bundle: .main).instantiateInitialViewController()!
        navigationController?.pushViewController(raiseTicket, animated: true)
    }
    
    @IBAction func btnRseTkt(_ sender: Any) {
        let viewController:
                      UIViewController = UIStoryboard(
                          name: "rseTkyStoryboard", bundle: nil
                      ).instantiateViewController(withIdentifier: "rseTkyStory") as! rseTkyViewController
                  let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                       //show window
                                       appDelegate.window?.rootViewController = viewController
       // let raiseTicket = UIStoryboard(name: "rseTkyStoryboard", bundle: .main).instantiateInitialViewController()!
       // navigationController?.pushViewController(raiseTicket, animated: true)
    }
    
    @IBOutlet weak var sideMnu: UIImageView!
    
    @IBOutlet weak var LogdInLbl: UILabel!
    @IBOutlet weak var CompnyLbl: UILabel!
    
    @IBOutlet weak var timrLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        let instanceOfUser = readWrite()
  //      self.navigationController?.interactivePopGestureRecognizer?.delegate = self as? UIGestureRecognizerDelegate
   //         let leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_menu"), style: .done, target: self, action: #selector(onClickMenu))
   //     leftBarButtonItem.tintColor = .red
  //      self.navigationItem.leftBarButtonItem  = leftBarButtonItem
       
        self.instanceOfUser.writeAnyData(key: "Finshd", value: false)
        self.instanceOfUser.writeAnyData(key: "gUid", value: "")
           self.instanceOfUser.writeAnyData(key: "Rescanz", value: false)
           self.instanceOfUser.writeAnyData(key: "QRFnsh", value: false)
           self.instanceOfUser.writeAnyData(key: "Finsh", value: false)
        self.instanceOfUser.writeAnyData(key: "PhtotknFnsh", value: false)
           self.instanceOfUser.writeAnyData(key: "Phtotkn", value: false)
           self.instanceOfUser.writeAnyData(key: "QRfound", value: false)
           self.instanceOfUser.writeAnyData(key: "PhtoOptn", value: "")
           self.instanceOfUser.writeAnyData(key: "WOphtochkLst", value: "")
           self.instanceOfUser.writeAnyData(key: "PausRlz", value: "")
//5L
   //    timrLbl.text = "00:00:00"
        lblEmp.text = "Welcome " + self.instanceOfUser.readStringData(key: "employeeNamez")
        let chkdTim  = self.instanceOfUser.readStringData(key: "ChekInTim")
        let cId = instanceOfUser.readStringData(key: "CompNamez")
        LogdInLbl.text = chkdTim
        CompnyLbl.text = cId
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
        self.initTimr()
        }
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barTintColor = UIColor.init(red: 247.0/255.0, green: 247.0/255.0, blue: 247.0/255.0, alpha: 1)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    func loadRootViewController() {
        let mainVC = SJSwiftSideMenuController()
        let rootScreen = UIStoryboard(name: "HomeStoryboard", bundle: nil).instantiateViewController(withIdentifier: "HomeStory") as! HomeScreenz

                   let sideMenu = UIStoryboard(name: "MainSdeStoryboard", bundle: nil).instantiateViewController(withIdentifier: "MainSde") as! MainSdeViewController
                   SJSwiftSideMenuController.setUpNavigation(rootController: rootScreen, leftMenuController: sideMenu, rightMenuController: nil, leftMenuType: .SlideOver, rightMenuType: .SlideView)
        
        SJSwiftSideMenuController.enableDimbackground = true
        SJSwiftSideMenuController.leftMenuWidth = UIScreen.main.bounds.size.width - 100
    }
   @objc func onClickMenu() {
          SJSwiftSideMenuController.toggleLeftSideMenu()
      }
 func getWelcomeDta(Stats: String,TmId: String) -> String {
               // self.insertCategorySubcategory(Id: "26",Name: "Floor Drains",catId: "5",catName: "Plumbing-Common",priority: "1",slaTmr: "8")
               var  strCount = ""
               let file_URL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
               .appendingPathComponent(instanceOfUser.readStringData(key: "dbNamez"))
               //opening the database
               if sqlite3_open(file_URL.path, &db) != SQLITE_OK {
                  print("There's error in opening the database")
               }
            else
                {
                    
                   let queryStatementString = "SELECT COUNT(*) AS total_count  FROM tbl_orders WHERE  team_id=? AND id = (SELECT MAX(id) FROM tbl_orders);"
                   var queryStatement: OpaquePointer?
                   let Tmid: String = TmId
                   // 1
                   if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) ==
                       SQLITE_OK {
                            //5F1!!!
                               // 2
                               sqlite3_bind_text(queryStatement, 1, (Tmid as NSString).utf8String, -1, nil)
                             // 2
                             if sqlite3_step(queryStatement) == SQLITE_ROW {
                                            strCount =    String(cString: sqlite3_column_text(queryStatement, 0))
                                     } else {
                                       print("\nUPDATE statement is not prepared")
                                     }
                           }

                    sqlite3_finalize(queryStatement)
                    sqlite3_close(db)
                    db = nil
               }
        return (strCount)
    }
    func ConstrctDta(Tkn: String)
        
    {
    var request = URLRequest(url: URL(string: "https://demo.helixsense.com/api/v2/call")!,timeoutInterval: Double.infinity)
    let string1 = "Bearer "
    let string2 = Tkn
        var closg = ""
    let combined2 = "\(string1) \(String(describing: string2))"
    request.addValue(combined2, forHTTPHeaderField: "Authorization")
    let stringFields = """
    welcome_dashboard
    """
    if instanceOfUser.readBoolData(key: "IS_SUPERVISOR")
        {
     closg = """
    [{"company":"","type":"all"}]
    """
      }
        else
        {
         closg = """
        [{"company":"","type":""}]
        """
        }
        
    let  stringRole1 = "&method="
    let stringRole2 = stringFields
    let varRole = "\(stringRole1)\(String(describing: stringRole2))"
    let stringDomain1 = "&args="
    let varDomain = "\(stringDomain1)\(String(describing: closg))"
    let postData = NSMutableData(data: "model=mro.order".data(using: String.Encoding.utf8)!)
    postData.append(varRole.data(using: String.Encoding.utf8)!)
    postData.append(varDomain.data(using: String.Encoding.utf8)!)
    request.httpBody = postData as Data
    request.httpMethod = "POST"
            let task1 = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
              print(String(describing: error))
              return
            }
            do {
               // make sure this JSON is in the format we expect
            let jsonc = try JSON(data: data)
             // let title = jsonc["data"][0]["name"].stringValue
             //let title = jsonc["data"][0]["parent_category_id"][1].stringValue
             let title = jsonc["data"]["company"]
             if (title.count > 0){

                var  siteNam, TempLcn ,strNewCnt ,strPndgCnt,strCompltdCnt,strTeam,strLcn,strTmId: String
                var strProgrsCnt,strAssgndCnt,newCnt,PndgCnt,CompltdCnt: Int
                 for i in 0..<title.count {
             //if (lngth.intValue > 0){
               //      for i in 0..<lngth.intValue {
                         siteNam = title[i]["parent_company"].stringValue
                         TempLcn = title[i]["name"].stringValue
                         let teamArry = title[i]["team"]

                            if (teamArry.count > 0){
                                    wOrderMdl.strNwCnt = []
                                    wOrderMdl.strPndgCnt = []
                                    wOrderMdl.strPrgCntz = []
                                    wOrderMdl.strCompltdCnt = []
                                    wOrderMdl.strTmNam = []
                                    wOrderMdl.strTmId = []
                                    for j in 0..<teamArry.count {
                                        newCnt = teamArry[j]["all_ready"].int ?? 0
                                        if ( newCnt > Int(99) ) {
                                           strNewCnt = "99+"
                                        }
                                        else
                                            {
                                                strNewCnt = String(newCnt)
                                            }
                                        PndgCnt = teamArry[j]["pause"].int ?? 0
                                        if ( PndgCnt > Int(99) ) {
                                           strPndgCnt = "99+"
                                        }
                                        else
                                            {
                                                strPndgCnt = String(PndgCnt)
                                            }
                                        strProgrsCnt = teamArry[j]["in_progress"].int ?? 0
                                        strAssgndCnt = teamArry[j]["assigned"].int ?? 0
                                        strProgrsCnt = strProgrsCnt + strAssgndCnt
                                        CompltdCnt = teamArry[j]["done"].int ?? 0
                                        if ( CompltdCnt > Int(99) ) {
                                           strCompltdCnt = "99+"
                                        }
                                        else
                                            {
                                                strCompltdCnt = String(CompltdCnt)
                                            }
                                        strTeam = teamArry[j]["team"].stringValue
                                        strLcn = TempLcn + " - "  + strTeam
                                        strTmId = teamArry[j]["team_id"].stringValue
                                   /*
                                        self.interNt.InterNt()
                                        if (self.instanceOfUser.readStringData(key: "Internt") == "NoInternet")
                                        {
                                            
                                        
                                       strNewCnt = self.getWelcomeDta(Stats: "ready",TmId: strTmId)
                                        if (strNewCnt == "0")
                                            {
                                                newCnt = teamArry[j]["all_ready"].int ?? 0
                                                if ( newCnt > Int(99) ) {
                                                   strNewCnt = "99+"
                                                }
                                                else
                                                    {
                                                        strNewCnt = String(newCnt)
                                                    }
                                            }
                                        
                                        strPndgCnt = self.getWelcomeDta(Stats: "pause",TmId: strTmId)
                                        if (strPndgCnt == "0")
                                            {
                                                        strPndgCnt = teamArry[j]["pause"].stringValue
                                            }
                                        strProgrsCnt = Int(self.getWelcomeDta(Stats: "in_progress",TmId: strTmId)) ?? 0
                                        if (strProgrsCnt == 0)
                                            {
                                                        strProgrsCnt = teamArry[j]["in_progress"].int ?? 0
                                            }
                                        strAssgndCnt = Int(self.getWelcomeDta(Stats: "assigned",TmId: strTmId)) ?? 0
                                        if (strAssgndCnt == 0)
                                            {
                                                        strAssgndCnt = teamArry[j]["assigned"].int ?? 0
                                            }
                                            strProgrsCnt = strProgrsCnt + strAssgndCnt

                                        strCompltdCnt = self.getWelcomeDta(Stats: "done",TmId: strTmId)
                                        if (strCompltdCnt == "0")
                                            {
                                            strCompltdCnt = teamArry[j]["done"].stringValue
                                            }
                                         
                                         

                                        }
            */
                                       /*let category = WelcomeModel(strPndgCnt : strPndgCnt ,strCompltdCnt:  strCompltdCnt  ,strTmId:  strTmId)
                                       let encodedData = NSKeyedArchiver.archivedData(withRootObject: category)
                                       if #available(iOS 10.0, *) {
                                        self.userDefaults.set(encodedData, forKey: UserDefaultsKeys.welcomeModel.rawValue)
                                       } else {
                                           // Fallback on earlier versions
                                       }*/
                                       var strPrgCntz  = String(strProgrsCnt)
                                        if ( strProgrsCnt > Int(99) ) {
                                           strPrgCntz = "99+"
                                        }
                                        else
                                            {
                                                strPrgCntz = String(strProgrsCnt)
                                            }
                                       // let dict = ["strNwCnt" : strNewCnt ,"strPndgCnt" : strPndgCnt,"strPrgCntz" : strPrgCntz ,"strCompltdCnt":  strCompltdCnt  ,"strTmNam":  strTeam,"strTmId": strTmId] as [String : Any]
                                       // self.instanceOfWOrder.compArrayz.add(dict)
                                      //  self.instanceOfWOrder.userDefaults = UserDefaults.standard
                                       // self.instanceOfWOrder.userDefaults.set(self.instanceOfWOrder.compArrayz, forKey: "myKeyz")

                                        wOrderMdl.strNwCnt.append(strNewCnt)
                                        wOrderMdl.strPndgCnt.append(strPndgCnt)
                                        wOrderMdl.strPrgCntz.append(strPrgCntz)
                                        wOrderMdl.strCompltdCnt.append(strCompltdCnt)
                                        wOrderMdl.strTmNam.append(strTeam)
                                        wOrderMdl.strTmId.append(strTmId)
                                        }
                              
                                }
                   
                     }
                        OperationQueue.main.addOperation {
                                   let storyBoard: UIStoryboard = UIStoryboard(name: "WOrderStoryboard", bundle: nil)
                                   let newViewController = storyBoard.instantiateViewController(withIdentifier: "WOStory") 
                                  self.present(newViewController, animated: true, completion: nil)
                               }
                 }
             
               }
            catch let error as NSError {
               print("Failed to load: \(error.localizedDescription)")
            }
            }
               task1.resume()

      }
    func timeString(time: TimeInterval) -> String {
        let hour = Int(time) / 3600
        let minute = Int(time) / 60 % 60
        let second = Int(time) % 60

        // return formated string
        return String(format: "%02i:%02i:%02i", hour, minute, second)
    }
    func initTimr()
    {
        let chkdTim  = self.instanceOfUser.readStringData(key: "ChekInTim")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        let convertedDate = dateFormatter.date(from: chkdTim)
        let diff = convertedDate!.timeIntervalSinceNow * -1
        timrLbl.text = timeString(time: TimeInterval(diff))
        }
override var prefersStatusBarHidden: Bool {
    return true
}
}

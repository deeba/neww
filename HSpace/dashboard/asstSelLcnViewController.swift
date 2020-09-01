//
//  asstSelLcnViewController.swift
//  HelixSense
//
//  Created by DEEBA on 22.06.20.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//


import UIKit
import SQLite3
import  SwiftyJSON

class asstSelLcnViewController: UIViewController {
    let instanceOfUser = readWrite()
    @IBOutlet weak var btnEdit: UIButton!
    
    var db:OpaquePointer? = nil
    var qryFld: String = "building"
    var isPrnt: Bool = false
    var disNam: String = ""
    var ticketData: toBvaldtedLstMdl!
    @IBOutlet weak var lblCnt: UILabel!
    
    @IBAction func btnGoBck() {
       self.dismiss(animated: true, completion: nil)
    }
   /* @IBAction func btnGoBck() {
            let viewController:
                UIViewController = UIStoryboard(
                    name: "HomeStoryboard", bundle: nil
                ).instantiateViewController(withIdentifier: "HomeStory") as! HomeScreenz
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                 //show window
                                 appDelegate.window?.rootViewController = viewController
       
                     
    }
 */
    func showToast(message: String) {
            let toastLabel = UITextView(frame: CGRect(x: self.view.frame.size.width/16, y: self.view.frame.size.height-150, width: self.view.frame.size.width * 7/8, height: 50))
            toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
            toastLabel.textColor = UIColor.white
            toastLabel.textAlignment = .center;
            toastLabel.text = "   \(message)   "
            toastLabel.alpha = 1.0
            toastLabel.layer.cornerRadius = 10;
            toastLabel.clipsToBounds  =  true
            toastLabel.font = UIFont(name: (toastLabel.font?.fontName)!, size: 16)
            toastLabel.center.x = self.view.frame.size.width/2
            self.view.addSubview(toastLabel)
            UIView.animate(withDuration: 5.0, delay: 0.1, options: .curveEaseOut, animations: {
                toastLabel.alpha = 0.0
            }, completion: {(isCompleted) in
                toastLabel.removeFromSuperview()
            })
    }
    @IBAction func btnTobValidted() {
        //if nothing is selected
        if selectedLocationLabel.text == "Chambers"
        {
             instanceOfUser.writeAnyData(key: "IsPrnt", value: true)
             instanceOfUser.writeAnyData(key: "LcnParent", value: "Chambers")
        }
            else
        {
            disNam = fndDisNam(selLocn: selectedLocationLabel.text!)
            isPrnt = fndtbValidted(selLocn: disNam.components(separatedBy: ",")[1])
            instanceOfUser.writeAnyData(key: "IsPrnt", value: isPrnt)
        }
        if lblCnt.text == ""
        {
           showToast(message: "There are no equipments for validation" )
        }
        else
        {
            let storyBoard: UIStoryboard = UIStoryboard(name: "MainSdeStoryboard", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "toBValidtedLbl") as! toBValidtedLblViewController
            self.present(newViewController, animated: true, completion: nil)
            /*
            let viewController:
                UIViewController = UIStoryboard(
                    name: "MainSdeStoryboard", bundle: nil
                ).instantiateViewController(withIdentifier: "toBValidtedLbl") as! toBValidtedLblViewController
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                 //show window
                                 appDelegate.window?.rootViewController = viewController
            */
        }
        
    }
    @IBAction func btnVali() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "MainSdeStoryboard", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "validateAsst") as! validateAsstViewController
        self.present(newViewController, animated: true, completion: nil)
       /* let viewController:
                                    UIViewController = UIStoryboard(
                                        name: "MainSdeStoryboard", bundle: nil
                                    ).instantiateViewController(withIdentifier: "validateAsst") as! validateAsstViewController
                                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                                     //show window
                                                     appDelegate.window?.rootViewController = viewController
        */
    }
    @IBOutlet weak var lblDisNam: UILabel!
    
    @IBOutlet weak var locationsTableView: UITableView!
    
    @IBAction func btnAdEqp(_ sender: Any) {
        let viewController:
                                    UIViewController = UIStoryboard(
                                        name: "MainSdeStoryboard", bundle: nil
                                    ).instantiateViewController(withIdentifier: "AssetRegistryMdfdViewController") as! EditAssetModifidViewController
                                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                                     //show window
                                                     appDelegate.window?.rootViewController = viewController
        
    }
    @IBOutlet weak var selectedLocationLabel: UILabel!
    @IBOutlet weak var subLocationsTableView: UITableView!
    
    @IBOutlet weak var nextButton: UIButton!
    var tobVerifd: Int?
    var rootSelectedIndex: Int?
    var selectedLocations = [Location]()
    var dataTree: Location!
    var cntBloks: Int =  0
    var cntFlrs: Int =  0
    var cntRoms: Int =  0
    var hasChld: Bool =  false
    override func viewDidLoad() {
        super.viewDidLoad()
        instanceOfUser.writeAnyData(key: "frstLoad", value: "notFrst")
        callGetAPI(Tkn:self.instanceOfUser.readStringData(key: "accessTokenz") )
        nextButton.isHidden = true
        instanceOfUser.writeAnyData(key: "selLocn", value: "")
        instanceOfUser.writeAnyData(key: "selLocnId", value: "")
        blkModl.spacId.removeAll()
        blkModl.spacNam.removeAll()
        blkModl.spacDisNam.removeAll()
        flrMdl.spacId.removeAll()
        flrMdl.spacNam.removeAll()
        flrMdl.spacDisNam.removeAll()
        romMdl.spacId.removeAll()
        romMdl.spacNam.removeAll()
        romMdl.spacDisNam.removeAll()
        poplateBlks()
        cntBloks = blkModl.spacId.count-1
        
     let rootLocation = Location.BranchingCategory.chambers("Chambers")
     var rootObjects = [Location]()
          for i in 0...cntBloks {
           //  getToken(Unam: (txtUser.text ?? nil)!,Pwd: (txtPwd.text ?? nil)!)
            flrMdl.spacId.removeAll()
            flrMdl.spacNam.removeAll()
            flrMdl.spacDisNam.removeAll()
            poplateFlrs(spcId: blkModl.spacId[i])
            blkModl.spachasChild[i]  =  hasChld
            let blockChambers = Location.BranchingCategory.blocks(blkModl.spacNam[i])
            var blockChambersItems = [Location]()
            cntFlrs = flrMdl.spacId.count-1
            if  flrMdl.spacId.count > 0 {
                    for j in 0...cntFlrs {
                        romMdl.spacId.removeAll()
                        romMdl.spacNam.removeAll()
                        romMdl.spacDisNam.removeAll()
                        poplateRoomz(spcId: flrMdl.spacId[j])
                        let floorGround = Location.BranchingCategory.floors(flrMdl.spacNam[j])
                        var floorGroundFloors = [Location]()
                        cntRoms = romMdl.spacId.count-1
                        if  romMdl.spacId.count > 0 {
                                for k in 0...cntRoms {
                                    floorGroundFloors.append(.floor(romMdl.spacNam[k]))
                                    }
                         }
                        blockChambersItems.append(.branch(floorGround, floorGroundFloors))
                         }
                }
            rootObjects.append(.branch(blockChambers,blockChambersItems))
           /*  cntFlrs = flrMdl.spacId.count-1
             for j in 0...cntFlrs {
                var floorGroundFloors = [Location]()
                blockChambersItems.append(.floor(flrMdl.spacNam[j]))
                rootObjects.append(.branch(blockChambers,blockChambersItems))
                 poplateRoomz(spcId: flrMdl.spacId[j])
                 cntRoms = romMdl.spacId.count-1
                }
 */
             }
      //  let index = find(value: "Block Chambers-11", in: blkModl.spacNam)
       // print(index as Any)
  
        /*
          let blockChambers = Location.BranchingCategory.blocks(BloksArray[1])
            var blockChambersItems = [Location]()
            
             let floorGround = Location.BranchingCategory.floors("Floor Ground")
            var floorGroundFloors = [Location]()
            floorGroundFloors.append(.floor("Floor 1"))
            floorGroundFloors.append(.floor("Floor 2"))//cntRms
            blockChambersItems.append(.branch(floorGround, floorGroundFloors))
            blockChambersItems.append(.floor("Floor 3"))
            blockChambersItems.append(.floor("Floor 4"))//cntFlrs
            rootObjects.append(.branch(blockChambers, blockChambersItems))
 
  */
         /*
                //let blockChambers = Location.BranchingCategory.blocks(BloksArray[1])
               let blockChambers = Location.BranchingCategory.blocks("Block Chambers")
               var blockChambersItems = [Location]()
               
               let floorGround = Location.BranchingCategory.floors("Floor Ground")
               var floorGroundFloors = [Location]()
              
               floorGroundFloors.append(.floor("Floor 1"))
               floorGroundFloors.append(.floor("Floor 2"))//cntRms
                for i in 0...10 {
                   floorGroundFloors.append(.floor("Floor \(i + 50)"))
               }
               blockChambersItems.append(.branch(floorGround, floorGroundFloors))
               blockChambersItems.append(.floor("Floor 3"))
               blockChambersItems.append(.floor("Floor 4"))//cntFlrs
              for i in 0...10 {
                   blockChambersItems.append(.floor("Floor \(i + 30)"))
               }
               rootObjects.append(.branch(blockChambers, blockChambersItems))
               rootObjects.append(.floor("Floor Basement 1")) //cntBloks
               for i in 0...10 {
                    rootObjects.append(.floor("Floor \(i + 10)"))
                }
          */
               selectedLocations = [Location.branch(rootLocation, rootObjects)]
               locationsTableView.reloadData()
           }
    func callGetAPIz(Tkn: String) {
        let chnge  = disNam.components(separatedBy: ",")[1]
              var test = "https://demo.helixsense.com/api/v2/read_group?groupby=%5B%22validation_status%22%5D&model=mro.equipment&domain=%5B%5B%22location_id%22%2C%22child_of%22%2C%22" + chnge.replacingOccurrences(of: " ", with: "%20")  + "%22%5D%5D&fields=%5B%22display_name%22%5D"
                                   var request = URLRequest(url: URL(string: test)!,timeoutInterval: Double.infinity)
                                   let string1 = "Bearer "
                                   let string2 = Tkn
                                   let combined2 = "\(string1) \(String(describing: string2))"
                                  request.addValue(combined2, forHTTPHeaderField: "Authorization")
                                  request.httpMethod = "GET"
                                  let task1 = URLSession.shared.dataTask(with: request) { data, response, error in
                                    guard let data = data else {
                                      print(String(describing: error))
                                      return
                                    }
                                   do {
                                       // make sure this JSON is in the format we expect
                                          let jsonc = try JSON(data: data)
                                    //print(json["data"][0]["validation_status_count"].stringValue)
                                           let title = jsonc["data"]
                                  //let title = jsonc["data"][0]["parent_category_id"][1].stringValue
                                  if (title.count > 0){
                                      for i in 0..<title.count {
                                        if title[i]["validation_status"].stringValue == "None" {
                                              DispatchQueue.main.async {
                                                  self.lblCnt.text = title[i]["validation_status_count"].stringValue
                                            }
                                            }
                                          }
                                      }
                                    else
                                        {
                                          DispatchQueue.main.async {
                                                  self.lblCnt.text = "0"
                                            }
                                        }
                                    }
                                    catch let error as NSError {
                                       print("Failed to load: \(error.localizedDescription)")
                                   }
                                  }
                           task1.resume()
            
            
    }
    func callGetAPI(Tkn: String) {
                                   var request = URLRequest(url: URL(string: "https://demo.helixsense.com/api/v2/read_group?groupby=%5B%22validation_status%22%5D&model=mro.equipment&domain=%5B%5D&fields=%5B%22display_name%22%5D")!,timeoutInterval: Double.infinity)
                                   let string1 = "Bearer "
                                   let string2 = Tkn
                                   let combined2 = "\(string1) \(String(describing: string2))"
                                  request.addValue(combined2, forHTTPHeaderField: "Authorization")
                                  request.httpMethod = "GET"
                                  let task1 = URLSession.shared.dataTask(with: request) { data, response, error in
                                    guard let data = data else {
                                      print(String(describing: error))
                                      return
                                    }
                                   do {
                                    //let jsonc = try JSON(data: data)
                                   // let title = jsonc["child_company_ids"][0]["name"].stringValue
                                    
                                    // let title = jsonc["child_company_ids"][0]["id"].int
                                    //let title = jsonc["address"]["locality"].stringValue
                                   // print(title)
                                    
                                        
                                       // make sure this JSON is in the format we expect
                                          let jsonc = try JSON(data: data)
                                    //print(json["data"][0]["validation_status_count"].stringValue)
                                           let title = jsonc["data"]
                                  //let title = jsonc["data"][0]["parent_category_id"][1].stringValue
                                  if (title.count > 0){
                                      for i in 0..<title.count {
                                        if title[i]["validation_status"].stringValue == "None" {
                                              DispatchQueue.main.async {
                                                  self.lblCnt.text = title[i]["validation_status_count"].stringValue
                                              /*  self.popupAlert(title: "Success!!!", message: "\(jsonDict)", actionTitles: ["OK"], actions:[
                                                {action1 in
                                                    print("No internet")
                                                }])
                                            */
                                            }
                                            }
                                          }
                                      }
                                    }
                                    catch let error as NSError {
                                       print("Failed to load: \(error.localizedDescription)")
                                   }
                                  }
                           task1.resume()
            
            
    }
    func find(value searchValue: String, in array: [String]) -> Int?
    {
        for (index, value) in array.enumerated()
        {
            if value == searchValue {
                return index
            }
        }

        return nil
    }
    func updteLblCnt(Tkn: String) {
                          var request = URLRequest(url: URL(string: "https://demo.helixsense.com/api/v2/read_group")!,timeoutInterval: Double.infinity)
                          let string1 = "Bearer "
                          let string2 = Tkn
                          let combined2 = "\(string1) \(String(describing: string2))"
                          request.addValue(combined2, forHTTPHeaderField: "Authorization")
                          request.httpMethod = "GET"
        let stringFields = """
        ["validation_status"]&domain=[]&fields=["display_name"]
        """
        let stringDomain = """
        [["user_id","=",
        """
        let stringDomain3 = """
        ]]
        """
        let stringRole1 = "&groupby="
        let stringRole2 = stringFields
        let varRole = "\(stringRole1) \(String(describing: stringRole2))"
        let postData = NSMutableData(data: "model=mro.equipment".data(using: String.Encoding.utf8)!)
        postData.append(varRole.data(using: String.Encoding.utf8)!)
        request.httpBody = postData as Data
        request.httpMethod = "GET"
                          let task1 = URLSession.shared.dataTask(with: request) { data, response, error in
                            guard let data = data else {
                              print(String(describing: error))
                              return
                            }
                           do {
                            
                               // make sure this JSON is in the format we expect
                            let jsonc = try JSON(data: data)
                             let title = jsonc["data"]
                             if (title.count > 0){
                                
                                    }
                               }
                            catch let error as NSError {
                               print("Failed to load: \(error.localizedDescription)")
                           }
                          }
                          task1.resume()
            
            
    }
    func poplateRoomz(spcId: String) {
               let file_URL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
               .appendingPathComponent(instanceOfUser.readStringData(key: "dbNamez"))
               //opening the database
               if sqlite3_open(file_URL.path, &db) != SQLITE_OK {
                  print("There's error in opening the database")
               }
            else
                {
                    
                  let queryStatementString = "SELECT space_id,space_name,space_display_name FROM tbl_space_details WHERE space_parent_id = ?  ORDER BY space_seqid ASC ;"
                   var queryStatement: OpaquePointer?
                   // 1
                   if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) ==
                       SQLITE_OK {
                            //5F1!!!
                               // 2
                     //  sqlite3_bind_text(queryStatement, 1,(qryFld  as NSString).utf8String, -1, nil)
                    sqlite3_bind_int(queryStatement, 1, (Int32(spcId)!))
                             // 2
                             while  sqlite3_step(queryStatement) == SQLITE_ROW {
                                     let spacIdz = Int(sqlite3_column_int(queryStatement, 0))
                                     let stringNam = String(cString: sqlite3_column_text(queryStatement, 1))
                                    let stringdisNam = String(cString: sqlite3_column_text(queryStatement, 2))
                                     romMdl.spacId.append(String(spacIdz))
                                     romMdl.spacNam.append(stringNam)
                                     romMdl.spacDisNam.append(stringdisNam)
                                     }
                      
                           }

                    sqlite3_finalize(queryStatement)
                    sqlite3_close(db)
                    db = nil
               }
    }
    func poplateFlrs(spcId: String) {
               let file_URL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
               .appendingPathComponent(instanceOfUser.readStringData(key: "dbNamez"))
               //opening the database
               if sqlite3_open(file_URL.path, &db) != SQLITE_OK {
                  print("There's error in opening the database")
               }
            else
                {
                  let queryStatementString = "SELECT space_id,space_name,space_display_name FROM tbl_space_details WHERE space_parent_id = ?  ORDER BY space_seqid ASC ;"
                   var queryStatement: OpaquePointer?
                   // 1
                   if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) ==
                       SQLITE_OK {
                            //5F1!!!
                               // 2
                     //  sqlite3_bind_text(queryStatement, 1,(qryFld  as NSString).utf8String, -1, nil)
                    sqlite3_bind_int(queryStatement, 1, (Int32(spcId)!))
                             // 2
                             hasChld  =  false
                             while  sqlite3_step(queryStatement) == SQLITE_ROW {
                                     hasChld  =  true
                                     let spacIdz = Int(sqlite3_column_int(queryStatement, 0))
                                      let stringNam = String(cString: sqlite3_column_text(queryStatement, 1))
                                     let stringdisNam = String(cString: sqlite3_column_text(queryStatement, 2))
                                     flrMdl.spacId.append(String(spacIdz))
                                     flrMdl.spacNam.append(stringNam)
                                     flrMdl.spacDisNam.append(stringdisNam)
                                     }
                      
                           }

                    sqlite3_finalize(queryStatement)
                    sqlite3_close(db)
                    db = nil
               }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let destination = segue.destination as? SelectCategoryViewController {
            destination.ticketData = TicketData(locationPath: selectedLocations)
        }
    }
    func poplateBlks()
    {
               let file_URL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
               .appendingPathComponent(instanceOfUser.readStringData(key: "dbNamez"))
               //opening the database
               if sqlite3_open(file_URL.path, &db) != SQLITE_OK {
                  print("There's error in opening the database")
               }
            else
                {
                  let queryStatementString = "SELECT space_id,space_name,space_display_name  FROM tbl_space_details WHERE space_category_type = ?  ORDER BY space_seqid ASC ;"
                   var queryStatement: OpaquePointer?
                   // 1
                   if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) ==
                       SQLITE_OK {
                            //5F1!!!
                               // 2
                      sqlite3_bind_text(queryStatement, 1,(qryFld  as NSString).utf8String, -1, nil)
                    // sqlite3_bind_int(queryStatement, 1, (Int32(chsStrtMdl.idWO)))
                             // 2
                             while  sqlite3_step(queryStatement) == SQLITE_ROW {
                                    let spacIdz = Int(sqlite3_column_int(queryStatement, 0))
                                      let stringNam = String(cString: sqlite3_column_text(queryStatement, 1))
                                     let stringdisNam = String(cString: sqlite3_column_text(queryStatement, 2))
                                     blkModl.spacId.append(String(spacIdz))
                                     blkModl.spacNam.append(stringNam)
                                     blkModl.spacDisNam.append(stringdisNam)
                                     blkModl.spachasChild.append(false)
                                     }
                      
                           }

                    sqlite3_finalize(queryStatement)
                    sqlite3_close(db)
                    db = nil
               }
    }

}

extension asstSelLcnViewController: UITableViewDataSource, UITableViewDelegate {
    func currentSubcategories() -> [Location] {
        if let rootSelectedIndex = rootSelectedIndex {
            return rootBranchingCategories()[rootSelectedIndex].subcategories
        } else {
            return rootBranchingCategories().last!.subcategories
        }
    }
    
    func rootBranchingCategories() -> [Location] {
        selectedLocations.filter { !$0.isFloor }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView === locationsTableView {
            return rootBranchingCategories().count
        } else if tableView === subLocationsTableView {
            return currentSubcategories().count
        } else {
            fatalError()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView === locationsTableView {
            let cell = asstSelLcn.dequeue(from: tableView, for: indexPath)
            let category = rootBranchingCategories()[indexPath.row]
            cell.locationNameLabel.text = category.name
            cell.locationImageView.image = category.image
            
            if let rootSelectedIndex = rootSelectedIndex {
                cell.overlayView.isHidden = rootSelectedIndex == indexPath.row
            } else {
                cell.overlayView.isHidden = indexPath.row == rootBranchingCategories().count - 1
            }
            
            return cell
        } else if tableView === subLocationsTableView {
            let cell = asstSelSubLcn.dequeue(from: tableView, for: indexPath)
            let category = currentSubcategories()[indexPath.row]
            cell.nameLabel.text = category.name
           /* if blkModl.spacNam.count > indexPath.row
            {
                if blkModl.spachasChild[indexPath.row]
                {//show edt icn if haschild  is false
                    cell.edtLcn.isHidden  = true
                }
                else{//show edt icn if haschild  is false
                    cell.edtLcn.isHidden  = false
                }
           }
            */
            let isSelected = selectedLocations.contains(category)
            cell.selectedIndicatorInner.isHidden = !isSelected
            cell.selectedIndicatorOuter.borderColor = isSelected ? #colorLiteral(red: 0, green: 0.7424671054, blue: 0.957267344, alpha: 1) : #colorLiteral(red: 0.7540688515, green: 0.7540867925, blue: 0.7540771365, alpha: 1)
            return cell
        } else {
            fatalError()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView === locationsTableView {
            return tableView.frame.width * 0.7
        } else if tableView === subLocationsTableView {
            return 50
        } else {
            fatalError()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView === locationsTableView {
            rootSelectedIndex = indexPath.row
        } else if tableView === subLocationsTableView {
            let subcategories = currentSubcategories()
            let subcategory = subcategories[indexPath.row]
            if let rootSelectedIndex = rootSelectedIndex {
                selectedLocations[(rootSelectedIndex + 1)...] = [subcategory]
            } else {
                selectedLocations.removeAll(where: { subcategories.contains($0) })
                selectedLocations.append(subcategory)
                /*
                if blkModl.spacNam.count > indexPath.row
                {
                    if blkModl.spacNam[indexPath.row] == subcategory.name
                    {
                        lblDisNam.text = blkModl.spacDisNam[indexPath.row]
                        instanceOfUser.writeAnyData(key: "selLocnId", value: blkModl.spacId[indexPath.row])
                    }
                }
                 if flrMdl.spacNam.count > indexPath.row
                {
                    if flrMdl.spacNam[indexPath.row] == subcategory.name
                    {
                        lblDisNam.text = flrMdl.spacDisNam[indexPath.row]
                        instanceOfUser.writeAnyData(key: "selLocnId", value:  flrMdl.spacId[indexPath.row])
                    }
                }
                  if romMdl.spacNam.count > indexPath.row
               {
                   if romMdl.spacNam[indexPath.row] == subcategory.name
                   {
                       lblDisNam.text = romMdl.spacDisNam[indexPath.row]
                       instanceOfUser.writeAnyData(key: "selLocnId", value:  romMdl.spacId[indexPath.row])
                   }
               }
                */
            }
            
            rootSelectedIndex = nil
        } else {
            fatalError()
        }
        
        reloadAllData()
    }
    
    func reloadAllData() {
        locationsTableView.reloadData()
        subLocationsTableView.reloadData()
        selectedLocationLabel.text = selectedLocations.last?.name
             disNam = fndDisNam(selLocn: selectedLocationLabel.text!)
             instanceOfUser.writeAnyData(key: "lcnId", value: disNam.components(separatedBy: ",")[0])
            isPrnt = fndtbValidted(selLocn: disNam.components(separatedBy: ",")[1])

            instanceOfUser.writeAnyData(key: "IsPrnt", value: isPrnt)
            callGetAPIz(Tkn:self.instanceOfUser.readStringData(key: "accessTokenz") )
            lblDisNam.text = disNam.components(separatedBy: ",")[1]
        instanceOfUser.writeAnyData(key: "LcnParent", value: selectedLocationLabel.text as Any)

            instanceOfUser.writeAnyData(key: "selLocn", value: disNam.components(separatedBy: ",")[1])
            instanceOfUser.writeAnyData(key: "selLocnId", value:  disNam.components(separatedBy: ",")[0])
        instanceOfUser.writeAnyData(key: "lcnSel", value: disNam.components(separatedBy: ",")[1])
            if  selectedLocationLabel.text != "" || selectedLocationLabel.text != "Chambers"
            {
                btnEdit.isHidden = false
                nextButton.isHidden = false
            }
               
        
        }
    func fndtbValidted(selLocn: String) -> Bool
    {
               let file_URL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
               .appendingPathComponent(instanceOfUser.readStringData(key: "dbNamez"))
         var spactbValidted = ""
         var spcId =  0
        var isPrnt: Bool = false
               //opening the database
               if sqlite3_open(file_URL.path, &db) != SQLITE_OK {
                  print("There's error in opening the database")
               }
            else
                {
                  let queryStatementString = "SELECT space_parent_id FROM tbl_space_details WHERE space_display_name = ? ORDER BY space_seqid ASC;"
                   var queryStatement: OpaquePointer?
                   // 1
                   if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) ==
                       SQLITE_OK {
                            //5F1!!!
                               // 2
                      sqlite3_bind_text(queryStatement, 1,(selLocn  as NSString).utf8String, -1, nil)
                    // sqlite3_bind_int(queryStatement, 1, (Int32(chsStrtMdl.idWO)))
                             // 2
                             while  sqlite3_step(queryStatement) == SQLITE_ROW {
                                     spactbValidted = String(cString: sqlite3_column_text(queryStatement, 0))
                                     }
                            if spactbValidted == ""
                            {
                                isPrnt = true
                            }
                           }

                    sqlite3_finalize(queryStatement)
                    sqlite3_close(db)
                    db = nil
               }
        return isPrnt
    }
    func fndDisNam(selLocn: String) -> String
    {
               let file_URL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
               .appendingPathComponent(instanceOfUser.readStringData(key: "dbNamez"))
         var spacdisNam = ""
         var spcId =  0
               //opening the database
               if sqlite3_open(file_URL.path, &db) != SQLITE_OK {
                  print("There's error in opening the database")
               }
            else
                {
                  let queryStatementString = "SELECT space_id,space_display_name,space_parent_id,space_short_code,space_parent_name,space_asset_category_id,space_maintenance_team_id,space_maintenance_team,space_asset_category_name  FROM tbl_space_details WHERE space_name = ?  ORDER BY space_seqid ASC ;"
                   var queryStatement: OpaquePointer?
                   // 1
                   if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) ==
                       SQLITE_OK {
                            //5F1!!!
                               // 2
                      sqlite3_bind_text(queryStatement, 1,(selLocn  as NSString).utf8String, -1, nil)
                    // sqlite3_bind_int(queryStatement, 1, (Int32(chsStrtMdl.idWO)))
                             // 2
                             while  sqlite3_step(queryStatement) == SQLITE_ROW {
                                     spcId  = Int(sqlite3_column_int(queryStatement, 0))
                                     spacdisNam = String(cString: sqlite3_column_text(queryStatement, 1))
                                     spacdisNam = String(sqlite3_column_int(queryStatement, 0)) + "," + spacdisNam
                                     instanceOfUser.writeAnyData(key: "lcnPrntId", value: String(cString: sqlite3_column_text(queryStatement, 2)))
                                     instanceOfUser.writeAnyData(key: "lcnShrtcde", value: String(cString: sqlite3_column_text(queryStatement, 3)))
                                     instanceOfUser.writeAnyData(key: "lcnPrntName", value: String(cString: sqlite3_column_text(queryStatement, 4)))
                                     instanceOfUser.writeAnyData(key: "spcCtrgId", value: String(cString: sqlite3_column_text(queryStatement, 5)))
                                     instanceOfUser.writeAnyData(key: "spcMTmId", value: String(cString: sqlite3_column_text(queryStatement, 6)))
                                     instanceOfUser.writeAnyData(key: "spcMTmNam", value: String(cString: sqlite3_column_text(queryStatement, 7)))
                                     instanceOfUser.writeAnyData(key: "spcCtrgNam", value: String(cString: sqlite3_column_text(queryStatement, 8)))
                                
                                     }
                      
                           }

                    sqlite3_finalize(queryStatement)
                    sqlite3_close(db)
                    db = nil
               }
        return spacdisNam
    }
}




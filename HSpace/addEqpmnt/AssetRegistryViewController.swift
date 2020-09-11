//
//  AssetRegistryViewController.swift
//  HSpace
//
//  Created by DEEBA on 20.07.20.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//

import UIKit
import SQLite3

class AssetRegistryViewController: UIViewController {
    let instanceOfUser = readWrite()
    var db:OpaquePointer? = nil
    var qryFld: String = "building"
    @IBOutlet weak var locationsTableView: UICollectionView!{
        didSet{
            settingServiceCollectionView()
        }
    }
    @IBAction func nextBt(_ sender: UIButton) {
        let vc = Constants.Storyboard.dshBrd.instantiateViewController(withIdentifier: Constants.Ids.rprtincidntViewController) as! rprtIncidntViewController
       vc.lcn = selectedLocationLabel.text
       vc.lcnPth = instanceOfUser.readStringData(key: "selLocn")
       vc.lcnidz = instanceOfUser.readStringData(key: "selLocnId")
       self.navigationController?.isNavigationBarHidden = false
       self.navigationController?.pushViewController(vc, animated: true)
        // self.performSegue(withIdentifier: "rprIncid", sender: nil)
    }
   
    @IBOutlet weak var nextButton: UIButton!
    private func settingServiceCollectionView(){
        
        let cellSize = CGSize(width:70 , height:70)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal //.vertical
        layout.itemSize = cellSize
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        //         layout.minimumLineSpacing = 1.0
        //         layout.minimumInteritemSpacing = 1.0
        locationsTableView.allowsMultipleSelection = false
        locationsTableView.allowsSelection = true
        //parentCollectionView.setCollectionViewLayout(layout, animated: true)
    }
    @IBOutlet weak var subLocationsTableView: UITableView!
    @IBOutlet weak var selectedLocationLabel: UILabel!
    var rootSelectedIndex: Int?
    var selectedLocations = [Location]()
    var dataTree: Location!
    var cntBloks: Int =  0
    var cntFlrs: Int =  0
    var cntRoms: Int =  0
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.configNavigationBar(title: "Select a Location")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
     let rootLocation = Location.BranchingCategory.chambers(usrInfoModls.company_name)
     var rootObjects = [Location]()
          for i in 0...cntBloks {
           //  getToken(Unam: (txtUser.text ?? nil)!,Pwd: (txtPwd.text ?? nil)!)

            flrMdl.spacId.removeAll()
            flrMdl.spacNam.removeAll()
            flrMdl.spacDisNam.removeAll()
            poplateFlrs(spcId: blkModl.spacId[i])
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
                    
                             while  sqlite3_step(queryStatement) == SQLITE_ROW {
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
    func poplateBlks()
    {
        
        var  strCount = 0
        var idy = ""
               let file_URL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
               .appendingPathComponent(instanceOfUser.readStringData(key: "dbNamez"))
               //opening the database
               if sqlite3_open(file_URL.path, &db) != SQLITE_OK {
                  print("There's error in opening the database")
               }
            else
                {
                    let tst = usrInfoModls.company_name
                  var queryStatementString = "SELECT space_id,space_name,space_display_name  FROM tbl_space_details WHERE space_category_type = ? and space_name = ?  ORDER BY space_seqid ASC ;"
                   var queryStatement: OpaquePointer?
                   // 1
                   if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) ==
                       SQLITE_OK {
                            //5F1!!!
                               // 2
                      sqlite3_bind_text(queryStatement, 1,(qryFld  as NSString).utf8String, -1, nil)
                      sqlite3_bind_text(queryStatement, 2, (tst as NSString).utf8String, -1, nil)
                    // sqlite3_bind_int(queryStatement, 1, (Int32(chsStrtMdl.idWO)))
                             // 2
                             while  sqlite3_step(queryStatement) == SQLITE_ROW {
                                    let spacIdz = Int(sqlite3_column_int(queryStatement, 0))
                                      let stringNam = String(cString: sqlite3_column_text(queryStatement, 1))
                                     let stringdisNam = String(cString: sqlite3_column_text(queryStatement, 2))
                                     blkModl.spacId.append(String(spacIdz))
                                     blkModl.spacNam.append(stringNam)
                                     blkModl.spacDisNam.append(stringdisNam)
                                     idy = String(cString: sqlite3_column_text(queryStatement, 0))
                                     }
                      
                           }

                    sqlite3_finalize(queryStatement)
                     queryStatementString = "SELECT COUNT(*) AS total_count  FROM tbl_space_details WHERE  space_category_type ='building' and space_name = ? ORDER BY space_seqid ASC"
                                   // 1
                                   if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) ==
                                       SQLITE_OK {
                                    sqlite3_bind_text(queryStatement, 1, (tst as NSString).utf8String, -1, nil)
                                            //5F1!!!
                                               // 2
                                             // 2
                                             if sqlite3_step(queryStatement) == SQLITE_ROW {
                                                            strCount =  Int(sqlite3_column_int(queryStatement, 0))
                                                     } else {
                                                       print("\nUPDATE statement is not prepared")
                                                     }
                                           }

                                    sqlite3_finalize(queryStatement)
                    if strCount > 0
                    {
                        blkModl.spacId.removeAll()
                        blkModl.spacNam.removeAll()
                        blkModl.spacDisNam.removeAll()
                        let queryStatementString = "SELECT space_id,space_name,space_display_name  FROM tbl_space_details WHERE space_parent_id =\(idy) ORDER BY space_seqid ASC"
                         var queryStatement : OpaquePointer? = nil
                        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
                            while sqlite3_step(queryStatement) == SQLITE_ROW {
                                let spacIdz = Int(sqlite3_column_int(queryStatement, 0))
                                  let stringNam = String(cString: sqlite3_column_text(queryStatement, 1))
                                 let stringdisNam = String(cString: sqlite3_column_text(queryStatement, 2))
                                 blkModl.spacId.append(String(spacIdz))
                                 blkModl.spacNam.append(stringNam)
                                 blkModl.spacDisNam.append(stringdisNam)
                            }
                            sqlite3_finalize(queryStatement)
                        }
                    }
                    sqlite3_close(db)
                    db = nil
               }
    }

}
extension AssetRegistryViewController: UITableViewDataSource, UITableViewDelegate {
    func currentSubcategories() -> [Location] {
        if let rootSelectedIndex = rootSelectedIndex {
            return rootBranchingCategories()[rootSelectedIndex].subcategories
        } else {
            return rootBranchingCategories().last!.subcategories
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return currentSubcategories().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SublocationCellasse
            let category = currentSubcategories()[indexPath.row]
        cell.nameLabel.text = category.name
            let isSelected = selectedLocations.contains(category)
            cell.selectedIndicatorInner.isHidden = !isSelected
            cell.selectedIndicatorOuter.borderColor = isSelected ? #colorLiteral(red: 0, green: 0.7424671054, blue: 0.957267344, alpha: 1) : #colorLiteral(red: 0.7540688515, green: 0.7540867925, blue: 0.7540771365, alpha: 1)
            return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
        reloadAllData()
    }
    
    func reloadAllData() {
        locationsTableView.reloadData()
        subLocationsTableView.reloadData()
        selectedLocationLabel.text = selectedLocations.last?.name
        let disNam = fndDisNam(selLocn: selectedLocationLabel.text!)
     //   lblDisNam.text = disNam.components(separatedBy: ",")[1]
        instanceOfUser.writeAnyData(key: "selLocn", value: disNam.components(separatedBy: ",")[1])
        instanceOfUser.writeAnyData(key: "selLocnId", value:  disNam.components(separatedBy: ",")[0])
        if  selectedLocationLabel.text != ""
        {
            nextButton.isHidden = false
        }
    }
    func fndDisNam(selLocn: String) -> String
    {
        var spcId =  0
               let file_URL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
               .appendingPathComponent(instanceOfUser.readStringData(key: "dbNamez"))
         var spacdisNam = ""
               //opening the database
               if sqlite3_open(file_URL.path, &db) != SQLITE_OK {
                  print("There's error in opening the database")
               }
            else
                {
                  let queryStatementString = "SELECT space_id,space_display_name  FROM tbl_space_details WHERE space_name = ?  ORDER BY space_seqid ASC ;"
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
                                     }
                      
                           }

                    sqlite3_finalize(queryStatement)
                    sqlite3_close(db)
                    db = nil
               }
        return spacdisNam
    }
}
extension AssetRegistryViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func rootBranchingCategories() -> [Location] {
        selectedLocations.filter { !$0.isFloor }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rootBranchingCategories().count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      let cell = locationsTableView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! LocationCellasse
        let category = rootBranchingCategories()[indexPath.row]
        cell.locationNameLabel.text = category.name
        cell.locationImageView.image = category.image
        
        if let rootSelectedIndex = rootSelectedIndex {
        //    cell.overlayView.isHidden = rootSelectedIndex == indexPath.row
        } else {
        //    cell.overlayView.isHidden = indexPath.row == rootBranchingCategories().count - 1
        }
        cell.layer.cornerRadius=10 //set corner radius here
        cell.layer.borderColor = UIColor.darkGray.cgColor
        cell.layer.borderWidth = 2
            cell.layer.borderColor = indexPath.row == rootSelectedIndex ?
                #colorLiteral(red: 0, green: 0.3774753511, blue: 0.8284870982, alpha: 1) :
                #colorLiteral(red: 0.7540688515, green: 0.7540867925, blue: 0.7540771365, alpha: 1)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        rootSelectedIndex = indexPath.row
        reloadAllData()
        self.view.layoutIfNeeded()
    }
}
class LocationCellasse: UICollectionViewCell, ReusableView {
    @IBOutlet weak var locationImageView: UIImageView!
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var overlayView: UIView!
}

class SublocationCellasse: UITableViewCell, ReusableView {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var selectedIndicatorOuter: DesignableView!
    @IBOutlet weak var selectedIndicatorInner: DesignableView!
}

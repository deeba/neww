//
//  EditAssetModifidViewController.swift
//  HelixSense
//
//  Created by DEEBA on 01.07.20.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//

import UIKit
import DropDown
import SwiftyJSON
class EditAssetModifidViewController: UIViewController {
    var ticketData: toBvaldtedLstMdl!
    let instanceOfUser = readWrite()
    var srl = ""
    var mdl = ""
    var mtbf = ""
    var mTm = ""
    var ctgry = ""
    var manufctrer = ""
    var purDte = ""
    var purVal = ""
    var vendr = ""
    var warrntyfrm = ""
    var warrntyTo = ""
    var amcTyp = ""
    var rskCst = ""
    var lcnId = 0
    var mTmId = 0
    var ctgryId = 0
    var ManfrId = 0
    @IBOutlet weak var txtFldLocation: FloatingLabelInput!
    @IBOutlet weak var txtFldEqName: FloatingLabelInput!
    @IBOutlet weak var txtFldEqNum: FloatingLabelInput!
    @IBOutlet weak var txtFldNum: FloatingLabelInput!
    @IBOutlet weak var txtFldModel: FloatingLabelInput!
    @IBOutlet weak var txtFldTeam: FloatingLabelInput!
    
   
    @IBOutlet weak var txtFldMTBF: FloatingLabelInput!
    @IBOutlet weak var txtFldCategory: FloatingLabelInput!
    @IBOutlet weak var txtFldCode: FloatingLabelInput!
    @IBOutlet weak var txtFldManuf: FloatingLabelInput!
    @IBOutlet weak var txtFldDate: FloatingLabelInput!
    @IBOutlet weak var txtFldValue : FloatingLabelInput!
    @IBOutlet weak var txtFldVendor: FloatingLabelInput!
    @IBOutlet weak var txtFldFromDate: FloatingLabelInput!
    @IBOutlet weak var txtFldToDate: FloatingLabelInput!
    @IBOutlet weak var txtFldType: FloatingLabelInput!
    @IBOutlet weak var txtFldCost: FloatingLabelInput!
    @IBOutlet weak var txtFldDescription: FloatingLabelInput!
    var amcTypArray: [String] = []
    var lcnArray: [String] = []
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
    func poplteLcn(Tkn: String) {

              var request = URLRequest(url: URL(string:"https://demo.helixsense.com/api/v2/isearch_read")!,timeoutInterval: Double.infinity)
              let string1 = "Bearer "
              let string2 = Tkn
              let combined2 = "\(string1) \(String(describing: string2))"
              request.addValue(combined2, forHTTPHeaderField: "Authorization")
              let stringFields = """
              &domain=[]&fields=["display_name"]
              """
                    
              let varRole = "\(String(describing: stringFields))"
              let postData = NSMutableData(data: "model=mro.equipment.location".data(using: String.Encoding.utf8)!)
              postData.append(varRole.data(using: String.Encoding.utf8)!)
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

                        let title = jsonc["data"]
                        //let title = jsonc["data"][0]["parent_category_id"][1].stringValue
                        if (title.count > 0){
                            for i in 0..<title.count {
                                lcnModl.lcnId.append(title[i]["id"].int!)
                                lcnModl.lcnNam.append(title[i]["display_name"].stringValue)
                                }
                            }
                        }
                       
                      catch let error as NSError {
                         print("Failed to load: \(error.localizedDescription)")
                      }
                      }
                         task1.resume()

                }
        func poplteFrm(Tkn: String) {
    //https://demo.helixsense.com/api/v2/isearch_read?model=mro.equipment&fields=["name","equipment_seq","serial","model","location_id","maintenance_team_id","mtbf_hours","category_id","manufacturer_id","warranty_start_date","warranty_end_date","purchase_date","purchase_value","vendor_id","amc_type","equipment_number","validation_status","risk_cost","commodity_id","image_medium"]&ids=[7581]
                  var request = URLRequest(url: URL(string:"https://demo.helixsense.com/api/v2/iread")!,timeoutInterval: Double.infinity)
                  let string1 = "Bearer "
                  let string2 = Tkn
                  let combined2 = "\(string1) \(String(describing: string2))"
                  request.addValue(combined2, forHTTPHeaderField: "Authorization")
                  let stringFields = """
                  &fields=["name","equipment_seq","serial","model","location_id","maintenance_team_id","mtbf_hours","category_id","manufacturer_id","warranty_start_date","warranty_end_date","purchase_date","purchase_value","vendor_id","amc_type","equipment_number","validation_status","risk_cost","commodity_id","image_medium"]&ids=[
                  """
                   let varId:Int =
                    Int(instanceOfUser.readStringData(key: "lcnId"))!
            print(Int(instanceOfUser.readStringData(key: "lcnId"))!)
                   let stringFields1 = """
                   ]
                   """
                  let varRole = "\(String(describing: stringFields))\(varId)\(String(describing: stringFields1))"
                  let postData = NSMutableData(data: "model=mro.equipment".data(using: String.Encoding.utf8)!)
                  postData.append(varRole.data(using: String.Encoding.utf8)!)
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
                            self.srl = jsonc["data"][0]["serial"].stringValue
                            self.mdl = jsonc["data"][0]["model"].stringValue
                            let myDouble = jsonc["data"][0]["mtbf_hours"].int!
                            self.mtbf = String(myDouble)
                            if (jsonc["data"][0]["category_id"][0].stringValue == "false" || jsonc["data"][0]["category_id"][0].stringValue == ""){
                              //   self.ctgry = ""
                                                       }
                                                       else{
                                                           self.ctgry  = jsonc["data"][0]["category_id"][1].stringValue
                                                       }
                            if (jsonc["data"][0]["manufacturer_id"][0].stringValue == "false" || jsonc["data"][0]["manufacturer_id"][0].stringValue == ""){
                              //   self.manufctrer = ""
                            }
                            else{
                                self.manufctrer  = jsonc["data"][0]["manufacturer_id"][1].stringValue
                            }
                            if (jsonc["data"][0]["vendor_id"][0].stringValue == "false" || jsonc["data"][0]["vendor_id"][0].stringValue == ""){
                              //   self.vendr = ""
                            }
                            else{
                                self.vendr  = jsonc["data"][0]["vendor_id"][1].stringValue
                            }
                            if (jsonc["data"][0]["maintenance_team_id"][0].stringValue == "false" || jsonc["data"][0]["maintenance_team_id"][0].stringValue == ""){
                              //   self.mTm = ""
                            }
                            else{
                                self.mTm  = jsonc["data"][0]["maintenance_team_id"][1].stringValue
                            }
                            
                            if (jsonc["data"][0]["amc_type"][0].stringValue == "false" || jsonc["data"][0]["amc_type"][0].stringValue == ""){
                               //  self.amcTyp = ""
                            }
                            else{
                                self.amcTyp  = jsonc["data"][0]["amc_type"][1].stringValue
                            }
                            if (jsonc["data"][0]["purchase_date"].stringValue == "false" || jsonc["data"][0]["purchase_date"].stringValue == ""){
                              //   self.purDte = ""
                            }
                                else{
                                    self.purDte = jsonc["data"][0]["purchase_date"].stringValue
                                }
                            if (jsonc["data"][0]["warranty_start_date"].stringValue == "false" || jsonc["data"][0]["warranty_start_date"].stringValue == ""){
                              //   self.warrntyfrm = ""
                            }
                                else{
                                    self.warrntyfrm = jsonc["data"][0]["warranty_start_date"].stringValue
                                }
                            if (jsonc["data"][0]["warranty_end_date"].stringValue == "false" || jsonc["data"][0]["warranty_end_date"].stringValue == ""){
                              //   self.warrntyTo = ""
                            }
                                else{
                                    self.warrntyTo = jsonc["data"][0]["warranty_end_date"].stringValue
                                }
                            self.purVal = jsonc["data"][0]["purchase_value"].stringValue
                            self.rskCst = jsonc["data"][0]["risk_cost"].stringValue
                            }
                           
                          catch let error as NSError {
                             print("Failed to load: c")
                          }
                          }
                             task1.resume()

                    }
      func ConstrctDta(Tkn: String)
          
      {
      var request = URLRequest(url: URL(string: "https://demo.helixsense.com/api/v2/isearch_read")!,timeoutInterval: Double.infinity)
      let string1 = "Bearer "
      let string2 = Tkn
          var closg = ""
      let combined2 = "\(string1) \(String(describing: string2))"
      request.addValue(combined2, forHTTPHeaderField: "Authorization")
      let stringFields = """
      []
      """
    
       closg = """
      ["name"]
      """
        
          
      let  stringRole1 = "&domain="
      let varRole = "\(stringRole1)\(String(describing: stringFields))"
      let stringDomain1 = "&fields="
      let varDomain = "\(stringDomain1)\(String(describing: closg))"
      let postData = NSMutableData(data: "model=mro.maintenance.team".data(using: String.Encoding.utf8)!)
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
               let title = jsonc["data"]
               //let title = jsonc["data"][0]["parent_category_id"][1].stringValue
               if (title.count > 0){
                   for i in 0..<title.count {
                      tmNamesModl.TmNam.append(jsonc["data"][i]["name"].stringValue)
                    tmNamesModl.TmId.append(jsonc["data"][i]["id"].int!)
                       }
                   }
               
                 }
              catch let error as NSError {
                 print("Failed to load: \(error.localizedDescription)")
              }
              }
                 task1.resume()

        }
    func poplteManufctr(Tkn: String)
      {
      var request = URLRequest(url: URL(string: "https://demo.helixsense.com/api/v2/isearch_read")!,timeoutInterval: Double.infinity)
      let string1 = "Bearer "
      let string2 = Tkn
          var closg = ""
      let combined2 = "\(string1) \(String(describing: string2))"
      request.addValue(combined2, forHTTPHeaderField: "Authorization")
      let stringFields = """
      ["display_name"]
      """
      let stringFields1 = """
      [["supplier","=",true]]
      """
      let stringDomain = "&domain="
      let stringDomain1 = "&fields="
      let varDomain = "\(stringDomain)\(String(describing: stringFields1))\(stringDomain1)\(String(describing: stringFields))"
      let postData = NSMutableData(data: "model=res.partner".data(using: String.Encoding.utf8)!)
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
               let title = jsonc["data"]
               //let title = jsonc["data"][0]["parent_category_id"][1].stringValue
               if (title.count > 0){
                   for i in 0..<title.count {
                    manufctrModl.manufctrNam.append(jsonc["data"][i]["display_name"].stringValue)
                    manufctrModl.manufctrId.append(jsonc["data"][i]["id"].int!)
                       }
                   }
               
                 }
              catch let error as NSError {
                 print("Failed to load: \(error.localizedDescription)")
              }
              }
                 task1.resume()

        }
    func poplteUNPSC(Tkn: String)
          
      {
      var request = URLRequest(url: URL(string: "https://demo.helixsense.com/api/v2/isearch_read")!,timeoutInterval: Double.infinity)
      let string1 = "Bearer "
      let string2 = Tkn
          var closg = ""
      let combined2 = "\(string1) \(String(describing: string2))"
      request.addValue(combined2, forHTTPHeaderField: "Authorization")
      let stringFields = """
      ["display_name"]
      """
    
      let stringDomain1 = "&fields="
      let varDomain = "\(stringDomain1)\(String(describing: stringFields))"
      let postData = NSMutableData(data: "model=code.unspsc".data(using: String.Encoding.utf8)!)
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
               let title = jsonc["data"]
               //let title = jsonc["data"][0]["parent_category_id"][1].stringValue
               if (title.count > 0){
                   for i in 0..<title.count {
                      uNPSCcde.cdeNam.append(jsonc["data"][i]["display_name"].stringValue)
                       }
                   }
               
                 }
              catch let error as NSError {
                 print("Failed to load: \(error.localizedDescription)")
              }
              }
                 task1.resume()

        }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // print(selectdEqp.dtls)
        lcnModl.lcnId.removeAll()
        lcnModl.lcnNam.removeAll()
        categryModl.categryNam.removeAll()
        categryModl.categryId.removeAll()
        tmNamesModl.TmNam.removeAll()
        tmNamesModl.TmId.removeAll()
       // amcTypArray.removeAll()
        poplteLcn(Tkn: self.instanceOfUser.readStringData(key: "accessTokenz"))
       // poplteFrm(Tkn: self.instanceOfUser.readStringData(key: "accessTokenz"))
        ConstrctDta(Tkn:self.instanceOfUser.readStringData(key: "accessTokenz") )
        poplteCategry(Tkn:self.instanceOfUser.readStringData(key: "accessTokenz") )
        poplteUNPSC(Tkn:self.instanceOfUser.readStringData(key: "accessTokenz") )
        poplteManufctr(Tkn:self.instanceOfUser.readStringData(key: "accessTokenz") )
        manufctrModl.manufctrNam.removeAll()
        manufctrModl.manufctrId.removeAll()
        uNPSCcde.cdeNam.removeAll()
        sleep(1)
        setupUI()
      //  lblLcn.text = selectdEqp.lcn
        txtFldLocation.text = selectdEqp.lcn
        txtFldEqName.text = selectdEqp.descrptn
        txtFldEqNum.text = selectdEqp.name
        txtFldCategory.text = selectdEqp.dtls
        txtFldDescription.text = selectdEqp.descrptn
        txtFldNum.text = srl
        txtFldModel.text = mdl
        txtFldTeam.text = mTm
        txtFldMTBF.text = String(mtbf)
        txtFldManuf.text = manufctrer
        txtFldDate.text = purDte
        txtFldValue.text = purVal
        txtFldVendor.text = vendr
        txtFldFromDate.text = warrntyfrm
        txtFldToDate.text = warrntyTo
        txtFldType.text = amcTyp
        txtFldCost.text = rskCst
        txtFldEqNum.isUserInteractionEnabled = false
       // view.backgroundColor = UIColor.clearColor()
       // view.isOpaque =  false
    }
      func poplteCategry(Tkn: String)
      {
      var request = URLRequest(url: URL(string: "https://demo.helixsense.com/api/v2/isearch_read")!,timeoutInterval: Double.infinity)
      let string1 = "Bearer "
      let string2 = Tkn
          var closg = ""
      let combined2 = "\(string1) \(String(describing: string2))"
      request.addValue(combined2, forHTTPHeaderField: "Authorization")
      let stringFields = """
      ["display_name"]
      """
    
      let stringDomain1 = "&fields="
      let varDomain = "\(stringDomain1)\(String(describing: stringFields))"
      let postData = NSMutableData(data: "model=mro.equipment.category".data(using: String.Encoding.utf8)!)
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
               let title = jsonc["data"]
               //let title = jsonc["data"][0]["parent_category_id"][1].stringValue
               if (title.count > 0){
                   for i in 0..<title.count {
                    categryModl.categryNam.append(jsonc["data"][i]["display_name"].stringValue)
                    categryModl.categryId.append(jsonc["data"][i]["id"].int!)
                       }
                   }
               
                 }
              catch let error as NSError {
                 print("Failed to load: \(error.localizedDescription)")
              }
              }
                 task1.resume()

        }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.configNavigationBar(title: "")
    }
    
    func setupUI() {
        
        setBorder(of: txtFldLocation)
        setBorder(of: txtFldEqName)
        setBorder(of: txtFldEqNum)
        setBorder(of: txtFldNum)
        setBorder(of: txtFldModel)
        setBorder(of: txtFldTeam)
        setBorder(of: txtFldMTBF)
        setBorder(of: txtFldCategory)
        setBorder(of: txtFldCode)
        setBorder(of: txtFldManuf)
        setBorder(of: txtFldDate)
        setBorder(of: txtFldValue)
        setBorder(of: txtFldVendor)
        setBorder(of: txtFldFromDate)
        setBorder(of: txtFldToDate)
        setBorder(of: txtFldType)
        setBorder(of: txtFldCost)
        setBorder(of: txtFldDescription)
        
        setDropDown(in: txtFldLocation, dataSource: lcnModl.lcnNam)
        setDropDown(in: txtFldTeam, dataSource: tmNamesModl.TmNam)
        setDropDown(in: txtFldCategory, dataSource: categryModl.categryNam)
        setDropDown(in: txtFldCode, dataSource: uNPSCcde.cdeNam)
        setDropDown(in: txtFldManuf, dataSource: manufctrModl.manufctrNam)
        setDropDown(in: txtFldVendor, dataSource: manufctrModl.manufctrNam)
        amcTypArray.append("Comprehensive")
        amcTypArray.append("Non-Comprehensive")
        setDropDown(in: txtFldType, dataSource: amcTypArray)
        setTrailingView(in: txtFldDate, image: UIImage(systemName: "calendar"))
        setTrailingView(in: txtFldFromDate, image: UIImage(systemName: "calendar"))
        setTrailingView(in: txtFldToDate, image: UIImage(systemName: "calendar"))
    }
    func setBorder(of tf: FloatingLabelInput) {
        tf.canShowBorder = true
        tf.borderColor = .darkGray
        tf.dtborderStyle = .rounded
        tf.paddingYFloatLabel = -7
    }
    
    func setDropDown(in tf: FloatingLabelInput, dataSource: [String] = ["1", "2", "3"]) {
        setTrailingView(in: tf, image: UIImage(systemName: "chevron.down"), tintColor: .gray)
        
        let dropDown = DropDown()
        dropDown.dataSource = dataSource
        dropDown.backgroundColor = UIColor.white
        dropDown.anchorView = tf
        
        tf.addGestureRecognizer(GestureRecognizerWithClosure {
            dropDown.show()
        })
        
        dropDown.selectionAction = { (index: Int, item: String) in
            dropDown.hide()
            tf.text = item
        }
    }
    
    func setTrailingView(in tf: FloatingLabelInput, image: UIImage?, tintColor: UIColor? = nil) {
        tf.rightViewMode = .always
        let imageView = UIImageView()
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 32, height: tf.frame.height))
        leftView.addSubview(imageView)
        imageView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        imageView.center = leftView.center
        if let color = tintColor {
            imageView.tintColor = color
        } else {
            imageView.tintColor = .black
            tf.addGestureRecognizer(GestureRecognizerWithClosure {
              if self.txtFldFromDate!.text == "" && tf.placeholder! == "Warranty To"  {
                self.showToast(message: "Please choose Warranty from date " )
                  }
                else
                {
                    let dateVC = self.storyboard!.instantiateViewController(withIdentifier: "DateSelectViewController") as! DateSelectViewController
                    //dateVC.txtFld = tf
                    dateVC.modalPresentationStyle = .overFullScreen
                    self.present(dateVC, animated: true)
                }
            })
        }
        tf.rightView = leftView
    }
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
    @IBAction func onClickBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickValidate(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        if txtFldEqNum.text == "" || txtFldCost.text == "" || txtFldType.text == "" || txtFldToDate.text == "" || txtFldFromDate.text == "" || txtFldVendor.text == "" || txtFldValue.text == "" || txtFldDate.text == "" || txtFldManuf.text == "" || txtFldMTBF.text == "" || txtFldTeam.text == "" || txtFldModel.text == "" || txtFldNum.text == "" || txtFldCode.text == "" ||  txtFldEqName.text == "" || txtFldCategory.text == "" || txtFldLocation.text == "" || txtFldDescription.text == ""
        {
            showToast(message: "Please fill in the fields")
        }
        else
        {
            let dateVC = self.storyboard!.instantiateViewController(withIdentifier: "valdteConfrmnViewController") as! valdteConfrmnViewController
                    dateVC.txtFldEqName = self.txtFldEqName
                    dateVC.txtFldEqNum = self.txtFldEqNum
                    dateVC.txtFldCost = self.txtFldCost
                    dateVC.txtFldType = self.txtFldType
                    dateVC.txtFldToDate = self.txtFldToDate
                    dateVC.txtFldFromDate = self.txtFldFromDate
                    dateVC.txtFldVendor = self.txtFldVendor
                    dateVC.txtFldValue = self.txtFldValue
                    dateVC.txtFldDate = self.txtFldDate
                    dateVC.txtFldManuf = self.txtFldManuf
                    dateVC.txtFldMTBF = self.txtFldMTBF
                    dateVC.txtFldTeam = self.txtFldTeam
                    dateVC.txtFldModel = self.txtFldModel
                    dateVC.txtFldNum = self.txtFldNum
            dateVC.cde = Int(self.txtFldCode.text!.components(separatedBy: "-")[0].trimmingCharacters(in: .whitespacesAndNewlines))!
                    dateVC.txtFldCategory = self.txtFldCategory
                    dateVC.txtFldLocation = self.txtFldLocation
                    dateVC.txtFldDescription = self.txtFldDescription
            
            self.lcnId = lcnModl.lcnId[find(value: self.txtFldLocation.text!, in: lcnModl.lcnNam)!]
            self.mTmId = tmNamesModl.TmId[find(value: self.txtFldTeam.text!, in: tmNamesModl.TmNam)!]
            self.ctgryId = categryModl.categryId[find(value: self.txtFldCategory.text!, in: categryModl.categryNam)!]
            self.ManfrId = manufctrModl.manufctrId[find(value: self.txtFldManuf.text!, in: manufctrModl.manufctrNam)!]
            dateVC.lcnId = self.lcnId
            dateVC.tmId = self.mTmId
            dateVC.catgrId = self.ctgryId
            dateVC.ManuId = self.ManfrId
                    dateVC.modalPresentationStyle = .overFullScreen
                    self.present(dateVC, animated: true)
        }
    }
    
    @IBAction func onClickCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

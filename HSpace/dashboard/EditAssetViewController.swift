//
//  EditAssetViewController.swift
//  HelixSense
//
//  Created by DEEBA on 24.06.20.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//

import UIKit
import DropDown
import SwiftyJSON
@available(iOS 13.0, *)
@available(iOS 13.0, *)
@available(iOS 13.0, *)
@available(iOS 13.0, *)
class EditAssetViewController: UIViewController {
    var ticketData: toBvaldtedLstMdl!
    let instanceOfUser = readWrite()
    var srl = ""
    var mdl = ""
    var mtbf = ""
    var mTm = ""
    
    @IBAction func btnGoBck() {
        self.dismiss(animated: true, completion: nil)
    }
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
    
    var lcnArray: [String] = []
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
                                self.lcnArray.append(title[i]["display_name"].stringValue)
                                }
                            }
                        }
                       
                      catch let error as NSError {
                         print("Failed to load: \(error.localizedDescription)")
                      }
                      }
                         task1.resume()

                }
        func polpteLcn(Tkn: String) {
    //https://demo.helixsense.com/api/v2/isearch_read?model=mro.equipment&fields=["name","equipment_seq","serial","model","location_id","maintenance_team_id","mtbf_hours","category_id","manufacturer_id","warranty_start_date","warranty_end_date","purchase_date","purchase_value","vendor_id","amc_type","equipment_number","validation_status","risk_cost","commodity_id","image_medium"]&ids=[7581]
                  var request = URLRequest(url: URL(string:"https://demo.helixsense.com/api/v2/isearch_read")!,timeoutInterval: Double.infinity)
                  let string1 = "Bearer "
                  let string2 = Tkn
                  let combined2 = "\(string1) \(String(describing: string2))"
                  request.addValue(combined2, forHTTPHeaderField: "Authorization")
                  let stringFields = """
                  &fields=["name","equipment_seq","serial","model","location_id","maintenance_team_id","mtbf_hours","category_id","manufacturer_id","warranty_start_date","warranty_end_date","purchase_date","purchase_value","vendor_id","amc_type","equipment_number","validation_status","risk_cost","commodity_id","image_medium"]&ids=[
                  """
                   let varId:Int = selectdEqp.id
                   let stringFields1 = """
                   ]
                   """
                  let varRole = "\(String(describing: stringFields))"
                  let postData = NSMutableData(data: "mro.equipment".data(using: String.Encoding.utf8)!)
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
                            let array = jsonc[0]["serial"]
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
        lcnArray.removeAll()
        poplteLcn(Tkn: self.instanceOfUser.readStringData(key: "accessTokenz"))
        sleep(1)
        print(self.lcnArray)
        setupUI()
      //  lblLcn.text = selectdEqp.lcn
        txtFldLocation.text = selectdEqp.lcn
        txtFldEqName.text = selectdEqp.descrptn
        txtFldEqNum.text = selectdEqp.name
        txtFldCategory.text = selectdEqp.dtls
        txtFldDescription.text = selectdEqp.descrptn
       // view.backgroundColor = UIColor.clearColor()
       // view.isOpaque =  false
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
        
        setDropDown(in: txtFldLocation, dataSource: lcnArray)
        setDropDown(in: txtFldTeam)
        setDropDown(in: txtFldCategory)
        setDropDown(in: txtFldCode)
        setDropDown(in: txtFldManuf)
        setDropDown(in: txtFldVendor)
        setDropDown(in: txtFldType)
        
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
                
            })
        }
        tf.rightView = leftView
    }
    
    @IBAction func onClickBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickValidate(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickCancel(_ sender: Any) {
       self.dismiss(animated: true, completion: nil)

    }
}

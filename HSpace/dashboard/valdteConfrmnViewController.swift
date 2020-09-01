//
//  valdteConfrmnViewController.swift
//  HelixSense
//
//  Created by DEEBA on 01.07.20.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//

import UIKit

class valdteConfrmnViewController: UIViewController {
    var tmId:Int=0
    var lcnId:Int=0
    var catgrId:Int=0
    var ManuId:Int=0
    var cde:Int=0
    var txtFldLocation: FloatingLabelInput!
    var txtFldEqName: FloatingLabelInput!
    var txtFldEqNum: FloatingLabelInput!
    var txtFldNum: FloatingLabelInput!
    var txtFldModel: FloatingLabelInput!
    var txtFldTeam: FloatingLabelInput!
    var txtFldMTBF: FloatingLabelInput!
    var txtFldCategory: FloatingLabelInput!
    var txtFldCode: FloatingLabelInput!
    var txtFldManuf: FloatingLabelInput!
    var txtFldDate: FloatingLabelInput!
    var txtFldValue : FloatingLabelInput!
    var txtFldVendor: FloatingLabelInput!
    var txtFldFromDate: FloatingLabelInput!
    var txtFldToDate: FloatingLabelInput!
    var txtFldType: FloatingLabelInput!
    var txtFldCost: FloatingLabelInput!
    var txtFldDescription: FloatingLabelInput!
    @IBAction func btnAcknowledge() {
        self.ackAPI(Tkn:self.instanceOfUser.readStringData(key: "accessTokenz") )
    }
    func ackAPI(Tkn: String) {
      //  {"name":"MAIN LT PANEL %231","serial":"NA","model":"NA","location_id":983,"maintenance_team_id":309,"mtbf_hours":4702,"category_id":2499,"warranty_start_date":"2020-07-01 18:30:0","warranty_end_date":"2020-07-02 18:30:0","purchase_date":"2020-07-01 18:30:0","purchase_value":"0.0","risk_cost":0,"commodity_id":"10101501","equipment_number":"MAIN LT PANEL %231","amc_type":"comprehensive","manufacturer_id":974,"validation_status":"Valid","validated_by":852,"validated_on":"2020-07-02 13:20:00","comment":"Test data"}&ids=[7562]#1","serial":"NA","model":"NA","location_id":983,"maintenance_team_id":309,"mtbf_hours":4702,"category_id":2499,"warranty_start_date":"2020-07-01 18:30:0","warranty_end_date":"2020-07-02 18:30:0","purchase_date":"2020-07-01 18:30:0","purchase_value":"0.0","risk_cost":0,"commodity_id":"10101501","equipment_number":"MAIN LT PANEL #1","amc_type":"comprehensive","manufacturer_id":974,"validation_status":"Valid","validated_by":852,"validated_on":"2020-07-02 13:20:00","comment":"Test data"}
    let idy = selectdEqp.id
                                  let stringFields1 = """
                                    {"name":"
                                    """
                                  let stringFields2 = """
                                  ","serial":"
                                  """
                                  let stringFields3 = """
                                  ","model":"
                                  """
                                  let stringFields4 = """
                                  ","location_id":
                                  """
                                  let stringFields5 = """
                                  ,"maintenance_team_id":
                                  """
                                  let stringFields6 = """
                                  ,"mtbf_hours":
                                  """
                                  let stringFields7 = """
                                  ,"category_id":
                                  """
                                  let stringFields8 = """
                                  ,"warranty_start_date":"
                                  """
                                  let stringFields9 = """
                                  ","warranty_end_date":"
                                  """
                                  let stringFields10 = """
                                  ","purchase_date":"
                                  """
                                  let stringFields11 = """
                                  ","purchase_value":"
                                  """
                                  let stringFields12 = """
                                  ","risk_cost":
                                  """
                                  let stringFields13 = """
                                  ,"commodity_id":"
                                  """
                                  let stringFields14 = """
                                  ","equipment_number":"
                                  """
                                  let stringFields15 = """
                                  ","amc_type":"
                                  """
                                  let stringFields16 = """
                                  ","manufacturer_id":
                                  """
                                  let stringFields17 = """
                                  ,"validation_status":"
                                  """
                                  let stringFields18 = """
                                  ","validated_by":
                                  """
                                  let stringFields19 = """
                                  ,"validated_on":"
                                  """
                                  let stringFields20 = """
                                  ","comment":"
                                  """
                                  let stringFields21 = """
                                  "}
                                  """
                                   let combined = "\(String(describing:stringFields1))\(String(describing:txtFldEqName))\(String(describing:stringFields2))\(String(describing:txtFldNum))\(String(describing:stringFields3))\(String(describing:txtFldModel))\(String(describing:stringFields4))\(lcnId)\(String(describing:stringFields5))\(tmId)\(String(describing:stringFields6))\(String(describing:txtFldMTBF))\(String(describing:stringFields7))\(String(describing:txtFldCategory))\(String(describing:stringFields1))\(String(describing:stringFields1))\(String(describing:stringFields1))\(String(describing:stringFields1))\(String(describing:stringFields1))\(String(describing:stringFields1))\(String(describing:stringFields1))\(String(describing:stringFields1))\(String(describing:stringFields1))\(String(describing:stringFields1))\(String(describing:stringFields1))\(String(describing:stringFields1))\(String(describing:stringFields1))\(String(describing:stringFields1))\(String(describing:stringFields1))\(String(describing:stringFields1))\(String(describing:stringFields1))\(String(describing:stringFields1))\(String(describing:stringFields1))\(String(describing:stringFields1))\(String(describing:stringFields1))\(String(describing:stringFields1))\(String(describing:stringFields1))\(String(describing:stringFields1))\(String(describing:stringFields1))\(String(describing:stringFields1))\(String(describing:stringFields1))\(String(describing:stringFields1))\(String(describing:stringFields1))\(String(describing:stringFields1))\(String(describing:stringFields1))\(String(describing:stringFields1))\(String(describing:stringFields1))\(String(describing:stringFields1))\(String(describing:stringFields1))\(String(describing:stringFields1))\(String(describing:stringFields1))\(String(describing:stringFields1))\(String(describing:stringFields1))\(String(describing:stringFields1))"
                                   
                                let    offsetFields1 = """
                                "}
                                """
    let    offsetFields2 = """
           ]
           """
        let  ids1 = "&ids=["
     let  stringRole5 = "&model=mro.equipment"
    let  stringRole2 = "&values="
    let    stringFields = "\(String(describing:stringRole5))\(String(describing:stringRole2))\(combined)(String(describing: ids1))\(idy)\(String(describing:offsetFields2))"
                                 let combinedOffset = "\(stringFields)"
                                                                let varRole = "\(String(describing: combinedOffset))"
                                                                    let url = NSURL(string: "https://demo.helixsense.com/api/v2/write") //Remember to put ATS exception if the URL is not https
                                                                                                  let request = NSMutableURLRequest(url: url! as URL)
                                                                                                      let string1 = "Bearer "
                                                                                                        let string2 = Tkn
                                                                                                        let combined2 = "\(string1) \(String(describing: string2))"

                                                                                                      request.addValue(combined2, forHTTPHeaderField: "Authorization")
                                                                                                  request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type") //Optional

                                                                                                  request.httpMethod = "PUT"
                                                                                                  let session = URLSession(configuration:URLSessionConfiguration.default, delegate: nil, delegateQueue: nil)
                                                                                                  let data = varRole.data(using: String.Encoding.utf8)
                                                                                                  request.httpBody = data


                                                                          let task1 = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
                                                                            guard let data = data else {
                                                                              print(String(describing: error))
                                                                              return
                                                                            }
                                                                           do {

                                                                              let jsonStr = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                                                                            print(jsonStr)
                                                                               let nwFlds = """
                                                                               "status": true
                                                                               """
                                                                               let varstts =  jsonStr?.contains("\(String(describing: nwFlds))") ?? false
                                                                               print(varstts)
                                                                               if varstts
                                                                                   {


                                                                            }

                                                                               }
                                                                               
                                                                           }

                                                                             
                                                                      task1.resume()

                                                                      }
    let instanceOfUser = readWrite()
    @IBOutlet weak var lblTitl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        lblTitl.text = "I, " + self.instanceOfUser.readStringData(key: "employeeNamez") + "validate " +  txtFldEqName.text! +  "at "  + instanceOfUser.readStringData(key: "LcnParent")
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

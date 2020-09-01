//
//  toBValidtedLblViewController.swift
//  HelixSense
//
//  Created by DEEBA on 27.06.20.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//

import UIKit
import SwiftyJSON

class toBValidtedLblViewController: UIViewController {
    let instanceOfUser = readWrite()
    @IBOutlet weak var eqpsinLcn: UILabel!
    @IBOutlet weak var eqpList: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchView: UIView!
    var ticketData: toBvaldtedLstMdl!
    var index = 0
    var tknz = ""
    var searchQuery = ""
    var eqpLstAry = [toBvaldtedLst]()
    var completion: ((toBvaldtedLst) -> Void)?
    func callAPI(Tkn: String){
            var    offsetFields = ""
            //5N
            
       // https://demo.helixsense.com/api/v2/isearch_read?model=mro.equipment&domain=[["validation_status","in",["None","Invalid"]]]&fields=["category_id","location_id","display_name","equipment_number","equipment_seq"]&limit=20&offset=20&length=true post
        
       // https://demo.helixsense.com/api/v2/isearch_read?model=mro.equipment&fields=["category_id","location_id","display_name","equipment_number","equipment_seq"]&length=true&limit=20&offset=0&domain=["%26",["location_id", "child_of", "DCS/BCS"],["validation_status","in",["None","Invalid"]]]],["validation_status","in",["None","Invalid"]]] post
        let stringOff =  self.instanceOfUser.readIntData(key:  "offsetzEqp")
            if instanceOfUser.readBoolData(key: "IsPrnt")
            {
                offsetFields = """
                &domain=[["validation_status","in",["None","Invalid"]]]&fields=["category_id","location_id","display_name","equipment_number","equipment_seq"]&limit=20&length=true&offset=
                """
             }
        else{
           offsetFields = """
           &domain=["%26",["location_id", "child_of","
           """
           let offsetFields1 = """
                "],["validation_status","in",["None","Invalid"]]]&fields=["category_id","location_id","display_name","equipment_number","equipment_seq"]&limit=20&length=true&offset=
                """
                offsetFields = "\(String(describing: offsetFields))\(instanceOfUser.readStringData(key: "selLocn"))\(offsetFields1)"
                
        }
            let reqstStr = "https://demo.helixsense.com/api/v2/isearch_read"
            let combinedOffset = "\(String(describing: offsetFields))\(stringOff)"
            let varRole = "\(String(describing: combinedOffset))"
            let mdl = "model=mro.equipment"
            let mthd = "POST"
            fetchFromAPI(paramy: varRole,reqsty: reqstStr,mdlz: mdl,htpMthd: mthd)
    }
    func fetchFromAPI(paramy: String,reqsty: String,mdlz: String,htpMthd: String) {
        tknz = instanceOfUser.readStringData(key: "accessTokenz")
        var catId :String = ""
        var catNam:String = ""
        var lcnId :String = ""
        var lcnNam:String = ""
        var title : JSON = [:]
        var request = URLRequest(url: URL(string:reqsty)!,timeoutInterval: Double.infinity)
        let varRole = "\(String(describing: paramy))"
        let string1 = "Bearer "
        let string2 = tknz
        let combined2 = "\(string1) \(String(describing: string2))"
        request.addValue(combined2, forHTTPHeaderField: "Authorization")
        let postData = NSMutableData(data: mdlz.data(using: String.Encoding.utf8)!)
        postData.append(varRole.data(using: String.Encoding.utf8)!)
        request.httpBody = postData as Data
        request.httpMethod = htpMthd
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
         title = jsonc["data"]
            if (title.count > 0){
            for i in 0..<title.count {
                if (title[i]["category_id"][0].stringValue == "false" || title[i]["category_id"][0].stringValue == ""){
                    catId = ""
                    catNam = ""
                }
                else{
                    catId = title[i]["category_id"][0].stringValue
                    catNam = title[i]["category_id"][1].stringValue
                }
                if (title[i]["location_id"][0].stringValue == "false" || title[i]["location_id"][0].stringValue == ""){
                    lcnId = ""
                    lcnNam = ""
                }
                else{
                    lcnId = title[i]["location_id"][0].stringValue
                    lcnNam = title[i]["location_id"][1].stringValue
                }
                self.eqpLstAry.append(toBvaldtedLst(id: title[i]["id"].int!, name: title[i]["equipment_seq"].stringValue, descrptn: title[i]["display_name"].stringValue,lcn: lcnNam, dtls: catNam))
                
        }
                        DispatchQueue.main.sync {
                        //Update UI
                            self.eqpList.reloadData()
                        }

                       
                        self.instanceOfUser.writeAnyData(key: "offsetzEqp", value: self.instanceOfUser.readIntData(key:  "offsetzEqp") + 20)


                        }
                        }
                        catch let error as NSError {
                        print("Failed to load: \(error.localizedDescription)")
                            title = "error"
                        }
                     }
                    task1.resume()
                    // return formated string
                }
    @IBAction func btnGoBck() {
        self.dismiss(animated: true, completion: nil)

       /* let viewController:
            UIViewController = UIStoryboard(
                name: "MainSdeStoryboard", bundle: nil
            ).instantiateViewController(withIdentifier: "asstSelLcn") as! asstSelLcnViewController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                             //show window
                             appDelegate.window?.rootViewController = viewController
           */
                     
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tknz = instanceOfUser.readStringData(key: "accessTokenz")
        eqpsinLcn.text = "Equipments in  " + instanceOfUser.readStringData(key: "LcnParent")
        eqpList.delegate = self
        eqpList.dataSource = self
        instanceOfUser.writeAnyData(key: "offsetzEqp", value: 0)
        callAPI(Tkn: tknz)
         /*for i in 0...100 {
            eqpLstAry.append(toBvaldtedLst(name: "Floor Drains \(i)", descrptn: "descrptn \(i)",lcn: "lcn \(i)", dtls: "dtls \(i)"))
        }
*/
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let destination = segue.destination as? EditAssetViewController,
            let subcategoryIndex = eqpList.indexPathForSelectedRow?.row {
            ticketData.ToBvaldtedLst = filteredCategories[subcategoryIndex]
            destination.ticketData = ticketData
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if let completion = completion, let selectedIndex = eqpList.indexPathForSelectedRow?.row {
            completion(filteredCategories[selectedIndex])
            return false
        }
        
        return true
    }
    
    @IBAction func showSearchView() {
        searchView.isHidden = false
        searchTextField.becomeFirstResponder()
    }
    
    @IBAction func closeSearchView() {
        searchView.isHidden = true
        searchTextField.resignFirstResponder()
        searchQuery = ""
        eqpList.reloadData()
    }
}

extension toBValidtedLblViewController: UITableViewDelegate, UITableViewDataSource {
    var filteredCategories: [toBvaldtedLst] {
        searchQuery.isEmpty ? eqpLstAry : eqpLstAry.filter { $0.name.lowercased().contains(searchQuery.lowercased()) }
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == eqpLstAry.count - 1
        {
            callAPI(Tkn: tknz)
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = toBValidtedLblCells.dequeue(from: tableView, for: indexPath)
        let subcategory = filteredCategories[indexPath.row]
        cell.nameLbl.text = subcategory.name
        cell.eqpDescrptnLbl.text = subcategory.descrptn
        cell.lcnLbl.text = subcategory.lcn
        cell.dtlsLbl.text = subcategory.dtls
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let subcategory = filteredCategories[indexPath.row]
        selectdEqp.name = subcategory.name
        selectdEqp.descrptn = subcategory.descrptn
        selectdEqp.lcn = subcategory.lcn
        selectdEqp.dtls = subcategory.dtls
        selectdEqp.id = subcategory.id
        let viewController:
            UIViewController = UIStoryboard(
                name: "MainSdeStoryboard", bundle: nil
            ).instantiateViewController(withIdentifier: "AssetRegistryMdfdViewController") as! EditAssetModifidViewController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                             //show window
                             appDelegate.window?.rootViewController = viewController
    }
    
}

extension toBValidtedLblViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        searchQuery = textField.text ?? ""
        print(eqpList!)
        eqpList.reloadData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}


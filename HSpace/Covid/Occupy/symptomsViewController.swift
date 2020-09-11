//
//  symptomsViewController.swift
//  HSpace
//
//  Created by DEEBA on 16.07.20.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//symptmsChecklist

import UIKit
extension UIApplication {

    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {


            return topViewController(controller: presented)
        }
        return controller
    }
}
class symptomsViewController: UIViewController {
    let instanceOfUser = readWrite()
    var selFlg = false
    @IBOutlet weak var itemTableView: UITableView!
    @IBOutlet weak var feelingLabel: UILabel!
    var locationArray : [ServiceModel] = [ServiceModel]()
    var subLocationArray : [SubLocation] = [SubLocation]()
    var db:DBHelper = DBHelper()
    var selectedChecklist:[symptmsChecklist] = []
    var checklist:[symptmsChecklist] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LoaderSpin.shared.showLoader(self)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        APIClient_redesign.shared().getTokenz { status in
        LoaderSpin.shared.hideLoader()
        if status {
        APIClient_redesign.shared().postSymptomsLst(chkLst_id: String(configurationModls.check_list_ids)){ count in
            self.checklist = count
            self.itemTableView.reloadData()
        }
        }
        }
        }

        feelingLabel.text = feelingLabel.text?.uppercased()
        itemTableView.separatorInset = .zero
        itemTableView.separatorColor = Colors.gray
       // insertDataToSQLite()
       // checklist = db.read()
        itemTableView.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.configNavigationBar(title: "Prescreen")
    }
    @IBAction func bookButtonPressed(_ sender: UIButton) {
        LoaderSpin.shared.showLoader(self)
        APIClient_redesign.shared().getTokenz { status in
            if status{
        for i in 0..<self.checklist.count {
            if self.checklist[i].answer == "no"
            {
            }
            else
            {
                self.selFlg = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                APIClient_redesign.shared().postSymptomAnswers(activtyId:String(self.checklist[i].symptmsId),answr:self.checklist[i].answer){ id in
                }
                }
        }
        }
        }
        let mainTabBarController = Constants.Storyboard.dshBrd.instantiateViewController(withIdentifier: Constants.Ids.gnrlpractizViewController) as! gnrlPractizViewController
        
        mainTabBarController.symptms = selFlg
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.pushViewController(mainTabBarController, animated: true)
    }
    internal func resetSublocation(){
        for item in 0..<subLocationArray.count{
            subLocationArray[item].isSelected = false
        }
    }
}
//MARK: - Table View delegate and data source
extension symptomsViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checklist.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "catagoryCell", for: indexPath) as! ItemTableViewCell
        cell.selectionStyle = .none
        cell.catagoryTitle.text = checklist[indexPath.row].question
        if checklist[indexPath.row].syncStatus == 1{
            cell.selectLocationButton.tintColor = Colors.themeBlueLIGHT
            cell.selectLocationButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        }else {
            cell.selectLocationButton.tintColor = Colors.gray
            cell.selectLocationButton.setImage(UIImage(systemName: "circle"), for: .normal)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        checklist[indexPath.row].answer = checklist[indexPath.row].answer == "no" ? "yes" : "no"
        if checklist[indexPath.row].syncStatus == 0 {
            checklist[indexPath.row].syncStatus = 1
        }
        else
        {
            checklist[indexPath.row].syncStatus = 0
            
        }
        itemTableView.reloadData()
    }
}


//
//  rprtIncidntViewController.swift
//  HSpace
//
//  Created by DEEBA on 21.07.20.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//

import UIKit

class rprtIncidntViewController: UIViewController , UITextFieldDelegate, UITextViewDelegate {
    var lcn:String!
    var lcnPth:String!
    var lcnidz:String!
    let instanceOfUser = readWrite()
   func showToast(message: String) {
           let toastLabel = UITextView(frame: CGRect(x: self.view.frame.size.width/16, y: self.view.frame.size.height-250, width: self.view.frame.size.width * 7/8, height: 50))
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
           UIView.animate(withDuration: 5.0, delay: 2, options: .curveEaseOut, animations: {
               toastLabel.alpha = 0.0
           }, completion: {(isCompleted) in
               toastLabel.removeFromSuperview()
           })
   }
    @IBOutlet weak var lbldescrpn: UITextField!
    @IBAction func btnSubmit(_ sender: UIButton) {
        let typcatgry = "asset"
        let chnl = "mobile_app"
        let issutyp = "request"
        if lbldescrpn.text != ""
        {
          // LoaderSpin.shared.showLoader(self)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            APIClient_redesign.shared().getTokenz
            {status in
            APIClient.shared().submtIncidnt_new(Tkn:self.instanceOfUser.readStringData(key: "accessTokenz"), subj:self.lbldescrpn.text!,category:typcatgry,categoryId:tenantModl.ticket_category_id,subcategoryId:tenantModl.sub_category_id,channel:chnl,issue_type:issutyp ,tenant_id:tenantModl.id,asset_id:self.lcnidz,maintenance_team_id:tenantModl.maintenance_team_id,at_done_mro:true) { id in
                }

        }
                self.showToast(message: "Thank You!You will be contacted by the COVID support team shortly.")
                               
                   let storyboard = UIStoryboard(name: "cvdDashbrdStoryboard", bundle: nil)
                   let mainTabBarController = storyboard.instantiateViewController(identifier: "tabBarStory")
                   mainTabBarController.modalPresentationStyle = .fullScreen
                   self.present(mainTabBarController, animated: true, completion: nil)
    }
             
            }
            else {
            showToast(message: "Please fill in the description ")
        }
    }
    @IBAction func descrpn(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    @IBAction func btnCncl(_ sender: Any) {
        let storyboard = UIStoryboard(name: "cvdDashbrdStoryboard", bundle: nil)
        let mainTabBarController = storyboard.instantiateViewController(identifier: "tabBarStory")
        mainTabBarController.modalPresentationStyle = .fullScreen
        self.present(mainTabBarController, animated: true, completion: nil)
    }
   
    @IBAction func btnValidUpdte(_ sender: Any) {
    }
    
    
    @IBOutlet weak var lblMTeam: FloatingLabelInput!
    @IBOutlet weak var lblSubCategry: FloatingLabelInput!
    @IBOutlet weak var lblCatgry: FloatingLabelInput!
    @IBOutlet weak var lblLcnPath: FloatingLabelInput!
    @IBOutlet weak var lblBdgNam: FloatingLabelInput!
    override func viewDidLoad() {
        super.viewDidLoad()
        lblBdgNam.text = usrInfoModls.company_name
        lblLcnPath.text = lcn + "(" + lcnPth + ")"
        lblCatgry.text = tenantModl.ticket_category_nam.string
        lblSubCategry.text = tenantModl.sub_category_nam.string
        lblMTeam.text = tenantModl.maintenance_team_nam.string
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.configNavigationBar(title: "Report COVID incident ")
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

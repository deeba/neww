//
//  OccpyRedesignViewController.swift
//  HSpace
//
//  Created by DEEBA on 26.08.20.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//

import UIKit

class OccpyRedesignViewController: UIViewController {
    var wrkSpac: String!
    var wrkSpacPth: String!
    var Dte: String!
    var Mnth: String!
    var Tim: String!
    var urlStr = ""
    var stts = ""
    @IBOutlet weak var imgVw: UIImageView!
    var Shft: String!
    @IBOutlet weak var lblTim: UILabel!
    @IBOutlet weak var lblShft: UILabel!
    @IBOutlet weak var lblWrkSpacPth: UILabel!
    @IBAction func btnPrs(_ sender: UIButton) {
        if  self.stts == "Notallow"
                                {
                                 let ackTitle = "Sorry,You are not allowed to access %@ "
                                 let titleLbl  = String(format: ackTitle, curntSchedulModll.space_name )
                                 let alert = UIAlertController(title: "Booking Status", message:titleLbl, preferredStyle: UIAlertController.Style.alert)
                                 alert.addAction(UIAlertAction(title: "OK", style: .default, handler:
                                     { (action) in
                                            
                                                LoaderSpin.shared.showLoader(self)
                                                 let storyboard = UIStoryboard(name: "cvdDashbrdStoryboard", bundle: nil)
                                                 let mainTabBarController = storyboard.instantiateViewController(identifier: "tabBarStory")
                                                 self.navigationController?.isNavigationBarHidden = true
                                                 self.navigationController?.pushViewController(mainTabBarController, animated: true)
                                             
                                     }))
                                     present(alert, animated: true,completion: nil)
                                }
                                 else if  self.stts == "allow"
                                 {
                                     let ackTitle = "Welcome,You are allowed to access %@ "
                                       let titleLbl  = String(format: ackTitle, curntSchedulModll.space_name )
                                       let alert = UIAlertController(title: "Confirmation", message:titleLbl, preferredStyle: UIAlertController.Style.alert)
                                     alert.addAction(UIAlertAction(title: "OK", style: .default, handler:
                                         { (action) in
                                                LoaderSpin.shared.showLoader(self)
                                                 let storyboard = UIStoryboard(name: "cvdDashbrdStoryboard", bundle: nil)
                                                 let mainTabBarController = storyboard.instantiateViewController(identifier: "tabBarStory")
                                                 self.navigationController?.isNavigationBarHidden = true
                                                 self.navigationController?.pushViewController(mainTabBarController, animated: true)
                                             
                                     }))

                                    present(alert, animated: true,completion: nil)
                                 }
    }
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblWrkSpacNum: UILabel!
    @IBOutlet weak var lblMnth: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        lblDate.text = Dte
        lblMnth.text = Mnth
        lblTim.text = Tim
        lblShft.text = Shft
        lblWrkSpacNum.text = wrkSpac
        lblWrkSpacPth.text = wrkSpacPth
        let site_id = usrInfoModls.company_id
        let shift_id = curntSchedulModll.id
        let employee_id = curntSchedulModll.employee_id
        /*
         access/check  ->.  site_id => company_id,  shift_id  =>  booking (id),  employee_id => employee_id
         */
        urlStr = "https://demo.helixsense.com/api/v3/access/check?site_id=" + String(site_id) + "&shift_id=" + String(shift_id)
        urlStr = urlStr + "&employee_id=" + String(employee_id)
        self.imgVw.image = self.generateQRCode(from:urlStr)
        imgVw.addGestureRecognizer(GestureRecognizerWithClosure.init(action: {
         //   DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        APIClient_redesign.shared().getTokenz { status in
                          if status {
                            APIClient_redesign.shared().getAccessCheck(siteid: String(site_id),shftid: String(shift_id),empid: String(employee_id)){ count in
                                
                                if count
                                {// allow
                                    let ackTitle = "Welcome,You are allowed to access %@ "
                                      let titleLbl  = String(format: ackTitle, curntSchedulModll.space_name )
                                      let alert = UIAlertController(title: "Confirmation", message:titleLbl, preferredStyle: UIAlertController.Style.alert)
                                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler:
                                        { (action) in
                                               sleep(1)
                                               LoaderSpin.shared.showLoader(self)
                                                let storyboard = UIStoryboard(name: "cvdDashbrdStoryboard", bundle: nil)
                                                let mainTabBarController = storyboard.instantiateViewController(identifier: "tabBarStory")
                                                self.navigationController?.isNavigationBarHidden = true
                                                self.navigationController?.pushViewController(mainTabBarController, animated: true)
                                            
                                    }))

                                    self.present(alert, animated: true,completion: nil)
                                }
                                else
                                {//not allow
                                 let ackTitle = "Sorry,You are not allowed to access %@ "
                                 let titleLbl  = String(format: ackTitle, curntSchedulModll.space_name )
                                 let alert = UIAlertController(title: "Booking Status", message:titleLbl, preferredStyle: UIAlertController.Style.alert)
                                 alert.addAction(UIAlertAction(title: "OK", style: .default, handler:
                                     { (action) in
                                                sleep(1)
                                                LoaderSpin.shared.showLoader(self)
                                                 let storyboard = UIStoryboard(name: "cvdDashbrdStoryboard", bundle: nil)
                                                 let mainTabBarController = storyboard.instantiateViewController(identifier: "tabBarStory")
                                                 self.navigationController?.isNavigationBarHidden = true
                                                 self.navigationController?.pushViewController(mainTabBarController, animated: true)
                                             
                                     }))
                                     self.present(alert, animated: true,completion: nil)
                                }
                            }
                   }
                        
                            }
               // }
        }))
    }
    
    func generateQRCode(from string: String) -> UIImage?
    {
        let data = string.data(using: String.Encoding.ascii)

        if let filter = CIFilter(name: "CIQRCodeGenerator")
        {
            filter.setValue(data, forKey: "inputMessage")

            guard let qrImage = filter.outputImage else {return nil}
            let scaleX = self.imgVw.frame.size.width / qrImage.extent.size.width
            let scaleY = self.imgVw.frame.size.height / qrImage.extent.size.height
            let transform = CGAffineTransform(scaleX: scaleX, y: scaleY)

            if let output = filter.outputImage?.transformed(by: transform)
            {
                return UIImage(ciImage: output)
            }
        }
        return nil
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.configNavigationBar(title: "Access")
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

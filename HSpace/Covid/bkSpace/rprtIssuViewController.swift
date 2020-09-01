//
//  rprtIssuViewController.swift
//  HSpace
//
//  Created by DEEBA on 19.07.20.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//

import UIKit

class rprtIssuViewController: UIViewController , UITextFieldDelegate, UITextViewDelegate {

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
    @IBAction func btnSubmit(_ sender: UIButton) {
       showToast(message: "Thank You!You will be contacted by the COVID support team shortly.")
       LoaderSpin.shared.showLoader(self)
       sleep(2)
       let storyboard = UIStoryboard(name: "cvdDashbrdStoryboard", bundle: nil)
       let mainTabBarController = storyboard.instantiateViewController(identifier: "tabBarStory")
       mainTabBarController.modalPresentationStyle = .fullScreen
       self.present(mainTabBarController, animated: true, completion: nil)
    }
    @IBAction func descrpn(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    @IBAction func btnCncl(_ sender: Any) {
        LoaderSpin.shared.showLoader(self)
        sleep(2)
            let storyboard = UIStoryboard(name: "cvdDashbrdStoryboard", bundle: nil)
            let mainTabBarController = storyboard.instantiateViewController(identifier: "tabBarStory")
            mainTabBarController.modalPresentationStyle = .fullScreen
            self.present(mainTabBarController, animated: true, completion: nil)
    }
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var shrtCde: FloatingLabelInput!
    @IBOutlet weak var lblLcn: FloatingLabelInput!
    @IBAction func btnValidUpdte(_ sender: Any) {
    }
    @IBOutlet weak var spcCatgry: FloatingLabelInput!
    @IBOutlet weak var CovidIncident: FloatingLabelInput!
    @IBOutlet weak var lblCtgry: FloatingLabelInput!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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

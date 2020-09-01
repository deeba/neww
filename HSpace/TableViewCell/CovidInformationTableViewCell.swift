//
//  CovidInformationTableViewCell.swift
//  HelixSense
//
//  Created by DEEBA on 07.07.20.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//

import UIKit

class CovidInformationTableViewCell: UITableViewCell {
    

    @IBAction func btnAttndnce(_ sender: UIButton)
    {
       // goToWebView()
       // https://www.redcross.org/get-help/how-to- prepare-for-emergencies/types-of- emergencies/coronavirus-safety.html
        let myUrl = "http://www.google.com"
        //let myUrl = "https://www.9healthfair.org/blog/advice- from-a-doctor-coronavirus-dos-and-donts/
           if let url = URL(string: "\(myUrl)"), !url.absoluteString.isEmpty {
               UIApplication.shared.open(url, options: [:], completionHandler: nil)
           }

           // or outside scope use this
           guard let url = URL(string: "\(myUrl)"), !url.absoluteString.isEmpty else {
              return
           }

        
    }
    
    
    // Typical usage

    @IBAction func btnRprtIssu(_ sender: UIButton) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "cvdDashbrdStoryboard", bundle: nil)
             let newViewController = storyBoard.instantiateViewController(withIdentifier: "MyShifts") as! MyShiftsVC
             let appDelegate = UIApplication.shared.delegate as! AppDelegate
             //show window
             appDelegate.window?.rootViewController = newViewController
    }
    
    @IBAction func btndosDnts() {
    }
    private func goToWebView(){
        let vc = UIStoryboard(name: "webViewStoryboard", bundle: nil).instantiateViewController(withIdentifier: "WebViewController") as! webViewController

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //show window
        appDelegate.window?.rootViewController = vc
        
    }
    @IBAction func btnSfty() {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "cvdDashbrdStoryboard", bundle: nil)
             let newViewController = storyBoard.instantiateViewController(withIdentifier: "attendnce") as! attendnceViewController
             let appDelegate = UIApplication.shared.delegate as! AppDelegate
             //show window
             appDelegate.window?.rootViewController = newViewController
    }
    private func callNumber(phoneNumber:String) {

      if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {

        let application:UIApplication = UIApplication.shared
        if (application.canOpenURL(phoneCallURL)) {
            application.open(phoneCallURL, options: [:], completionHandler: nil)
        }
        
      }
    }
    @IBAction func callCovidcntre() {
        callNumber(phoneNumber: "+919874563215")
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

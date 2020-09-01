//
//  webViewController.swift
//  HSpace
//
//  Created by DEEBA on 19.07.20.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//
import UIKit
import WebKit

class webViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            title = webView.title
            
        }
        
    var dosLink: String!
    var saftyLink: String!
     let instanceOfUser = readWrite()
    @IBOutlet weak var webView: WKWebView!
    var loadURL = ""
    
    //let loadURL = "https://www.9healthfair.org/blog/advice- from-a-doctor-coronavirus-dos-and-donts/"
    override func viewDidLoad() {
        super.viewDidLoad()
        print(self.instanceOfUser.readStringData(key: "covidsafety"))
        if (self.instanceOfUser.readStringData(key: "dos_safty") == "dos")
        {
            loadURL = dosLink
        }
        else
        {
            loadURL = saftyLink
        }
        
        self.instanceOfUser.writeAnyData(key: "dos_safty", value: "")
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"Back", style:.plain, target:nil, action:nil)
               webView.uiDelegate = self
               webView.navigationDelegate = self
        self.webView.load(URLRequest(url: URL(string: self.loadURL)!))
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

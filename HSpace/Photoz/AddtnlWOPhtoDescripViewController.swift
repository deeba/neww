//
//  AddtnlWOPhtoDescripViewController.swift
//  AMTfm
//
//  Created by DEEBA on 27.05.20.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//

import UIKit

class AddtnlWOPhtoDescripViewController: UIViewController, UITextFieldDelegate {
     let instanceOfUser = readWrite()
    @IBOutlet weak var txtDescrip: UITextField!
    
    @IBOutlet weak var btnOk: UIButton!
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.tagBasedTextField(textField)
        return true
    }
    private func tagBasedTextField(_ textField: UITextField) {
            textField.resignFirstResponder()
    }
    @IBAction func btnOk(_ sender: UIButton) {
        self.instanceOfUser.writeAnyData(key: "descriptn", value: "")
        if (txtDescrip.text!) != ""
        {
            self.instanceOfUser.writeAnyData(key: "descriptn", value: txtDescrip.text!)
        let viewController:
               UIViewController = UIStoryboard(
                   name: "AddtnlWOPhtoStoryboard", bundle: nil
               ).instantiateViewController(withIdentifier: "AddtnlWOPhtoStory") as! AddtnlWOPhtoViewController
                               // .instantiatViewControllerWithIdentifier() returns AnyObject!
                               // this must be downcast to utilize it

                               let appDelegate = UIApplication.shared.delegate as! AppDelegate
                               //show window
                               appDelegate.window?.rootViewController = viewController
         }
        else
        {
            
            showToast(message: "Please enter the description " )
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        txtDescrip.delegate = self
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
}

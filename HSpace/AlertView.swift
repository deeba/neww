//
//  AlertView.swift
//  CustomAlert
//
//  Created by SHUBHAM AGARWAL on 31/12/18.
//  Copyright © 2018 SHUBHAM AGARWAL. All rights reserved.
//

import Foundation
import UIKit

class AlertView: UIView {
    
    static let instance = AlertView()
    
    @IBOutlet var parentView: UIView!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var messageLbl: UILabel!
    @IBOutlet weak var doneBtn: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        Bundle.main.loadNibNamed("AlertView", owner: self, options: nil)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
      //  img.layer.cornerRadius = 30
        img.layer.borderColor = UIColor.white.cgColor
        img.layer.borderWidth = 0
        
        alertView.layer.cornerRadius = 24
        parentView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        parentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        parentView.backgroundColor =   #colorLiteral(red: 0.5098039216, green: 0.5098039216, blue: 0.5098039216, alpha: 1)
    }
    
    enum AlertType {
        case success
        case failure
    }
    
    func showAlert(title: String, message: String, alertType: AlertType) {
        self.titleLbl.text = title
        self.messageLbl.text = message
        
        switch alertType {
        case .success:
            img.image = UIImage(named: "Success")
            doneBtn.backgroundColor = #colorLiteral(red: 0.999904573, green: 1, blue: 0.9998808503, alpha: 1) // #colorLiteral(red: 0.7685594559, green: 0.7686710954, blue: 0.7685350776, alpha: 1)
            doneBtn.layer.cornerRadius = 20
        case .failure:
            img.image = UIImage(named: "Failure")
            doneBtn.layer.cornerRadius = 20
            doneBtn.backgroundColor = #colorLiteral(red: 0.2830431461, green: 0.7269189954, blue: 0.9830313325, alpha: 1)
        }
        
        UIApplication.shared.keyWindow?.addSubview(parentView)
    }
    
    
    
    @IBAction func onClickDone(_ sender: Any) {
        parentView.removeFromSuperview()
        //exit app
        exit(0)
    }
    
    
    
    
    
    
    
}

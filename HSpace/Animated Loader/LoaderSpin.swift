//
//  LoaderSpin.swift
//  HSpace
//
//  Created by DEEBA on 15.08.20.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//
import Foundation
import SVProgressHUD

class LoaderSpin {
    
    var loaderView: LoaderView!
    static let shared = LoaderSpin()
    
    private init() {
        let nib = UINib(nibName: "LoaderView", bundle: nil)
        loaderView = nib.instantiate(withOwner: nil, options: nil)[0] as? LoaderView
        loaderView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }
    func showLoader(_ sender: UIViewController) {
        loaderView.frame = CGRect(x: 0, y: 0, width: sender.view.frame.width, height: sender.view.frame.height)
        sender.view.addSubview(loaderView)
    }

    
    func hideLoader() {
        DispatchQueue.main.async {
            self.loaderView.removeFromSuperview()
        }
    }
    
    static func show() {
        SVProgressHUD.setForegroundColor(Constants.Color.lightBlue)
        SVProgressHUD.setBackgroundColor(Constants.Color.lightBlue.withAlphaComponent(0.1))
        SVProgressHUD.resetOffsetFromCenter()
        SVProgressHUD.show()
        if !UIApplication.shared.isIgnoringInteractionEvents {
            UIApplication.shared.beginIgnoringInteractionEvents() //freeze app
        }
    }
    
    static func showProgress(progress:Float) {
        SVProgressHUD.setForegroundColor(Constants.Color.lightBlue)
        SVProgressHUD.setBackgroundColor(Constants.Color.lightBlue.withAlphaComponent(0.1))
        SVProgressHUD.resetOffsetFromCenter()
        SVProgressHUD.showProgress(progress)
        if !UIApplication.shared.isIgnoringInteractionEvents {
            UIApplication.shared.beginIgnoringInteractionEvents() //freeze app
        }
    }
    
    static func hide() {
        SVProgressHUD.dismiss()
        UIApplication.shared.endIgnoringInteractionEvents() //unfreeze app
    }
}

//
//  Extensions.swift
//  HelixSense
//
//  Created by DEEBA on 22.06.20.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//

import Foundation
@IBDesignable
class CustomizeView:UIView {
    @IBInspectable
    var borderColor:UIColor = .clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable
    var borderWidth:CGFloat = 0.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable
    var cornerRadius:CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable
    var masksToBounds:Bool = true {
        didSet {
            layer.masksToBounds = masksToBounds
        }
    }
    
    @IBInspectable
    var shadowOpacity:Float = 0 {
        didSet {
            layer.shadowOpacity = shadowOpacity
        }
    }
    
    @IBInspectable
    var shadowColor:UIColor = .clear {
        didSet {
            layer.shadowColor = shadowColor.cgColor
        }
    }
    
    @IBInspectable
    var shadowRadius:CGFloat = 3 {
        didSet {
            layer.shadowRadius = shadowRadius
        }
    }
    
    @IBInspectable
    var shadowOffset:CGSize = CGSize(width: 0, height: 0) {
        didSet {
            layer.shadowOffset = shadowOffset
        }
    }
    
}

final class GestureRecognizerWithClosure: UITapGestureRecognizer {
    private var action: () -> Void
    
    init(action: @escaping () -> Void) {
        self.action = action
        super.init(target: nil, action: nil)
        self.addTarget(self, action: #selector(execute))
    }
    
    @objc private func execute() {
        action()
    }
}

enum DateFormat:String {
    case yyyyMMddHHmmss = "yyyy-MM-dd HH:mm:ss +SSSS"
    case ddMMMyyyy = "dd-MM-yyyy"
}

extension String {
    
    func convertDateFormat(from frmDtFrmt:DateFormat, to toDtFrmt:DateFormat) -> String {
        let strDate = self.components(separatedBy: ".").first ?? ""
        
        if strDate == "" {
            return ""
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current //  TimeZone(identifier: "UTC")
        dateFormatter.dateFormat = frmDtFrmt.rawValue
        let date = dateFormatter.date(from: strDate) ?? Date()
        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = toDtFrmt.rawValue
        return dateFormatter.string(from: date)
    }
}

@available(iOS 13.0, *)
extension UIViewController {
    
    func configNavigationBar(title: String) {
//        self.navigationController?.navigationBar.tintColor = Constants.Color.lightBlue
        self.navigationController?.navigationBar.barTintColor = Constants.Color.lightBlue
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        let view = UIView(frame: CGRect(x: 4, y: 4, width: self.view.frame.width - 30, height: (self.navigationController?.navigationBar.frame.height ?? 44) - 8))
        view.backgroundColor = Constants.Color.darkBlue
        
        let backBtn = UIButton(frame: CGRect(x: 0, y: (view.frame.height - 32) / 2, width: 32, height: 32))
        backBtn.translatesAutoresizingMaskIntoConstraints = true
        backBtn.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backBtn.tintColor = .white
        backBtn.contentEdgeInsets = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 4)
        backBtn.addTarget(self, action: #selector(onClickBack), for: .touchUpInside)
        
        let label = UILabel(frame: CGRect(x: 30, y: 0, width: self.view.frame.width - 100, height: view.frame.height))
        label.textColor = .white
        label.text = "Equipment Validation"
        
        view.addSubview(backBtn)
        view.addSubview(label)
        view.layer.cornerRadius = 4
        
        let barButton = UIBarButtonItem(customView: view)
        self.navigationItem.leftBarButtonItem = barButton
    }
    
    @objc func onClickBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
}

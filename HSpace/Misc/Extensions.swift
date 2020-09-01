//
//  Extensions.swift
//  AMTfm
//
//  Created by Serge Vysotsky on 03.06.2020.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//

import UIKit
import Foundation
@IBDesignable class customView: UIButton {
    
    
    @IBInspectable var customBorderColor: UIColor = UIColor.clear {
        didSet {
            refreshBorderColor(_color: customBorderColor)
        }
    }
    
    @IBInspectable var customBorderWidth: CGFloat = 0 {
        didSet {
            refreshBorderWidth(_value: customBorderWidth)
        }
    }
    
    @IBInspectable var cornerRadiuss: CGFloat = 0 {
        didSet {
            refreshCR(_value: cornerRadiuss)
        }
    }
    
    func refreshCR(_value: CGFloat) {
        layer.cornerRadius = _value
    }
    
    func refreshBorderColor(_color: UIColor) {
        layer.borderColor = _color.cgColor
    }
    
    func refreshBorderWidth(_value: CGFloat) {
        layer.borderWidth = _value
    }
    
    //    @IBInspectable var customBGColor: UIColor = UIColor.init(red: 0, green: 122/255, blue: 255/255, alpha: 1) {
    //        didSet {
    //            refreshColor(_color: customBGColor)
    //        }
    //    }
    
    func refreshColor(_color: UIColor) {
        print("refreshColor(): \(_color)")
        let size: CGSize = CGSize(width: 1, height: 1)
        UIGraphicsBeginImageContextWithOptions(size, true, 0.0)
        _color.setFill()
        UIRectFill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let bgImage: UIImage = (UIGraphicsGetImageFromCurrentImageContext() as UIImage?)!
        UIGraphicsEndImageContext()
        setBackgroundImage(bgImage, for: UIControl.State.normal)
        clipsToBounds = true
    }
    
    override init(frame: CGRect) {
        print("init(frame:)")
        super.init(frame: frame);
        
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        print("init?(coder:)")
        super.init(coder: aDecoder)
        
        sharedInit()
    }
    
    override func prepareForInterfaceBuilder() {
        print("prepareForInterfaceBuilder()")
        sharedInit()
    }
    
    func sharedInit() {
        refreshCR(_value: cornerRadiuss)
        //        refreshColor(_color: customBGColor)
        //        self.tintColor = UIColor.white
    }
}
@IBDesignable extension UIButton {

    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }

    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }

    @IBInspectable var borderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
    
}
@IBDesignable  class CustomView: UIView {
    
    
    @IBInspectable var customBorderColor: UIColor = UIColor.clear {
        didSet {
            refreshBorderColor(_color: customBorderColor)
        }
    }
    
    @IBInspectable var customBorderWidth: CGFloat = 0 {
        didSet {
            refreshBorderWidth(_value: customBorderWidth)
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            refreshCR(_value: cornerRadius)
        }
    }
    
    func refreshCR(_value: CGFloat) {
        layer.cornerRadius = _value
    }
    
    func refreshBorderColor(_color: UIColor) {
        layer.borderColor = _color.cgColor
    }
    
    func refreshBorderWidth(_value: CGFloat) {
        layer.borderWidth = _value
    }
    
    //    @IBInspectable var customBGColor: UIColor = UIColor.init(red: 0, green: 122/255, blue: 255/255, alpha: 1) {
    //        didSet {
    //            refreshColor(_color: customBGColor)
    //        }
    //    }
    
    
    
    override init(frame: CGRect) {
        print("init(frame:)")
        super.init(frame: frame);
        
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        print("init?(coder:)")
        super.init(coder: aDecoder)
        
        sharedInit()
    }
    
    public override func prepareForInterfaceBuilder() {
        print("prepareForInterfaceBuilder()")
        sharedInit()
    }
    
    func sharedInit() {
        refreshCR(_value: cornerRadius)
        //        refreshColor(_color: customBGColor)
        //        self.tintColor = UIColor.white
    }
}

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
class Alertz {
    
    private init() {
        
    }
    
    private static func getAlert(title: String?, message: String?) -> UIAlertController {
        return UIAlertController(title: title, message: message, preferredStyle: .alert)
    }
    
    static func show(_ title:String, _ message:String, _ actionName:String = Constants.Ok) {
        let alert = getAlert(title: title, message: message)
        alert.addAction(UIAlertAction(title: actionName, style: .cancel, handler: nil))
        UIApplication.shared.windows.last?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    static func show(_ title:String, _ message:String, _ confirmAction:String = Constants.Ok, onSelectConfirm:@escaping (Bool) -> Void) {
        let alert = getAlert(title: title, message: message)
        alert.addAction(UIAlertAction(title: confirmAction, style: .default, handler: { (_) in
            onSelectConfirm(true)
        }))
        UIApplication.shared.windows.last?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    static func show(_ title:String, _ message:String, _ cancelAction:String, _ confirmAction:String, onSelectConfirm:@escaping (Bool) -> Void) {
        let alert = getAlert(title: title, message: message)
        alert.addAction(UIAlertAction(title: cancelAction, style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: confirmAction, style: .default, handler: { (_) in
            onSelectConfirm(true)
        }))
        UIApplication.shared.windows.last?.rootViewController?.present(alert, animated: true, completion: nil)
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
    case yyyyMMddHHmmssSSSS = "yyyy-MM-dd HH:mm:ss +SSSS"
    case ddMMMyyyy = "dd-MM-yyyy"
    case yyyyMMddHHmmss = "yyyy-MM-dd HH:mm:ss"
}

extension UIView {
    func roundCornerWithMaskedCorners(corners: CACornerMask, radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.maskedCorners = corners
        
    }
}
extension UINavigationItem {
    
    func setTitle(_ title: String, subtitle: String, time : String, height : CGFloat, weidth : CGFloat, navigationController : UINavigationController) {
        let appearance = UINavigationBar.appearance()
        let textColor = appearance.titleTextAttributes?[NSAttributedString.Key.foregroundColor] as? UIColor ?? .white
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .preferredFont(forTextStyle: UIFont.TextStyle.footnote)
        titleLabel.textAlignment = .left
        titleLabel.textColor = textColor
        
        let timeLabel = UILabel()
        timeLabel.text = time
        timeLabel.textAlignment = .right
        timeLabel.font = .preferredFont(forTextStyle: UIFont.TextStyle.footnote)
        timeLabel.textColor = textColor
        let subtitleLabel = UILabel()
        subtitleLabel.text = subtitle
        subtitleLabel.font = .preferredFont(forTextStyle: UIFont.TextStyle.caption1)
        subtitleLabel.textAlignment = .left
        subtitleLabel.textColor = .white
        
        let timesubtitleLabel = UILabel()
        timesubtitleLabel.text = ""
        timesubtitleLabel.font = .preferredFont(forTextStyle: UIFont.TextStyle.caption1)
        timesubtitleLabel.textColor = .white
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.axis = .vertical
        let timeStackView = UIStackView(arrangedSubviews: [timeLabel, timesubtitleLabel])
        timeStackView.distribution = .fillEqually
        timeStackView.alignment = .fill
        timeStackView.axis = .vertical
        let rightStackView = UIStackView(arrangedSubviews: [stackView, timeStackView])
        rightStackView.distribution = .fillEqually
        rightStackView.alignment = .fill
        rightStackView.axis = .horizontal
        rightStackView.translatesAutoresizingMaskIntoConstraints = false
        let menuImageView = UIImageView()
        menuImageView.image = UIImage(systemName: "line.horizontal.3")
        menuImageView.translatesAutoresizingMaskIntoConstraints = false
        let mainStackView = UIStackView(arrangedSubviews: [menuImageView, rightStackView])
        mainStackView.distribution = .fill
        mainStackView.alignment = .center
        mainStackView.spacing = 5
        mainStackView.axis = .horizontal
//        mainStackView.addBackground(color: .red)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        menuImageView.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor, constant: 0).isActive = true
        menuImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        rightStackView.leadingAnchor.constraint(equalTo: menuImageView.trailingAnchor, constant: 5).isActive = true
        rightStackView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor, constant: 0).isActive = true
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: height - 10))
        view.layer.cornerRadius = 5
        view.backgroundColor = UIColor(red:0.00, green:0.00, blue:0.00, alpha:0.3)
        view.addSubview(mainStackView)
        mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 4).isActive = true
        mainStackView.widthAnchor.constraint(equalToConstant: view.frame.width - 50).isActive = true
        mainStackView.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
        mainStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        mainStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        self.titleView = view
    }
}
extension UIStackView {
    func addBackground(color: UIColor) {
        let subView = UIView(frame: bounds)
        subView.backgroundColor = color
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(subView, at: 0)
    }
}
extension Data{
    func converToString() -> String{
        return String(decoding: self, as: UTF8.self)
    }
}
extension String {
    
        func convertDateFormat(from frmDtFrmt:DateFormat, to toDtFrmt:DateFormat) -> String {
        let strDate = self.components(separatedBy: ".").first ?? ""
        
        if strDate == "" {
            return ""
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "UTC") // TimeZone.current
        dateFormatter.dateFormat = frmDtFrmt.rawValue
        let date = dateFormatter.date(from: strDate) ?? Date()
        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = toDtFrmt.rawValue
        return dateFormatter.string(from: date)
    }
    func isValidateFormat(_ format:StringFormats) -> Bool {
        let regEx = format.rawValue
        let str = NSPredicate(format:"SELF MATCHES %@", regEx)
        return str.evaluate(with: self)
    }
}

@available(iOS 13.0, *)
extension UIViewController {
    func popupAlert(title: String?, message: String?, actionTitles:[String?], actions:[((UIAlertAction) -> Void)?]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for (index, title) in actionTitles.enumerated() {
            let action = UIAlertAction(title: title, style: .default, handler: actions[index])
            alert.addAction(action)
        }
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    @IBAction func back() {
           navigationController?.popViewController(animated: true)
       }
       
       @IBAction func resignResponder() {
           view.endEditing(true)
       }
       
       @IBAction func dismissController() {
           dismiss(animated: true)
       }
    func configNavigationBar(title: String) {
    //        self.navigationController?.navigationBar.tintColor = Constants.Color.lightBlue
        self.navigationController?.navigationBar.barTintColor = UIColor.white
            self.navigationController?.navigationBar.isTranslucent = true
            self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
            let view = UIView(frame: CGRect(x: 4, y: 4, width: self.view.frame.width - 30, height: (self.navigationController?.navigationBar.frame.height ?? 44) - 8))
            //view.backgroundColor = UIColor.white
            
            let backBtn = UIButton(frame: CGRect(x: 0, y: (view.frame.height - 32) / 2, width: 32, height: 32))
            backBtn.translatesAutoresizingMaskIntoConstraints = true
            backBtn.setImage(UIImage(named: "Back"), for: .normal)
            backBtn.tintColor = .black
            backBtn.contentEdgeInsets = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 4)
            backBtn.addTarget(self, action: #selector(onClickBack), for: .touchUpInside)
            
        let label = UILabel(frame: CGRect(x: (self.view.frame.width - self.view.frame.width/1.3) + 20, y: 0, width: self.view.frame.width - 100, height: view.frame.height))
            label.textColor = .black
            label.text = title
            
            view.addSubview(backBtn)
            view.addSubview(label)
            view.layer.cornerRadius = 4
            
            let barButton = UIBarButtonItem(customView: view)
            self.navigationItem.leftBarButtonItem = barButton
        }
    
    @objc func onClickBack() {
        
        LoaderSpin.shared.showLoader(self)
         APIClient_redesign.shared().getTokenz { status in
                   if status {
                       APIClient.shared().dashBrdApi()
                     }
                   }
        let storyboard = UIStoryboard(name: "cvdDashbrdStoryboard", bundle: nil)
        let mainTabBarController = storyboard.instantiateViewController(identifier: "tabBarStory")
        mainTabBarController.modalPresentationStyle = .fullScreen
        self.present(mainTabBarController, animated: true, completion: nil)
    }
    
}

extension UIAlertController {
    static func showAlert(title: String, message: String, vc: UIViewController, buttonTitles:[String], buttonStyles:[UIAlertAction.Style], completion: @escaping (Int)->Void) {
        
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        var index = 0
        
        for btnTitle in buttonTitles {
            alert.addAction(UIAlertAction(title: btnTitle, style: buttonStyles[index], handler: {_ in
                completion(buttonTitles.firstIndex(of: btnTitle)!)
            }))
            
            index += 1
        }
        DispatchQueue.main.async {
            
            vc.present(alert, animated: true, completion: nil)
        }
    }
    
    static func showActionSheet(title: String, message: String, vc: UIViewController, buttonTitles:[String], buttonStyles:[UIAlertAction.Style], completion: @escaping (Int)->Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        var index = 0
        
        for btnTitle in buttonTitles {
            alert.addAction(UIAlertAction(title: btnTitle, style: buttonStyles[index], handler: {action in
                UIApplication.shared.keyWindow?.windowLevel = UIWindow.Level.normal
                completion(buttonTitles.firstIndex(of: action.title!)!)
            }))
            index += 1
        }
        DispatchQueue.main.async {
            
            
            vc.present(alert, animated: true, completion: nil)
            
        }
    }
}

extension Date {
    var startOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 1, to: sunday)
    }
    
    var endOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 7, to: sunday)
    }
    
    var startOfMonth: Date? {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: self))!
    }
    
    var endOfMonth: Date? {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth!)!
    }
    
    func getTimeDifference(fromDate:Date, toDate:Date) -> String{
        let hoursBtw = Calendar.current.dateComponents([.hour, .minute, .second], from: fromDate, to: toDate)
        var timeDiff = ""
        if hoursBtw.hour! > 0{
            timeDiff = "\(hoursBtw.hour!)h "
        }
        if hoursBtw.minute! > 0{
            timeDiff = "\(timeDiff)\(hoursBtw.minute!)m "
        }
        if hoursBtw.second! > 0{
            timeDiff = "\(timeDiff)\(hoursBtw.second!)s"
        }
        if timeDiff.last == " "{
            timeDiff.removeLast()
        }
        
        return timeDiff
    }
    
    func getDayDifference(fromDate:Date, toDate:Date) -> String{
        // Replace the hour (time) of both dates with 00:00
        let date1 = Calendar.current.startOfDay(for: fromDate)
        let date2 = Calendar.current.startOfDay(for: toDate)
        
        let dayDiff = Calendar.current.dateComponents([Calendar.Component.day], from: date1, to: date2)
        if dayDiff.day! > 0{
            return "(+\(dayDiff.day!))"
        }
        
        return ""
    }
    

}

extension Calendar {
    
    func dayOfWeek(_ date: Date) -> Int {
        var dayOfWeek = self.component(.weekday, from: date) + 1 - self.firstWeekday
        
        if dayOfWeek <= 0 {
            dayOfWeek += 7
        }
        
        return dayOfWeek
    }
    
    func startOfWeek(_ date: Date) -> Date {
        return self.date(byAdding: DateComponents(day: -self.dayOfWeek(date) + 1), to: date)!
    }
    
    func endOfWeek(_ date: Date) -> Date {
        return self.date(byAdding: DateComponents(day: 6), to: self.startOfWeek(date))!
    }
    
    func startOfMonth(_ date: Date) -> Date {
        return self.date(from: self.dateComponents([.year, .month], from: date))!
    }
    
    func endOfMonth(_ date: Date) -> Date {
        return self.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth(date))!
    }
    
    func startOfQuarter(_ date: Date) -> Date {
        let quarter = (self.component(.month, from: date) - 1) / 3 + 1
        return self.date(from: DateComponents(year: self.component(.year, from: date), month: (quarter - 1) * 3 + 1))!
    }
    
    func endOfQuarter(_ date: Date) -> Date {
        return self.date(byAdding: DateComponents(month: 3, day: -1), to: self.startOfQuarter(date))!
    }
    
    func startOfYear(_ date: Date) -> Date {
        return self.date(from: self.dateComponents([.year], from: date))!
    }
    
    func endOfYear(_ date: Date) -> Date {
        return self.date(from: DateComponents(year: self.component(.year, from: date), month: 12, day: 31))!
    }
}

extension Dictionary {
    var json: String {
        let invalidJson = "Not a valid JSON"
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return String(bytes: jsonData, encoding: String.Encoding.utf8) ?? invalidJson
        } catch {
            return invalidJson
        }
    }
    
    func dict2json() -> String {
        return json
    }
}


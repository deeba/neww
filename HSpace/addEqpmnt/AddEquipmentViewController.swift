//
//  AddEquipmentViewController.swift
//  HSpace
//
//  Created by DEEBA on 20.07.20.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class AddEquipmentViewController: UIViewController {
    
    @IBOutlet weak var attachPhotoView: UIView!
    @IBOutlet weak var imagesShowConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var txtFldLocation: FloatingLabelInput!
    @IBOutlet weak var txtFldEqName: FloatingLabelInput!
    @IBOutlet weak var txtFldEqNum: FloatingLabelInput!
    @IBOutlet weak var txtFldNum: FloatingLabelInput!
    @IBOutlet weak var txtFldModel: FloatingLabelInput!
    @IBOutlet weak var txtFldTeam: FloatingLabelInput!
    @IBOutlet weak var txtFldMTBF: FloatingLabelInput!
    @IBOutlet weak var txtFldCategory: FloatingLabelInput!
    @IBOutlet weak var txtFldCode: FloatingLabelInput!
    @IBOutlet weak var txtFldManuf: FloatingLabelInput!
    @IBOutlet weak var txtFldDate: FloatingLabelInput!
    @IBOutlet weak var txtFldValue : FloatingLabelInput!
    @IBOutlet weak var txtFldVendor: FloatingLabelInput!
    @IBOutlet weak var txtFldFromDate: FloatingLabelInput!
    @IBOutlet weak var txtFldToDate: FloatingLabelInput!
    @IBOutlet weak var txtFldType: FloatingLabelInput!
    @IBOutlet weak var txtFldCost: FloatingLabelInput!
    @IBOutlet weak var txtFldDescription: IQTextView!
    @IBOutlet weak var floatPlaceholder: UILabel!
    
    var spaceName: String!

    var location = ""
    var purchaseDate: Date? {
        didSet {
            txtFldDate.text = purchaseDate?.description.convertDateFormat(from: .yyyyMMddHHmmssSSSS, to: .ddMMMyyyy)
        }
    }
    var fromDate: Date? {
        didSet {
            txtFldFromDate.text = fromDate?.description.convertDateFormat(from: .yyyyMMddHHmmssSSSS, to: .ddMMMyyyy)
        }
    }
    var toDate: Date? {
        didSet {
            txtFldToDate.text = toDate?.description.convertDateFormat(from: .yyyyMMddHHmmssSSSS, to: .ddMMMyyyy)
        }
    }
    var images = [UIImage]() {
        didSet {
            imageCollectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.configNavigationBar(title: "Select a Location")
    }
    
    func setupUI() {
            setBorder(of: txtFldLocation)
            setBorder(of: txtFldEqName)
            setBorder(of: txtFldEqNum)
            setBorder(of: txtFldNum)
            setBorder(of: txtFldModel)
            setBorder(of: txtFldTeam)
            setBorder(of: txtFldMTBF)
            setBorder(of: txtFldCategory)
            setBorder(of: txtFldCode)
            setBorder(of: txtFldManuf)
            setBorder(of: txtFldDate)
            setBorder(of: txtFldValue)
            setBorder(of: txtFldVendor)
            setBorder(of: txtFldFromDate)
            setBorder(of: txtFldToDate)
            setBorder(of: txtFldType)
            setBorder(of: txtFldCost)

            txtFldDescription.layer.cornerRadius = 4.5
            txtFldDescription.layer.borderWidth = 1
            txtFldDescription.layer.borderColor = UIColor.darkGray.cgColor
            
            APIClient.shared().getLocation { (data) in
                    self.txtFldLocation.text = self.location
                
                self.setDropDown(in: self.txtFldLocation, dataSource: data, screenType: .Location)
            }
            APIClient.shared().getTeam { (data) in
                self.setDropDown(in: self.txtFldTeam, dataSource: data, screenType: .Team)
            }
            APIClient.shared().getCategory { (data) in
                self.setDropDown(in: self.txtFldCategory, dataSource: data, screenType: .Category)
            }
            APIClient.shared().getUNSPSC { (data) in
                self.setDropDown(in: self.txtFldCode, dataSource: data, screenType: .Code)
            }
            APIClient.shared().getPartner { (data) in
                self.setDropDown(in: self.txtFldManuf, dataSource: data, screenType: .Manuf)
                self.setDropDown(in: self.txtFldVendor, dataSource: data, screenType: .Vendor)
            }
            self.setDropDown(in: self.txtFldType, dataSource: ["Comprehensive", "Non-Comprehensive"], screenType: .Types)
            
            setTrailingView(in: txtFldDate, image: UIImage(systemName: "calendar"))
            setTrailingView(in: txtFldFromDate, image: UIImage(systemName: "calendar"))
            setTrailingView(in: txtFldToDate, image: UIImage(systemName: "calendar"))
            
            attachPhotoView.addGestureRecognizer(GestureRecognizerWithClosure.init(action: {
                let storyBoard: UIStoryboard = UIStoryboard(name: "addEqpmntStoryboard", bundle: nil)
                let ImagePickerVC = storyBoard.instantiateViewController(withIdentifier: Constants.Ids.imagePickerViewController) as! ImagePickerViewController
                ImagePickerVC.onImageSelect = { newImage in
                    self.images.append(newImage)
                }
                self.present(ImagePickerVC, animated: true)
            }))
        }
        
        func setBorder(of tf: FloatingLabelInput) {
            tf.canShowBorder = true
            tf.borderColor = .darkGray
            tf.dtborderStyle = .rounded
            tf.paddingYFloatLabel = -7
        
            tf.delegate = self
        }
        
        func setDropDown(in tf: FloatingLabelInput, dataSource: [String], screenType: ItemType) {
            setTrailingView(in: tf, image: UIImage(systemName: "chevron.down"), tintColor: .gray)
            
            tf.addGestureRecognizer(GestureRecognizerWithClosure {
                let storyBoard: UIStoryboard = UIStoryboard(name: "addEqpmntStoryboard", bundle: nil)
                let vc = storyBoard.instantiateViewController(withIdentifier: Constants.Ids.itemSelectionViewController) as! ItemSelectionViewController
               
                vc.items = dataSource
                vc.type = screenType
                vc.selectionTitle = "Select \(tf.placeholder ?? "")"
                if let data = tf.text, !data.isEmptyStr {
                    vc.selectedItem = data
                }
                vc.onItemSelect = { item in
                    tf.text = item
                }
                self.present(vc, animated: true)
            })
        }
        
        func setTrailingView(in tf: FloatingLabelInput, image: UIImage?, tintColor: UIColor? = nil) {
          //  tf.ignoreSwitchingByNextPrevious = true
            tf.rightViewMode = .always
            let imageView = UIImageView()
            imageView.image = image
            imageView.contentMode = .scaleAspectFit
            let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 32, height: tf.frame.height))
            leftView.addSubview(imageView)
            imageView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
            imageView.center = leftView.center
            if let color = tintColor {
                imageView.tintColor = color
            } else {
                imageView.tintColor = .black
                tf.addGestureRecognizer(GestureRecognizerWithClosure {
                    let storyBoard: UIStoryboard = UIStoryboard(name: "addEqpmntStoryboard", bundle: nil)
                    let dateVC = storyBoard.instantiateViewController(withIdentifier: Constants.Ids.dateSelectViewController) as! DateSelectViewController
                    switch tf {
                    case self.txtFldDate:
                        dateVC.maximumDate = Date()
                    case self.txtFldFromDate:
                        dateVC.maximumDate = Date()
                    case self.txtFldToDate:
                        if self.fromDate != nil {
                            dateVC.minimumDate = Calendar.current.date(byAdding: .day, value: 1, to: self.fromDate!)
                        }
                    default:
                        break
                    }
                    dateVC.onDateSelect = { date in
                        switch tf {
                        case self.txtFldDate:
                            self.purchaseDate = date
                        case self.txtFldFromDate:
                            self.fromDate = date
                            if self.toDate != nil, self.toDate!.compare(self.fromDate!) == .orderedAscending {
                                self.toDate = nil
                            }
                            
                        case self.txtFldToDate:
                            self.toDate = date
                        default:
                            break
                        }
                    }
                    self.present(dateVC, animated: true)
                })
            }
            tf.rightView = leftView
        }
    
    @IBAction func onClickBack(_ sender: Any) {
         self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onClickValidate(_ sender: Any) {
        
        for view in txtFldLocation.superview!.subviews {
            if let tf = view as? UITextField, tf.text ?? "" == "" {
                Alertz.show("", (tf.placeholder ?? "") + " Data is Empty") { _ in
                    switch tf.tag {
                    case 1, 2, 3, 4, 6, 11, 16, 17:
                        tf.becomeFirstResponder()
                    default:
                        for gstr in tf.gestureRecognizers ?? [] {
                            if let gesture = gstr as? GestureRecognizerWithClosure {
                                gesture
                            }
                        }
                    }
                }
                return
            } else if let tv = view as? IQTextView, tv.text ?? "" == "" {
                Alertz.show("", (tv.placeholder ?? "") + " Data is Empty") { _ in
                    tv.becomeFirstResponder()
                }
                return
            }
        }
        
        var data = Equipment()
         data.location = "\(APIClient.shared().location?.first(where: {txtFldLocation.text == $0.1})?.0 ?? APIClient.shared().location?.first?.0 ?? 0)"
        //data.location = "\(APIClient.location?.first(where: {txtFldLocation.text == $0.1})?.0 ?? 0)"
        data.eqName   = txtFldEqName.text
        data.eqNum    = txtFldEqNum.text
        data.num      = txtFldNum.text
        data.model    = txtFldModel.text
        data.team     = "\(APIClient.shared().team?.first(where: {txtFldTeam.text == $0.1})?.0 ?? 0)"
        data.mtbf     = txtFldMTBF.text
        data.category = "\(APIClient.shared().category?.first(where: {txtFldCategory.text == $0.1})?.0 ?? 0)"
        data.code     = "\(APIClient.shared().code?.first(where: {txtFldCode.text == $0.1})?.0 ?? 0)"
        data.manuf    = "\(APIClient.shared().partner?.first(where: {txtFldManuf.text == $0.1})?.0 ?? 0)"
        data.date     = purchaseDate?.description.convertDateFormat(from: .yyyyMMddHHmmssSSSS, to: .yyyyMMddHHmmss)
        data.value    = txtFldValue.text
        data.vendor   = "\(APIClient.shared().partner?.first(where: {txtFldVendor.text == $0.1})?.0 ?? 0)"
        data.fromDate = fromDate?.description.convertDateFormat(from: .yyyyMMddHHmmssSSSS, to: .yyyyMMddHHmmss)
        data.toDate   = toDate?.description.convertDateFormat(from: .yyyyMMddHHmmssSSSS, to: .yyyyMMddHHmmss)
        data.type     = txtFldType.text == "Comprehensive" ? "comprehensive" : "non_comprehensive"
        data.cost     = txtFldCost.text
        data.description = txtFldDescription.text
        
        APIClient.shared().createID(data: data) { id in
            if id != nil {
                let storyBoard: UIStoryboard = UIStoryboard(name: "addEqpmntStoryboard", bundle: nil)
                let ValidationVC = storyBoard.instantiateViewController(withIdentifier: Constants.Ids.validationViewController) as! ValidationViewControllerz
                ValidationVC.userName = "vicky"
                ValidationVC.data = data
                ValidationVC.spaceName = self.spaceName ?? ""
                ValidationVC.onSuccess = {
                    self.navigationController?.popViewController(animated: true)
                }
                self.present(ValidationVC, animated: false)
            } else {
                Alertz.show("", "try again")
            }
        }
    }
    
    @IBAction func onClickCancel(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}


extension AddEquipmentViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let showLbl = textView.text != ""
        let Y = textView.frame.minY
        let H = self.floatPlaceholder.font.lineHeight
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [.beginFromCurrentState,.curveEaseOut], animations: {
            self.floatPlaceholder.alpha = showLbl ? 1.0 : 0.0
            self.floatPlaceholder.frame = CGRect(x: self.floatPlaceholder.frame.origin.x,
                                                 y: showLbl ? Y-(H/2) : Y+H,
                                                 width: self.floatPlaceholder.bounds.size.width,
                                                 height: self.floatPlaceholder.bounds.size.height)
            
        })
    }
}

extension AddEquipmentViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtFldLocation || textField == txtFldTeam || textField == txtFldCategory || textField == txtFldCode || textField == txtFldManuf || textField == txtFldVendor || textField == txtFldType || textField == txtFldDate || textField == txtFldFromDate || textField == txtFldToDate {
            return false
        }
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else {
            return false
        }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        if [6, 11, 16].contains(textField.tag) {
            return updatedText.isValidateFormat(.numeric)
        }
        return true
    }
}

extension AddEquipmentViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let noImages = images.count == 0
        collectionView.isHidden = noImages
        imagesShowConstraint.priority = UILayoutPriority(rawValue: noImages ? 9 : 999)
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        for view in cell.contentView.subviews {
            if let img = view as? UIImageView {
                img.image = images[indexPath.row]
            } else if let btn = view as? UIButton {
                btn.addGestureRecognizer(GestureRecognizerWithClosure.init(action: {
                    self.images.remove(at: indexPath.row)
                }))
            }
        }
        return cell
    }
}

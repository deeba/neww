//
//  dshBrdbkSpace.swift
//  HSpace
//
//  Created by DEEBA on 17.07.20.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//

import UIKit

import IQKeyboardManagerSwift
extension UINavigationItem {
    
    func setTitlez(_ title: String, subtitle: String, time : String, height : CGFloat, weidth : CGFloat, navigationController : UINavigationController) {
        let appearance = UINavigationBar.appearance()
        let textColor = appearance.titleTextAttributes?[NSAttributedString.Key.foregroundColor] as? UIColor ?? .white
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .preferredFont(forTextStyle: UIFont.TextStyle.footnote)
        titleLabel.textAlignment = .center
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
class dshBrdbkSpace: UIViewController {

    let interNt = Internt()
    @IBAction func btnConfrnce(_ sender: UIButton) {
        let mainTabBarController = Constants.Storyboard.dshBrd.instantiateViewController(withIdentifier: Constants.Ids.tbltoCollcn) as! tbltoCollcnViewController
        /*
         Desk, read workstation_space_id
         If Office, read office_room_space_id
         If Meeting Room <Conference room text name is changed>, read conference_room_space_id

         */
        mainTabBarController.spaceId = configurationModls.conference_room_space_id
        mainTabBarController.spaceName = configurationModls.conference_room_space_name
        self.present(mainTabBarController, animated: true, completion: nil)
    }
    @IBAction func btnOffic(_ sender: UIButton) {
        let mainTabBarController = Constants.Storyboard.dshBrd.instantiateViewController(withIdentifier: Constants.Ids.tbltoCollcn) as! tbltoCollcnViewController
        /*
         Desk, read workstation_space_id
         If Office, read office_room_space_id
         If Meeting Room <Conference room text name is changed>, read conference_room_space_id

         */
        mainTabBarController.spaceId = configurationModls.office_room_space_id
        mainTabBarController.spaceName = configurationModls.office_room_space_name
        self.present(mainTabBarController, animated: true, completion: nil)
    }
    @IBAction func btndsk(_ sender: UIButton) {
       let mainTabBarController = Constants.Storyboard.dshBrd.instantiateViewController(withIdentifier: Constants.Ids.tbltoCollcn) as! tbltoCollcnViewController
        /*
         Desk, read workstation_space_id
         If Office, read office_room_space_id
         If Meeting Room <Conference room text name is changed>, read conference_room_space_id
         */
        mainTabBarController.spaceId = configurationModls.workstation_space_id
        mainTabBarController.spaceName = configurationModls.workstation_space_name
        self.present(mainTabBarController, animated: true, completion: nil)
    }
    @IBOutlet weak var bkDte: UILabel!
    var shftzy = [String]()
    var chosenShift: String!
    var chosenDurn: String!
    @IBOutlet weak var bkTim: UILabel!
    @IBOutlet weak var bkShift: UILabel!
    let instanceOfUser = readWrite()
    @IBAction func btnShowspace(_ sender: UIButton) {
        if bkDte.text == "" || bkShift.text == "" || bkTim.text == ""
        {
            showToast(message: "Please select all the fields to proceed")
            return
        }
        else
            {

              /*  self.instanceOfUser.writeAnyData(key: "chsnShftdte", value: bkDte.text as Any)
                self.instanceOfUser.writeAnyData(key: "chsnShftdurn", value: bkTim.text as Any)

                self.performSegue(withIdentifier: "showSpac", sender: sender)
 */
               
               let mainTabBarController = Constants.Storyboard.dshBrd.instantiateViewController(withIdentifier: Constants.Ids.tbltoCollcn) as! tbltoCollcnViewController
                self.present(mainTabBarController, animated: true, completion: nil)
                }
    }
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if bkDte.text == "" || bkShift.text == "" || bkTim.text == ""
        {
            showToast(message: "Please select all the fields to proceed")
            return
        }
        else
            {
        if let nextViewController = segue.destination as? BookASpaceViewController {
            self.instanceOfUser.writeAnyData(key: "bk_rprtSpac", value: "book")
        }
                }
        }
    */
        
    func showToast(message: String) {
            let toastLabel = UITextView(frame: CGRect(x: self.view.frame.size.width/16, y: self.view.frame.size.height-225, width: self.view.frame.size.width * 7/8, height: 50))
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
    /*
    @IBAction func btnScanQR(_ sender: Any) {
        if bkDte.text == "" || bkShift.text == "" || bkTim.text == ""
        {
            showToast(message: "Please select all the fields to proceed")
        }
        else
            {
            self.performSegue(withIdentifier: "scanQRSpac", sender: sender)
                }
    }
    */
    override func viewDidAppear(_ animated: Bool) {
        // 1
        let nav = self.navigationController?.navigationBar
      
        // 2
        nav?.barStyle = UIBarStyle.black
        nav?.tintColor = UIColor.yellow
      
        // 3
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imageView.contentMode = .scaleAspectFit
          
        // 4
        let image = UIImage(named: "Apple_Swift_Logo")
        imageView.image = image
          
        // 5
        navigationItem.titleView = imageView
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.configNavigationBar(title: "Book a Space")
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    var purchaseDate: Date? {
        didSet {
            bkDte.text = purchaseDate?.description.convertDateFormat(from: .yyyyMMddHHmmssSSSS, to: .ddMMMyyyy)
        }
    }
    func setDropDown(in tf: FloatingLabelInput, dataSource: [String], screenType: ItemType) {
        setTrailingView(in: tf, image: UIImage(systemName: "chevron.down"), tintColor: .gray)
        //ItemSelection
        tf.addGestureRecognizer(GestureRecognizerWithClosure {
            let vc = Constants.Storyboard.dshBrd.instantiateViewController(withIdentifier: Constants.Ids.ItemSelectionViewController) as! ItemSelectionViewController
            vc.items = dataSource
            vc.type = screenType
            vc.selectionTitle = "Select \(tf.placeholder ?? "")"
            if let data = tf.text, !data.isEmptyStr {
                vc.selectedItem = data
            }
            vc.onItemSelect = { item in
                let arrsplitOut = item.components(separatedBy: " ")
                let shft =  arrsplitOut[1].components(separatedBy: "(")
                tf.text = item//shft[0]
                self.bkTim.text = String(shiftzModl.duratn[find(value: shft[0], in: shiftzModl.name)!])
                let chsnShftId = shiftzModl.id[find(value: shft[0], in: shiftzModl.name)!]
                let chsnShftStart = shiftzModl.strtTim[find(value: shft[0], in: shiftzModl.name)!]
                let chsnShftEnd = shiftzModl.endTim[find(value: shft[0], in: shiftzModl.name)!]
                self.instanceOfUser.writeAnyData(key: "chsnShftId", value: chsnShftId)
                self.instanceOfUser.writeAnyData(key: "chsnShftStart", value: chsnShftStart)
                self.instanceOfUser.writeAnyData(key: "chsnShftEnd", value: chsnShftEnd)
                self.instanceOfUser.writeAnyData(key: "chsnShft", value: shft[0])
                
               
                /*
                DbHandler.getSpaces(Tkn:self.instanceOfUser.readStringData(key: "accessTokenz"),id:mainBldgModl.Id,shftId:chsnShftId,strt:chsnShftStart,endd:chsnShftEnd )
                */

                
                self.instanceOfUser.writeAnyData(key: "chsnShfttim", value: item.components(separatedBy: "(")[1])
                sleep(1)
            }
            self.present(vc, animated: true)
        })
    }
     @objc func selectorX() {
        
        LoaderSpin.shared.showLoader(self)
       let storyboard = UIStoryboard(name: "cvdDashbrdStoryboard", bundle: nil)
       let mainTabBarController = storyboard.instantiateViewController(identifier: "tabBarStory")
       mainTabBarController.modalPresentationStyle = .fullScreen
       self.present(mainTabBarController, animated: true, completion: nil)
    }
    override func viewWillLayoutSubviews() {
         let width = self.view.frame.width
         let navigationBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 40, width: width, height: 44))
         self.view.addSubview(navigationBar);
         let navigationItem = UINavigationItem(title: "Book a Space")
         navigationItem.leftBarButtonItem = UIBarButtonItem(
             image: UIImage(named: "Back"),
             style: .plain,
             target: self,
             action: #selector(selectorX)
         )
         navigationBar.setItems([navigationItem], animated: false)
      }
    func splitDatestr(dteStr: String) -> String {
            let dte = dteStr
            let newwq = dte.components(separatedBy: "-")[1]
            let monthNumber = Int(newwq)
            let fmt = DateFormatter()
            fmt.dateFormat = "M"
            let month = fmt.monthSymbols[monthNumber! - 1]
            let mnth = month[month.index(month.startIndex, offsetBy: 0)..<month.index(month.startIndex, offsetBy: 3)]
            let mnthQ = String(mnth)
            var dayQ = dte.components(separatedBy: "-")[2]//08
                dayQ = dayQ.components(separatedBy: " ")[0]
            let yrQ = dte.components(separatedBy: "-")[0]
        return dayQ + "/" + mnthQ + "/" + yrQ
      //print(dayQ + "/" + mnthQ + "/" + yrQ)//21/Aug/2020
     }
    override func viewDidLoad() {
        super.viewDidLoad()
       
       
        
       // setBorder(of: bkDte)
      //  setBorder(of: bkTim)
      //  setBorder(of: bkShift)
        let dtey = splitDatestr(dteStr: self.instanceOfUser.readStringData(key: "chsnShftdte"))
        bkDte.text = dtey
        var shfty = chosenShift.components(separatedBy: "(")[0]
        shfty = shfty.components(separatedBy: " ")[1]
        bkShift.text = shfty//chosenShift.components(separatedBy: "(")[0]
        bkTim.text = chosenDurn
        self.instanceOfUser.writeAnyData(key: "chsnShftdurn", value: chosenDurn as Any)
     //   setTrailingView(in: bkDte, image: UIImage(systemName: "calendar"))
        
        // Do any additional setup after loading the view.
    }
        func setTrailingView(in tf: FloatingLabelInput, image: UIImage?, tintColor: UIColor? = nil) {
    //        tf.ignoreSwitchingByNextPrevious = true
            tf.rightViewMode = .always
            let imageView = UIImageView()
            imageView.image = image
            imageView.contentMode = .scaleAspectFit
            let leftView = UIView(frame: CGRect(x: 0, y: 10, width: 32, height: tf.frame.height))
            leftView.addSubview(imageView)
            imageView.frame = CGRect(x: 0, y: 10, width: 20, height: tf.frame.height)
            imageView.center = leftView.center
            if let color = tintColor {
                imageView.tintColor = color
            } else {
                imageView.tintColor = .black
                tf.addGestureRecognizer(GestureRecognizerWithClosure {

                    let dateVC = Constants.Storyboard.dshBrd.instantiateViewController(withIdentifier: Constants.Ids.dateSelectViewController) as! DateSelectViewController
                    switch tf {
                    case self.bkDte:
                        dateVC.minimumDate = Date()
                    default:
                        break
                    }
                    dateVC.onDateSelect = { date in
                        switch tf {
                        case self.bkDte:
                            self.purchaseDate = date
                        default:
                            break
                        }
                    }
                    self.present(dateVC, animated: true)
                })
            }
            tf.rightView = leftView
        }
    func setBorder(of tf: FloatingLabelInput) {
        tf.canShowBorder = true
        tf.borderColor = .black
        tf.dtborderStyle = .rounded
        tf.paddingYFloatLabel = -7
        tf.delegate = self
    }
    override var prefersStatusBarHidden: Bool {
           return false
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
extension dshBrdbkSpace: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
    }
}

extension dshBrdbkSpace: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
}

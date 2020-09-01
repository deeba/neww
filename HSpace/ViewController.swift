//
//  ViewController.swift
//  Reachability
//
//  Created by Leo Dabus on 2/9/19.
//  Copyright © 2019 Dabus.tv. All rights reserved.
//if space is more than 40 mb ,gps ,wifi enabled
import UIKit
import CoreLocation
import SQLite3
import SwiftyJSON
import OneSignal
import CoreNFC
import OAuthSwift
import IQKeyboardManagerSwift
extension Formatter {
    // create static date formatters for your date representations
    static let preciseLocalTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "HH:mm:ss.SSS"
        return formatter
    }()
    static let preciseGMTTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "HH:mm:ss.SSS"
        return formatter
    }()
}
extension Date {
    // you can create a read-only computed property to return just the nanoseconds from your date time
    var nanosecond: Int { return Calendar.current.component(.nanosecond,  from: self)   }
    // the same for your local time
    var preciseLocalTime: String {
        return Formatter.preciseLocalTime.string(for: self) ?? ""
    }
    // or GMT time
    var preciseGMTTime: String {
        return Formatter.preciseGMTTime.string(for: self) ?? ""
    }
}
struct ActivityIndicator {
    
    let viewForActivityIndicator = UIView()
    let view: UIView
    let navigationController: UINavigationController?
    let tabBarController: UITabBarController?
    let activityIndicatorView = UIActivityIndicatorView()
    let loadingTextLabel = UILabel()
    
    var navigationBarHeight: CGFloat { return navigationController?.navigationBar.frame.size.height ?? 0.0 }
    var tabBarHeight: CGFloat { return tabBarController?.tabBar.frame.height ?? 0.0 }
    
    func showActivityIndicator() {
        viewForActivityIndicator.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        viewForActivityIndicator.backgroundColor = UIColor.white
        view.addSubview(viewForActivityIndicator)
        
        activityIndicatorView.center = CGPoint(x: self.view.frame.size.width / 2.0, y: (self.view.frame.size.height - tabBarHeight - navigationBarHeight) / 2.0)
        
        loadingTextLabel.textColor = UIColor.black
        loadingTextLabel.text = "LOADING"
        loadingTextLabel.font = UIFont(name: "Avenir Light", size: 10)
        loadingTextLabel.sizeToFit()
        loadingTextLabel.center = CGPoint(x: activityIndicatorView.center.x, y: activityIndicatorView.center.y + 30)
        viewForActivityIndicator.addSubview(loadingTextLabel)
        
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.style = .gray
        viewForActivityIndicator.addSubview(activityIndicatorView)
        activityIndicatorView.startAnimating()
    }
    
    func stopActivityIndicator() {
        viewForActivityIndicator.removeFromSuperview()
        activityIndicatorView.stopAnimating()
        activityIndicatorView.removeFromSuperview()
    }
}
extension ViewController{
//    // MARK: Flickr
    func doOAuth(){
        let oauthswift = OAuth2Swift(
            consumerKey:    "clientkey",
            consumerSecret: "clientsecret",
            authorizeUrl:   "https://demo.helixsense.com/api/v2/read_group?groupby=%5B%22validation_status%22%5D&model=mro.equipment&domain=%5B%5D&fields=%5B%22display_name%22%5D",
            accessTokenUrl: "https://demo.helixsense.com/api/authentication/oauth2/token",
            responseType:   "token"
            
        )
        self.oauthswift = oauthswift
        oauthswift.authorizeURLHandler = SafariURLHandler(viewController: self, oauthSwift: oauthswift)
        let helper = oauthswift.authorize(username: "\(user)", password: "\(password)", scope: "") { result in
            switch result {
            case .success(let (credential, _, _)):
                self.callApi(oauthswift)
            case .failure(let error):
                print(error.description)
            }
        }
    }

    func callApi(_ oauthswift: OAuth2Swift) {
          let _ = oauthswift.client.get("https://demo.helixsense.com/api/v2/read_group?groupby=%5B%22validation_status%22%5D&model=mro.equipment&domain=%5B%5D&fields=%5B%22display_name%22%5D", parameters: [:]) { result in
              switch result {
              case .success(let response):
                  let jsonDict = try? response.jsonObject()
                  print(String(describing: jsonDict))

              case .failure(let error):
                  print(error)
              }
          }
      }
}
extension String {
   
        func base64ToImage() -> UIImage? {
            if let url = URL(string: self),let data = try? Data(contentsOf: url),let image = UIImage(data: data) {
                return image
            }
            return nil
        }
    
    //Encode base64
    func base64Encoded() -> String {
        let plainData = self.data(using: String.Encoding.utf8)
        let base64String = plainData?.base64EncodedString(options: [])
        return base64String!
    }
    
    //Decode base64
    func base64Decoded() -> String {
        let decodedData = Data(base64Encoded: self, options: [])
        let decodedString = NSString(data: decodedData!, encoding: String.Encoding.utf8.rawValue)
        return decodedString! as String
    }
}
extension String {
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }

    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return String(self[fromIndex...])
    }

    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return String(self[..<toIndex])
    }

    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return String(self[startIndex..<endIndex])
    }
}
extension UIDevice
{

        func totalDiskSpaceInBytes() -> Int64 {
            do {
                guard let totalDiskSpaceInBytes = try FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory())[FileAttributeKey.systemSize] as? Int64 else {
                    return 0
                }
                return totalDiskSpaceInBytes
            } catch {
                return 0
            }
        }

        func freeDiskSpaceInBytes() -> Int64 {
            do {
                guard let totalDiskSpaceInBytes = try FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory())[FileAttributeKey.systemFreeSize] as? Int64 else {
                    return 0
                }
                return totalDiskSpaceInBytes
            } catch {
                return 0
            }
        }

        func usedDiskSpaceInBytes() -> Int64 {
            return totalDiskSpaceInBytes() - freeDiskSpaceInBytes()
        }

        func totalDiskSpace() -> String {
            let diskSpaceInBytes = totalDiskSpaceInBytes()
            if diskSpaceInBytes > 0 {
                return ByteCountFormatter.string(fromByteCount: diskSpaceInBytes, countStyle: ByteCountFormatter.CountStyle.binary)
            }
            return "The total disk space on this device is unknown"
        }

        func freeDiskSpace() -> String {
            let freeSpaceInBytes = freeDiskSpaceInBytes()
            if freeSpaceInBytes > 0 {
                return ByteCountFormatter.string(fromByteCount: freeSpaceInBytes, countStyle: ByteCountFormatter.CountStyle.binary)
            }
            return "The free disk space on this device is unknown"
        }

        func usedDiskSpace() -> String {
            let usedSpaceInBytes = totalDiskSpaceInBytes() - freeDiskSpaceInBytes()
            if usedSpaceInBytes > 0 {
                return ByteCountFormatter.string(fromByteCount: usedSpaceInBytes, countStyle: ByteCountFormatter.CountStyle.binary)
            }
            return "The used disk space on this device is unknown"
        }

}
@available(iOS 10.0, *)
enum UserDefaultsKeys: String {
    case welcomeModel
}
struct Response: Codable {
    var results: [Result]
}

struct Result: Codable {
    var trackId: Int
}
class ViewController: UIViewController, CLLocationManagerDelegate {
    let interNt = Internt()
    @IBOutlet weak var imgVw: UIImageView!
    var  dtQ = ""
    var mnthQ = ""
    var dayQ = ""
    var timQ = ""
    var shftQ = ""
    var wrkSpceQ = ""
    var task1 = URLSessionDataTask()
    var oauthswift: OAuthSwift?
    let user = "vinoth@dcs.hs.in"
    let status = CLLocationManager.authorizationStatus()
    let password = "12345"
    var locationManager = CLLocationManager()
    let getLocation = GetLocation()
    @IBOutlet var activityIncicator: UIActivityIndicatorView!
/* class ViewController: UIViewController, CLLocationManagerDelegate , UITextFieldDelegate ,NFCNDEFReaderSessionDelegate {
    
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        print("invalid:\(error.localizedDescription)")
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        var resul = ""
          for message in messages[0].records {
            resul += String.init(data: message.payload.advanced(by: 1), encoding: .utf8) ?? "format wrong"
            }
        print(resul)
          }
 var nfcSession: NFCNDEFReaderSession?
    var ds = "home"
 
 */
    private var results = [Result]()
    var imgId  = 0
    var lati = 0.0
    var longi = 0.0
    @IBOutlet weak var btnPwdToggle : UIButton!
    let helper = NFCHelper()
    var payloadLabel: UILabel!
    func onNFCResult(success: Bool, msg: String) {
      DispatchQueue.main.async {
        if self.payloadLabel.text == ""
        {
            if success{
                self.payloadLabel.text = "\(self.payloadLabel.text!)\n\(msg)"
                    let r = self.payloadLabel.text!.index(self.payloadLabel.text!.startIndex, offsetBy: 2)..<self.payloadLabel.text!.index(self.payloadLabel.text!.endIndex, offsetBy: 0)
                    // Access the string by the range.
                    let substring = self.payloadLabel.text![r]
                    let uNam = substring.components(separatedBy: "-")[0]
                    let pwd = substring.components(separatedBy: "-")[1]
                    self.getTokenNFC(Unam: uNam,Pwd: pwd)
                    sleep(1)
                }
            }
        else
            {
                self.payloadLabel.text = ""
                 }
      }
    }
    @objc func didTapReadNFC() {
      print("didTapReadNFC")
      self.payloadLabel.text = ""
      print(onNFCResult(success:msg:))
      helper.onNFCResult = onNFCResult(success:msg:)
      helper.restartSession()
    }
    @IBAction func btnNFC(_ sender: UIButton) {
//        erricn.isHidden = true
       // btnlgn.isHidden = true
        self.payloadLabel.text = ""
        helper.onNFCResult = onNFCResult(success:msg:)
        helper.restartSession()
/*
        lblUserErr.isHidden = true
        nfcSession = NFCNDEFReaderSession.init(delegate: self, queue: nil, invalidateAfterFirstRead: true)
        nfcSession?.begin()
        */
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
     
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return choices.count
    }
        
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return choices[row]
    }
        
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row == 0 {
            typeValue = "Toyota"
        } else if row == 1 {
            typeValue = "Honda"
        } else if row == 2 {
            typeValue = "Chevy"
        } else if row == 3 {
            typeValue = "Audi"
        } else if row == 4 {
            typeValue = "BMW"
        }
    }
    
    @IBAction func txtuserz(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    var choices = ["Toyota","Honda","Chevy","Audi","BMW"]
    var typeValue = String()
  //  var compArray: NSMutableArray = []
    var contacts: [WelcomeModel] = []
    var db:OpaquePointer? = nil
    @IBOutlet fileprivate var lblUserErr: UILabel!
    @IBOutlet fileprivate var txtUser: FloatingLabelInput!
    @IBOutlet fileprivate var txtPwd: FloatingLabelInput!
        
    let instanceOfUser = readWrite()
    let instanceOfWOrder = WOglobal()
    let instanceOfDBConst = DBConstanz()
    
    @IBOutlet weak var pwdView: UIView!
    @IBOutlet weak var btnlgn: UIButton!
    
    @IBAction func PwdTogl(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        //txtPwd.isSecureTextEntry = !sender.isSelected
        txtPwd.isSecureTextEntry.toggle()
        if txtPwd.isSecureTextEntry {
            btnPwdToggle.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        } else {
            btnPwdToggle.setImage(UIImage(systemName: "eye"), for: .normal)
        }
    }
    /*
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            self.tagBasedTextField(textField)
            return true
        }
        private func switchBasedNextTextField(_ textField: UITextField) {
            switch textField {
            case self.txtUser:
                self.txtUser.becomeFirstResponder()
            case self.txtPwd:
                self.txtPwd.becomeFirstResponder()
            default:
                self.txtPwd.resignFirstResponder()
            }
        }
        private func tagBasedTextField(_ textField: UITextField) {
            let nextTextFieldTag = textField.tag + 1

            if let nextTextField = textField.superview?.viewWithTag(nextTextFieldTag) as? UITextField {
                nextTextField.becomeFirstResponder()
            } else {
                textField.resignFirstResponder()
            }
        }
*/

    func pauseReasonz(Tkn: String) {
                                      var request = URLRequest(url: URL(string: "https://demo.helixsense.com/api/v2/isearch_read")!,timeoutInterval: Double.infinity)
                                      let string1 = "Bearer "
                                      let string2 = Tkn
                                      let combined2 = "\(string1) \(String(describing: string2))"
                                      request.addValue(combined2, forHTTPHeaderField: "Authorization")
                                      let stringFields = """
                                      ["name"]
                                      """
                                   
                                      let stringDomain1 = "&fields="
                                      let varDomain = "\(stringDomain1)\(String(describing: stringFields))"
                                      let postData = NSMutableData(data: "model=mro.pause.reason".data(using: String.Encoding.utf8)!)
                                      postData.append(varDomain.data(using: String.Encoding.utf8)!)
                                      request.httpBody = postData as Data
                                      request.httpMethod = "POST"

                                    let task1 = URLSession.shared.dataTask(with: request) { data, response, error in
                                      guard let data = data else {
                                        print(String(describing: error))
                                        return
                                      }
                                     do {
                                         // make sure this JSON is in the format we expect
                                         let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                                       
                                       let jsonc = try JSON(data: data)
                                       let title = jsonc["data"]
                                      if (jsonc["data"]  != "" ) {
                                         if (title.count > 0){
                                             for i in 0..<title.count {
                                                pausRsnzModl.pauzNam.append(jsonc["data"][i]["name"].stringValue)
                                                pausRsnzModl.pauzId.append(jsonc["data"][i]["id"].stringValue)
                                                 }
                                             }
                                       }
                                         }
                                      catch let error as NSError {
                                         print("Failed to load: \(error.localizedDescription)")
                                     }
                                    }
                             task1.resume()
              
              
      }
   
      
    func poplteVendr(Tkn: String)
      {
      var request = URLRequest(url: URL(string: "https://demo.helixsense.com/api/v2/isearch_read")!,timeoutInterval: Double.infinity)
      let string1 = "Bearer "
      let string2 = Tkn
          var closg = ""
      let combined2 = "\(string1) \(String(describing: string2))"
      request.addValue(combined2, forHTTPHeaderField: "Authorization")
      let stringFields = """
      ["display_name"]
      """
      let stringFields1 = """
      [["supplier","=",true]]
      """
      let stringDomain = "&domain="
      let stringDomain1 = "&fields="
      let varDomain = "\(stringDomain)\(String(describing: stringFields1))\(stringDomain1)\(String(describing: stringFields))"
      let postData = NSMutableData(data: "model=res.partner".data(using: String.Encoding.utf8)!)
      postData.append(varDomain.data(using: String.Encoding.utf8)!)
      request.httpBody = postData as Data
      request.httpMethod = "POST"
              let task1 = URLSession.shared.dataTask(with: request) { data, response, error in
              guard let data = data else {
                print(String(describing: error))
                return
              }
              do {
                 // make sure this JSON is in the format we expect
              let jsonc = try JSON(data: data)
               let title = jsonc["data"]
               //let title = jsonc["data"][0]["parent_category_id"][1].stringValue
               if (title.count > 0){
                   for i in 0..<title.count {
                    uNPSCcde.cdeNam.append(jsonc["data"][i]["display_name"].stringValue)
                       }
                   }
               
                 }
              catch let error as NSError {
                 print("Failed to load: \(error.localizedDescription)")
              }
              }
                 task1.resume()

        }

    func  logoutAPI(Tkn: String)
       {
        
        let idy = Int(chsStrtMdl.idWO)
                                      let stringFields1 = """
                                        {"source":"api","check_out":"
                                        """
                                        let  stringFields2 = """
                                        ","co_lat":"
                                        """
                                         let  stringFields3 = """
                                         ","co_long":"
                                         """
                                       let  stringFields4 = """
                                        ","co_status":"
                                       """
                                       let    offsetFields = """
                                       ","co_desc":""}
                                       """
                                    let    offsetFields1 = """
                                    "}
                                    """
        let    offsetFields2 = """
               ]
               """

        
            let  ids1 = "&ids=["
         let  stringRole5 = "&model=hr.attendance"
        let  stringRole2 = "&values="
       
        let dateFormatter1 : DateFormatter = DateFormatter()
        let dateFormatter : DateFormatter = DateFormatter()
                     //  dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                     dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                     dateFormatter1.dateFormat = "dd-MM-yyyy HH:mm:ss"
                     let date = Date()
                     let dateString = dateFormatter.string(from: date)
                     let dateString1 = dateFormatter1.string(from: date)
        let lstDatetime = interNt.convertToUTC(dateToConvert: dateString)
        let trimmed1 = lstDatetime.trimmingCharacters(in: .whitespacesAndNewlines)
        let    stringFields = "\(String(describing:stringRole5))\(String(describing:stringRole2))\(stringFields1)\(String(describing:trimmed1))\(String(describing:stringFields2))\(lati)\(String(describing:stringFields3))\(longi)\(String(describing: stringFields4))\(String(describing: ""))\(String(describing: offsetFields))\(String(describing: ids1))\(self.instanceOfUser.readStringData(key: "ChekInTim"))\(String(describing:offsetFields2))"
        print(stringFields)
                                     let combinedOffset = "\(stringFields)"
                                                                    let varRole = "\(String(describing: combinedOffset))"
                                                                    print(varRole)
                                                                        let url = NSURL(string: "https://demo.helixsense.com/api/v2/write") //Remember to put ATS exception if the URL is not https
                                                                                                      let request = NSMutableURLRequest(url: url! as URL)
                                                                                                          let string1 = "Bearer "
                                                                                                            let string2 = instanceOfUser.readStringData(key: "accessTokenz")
                                                                                                            let combined2 = "\(string1) \(String(describing: string2))"

                                                                                                          request.addValue(combined2, forHTTPHeaderField: "Authorization")
                                                                                                      request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type") //Optional

                                                                                                      request.httpMethod = "PUT"
                                                                                                      let session = URLSession(configuration:URLSessionConfiguration.default, delegate: nil, delegateQueue: nil)
                                                                                                      let data = varRole.data(using: String.Encoding.utf8)
                                                                                                      request.httpBody = data


                                                                              let task1 = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
                                                                                guard let data = data else {
                                                                                  print(String(describing: error))
                                                                                  return
                                                                                }
                                                                               do {

                                                                                  let jsonStr = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                                                                                print(jsonStr)
                                                                                   let nwFlds = """
                                                                                   "status": true
                                                                                   """
                                                                                   let varstts =  jsonStr?.contains("\(String(describing: nwFlds))") ?? false
                                                                                   print(varstts)
                                                                                   if varstts
                                                                                       {


                                                                                }

                                                                                   }
                                                                                   
                                                                               }

                                                                                 
                                                                          task1.resume()

                                                                          }

    func splitDatestr(dteStr: String) -> String {
    let dte = dteStr
    let newwq = dte.components(separatedBy: "-")[1]
    let monthNumber = Int(newwq)
    let fmt = DateFormatter()
    fmt.dateFormat = "M"
    let month = fmt.monthSymbols[monthNumber! - 1]
    let mnth = month[month.index(month.startIndex, offsetBy: 0)..<month.index(month.startIndex, offsetBy: 3)]
    mnthQ = String(mnth)
    dayQ = dte.components(separatedBy: "-")[2]//08
        dayQ = dayQ.components(separatedBy: " ")[0]
        let yrQ = dte.components(separatedBy: "-")[0]
        return dayQ + "/" + mnthQ + "/" + yrQ
      //print(dayQ + "/" + mnthQ + "/" + yrQ)//21/Aug/2020
     }
    
    func showAlert(title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }

    @IBAction func Login(_ sender: UIButton) {
        
     /* let image = generateQRCode(from: "Hacking with Swift is the best iOS coding tutorial I've ever read!")
        self.imgVw.image = self.generateQRCode(from:"test")

        print(image as Any)
        print(image as Any)
        
        credentlsModl.usrId = "adalia@gmail.com"
        credentlsModl.pwd = "adalia@gmail.com"
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
         APIClient_redesign.shared().getToken { status in
           if status {
            print(status)
            }
            }
            }
        
        let company_id = "63"
        let vendor_id = "1450"
        let space_id = "9654"
        let shift_id = "47"
        let planned_in = "2020-08-30 00:00:00"
        let planned_out = "2020-08-30 15:00:00"
        let user_defined = true
        let employee_id = "6381"
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
         APIClient_redesign.shared().getToken { status in
           if status {
            APIClient.shared().getSpaceIdBooked(compid: company_id,vndrId: vendor_id,spacId: space_id,shftId: shift_id ,PlndIn: planned_in,PlndOut: planned_out,empId: employee_id)
            {_ in
                
            }
            }
         }
             }
         
        let space_id = "9432"
        let shift_id = "51"
        let start_time = "2020-08-24 06:30:00"
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
         APIClient_redesign.shared().getToken { status in
           if status {
            APIClient.shared().confrmSpacBkg(id: space_id, shftId: shift_id, strt: start_time)
            {
                
            }
            }
         }
             }
       
         
      credentlsModl.usrId = "adalia@gmail.com"
         credentlsModl.pwd = "adalia@gmail.com"
       let space_id = "90030"
        let shift_id = "51"
        let start_time = "2020-07-30 17:30:00"

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
         APIClient_redesign.shared().getToken { status in
            print(status)
                      if status {
                        APIClient.shared().clseBooking(clsgId: space_id ){ count in
                        print(availableSpaceModl)
                   }
               }
               }
    }
     
       credentlsModl.usrId = "adalia@gmail.com"
        credentlsModl.pwd = "adalia@gmail.com"
        let space_id = "9104"
            let from_date  = "2020-08-07 10:00:00"
            let to_date  = "2020-08-10 10:00:00"
            let typ  = "2"
            
        APIClient_redesign.shared().getToken { status in
               if status {
                APIClient_redesign.shared().getSpaceListAvailable(space_id: space_id,from_date: from_date,to_date:to_date ,type:typ ){ count in
                 print(availableSpaceModl)
            }
        }
        }
         
         let dteStr = "2020-08-21 01:45:00"//self.instanceOfUser.readStringData(key: "chsnShftdte")
         print(splitDatestr(dteStr: dteStr))
        credentlsModl.usrId = "adalia@gmail.com"
        credentlsModl.pwd = "adalia@gmail.com"
        let storyboard = UIStoryboard(name: "addEqpmntStoryboard", bundle: nil)
              let vc = storyboard.instantiateViewController(withIdentifier: "ItemSelection") as! ItemSelectionViewController
              APIClient_redesign.shared().getToken { status in
                     if status {
                      APIClient_redesign.shared().getShftListAvailable(){ count in
                        vc.items = availableshftListModl.ttlDis
                      
                  }
              }
              }
        self.present(vc, animated: true)
         
       */
        
        self.interNt.InterNt()
        if (self.instanceOfUser.readStringData(key: "Internt") == "NoInternet") {
            self.showAlert(title: "No Internet", msg: "Caution!")
         } else {
            if pwdView.isHidden {
                if txtUser.text!.isEmpty {
                    self.lblUserErr.text = "Please enter username"
                    self.lblUserErr.isHidden = false
                } else {
                    self.lblUserErr.isHidden = true
                    txtUser.isHidden = true
                    pwdView.isHidden = false
                    btnPwdToggle.isHidden = false
                    txtPwd.becomeFirstResponder()
                }
            } else if !pwdView.isHidden, txtPwd.text!.isEmpty {
                self.lblUserErr.text = "Please enter password"
                self.lblUserErr.isHidden = false
            } else {
                txtUser.isHidden = false
                pwdView.isHidden = false
                btnlgn.setImage(UIImage(named: "LoginBtn"), for: .normal)
                self.lblUserErr.isHidden = true
                
                LoaderSpin.shared.showLoader(self)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.getToken(Unam: (self.txtUser.text ?? nil)!,Pwd: (self.txtPwd.text ?? nil)!)
                }
            
            }
            sleep(1)
         }
  
     }
     func insertSpaces(spacId: String, seqId: String, spaceName: String ,spacShrtCde:String,displayName: String, categoryTyp: String, parentId: String,parentNam: String,maintTeamId: String,maintTeamName: String,spcCtrgyId: String,spcCtrgyName: String )
        
          {
               let file_URL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
               .appendingPathComponent(instanceOfUser.readStringData(key: "dbNamez"))
               //opening the database
               if sqlite3_open(file_URL.path, &db) != SQLITE_OK {
                  print("There's error in opening the database")
               }
            else
            {
               let queryStatementString = "SELECT * FROM tbl_space_details WHERE space_id=? ;"
               var queryStatement: OpaquePointer?
               // 1
               if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) ==
                   SQLITE_OK {
                   // 5G1
                sqlite3_bind_int(queryStatement, 1, (Int32(spacId)!))
                 // 2
                 if sqlite3_step(queryStatement) == SQLITE_ROW {
                    
                 let updateStatementString = "UPDATE tbl_space_details SET space_seqid = ?,space_name = ?,space_short_code = ?, space_display_name = ?,space_category_type = ?,space_parent_id = ?,space_parent_name = ?,space_maintenance_team_id = ?,space_maintenance_team = ?,space_asset_category_id = ?,space_asset_category_name = ? WHERE space_id=? ;"
                 var updateStatement: OpaquePointer?
                 if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) ==
                     SQLITE_OK {
                      //    let catNam: String = "hello"
                    sqlite3_bind_int(updateStatement, 1, (Int32(seqId)!))
                    sqlite3_bind_text(updateStatement, 2,(spaceName as NSString).utf8String, -1, nil)
                    sqlite3_bind_text(updateStatement, 3, (spacShrtCde as NSString).utf8String, -1, nil)
                    sqlite3_bind_text(updateStatement, 4, (displayName as NSString).utf8String, -1, nil)
                    sqlite3_bind_text(updateStatement, 5,(categoryTyp as NSString).utf8String, -1, nil)
                    sqlite3_bind_text(updateStatement, 6, (parentId as NSString).utf8String, -1, nil)
                    sqlite3_bind_text(updateStatement, 7, (parentNam as NSString).utf8String, -1, nil)
                    sqlite3_bind_text(updateStatement, 8,(maintTeamId as NSString).utf8String, -1, nil)
                    sqlite3_bind_text(updateStatement, 9,(maintTeamName as NSString).utf8String, -1, nil)
                    sqlite3_bind_text(updateStatement, 10, (spcCtrgyId as NSString).utf8String, -1, nil)
                    sqlite3_bind_text(updateStatement, 11, (spcCtrgyName as NSString).utf8String, -1, nil)
                    sqlite3_bind_int(updateStatement, 12,(Int32(spacId)!))
                   if sqlite3_step(updateStatement) == SQLITE_DONE {
                   //   print("\nSuccessfully updated row.")
                   } else {
                     print("\nCould not update row.")
                   }
                 } else {
                   print("\nUPDATE statement is not prepared")
                 }
                    sqlite3_finalize(updateStatement)
                   // 3
                  //  let name = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                   // 5
                  //  print("\nQuery Result:")
                 //   print("\(catid) | \(catSubid)")
               } else {// 5G2
                   let insertStatementString = "INSERT INTO tbl_space_details (space_id, space_seqid, space_name,space_short_code, space_display_name, space_category_type, space_parent_id,space_parent_name,space_maintenance_team_id,space_maintenance_team,space_asset_category_id,space_asset_category_name) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);"

                   var insertStatement: OpaquePointer?
                   // 1
                   if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) ==
                       SQLITE_OK {
                     // 3
                     sqlite3_bind_int(insertStatement, 1, (Int32(spacId)!))
                     sqlite3_bind_int(insertStatement, 2,(Int32(seqId)!))
                     sqlite3_bind_text(insertStatement, 3,(spaceName as NSString).utf8String, -1, nil)
                     sqlite3_bind_text(insertStatement, 4, (spacShrtCde as NSString).utf8String, -1, nil)
                     sqlite3_bind_text(insertStatement, 5, (displayName as NSString).utf8String, -1, nil)
                     sqlite3_bind_text(insertStatement, 6,(categoryTyp as NSString).utf8String, -1, nil)
                     sqlite3_bind_text(insertStatement, 7, (parentId as NSString).utf8String, -1, nil)
                     sqlite3_bind_text(insertStatement, 8, (parentNam as NSString).utf8String, -1, nil)
                     sqlite3_bind_text(insertStatement, 9,(maintTeamId as NSString).utf8String, -1, nil)
                     sqlite3_bind_text(insertStatement, 10,(maintTeamName as NSString).utf8String, -1, nil)
                     sqlite3_bind_text(insertStatement, 11, (spcCtrgyId as NSString).utf8String, -1, nil)
                     sqlite3_bind_text(insertStatement, 12, (spcCtrgyName as NSString).utf8String, -1, nil)
                     // 4
                     if sqlite3_step(insertStatement) == SQLITE_DONE {
                   //     print("\nSuccessfully inserted row.")
                     } else {
                       print("\nCould not insert row.")
                     }
                   } else {
                     print("\nINSERT statement is not prepared.")

                    }
                   // 5
                   sqlite3_finalize(insertStatement)
                    sqlite3_close(db)
                    db = nil
               }

               } else {
                   // 6
                 let errorMessage = String(cString: sqlite3_errmsg(db))
                 print("\nQuery is not prepared \(errorMessage)")
               }

                sqlite3_finalize(queryStatement)
                sqlite3_close(db)
                db = nil
           }
    }
    func deleteTblchklst(){
        let file_URL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
           .appendingPathComponent(instanceOfUser.readStringData(key: "dbNamez"))
           //opening the database
           if sqlite3_open(file_URL.path, &db) != SQLITE_OK {
              print("There's error in opening the database")
           }
        else
        {
        let deleteStatementString = "DELETE FROM tbl_checklist;"
      var deleteStatement: OpaquePointer?
      if sqlite3_prepare_v2(db, deleteStatementString, -1, &deleteStatement, nil) ==
          SQLITE_OK {
        if sqlite3_step(deleteStatement) == SQLITE_DONE {
          print("\nSuccessfully deleted table.")
        } else {
          print("\nCould not delete table.")
        }
      } else {
        print("\nDELETE statement could not be prepared")
      }
      
      sqlite3_finalize(deleteStatement)
            }
    }
    func insertCategorySubcategory(Id: String,Name: String,catId: String,catName: String,priority: String,slaTmr: String)
          {
               // self.insertCategorySubcategory(Id: "26",Name: "Floor Drains",catId: "5",catName: "Plumbing-Common",priority: "1",slaTmr: "8")
               
               let file_URL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
               .appendingPathComponent(instanceOfUser.readStringData(key: "dbNamez"))
               //opening the database
               if sqlite3_open(file_URL.path, &db) != SQLITE_OK {
                  print("There's error in opening the database")
               }
            else
                {
                    
                   let queryStatementString = "SELECT * FROM tbl_category WHERE cat_id=? AND cat_sub_id=?;"
                   var queryStatement: OpaquePointer?
                   let catid: String = catId
                   let catSubid: String = Id
                   // 1
                   if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) ==
                       SQLITE_OK {
                            //5F1!!!
                               // 2
                               sqlite3_bind_text(queryStatement, 1, (catid as NSString).utf8String, -1, nil)
                               sqlite3_bind_text(queryStatement, 2, (catSubid as NSString).utf8String, -1, nil)
                             // 2
                             if sqlite3_step(queryStatement) == SQLITE_ROW {
                                
                                     let updateStatementString = "UPDATE tbl_category SET cat_name = ?,cat_sub_name = ?,priority = ?,sla_timer = ? WHERE cat_id=? AND cat_sub_id=?;"
                                     var updateStatement: OpaquePointer?
                                     if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) ==
                                         SQLITE_OK {
                                          //    let catNam: String = "hello"
                                        sqlite3_bind_text(updateStatement, 1, (catName as NSString).utf8String, -1, nil)
                                        sqlite3_bind_text(updateStatement, 2, (Name as NSString).utf8String, -1, nil)
                                        sqlite3_bind_text(updateStatement, 3,(priority as NSString).utf8String, -1, nil)
                                        sqlite3_bind_text(updateStatement, 4, (slaTmr as NSString).utf8String, -1, nil)
                                        sqlite3_bind_text(updateStatement, 5, (catid as NSString).utf8String, -1, nil)
                                        sqlite3_bind_text(updateStatement, 6,(Id as NSString).utf8String, -1, nil)
                                       if sqlite3_step(updateStatement) == SQLITE_DONE {
                                     //     print("\nSuccessfully updated row.")
                                       } else {
                                         print("\nCould not update row.")
                                       }

                                        
                                     } else {
                                       print("\nUPDATE statement is not prepared")
                                     }
                                    sqlite3_finalize(updateStatement)
                                   // 3
                                  //  let name = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                                   // 5
                                  //  print("\nQuery Result:")
                                 //   print("\(catid) | \(catSubid)")
                           } else {//5F2 !!!
                                   let insertStatementString = "INSERT INTO tbl_category (cat_id, cat_name, cat_sub_id, cat_sub_name, priority, sla_timer) VALUES (?, ?, ?, ?, ?, ?);"
                                   var insertStatement: OpaquePointer?
                                   // 1
                                   if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) ==
                                       SQLITE_OK {
                                       
                                     // 3
                                     sqlite3_bind_text(insertStatement, 1, (catId as NSString).utf8String, -1, nil)
                                     sqlite3_bind_text(insertStatement, 2,(catName as NSString).utf8String, -1, nil)
                                     sqlite3_bind_text(insertStatement, 3,(Id as NSString).utf8String, -1, nil)
                                     sqlite3_bind_text(insertStatement, 4,(Name as NSString).utf8String, -1, nil)
                                     sqlite3_bind_text(insertStatement, 5,(priority as NSString).utf8String, -1, nil)
                                     sqlite3_bind_text(insertStatement, 6,(slaTmr as NSString).utf8String, -1, nil)
                                     // 4
                                     if sqlite3_step(insertStatement) == SQLITE_DONE {
                                 //       print("\nSuccessfully inserted row.")
                                     } else {
                                       print("\nCould not insert row.")
                                     }
                                   } else {
                                     print("\nINSERT statement is not prepared.")
                                   }
                                   // 5
                                sqlite3_finalize(insertStatement)
                                sqlite3_close(db)
                                db = nil
                                }

                   } else {
                       // 6
                     let errorMessage = String(cString: sqlite3_errmsg(db))
                     print("\nQuery is not prepared \(errorMessage)")
                   }

                    sqlite3_finalize(queryStatement)
                    sqlite3_close(db)
                    db = nil
               }
    }
   func isAuthorizedtoGetUserLocation() {

       if CLLocationManager.authorizationStatus() != .authorizedWhenInUse     {
           locationManager.requestWhenInUseAuthorization()
       }
   }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Did location updates is called")
        manager.stopUpdatingLocation()
        //store the user location here to firebase or somewhere
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Did location updates is called but failed getting location \(error)")
    }

    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            print("User allowed us to access location")
            //do whatever init activities here.
        }
    }
    func getFormattedDate(strDate: String , currentFomat:String, expectedFromat: String) -> String{
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = currentFomat

        let date : Date = dateFormatterGet.date(from: strDate)!

        dateFormatterGet.dateFormat = expectedFromat
        return dateFormatterGet.string(from: date)
    }
    func setBorder(of tf: FloatingLabelInput) {
    tf.canShowBorder = true
    tf.borderColor = .darkGray
    tf.dtborderStyle = .rounded
    tf.paddingYFloatLabel = -7
    tf.paddingHeight = 20.0
    tf.delegate = self
    }

    func getCurrentTimeZone() -> String{

           return TimeZone.current.identifier

    }
    func stringFromTimeInterval(interval: Double) -> NSString {

        let hours = (Int(interval) / 3600)
        let minutes = Int(interval / 60) - Int(hours * 60)
        let seconds = Int(interval) - (Int(interval / 60) * 60)

        return NSString(format: "%0.2d:%0.2d:%0.2d",hours,minutes,seconds)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
      
        
        //print(formattedDuration ?? "")
        self.lblUserErr.isHidden = true
        self.pwdView.isHidden = true
        setBorder(of: txtPwd)
        setBorder(of: txtUser)
        txtUser.becomeFirstResponder()
        self.btnPwdToggle.isHidden = true
        curntSHift.empId = 0
        curntSHift.idx = 0
        curntSHift.planned_in  = ""
        curntSHift.planned_out  = ""
        curntSHift.shift_id = 0
        curntSHift.shift_name  = ""
        curntSHift.space_id = 0
        curntSHift.space_name  = ""
        curntSHift.space_number  = ""
        curntSHift.space_status  = ""
        curntSHift.space_path_name  = ""
        self.instanceOfUser.writeAnyData(key: "bkStatus", value: "")
        self.instanceOfUser.writeAnyData(key: "returnFromPhoto", value: "")
        self.instanceOfUser.writeAnyData(key: "initlLogin", value: "")
        self.instanceOfUser.writeAnyData(key: "chsnShftdte", value: "")
        self.instanceOfUser.writeAnyData(key: "chsnShftTTl", value: "")

        self.instanceOfUser.writeAnyData(key: "ShftTiminpt", value: "")
        self.instanceOfUser.writeAnyData(key: "chsnShfttim", value: "")
        self.instanceOfUser.writeAnyData(key: "chsnShft", value: "")
        self.instanceOfUser.writeAnyData(key: "chsnShftdurn", value: "")

        self.instanceOfUser.writeAnyData(key: "chsnShftId", value: "")
        self.instanceOfUser.writeAnyData(key: "chsnShftStart", value: "")
        self.instanceOfUser.writeAnyData(key: "chsnShftEnd", value: "")
         self.instanceOfUser.writeAnyData(key: "bk_rprtSpac", value: "")
         self.instanceOfUser.writeAnyData(key: "dos_safty", value: "")
      getLocation.run {
            if let location = $0 {
                self.lati =  location.coordinate.latitude
                self.longi = location.coordinate.longitude
            } else {
                print("Get Location failed \(self.getLocation.didFailWithError ?? "" as! Error)")
            }
        }
         //doOAuth()
             instanceOfUser.writeAnyData(key: "Userz", value:  "")
             instanceOfUser.writeAnyData(key: "Pwdz", value:  "")

            credentlsModl.usrId = ""
            credentlsModl.pwd = ""
            self.instanceOfUser.writeAnyData(key: "cmpName", value: "")
            self.instanceOfUser.writeAnyData(key: "UsrId", value: "")
         let button = UIButton(type: .system)
         button.setTitle("Read NFC", for: .normal)
         button.titleLabel?.font = UIFont(name: "Helvetica", size: 28.0)
         button.addTarget(self, action: #selector(didTapReadNFC), for: .touchUpInside)
         button.frame = CGRect(x: 60, y: 200, width: self.view.bounds.width - 120, height: 80)
            button.isEnabled = false
         self.view.addSubview(button)
         button.isHidden = true
         payloadLabel = UILabel(frame: button.frame.offsetBy(dx: 0, dy: 300))
         payloadLabel.numberOfLines = 10
         payloadLabel.text = "Scan an NFC Tag"
         payloadLabel.isHidden = true
         self.view.addSubview(payloadLabel)
         locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()

            if CLLocationManager.locationServicesEnabled(){
                locationManager.startUpdatingLocation()
            }
            txtUser.text = ""
            txtPwd.text = ""
          self.txtUser.tag = 0
             self.txtPwd.tag = 1
                 
             self.txtUser.delegate = self
             self.txtPwd.delegate = self
         //   let jsonx = JSON(parseJSON: "{\"hello\": \"Playground!\"}")
         //   print(jsonx["hello"])
           instanceOfUser.writeAnyData(key: "dbNamez", value: "db_ifmp.sqlite")
            instanceOfUser.writeAnyData(key: "lcnId", value: "")
            instanceOfUser.writeAnyData(key: "lcnPrntId", value: "")
            instanceOfUser.writeAnyData(key: "lcnPrntName", value: "")
            instanceOfUser.writeAnyData(key: "spcCtrgId", value: "")
            instanceOfUser.writeAnyData(key: "spcMTmId", value: "")
            instanceOfUser.writeAnyData(key: "lcnSel", value: "")
            instanceOfUser.writeAnyData(key: "lcnShrtcde", value: "")
            instanceOfUser.writeAnyData(key: "spcMTmNam", value: "")
            instanceOfUser.writeAnyData(key: "spcCtrgNam", value: "")

           // deleteDB()
           // getlastUpdateDateTimeSpace()
          // self.moveNext()
            if(instanceOfUser.readBoolData(key: "ISLOGIN"))
            {
                instanceOfUser.writeAnyData(key: "ISLOGIN", value: true)
            }
            else
            {
                instanceOfUser.writeAnyData(key: "ISLOGIN", value: false)
            }
            if(instanceOfUser.readBoolData(key: "IS_SUPERVISOR"))
            {
                instanceOfUser.writeAnyData(key: "IS_SUPERVISOR", value: true)
            }
            else
            {
                instanceOfUser.writeAnyData(key: "IS_SUPERVISOR", value: false)
            }
            if(instanceOfUser.readBoolData(key: "IS_SUPERVISOR_ACCEPT"))
            {
                instanceOfUser.writeAnyData(key: "IS_SUPERVISOR_ACCEPT", value: true)
            }
            else
            {
                instanceOfUser.writeAnyData(key: "IS_SUPERVISOR_ACCEPT", value: false)
            }
            if(instanceOfUser.readBoolData(key: "IS_DOWNLOADED"))
            {
                instanceOfUser.writeAnyData(key: "IS_DOWNLOADED", value: true)
            }
            else
            {
                instanceOfUser.writeAnyData(key: "IS_DOWNLOADED", value: false)
            }
            if(instanceOfUser.readBoolData(key: "isNotification"))
            {
                instanceOfUser.writeAnyData(key: "isNotification", value: true)
            }
            else
            {
                instanceOfUser.writeAnyData(key: "isNotification", value: false)
            }
            //1!!!check for freeDiskSpace, No Internet, gpsEnable
            updateUserInterface()
            ////Create database
            instanceOfDBConst.writeAny()
            //2!!!
            makeDB()
            //If logged in already
            //3!!!
            if (instanceOfUser.readBoolData(key: "isNotification")){
            
            }
            //4!!!
            if (instanceOfUser.readBoolData(key: "ISLOGIN")){
                //If downloaded
                if (instanceOfUser.readBoolData(key: "IS_DOWNLOADED")){
                    
                }
                else{//show download  screen


                }
            }//5!!!
            else{//show login screen this screen
                
                
            }
            self.txtUser.tag = 0
            self.txtPwd.tag = 1
        }
 func attendanceAPI(Tkn: String)
        {
            let dateFormatter1 : DateFormatter = DateFormatter()
            let dateFormatter : DateFormatter = DateFormatter()
                         //  dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                         dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                         dateFormatter1.dateFormat = "dd-MM-yyyy HH:mm:ss"
                         let date = Date()
                         let dateString = dateFormatter.string(from: date)
                         let dateString1 = dateFormatter1.string(from: date)
            let lstDatetime = interNt.convertToUTC(dateToConvert: dateString)
            var request = URLRequest(url: URL(string:"https://demo.helixsense.com/api/v2/create")!,timeoutInterval: Double.infinity)
            let stringFields = """
            {"source":"api","check_in":"
            """
            let stringFields2 = """
                ","ci_lat":"
                """
            let stringFields3 = """
            ","ci_long":"
            """
             let stringFields4 = """
                ","ci_status":"in_campus","ci_desc":""
             """
            
            let    offsetFields1 = """
            }
            """

            self.instanceOfUser.writeAnyData(key: "lati", value: lati)
            self.instanceOfUser.writeAnyData(key: "longi", value: longi)
            let trimmed1 = lstDatetime.trimmingCharacters(in: .whitespacesAndNewlines)
            let  stringRole1 = "&values="
            let stringRole2 = stringFields
            let varRole = "\(stringRole1)\(String(describing: stringRole2))\(trimmed1)\(String(describing: stringFields2))\(lati)\(String(describing: stringFields3))\(longi)\(String(describing: stringFields4))\(String(describing: offsetFields1))"
           
                                let string1 = "Bearer "
                                                      let string2 = Tkn
                                                      let combined2 = "\(string1) \(String(describing: string2))"
                                                             request.addValue(combined2, forHTTPHeaderField: "Authorization")
                                 let postData = NSMutableData(data: "model=hr.attendance".data(using: String.Encoding.utf8)!)
                                 postData.append(varRole.data(using: String.Encoding.utf8)!)
                                request.httpBody = postData as Data
                                 request.httpMethod = "POST"
                                 let task1 = URLSession.shared.dataTask(with: request) { data, response, error in
                                   guard let data = data else {
                                     print(String(describing: error))
                                     return
                                   }
                                  do {
                                      // make sure this JSON is in the format we expect
                                   let jsonc = try JSON(data: data)
                                    // let title = jsonc["data"][0]["name"].stringValue
                                    //let title = jsonc["data"][0]["parent_category_id"][1].stringValue
                                    let title = jsonc["data"][0]
                                    self.instanceOfUser.writeAnyData(key: "AttendIdz", value: title.stringValue)
                                    self.instanceOfUser.writeAnyData(key: "ChekInTim", value: dateString1)
                                      }
                                   catch let error as NSError {
                                      print("Failed to load: \(error.localizedDescription)")
                                  }
                                 }
                          task1.resume()

        }
        
        // 1

           func showCurrentLocationonMap() {
                  lati = self.locationManager.location?.coordinate.latitude as! Double
                  longi = self.locationManager.location?.coordinate.longitude as! Double

              }
           // 2
    
      func getTokenNFC(Unam: String,Pwd: String) {
//                btnNfz.isHidden = !btnNfz.isHidden
//                imgNFz.isHidden = true
                instanceOfUser.writeAnyData(key: "Userz", value: Unam)
                instanceOfUser.writeAnyData(key: "Pwdz", value: Pwd)
        credentlsModl.usrId = Unam
        credentlsModl.pwd = Pwd
        
                 self.lblUserErr.text = "  "
                 self.lblUserErr.isHidden = true
//                 self.erricn.isHidden = true
                  var request = URLRequest(url: URL(string: "https://demo.helixsense.com/api/authentication/oauth2/token")!,timeoutInterval: Double.infinity)
                  request.httpMethod = "POST"
                  let postData = NSMutableData(data: "grant_type=password".data(using: String.Encoding.utf8)!)
                  let stringDomain1 = "&username="
                  let varDomain = "\(stringDomain1)\(String(describing:self.instanceOfUser.readStringData(key: "Userz")))"
                  let stringDomain2 = "&password="
                  let varDomain2 = "\(stringDomain2)\(String(describing:self.instanceOfUser.readStringData(key: "Pwdz")))"
                  postData.append("&client_id=clientkey".data(using: String.Encoding.utf8)!)
                  postData.append("&client_secret=clientsecret".data(using: String.Encoding.utf8)!)
                  let trimmed1 = varDomain.trimmingCharacters(in: .whitespacesAndNewlines)
                  let trimmed2 = varDomain2.trimmingCharacters(in: .whitespacesAndNewlines)
                  postData.append(trimmed1.data(using: String.Encoding.utf8)!)
                  postData.append(trimmed2.data(using: String.Encoding.utf8)!)
                  request.httpMethod = "POST"
                  request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                  request.setValue("application/json", forHTTPHeaderField: "Accept")
                  request.httpBody = postData as Data
                  let task = URLSession.shared.dataTask(with: request as URLRequest){
                        data, response, error in

                        if error != nil {
                           print("error=\(String(describing: error))")
                            return
                        }

                        var err: NSError?
                        do
                        {
                           let myJson = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                                       if  (myJson["code"] as? Int64)   != Int64(500)  {//5A1!!!
                                           self.instanceOfUser.writeAnyData(key: "accessTokenz", value: myJson["access_token"]!!)
                                           self.instanceOfUser.writeAnyData(key: "refreshTokenz", value: myJson["refresh_token"]!!)
                                                                   DispatchQueue.main.sync {
                                                                       self.lblUserErr.text = ""
                                                                       self.lblUserErr.isHidden = true
//                                                                       self.erricn.isHidden = true
                                                              //        self.ldg.isHidden =  false
                                                                   }

                                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                        APIClient_redesign.shared().getToken { status in
                                                                          if status {
                                                                              APIClient_redesign.shared().getCurrentSchedule()
                                                                            { status in
                                                                                if status
                                                                                {
                                                                                    self.instanceOfUser.writeAnyData(key: "bkStatus", value: "nobook")
                                                                                }
                                                                                else
                                                                                {
                                                                                    self.instanceOfUser.writeAnyData(key: "bkStatus", value: "book")
                                                                                    
                                                                                }
                                                                              }
                                                                            }
                                                                          }
                                            }
                                        /*
                                          //5B!!!
                                        self.UserDetails(Tkn:self.instanceOfUser.readStringData(key: "accessTokenz") )
                                         // //5C!!!
                                         self.CompanyDetails(Tkn:self.instanceOfUser.readStringData(key: "accessTokenz") )
                                         // //5D!!!
                                         self.UserRole(Tkn:self.instanceOfUser.readStringData(key: "accessTokenz") )
                                          //5K!!!
                                         self.pauseReason(Tkn:self.instanceOfUser.readStringData(key: "accessTokenz") )
                                         self.pauseReasonz(Tkn:self.instanceOfUser.readStringData(key: "accessTokenz") )
                                          //5J!!!
                                        self.attendanceAPI(Tkn:self.instanceOfUser.readStringData(key: "accessTokenz") )
                                         // //5E!!!
                                         self.getCompLogo(Tkn:self.instanceOfUser.readStringData(key: "accessTokenz") )
                                        */
                                         // //OperationQueue.main.addOperation {
                                           //                                    let storyBoard: UIStoryboard = UIStoryboard(name: "HomeStoryboard", bundle: nil)
                                           //                                    let newViewController = storyBoard.instantiateViewController(withIdentifier: "HomeStory") as!  HomeScreen
                                             //                                  self.present(newViewController, animated: true, completion: nil)//
                                               //                            }
                                        if (self.instanceOfUser.readStringData(key: "initlLogin")) == ""
                                        {
                                            
                                                   self.instanceOfUser.writeAnyData(key: "initlLogin", value: "no")

                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                                      APIClient.shared().getTokenz
                                                          {status in}
                                                      self.DownldCategory(Tkn:self.instanceOfUser.readStringData(key: "accessTokenz"))
                                            }
                                             DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                                      APIClient.shared().getTokenz
                                                          {status in}
                                                      APIClient.shared().getUserInfo(Tkn:self.instanceOfUser.readStringData(key: "accessTokenz") )
                                                      sleep(1)
                                            }
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                                      APIClient.shared().getTokenz
                                                      {status in}
                                                      APIClient.shared().getusrRoleAlom(){ (data) in
                                                      }
                                                      sleep(1)
                                            }
                                             DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                                        APIClient.shared().getToken { status in
                                                        if status {
                                                            APIClient.shared().getTenantdtls(vndrId:String(usrRlrModl.vndrId)){ count in
                                                            }
                                                        }
                                                        }
                                                 }
                                            self.deleteTblchklst()
                                            self.writTochklstTble()
                                            sleep(1)
                                            APIClient.shared().getToken { status in
                                             if status {
                                                 let dateFormatter1 : DateFormatter = DateFormatter()
                                                 let dateFormatter : DateFormatter = DateFormatter()
                                                  //  dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                                                  dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                                                  dateFormatter1.dateFormat = "dd-MM-yyyy HH:mm:ss"
                                                  let date = Date()
                                                  let dateString = dateFormatter.string(from: date)
                                                 let lstDatetime = self.interNt.convertToUTC(dateToConvert: dateString)
                                                 let trimmed1 =  lstDatetime.trimmingCharacters(in: .whitespacesAndNewlines)
                                                 self.instanceOfUser.writeAnyData(key: "ShftTiminpt", value: trimmed1)
                                                 APIClient.shared().getShiftz() { (data) in
                                                  }
                                               }
                                             }
                                        }
                                     
                                         }
                                      else
                                      {
                                           DispatchQueue.main.sync {
                                               self.lblUserErr.text = "Invalid username and password"
                                               self.lblUserErr.isHidden = false
                                           }
                                      }
                            }
                        catch let error as NSError {
                            err = error
                            print("error=\(String(describing: err))")
                        }
                    }
               task.resume()
             
           
         //
      }
    override func viewWillAppear(_ animated: Bool) {
           self.navigationController?.setNavigationBarHidden(true, animated: false)
       }
        func getToken(Unam: String,Pwd: String) {

             if (txtUser.text!.isEmpty && txtPwd.text!.isEmpty ) {
                self.lblUserErr.text = "Invalid username and password"
                self.lblUserErr.isHidden = false
            } else {
                if (txtUser.text!.isEmpty || txtPwd.text!.isEmpty) {
                    self.lblUserErr.text = "Invalid username and password"
                    self.lblUserErr.isHidden = false
                } else {
                   instanceOfUser.writeAnyData(key: "Userz", value: txtUser.text ?? "")
                   instanceOfUser.writeAnyData(key: "Pwdz", value: txtPwd.text ?? "")
                    self.lblUserErr.text = "  "
                    self.lblUserErr.isHidden = true
                    var request = URLRequest(url: URL(string: "https://demo.helixsense.com/api/authentication/oauth2/token")!,timeoutInterval: Double.infinity)
                    request.httpMethod = "POST"
                       let postData = NSMutableData(data: "grant_type=password".data(using: String.Encoding.utf8)!)
                       let stringDomain1 = "&username="
                       let varDomain = "\(stringDomain1)\(String(describing:self.instanceOfUser.readStringData(key: "Userz")))"
                       let stringDomain2 = "&password="
                       let varDomain2 = "\(stringDomain2)\(String(describing:self.instanceOfUser.readStringData(key: "Pwdz")))"
                       postData.append("&client_id=clientkey".data(using: String.Encoding.utf8)!)
                       postData.append("&client_secret=clientsecret".data(using: String.Encoding.utf8)!)
                       let trimmed1 = varDomain.trimmingCharacters(in: .whitespacesAndNewlines)
                       let trimmed2 = varDomain2.trimmingCharacters(in: .whitespacesAndNewlines)
                       postData.append(trimmed1.data(using: String.Encoding.utf8)!)
                       postData.append(trimmed2.data(using: String.Encoding.utf8)!)
                       request.httpMethod = "POST"
                       request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                       request.setValue("application/json", forHTTPHeaderField: "Accept")
                       request.httpBody = postData as Data
                       let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
                        LoaderSpin.shared.hideLoader()
                        if error != nil {
                                print("error=\(String(describing: error))")
                            
                                return
                            }
                            var err: NSError?
                            do {
                                let myJson = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                                if  (myJson["code"] as? Int64)   != Int64(500)  {//5A1!!!
                                    credentlsModl.usrId = Unam
                                    credentlsModl.pwd = Pwd
                                    self.instanceOfUser.writeAnyData(key: "accessTokenz", value: myJson["access_token"]!!)
                                    self.instanceOfUser.writeAnyData(key: "refreshTokenz", value: myJson["refresh_token"]!!)
                                  DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                  APIClient_redesign.shared().getToken { status in
                                                                    if status {
                                                                        APIClient_redesign.shared().getCurrentSchedule()
                                                                      { status in
                                                                          if status
                                                                          {
                                                                              self.instanceOfUser.writeAnyData(key: "bkStatus", value: "nobook")
                                                                          }
                                                                          else
                                                                          {
                                                                              self.instanceOfUser.writeAnyData(key: "bkStatus", value: "book")
                                                                              
                                                                          }
                                                                        }
                                                                      }
                                                                    }
                                      }
                                   
                                        
                                               

                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                                  APIClient.shared().getTokenz
                                                      {status in}
                                                  self.DownldCategory(Tkn:self.instanceOfUser.readStringData(key: "accessTokenz"))
                                        }
                                         DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                                  APIClient.shared().getTokenz
                                                      {status in}
                                                  APIClient.shared().getUserInfo(Tkn:self.instanceOfUser.readStringData(key: "accessTokenz") )
                                                  sleep(1)
                                        }
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                                  APIClient.shared().getTokenz
                                                  {status in}
                                                  APIClient.shared().getusrRoleAlom(){ (data) in
                                                  }
                                                  sleep(1)
                                        }
                                         DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                                    APIClient.shared().getToken { status in
                                                    if status {
                                                        APIClient.shared().getTenantdtls(vndrId:String(usrRlrModl.vndrId)){ count in
                                                        }
                                                    }
                                                    }
                                             }

                                    
                                    DispatchQueue.main.sync {
                                       LoaderSpin.shared.showLoader(self)
                                        self.lblUserErr.text = ""
                                        self.lblUserErr.isHidden = true
                                        let storyboard = UIStoryboard(name: "cvdDashbrdStoryboard", bundle: nil)
                                        let mainTabBarController = storyboard.instantiateViewController(identifier: "tabBarStory") as! UITabBarController
                                        mainTabBarController.selectedIndex = 4 // choose which tab is selected
                                        if let tabBar = mainTabBarController as? UITabBarController {
                                        let nav = tabBar.viewControllers![0] as! UINavigationController
                                        let destination = nav.visibleViewController
                                            if let destination = destination as? cvdDashbrdViewController {
                                                destination.frstApprnce = true
                                            }
                                        }
                                        self.navigationController?.isNavigationBarHidden = true
                                        self.navigationController?.pushViewController(mainTabBarController, animated: true)
//                                        mainTabBarController.modalPresentationStyle = .fullScreen
//                                        self.present(mainTabBarController, animated: true, completion: nil)
                                    }
                                   
                                } else {
                                    DispatchQueue.main.sync {
                                        self.lblUserErr.text = "Invalid username and password"
                                        self.lblUserErr.isHidden = false
                                        self.lblUserErr.isHidden = false
                                    }
                                }
                            } catch let error as NSError {
                                err = error
                                print("error=\(String(describing: err))")
                            }
                        }
                    task.resume()
                }
            }
           
        }
        
     /* func resize(image: UIImage, maxHeight: Float = 500.0, maxWidth: Float = 500.0, compressionQuality: Float = 0.5) -> Data? {
        var actualHeight: Float = Float(image.size.height)
        var actualWidth: Float = Float(image.size.width)
        var imgRatio: Float = actualWidth / actualHeight
        let maxRatio: Float = maxWidth / maxHeight

        if actualHeight > maxHeight || actualWidth > maxWidth {
          if imgRatio < maxRatio {
            //adjust width according to maxHeight
            imgRatio = maxHeight / actualHeight
            actualWidth = imgRatio * actualWidth
            actualHeight = maxHeight
          }
          else if imgRatio > maxRatio {
            //adjust height according to maxWidth
            imgRatio = maxWidth / actualWidth
            actualHeight = imgRatio * actualHeight
            actualWidth = maxWidth
          }
          else {
            actualHeight = maxHeight
            actualWidth = maxWidth
          }
        }
        let rect = CGRect(x: 0.0, y: 0.0, width: CGFloat(actualWidth), height: CGFloat(actualHeight))
        UIGraphicsBeginImageContext(rect.size)
        image.draw(in:rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        let imageData = img!.jpegData(compressionQuality: CGFloat(compressionQuality))
        UIGraphicsEndImageContext()
        return imageData
      }
        */
     func writTochklstTble(){
        for j in 0..<symptmsListModl.display_name.count {
               let file_URL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
               .appendingPathComponent(instanceOfUser.readStringData(key: "dbNamez"))
               //opening the database
               if sqlite3_open(file_URL.path, &db) != SQLITE_OK {
                  print("There's error in opening the database")
               }
            else
            {
               // header_group=Others checklist_id=16811 answer= checklist_type=boolean question=Do you have Cough? is_submitted=0 shift_id=87350 expected_ans=yes suggestion_array=
                var queryStatement: OpaquePointer?
               // (curntSHift.idx)
                 
                   let insertStatementString = "INSERT INTO tbl_checklist (shift_id ,checklist_id ,checklist_type ,question ,suggestion_array ,answer ,is_submitted ,header_group ,expected_ans ,sync_status )  VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?);"
                   var insertStatement: OpaquePointer?
                   // 1
                   if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) ==
                       SQLITE_OK {
                     // 3
                    
                            let tst = String(curntSHift.idx)
                            let tst1 = String(symptmsListModl.id[j])
                            var hdrGrp = ""
                              sqlite3_bind_text(insertStatement, 1, (tst as NSString).utf8String, -1, nil)
                            sqlite3_bind_text(insertStatement, 2,(tst1 as NSString).utf8String, -1, nil)
                            sqlite3_bind_text(insertStatement, 3,(symptmsListModl.type[j] as NSString).utf8String, -1, nil)
                        sqlite3_bind_text(insertStatement, 4,(symptmsListModl.display_name[j] as NSString).utf8String, -1, nil)
                            sqlite3_bind_text(insertStatement, 5,("" as NSString).utf8String, -1, nil)
                            sqlite3_bind_text(insertStatement, 6,("" as NSString).utf8String, -1, nil)
                            sqlite3_bind_text(insertStatement, 7,("0" as NSString).utf8String, -1, nil)
                        if symptmsListModl.mro_quest_grp_nam[j] == ""
                        {
                            hdrGrp = "Others"
                        }
                        else
                        {
                            hdrGrp = symptmsListModl.mro_quest_grp_nam[j]
                        }
                        sqlite3_bind_text(insertStatement, 8,(hdrGrp as NSString).utf8String, -1, nil)
                            sqlite3_bind_text(insertStatement, 9,("yes" as NSString).utf8String, -1, nil)
                            sqlite3_bind_text(insertStatement, 10,("" as NSString).utf8String, -1, nil)
                             if sqlite3_step(insertStatement) == SQLITE_DONE {
                               print("\nSuccessfully inserted row.")
                             } else {
                               print("\nCould not insert row.")
                             }
                    
                    
                    //
                   } else {
                     print("\nINSERT statement is not prepared.")
                   }
                   // 5
                    sqlite3_close(db)
                    db = nil
                    /*
                    OperationQueue.main.addOperation {
                        
                       let storyBoard: UIStoryboard = UIStoryboard(name: "cvdDashbrdStoryboard", bundle: nil)
                        let newViewController = storyBoard.instantiateViewController(withIdentifier: "cvdDash") as! cvdDashbrdViewController
                        self.present(newViewController, animated: true, completion: nil)
                    }
                    */
               

                
               
                }
           }
    }
    func convertToUTC(dateToConvert:String) -> String {
     let formatter = DateFormatter()
     formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
     let convertedDate = formatter.date(from: dateToConvert)
     formatter.timeZone = TimeZone(identifier: "UTC")
     return formatter.string(from: convertedDate!)
        
    }
    func UpdateSpaceLastUpdte() {
        //get last_update_date_time_space
        
              let dateFormatter : DateFormatter = DateFormatter()
              //  dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
              dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
              let date = Date()
              let dateString = dateFormatter.string(from: date)
              let lstDatetime = convertToUTC(dateToConvert: dateString)

           
            let file_URL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
               .appendingPathComponent(instanceOfUser.readStringData(key: "dbNamez"))
            //print(instanceOfUser.readStringData(key: "dbNamez"))
               //opening the database
               if sqlite3_open(file_URL.path, &db) != SQLITE_OK {
                  print("There's error in opening the database")
               }
            else
            {
                  let UpdStatementString = "UPDATE tbl_last_update_data SET  last_update_date_time_space =  ?  WHERE id = (SELECT MAX(id) FROM tbl_last_update_data);"
                var UpdStatement: OpaquePointer?
                // 1
                if sqlite3_prepare_v2(db, UpdStatementString, -1, &UpdStatement, nil) ==
                    SQLITE_OK {
                    let name1: NSString = lstDatetime as NSString
                    // 2
                  sqlite3_bind_text(UpdStatement, 1, (name1 as NSString).utf8String, -1, nil)
                  // 4
                  if sqlite3_step(UpdStatement) == SQLITE_DONE {
                 //   print("\nSuccessfully updated row.")
                    instanceOfUser.writeAnyData(key: "IS_DOWNLOADED", value: true)
                  } else {
                    print("\nCould not update row.")
                  }
                } else {
                  print("\nUPDATE statement is not prepared.")
                }
                // 5
                sqlite3_finalize(UpdStatement)
                sqlite3_close(db)
                db = nil
            }
            
        }
    func UpdateCatLastUpdte() {
        //get last_update_date_time_space
        
              let dateFormatter : DateFormatter = DateFormatter()
              //  dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
              dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
              let date = Date()
              let dateString = dateFormatter.string(from: date)
              let lstDatetime = convertToUTC(dateToConvert: dateString)

           
            let file_URL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
               .appendingPathComponent(instanceOfUser.readStringData(key: "dbNamez"))
               //opening the database
               if sqlite3_open(file_URL.path, &db) != SQLITE_OK {
                  print("There's error in opening the database")
               }
            else
            {
                  let UpdStatementString = "UPDATE tbl_last_update_data SET  last_update_date_time_cat =  ?  WHERE id = (SELECT MAX(id) FROM tbl_last_update_data);"
                var UpdStatement: OpaquePointer?
                // 1
                if sqlite3_prepare_v2(db, UpdStatementString, -1, &UpdStatement, nil) ==
                    SQLITE_OK {
                    let name1: NSString = lstDatetime as NSString
                    // 2
                  sqlite3_bind_text(UpdStatement, 1, (name1 as NSString).utf8String, -1, nil)
                  // 4
                  if sqlite3_step(UpdStatement) == SQLITE_DONE {
                   // print("\nSuccessfully updated row.")
                   // instanceOfUser.writeAnyData(key: "IS_DOWNLOADED", value: true)
                  } else {
                    print("\nCould not update row.")
                  }
                } else {
                  print("\nUPDATE statement is not prepared.")
                }
                // 5
                sqlite3_finalize(UpdStatement)
                sqlite3_close(db)
                db = nil
            }
            
        }
    func UpdateLastUpdte() {
        //get last_update_date_time_space
        
              let dateFormatter : DateFormatter = DateFormatter()
              //  dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
              dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
              let date = Date()
              let dateString = dateFormatter.string(from: date)
              let lstDatetime = convertToUTC(dateToConvert: dateString)

           
            let file_URL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
               .appendingPathComponent(instanceOfUser.readStringData(key: "dbNamez"))
               //opening the database
               if sqlite3_open(file_URL.path, &db) != SQLITE_OK {
                  print("There's error in opening the database")
               }
            else
            {
                  let UpdStatementString = "UPDATE tbl_last_update_data SET  last_update_date_time =  ?  WHERE id = (SELECT MAX(id) FROM tbl_last_update_data);"
                var UpdStatement: OpaquePointer?
                // 1
                if sqlite3_prepare_v2(db, UpdStatementString, -1, &UpdStatement, nil) ==
                    SQLITE_OK {
                    let name1: NSString = lstDatetime as NSString
                    // 2
                  sqlite3_bind_text(UpdStatement, 1, (name1 as NSString).utf8String, -1, nil)
                  // 4
                  if sqlite3_step(UpdStatement) == SQLITE_DONE {
                   // print("\nSuccessfully updated row.")
                    instanceOfUser.writeAnyData(key: "IS_DOWNLOADED", value: true)
                  } else {
                    print("\nCould not update row.")
                  }
                } else {
                  print("\nUPDATE statement is not prepared.")
                }
                // 5
                sqlite3_finalize(UpdStatement)
                sqlite3_close(db)
                db = nil
            }
            
        }
    func DownldSpace(Tkn: String) {
       // https://demo.helixsense.com/api/isearch_read_v1?model=mro.equipment.location&domain=[]&fields=["space_name","name","display_name","maintenance_team_id","asset_categ_type","asset_category_id","parent_id","asset_categ_type","sort_sequence"]&limit=10&offset=0&order=id ASC
                            var stringFields = ""
                            if (instanceOfUser.readStringData(key: "lastUpdtdDtTimSpace") == "" )
                            {
                                 stringFields = """
                                &domain=[]&fields=["space_name","display_name","name","maintenance_team_id","parent_id","asset_categ_type","asset_category_id","sort_sequence"]&limit=80&offset=
                                """
                            }
                            else
                            {
                                let stringFields1 = """
                                &domain=[["write_date",">","
                                """

                                let trimmed1 = instanceOfUser.readStringData(key: "lastUpdtdDtTimSpace").trimmingCharacters(in: .whitespacesAndNewlines)
                                let  stringFields2 = """
                                "]]&fields=["space_name","display_name","name","maintenance_team_id","parent_id","asset_categ_type","asset_category_id","sort_sequence"]&limit=10&offset=
                                """
                                     stringFields = "\(stringFields1)\(trimmed1)\(String(describing: stringFields2))"
                            }

                            var request = URLRequest(url: URL(string:"https://demo.helixsense.com/api/isearch_read_v1")!,timeoutInterval: Double.infinity)
                            let    offsetFields = """
                            &order=id ASC
                            """
                            let stringOff = instanceOfUser.readIntData(key:  "offsetz")
                            let combinedOffset = "\(stringFields)\(stringOff)\(String(describing: offsetFields))"
                            let varRole = "\(String(describing: combinedOffset))"
                            let string1 = "Bearer "
                                                  let string2 = Tkn
                                                  let combined2 = "\(string1) \(String(describing: string2))"
                                                         request.addValue(combined2, forHTTPHeaderField: "Authorization")
                             let postData = NSMutableData(data: "model=mro.equipment.location".data(using: String.Encoding.utf8)!)
                             postData.append(varRole.data(using: String.Encoding.utf8)!)
                            request.httpBody = postData as Data
                             request.httpMethod = "POST"
                              task1 = URLSession.shared.dataTask(with: request) { data, response, error in
                               guard let data = data else {
                                 print(String(describing: error))
                                 return
                               }
                              do {
                                  // make sure this JSON is in the format we expect
                               let jsonc = try JSON(data: data)
                                // let title = jsonc["data"][0]["name"].stringValue
                                //let title = jsonc["data"][0]["parent_category_id"][1].stringValue
                                let title = jsonc["data"]
                                 //let lngth = jsonc["length"]

                                if (title.count > 0){
                                    for i in 0..<title.count {

                                     // if (lngth.intValue > 0){
                                      //   for i in 0..<lngth.intValue{
                                            var spacId, seqId, spaceName ,displayName, categoryTyp, maintTeamId,maintTeamName, parentId,spaceShrtcde,spcPrntNam,spcCgryId,spcCgryNam: String
                                            spacId = title[i]["id"].stringValue
                                            seqId = title[i]["sort_sequence"].stringValue
                                            spaceName = title[i]["space_name"].stringValue
                                            spaceShrtcde = title[i]["name"].stringValue
                                            displayName = title[i]["display_name"].stringValue
                                            categoryTyp = title[i]["asset_categ_type"].stringValue
                                            parentId = title[i]["parent_id"][0].stringValue
                                           if (parentId == "false" || parentId == ""){
                                                parentId = ""
                                                spcPrntNam = ""
                                            }
                                            else{
                                                parentId = title[i]["parent_id"][0].stringValue
                                                spcPrntNam = title[i]["parent_id"][1].stringValue
                                            }
                                            maintTeamId = title[i]["maintenance_team_id"][0].stringValue
                                            if (maintTeamId == "false" || maintTeamId == ""){
                                                maintTeamId = ""
                                                maintTeamName = ""
                                            }
                                            else{
                                                maintTeamId = title[i]["maintenance_team_id"][0].stringValue
                                                maintTeamName = title[i]["maintenance_team_id"][1].stringValue
                                            }
                                        spcCgryId = title[i]["asset_category_id"][0].stringValue
                                        if (spcCgryId == "false" || spcCgryId == "")
                                        {
                                           spcCgryId = ""
                                           spcCgryNam = ""
                                       }
                                       else{
                                           spcCgryId = title[i]["asset_category_id"][0].stringValue
                                           
                                           spcCgryNam = title[i]["asset_category_id"][1].stringValue
                                       }
                                        self.insertSpaces(spacId: spacId, seqId: seqId, spaceName: spaceName ,spacShrtCde:spaceShrtcde,displayName: displayName, categoryTyp: categoryTyp, parentId: parentId,parentNam: spcPrntNam,maintTeamId: maintTeamId,maintTeamName: maintTeamName,spcCtrgyId: spcCgryId,spcCtrgyName: spcCgryNam )
                                        }
                                        
                                               self.instanceOfUser.writeAnyData(key: "offsetz", value: self.instanceOfUser.readIntData(key:  "offsetz") + 80)
                                        self.DownldSpace(Tkn:  Tkn)
                                     }
                                    else
                                    {
                                        //5F4
                                        self.task1.cancel()
                                        self.moveNextt()
                                    }
                                  }
                               catch let error as NSError {
                                  print("Failed to load: \(error.localizedDescription)")
                              }
                             }
                      task1.resume()

    }
     func moveNextt(){
        
        let stry = getlastUpdateDateTimeSpace()
        print(stry)
              let dateFormatter : DateFormatter = DateFormatter()
              //  dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
              dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
              let date = Date()
              let dateString = dateFormatter.string(from: date)
              let lstDatetime = convertToUTC(dateToConvert: dateString)
               let file_URL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
               .appendingPathComponent(instanceOfUser.readStringData(key: "dbNamez"))
               //opening the database
               if sqlite3_open(file_URL.path, &db) != SQLITE_OK {
                  print("There's error in opening the database")
               }
            else
            {
                var queryStatement: OpaquePointer?
               // 1
               
                   // 2
                 // 2
                if (stry != "")
                    {
                        UpdateLastUpdte()
                        UpdateSpaceLastUpdte()
                        UpdateCatLastUpdte()
                     /*
                       OperationQueue.main.addOperation {

                        let storyBoard: UIStoryboard = UIStoryboard(name: "cvdDashbrdStoryboard", bundle: nil)
                        let newViewController = storyBoard.instantiateViewController(withIdentifier: "cvdDash") as! cvdDashbrdViewController
                        self.present(newViewController, animated: true, completion: nil)
                                                        }
                        */
                    }
                    else {
                   let insertStatementString = "INSERT INTO tbl_last_update_data (last_update_date_time, last_update_date_time_space, last_update_date_time_cat, company_id) VALUES (?, ?, ?, ?);"
                   var insertStatement: OpaquePointer?
                   // 1
                   if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) ==
                       SQLITE_OK {
                     // 3
                      sqlite3_bind_text(insertStatement, 1, ("" as NSString).utf8String, -1, nil)
                      sqlite3_bind_text(insertStatement, 2,(lstDatetime as NSString).utf8String, -1, nil)
                      sqlite3_bind_text(insertStatement, 3,(lstDatetime as NSString).utf8String, -1, nil)
                    sqlite3_bind_int(insertStatement, 4,(Int32(instanceOfUser.readIntData(key: "CompIdz"))))
                     if sqlite3_step(insertStatement) == SQLITE_DONE {
                       print("\nSuccessfully inserted row.")
                     } else {
                       print("\nCould not insert row.")
                     }
                   } else {
                     print("\nINSERT statement is not prepared.")
                   }
                   // 5
                   sqlite3_finalize(insertStatement)
                    sqlite3_close(db)
                    db = nil
                    /*
                    OperationQueue.main.addOperation {
                        
                       let storyBoard: UIStoryboard = UIStoryboard(name: "cvdDashbrdStoryboard", bundle: nil)
                        let newViewController = storyBoard.instantiateViewController(withIdentifier: "cvdDash") as! cvdDashbrdViewController
                        self.present(newViewController, animated: true, completion: nil)
                    }
                    */
               }

                
               
           }
    }
        func DownldCategory(Tkn: String) {
                               // read the last updated value from the table and if update value is empty  the domain filed should be [] array otherwise send the last update value in the domain field like this [["write_date",">","2020-02-23 08:27:08"]] and the time should send UTC format.
                                //5F1
                                getlastUpdateDateTimeSpace()
                                var stringFields = ""
                                if (instanceOfUser.readStringData(key: "lastUpdtdDtTimSpace") == "" )
                                {
                                     stringFields = """
                                    &domain=[]&fields=["parent_category_id","name","priority","sla_timer"]&limit=80&offset=
                                    """
                                }
                                else
                                {
                                    let stringFields1 = """
                                    &domain=[["write_date",">","
                                    """

                                    let trimmed1 = instanceOfUser.readStringData(key: "lastUpdtdDtTimSpace").trimmingCharacters(in: .whitespacesAndNewlines)
                                    let  stringFields2 = """
                                    "]]&fields=["parent_category_id","name","priority","sla_timer"]&limit=80&offset=
                                    """
                                         stringFields = "\(stringFields1)\(trimmed1)\(String(describing: stringFields2))"
                                }
            
                                 let    offsetFields = """
                                    &order=parent_category_id ASC
                                    """
                                var request = URLRequest(url: URL(string:"https://demo.helixsense.com/api/isearch_read_v1")!,timeoutInterval: Double.infinity)
                                
                                let stringOff = instanceOfUser.readIntData(key:  "offsetz")
                                let combinedOffset = "\(stringFields)\(stringOff)\(String(describing: offsetFields))"
                                let varRole = "\(String(describing: combinedOffset))"
                                let string1 = "Bearer "
                                let string2 = Tkn
                                let combined2 = "\(string1) \(String(describing: string2))"
                                request.addValue(combined2, forHTTPHeaderField: "Authorization")
                                let postData = NSMutableData(data: "model=website.support.ticket.subcategory".data(using: String.Encoding.utf8)!)
                                postData.append(varRole.data(using: String.Encoding.utf8)!)
                                request.httpBody = postData as Data
                                request.httpMethod = "POST"
    /*https://demo.helixsense.com/api/isearch_read_v1?model=website.support.ticket.subcategory&domain=[["write_date",">","2020-01-23 18:14:25"]]&fields=["parent_category_id","name","priority","sla_timer"]&limit=80&offset=0&order=parent_category_id ASC*/
                                let  task1 = URLSession.shared.dataTask(with: request) { data, response, error in
                                   guard let data = data else {
                                     print(String(describing: error))
                                     return
                                   }
                                  do {
                                      // make sure this JSON is in the format we expect
                                   let jsonc = try JSON(data: data)
                                    // let title = jsonc["data"][0]["name"].stringValue
                                    //let title = jsonc["data"][0]["parent_category_id"][1].stringValue
                                    let title = jsonc["data"]
                                    //let lngth = jsonc["length"]
                                    if (title.count > 0){
                                        for i in 0..<title.count {
                                    //if (lngth.intValue > 0){
                                      //      for i in 0..<lngth.intValue {
                                                var catId, Id, slaTmr ,catName, Name, priority: String
                                                catId = title[i]["parent_category_id"][0].stringValue
                                                catName = title[i]["parent_category_id"][1].stringValue
                                                Id = title[i]["id"].stringValue
                                                Name = title[i]["name"].stringValue
                                                priority = title[i]["priority"].stringValue
                                                slaTmr = title[i]["sla_timer"].stringValue
                                                // set your values into models property like this
     //5F2
                                                self.insertCategorySubcategory(Id: Id,Name: Name,catId: catId,catName: catName,priority: priority,slaTmr: slaTmr)
                                                
                                            }
                                                self.instanceOfUser.writeAnyData(key: "offsetz", value: self.instanceOfUser.readIntData(key:  "offsetz") + 80)
                                         self.DownldCategory(Tkn: Tkn)
                                        }
                                    else{
                                     self.instanceOfUser.writeAnyData(key: "offsetz", value: 0)
                                        //5F3
                                        self.task1.cancel()
                                    self.DownldSpace(Tkn:  Tkn)
                                    self.instanceOfUser.writeAnyData(key: "offsetz", value: 0)
                                            }
                                      }
                                   catch let error as NSError {
                                      print("Failed to load: \(error.localizedDescription)")
                                  }
                                 }
                          task1.resume()

        }
    func getlastUpdateDateTimeSpace() -> String {

                  var string1 = ""
                   let file_URL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                   .appendingPathComponent(instanceOfUser.readStringData(key: "dbNamez"))
                   //opening the database
                   if sqlite3_open(file_URL.path, &db) != SQLITE_OK {
                      print("There's error in opening the database")
                   }
                else
                {
                   let queryStatementString = "SELECT last_update_date_time_space FROM tbl_last_update_data WHERE id = (SELECT MAX(id) FROM tbl_last_update_data);"
                   var queryStatement: OpaquePointer?
                   if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) ==
                       SQLITE_OK {
                     // 2
                     if sqlite3_step(queryStatement) == SQLITE_ROW{
                         string1 =    String(cString: sqlite3_column_text(queryStatement, 0))
                        instanceOfUser.writeAnyData(key: "lastUpdtdDtTimSpace", value: string1)
                    }
                    else{//if the tbl is empty
                         string1 = ""
                        instanceOfUser.writeAnyData(key: "lastUpdtdDtTimSpace", value: "")
                    }
                   } else {
                       // 6
                     let errorMessage = String(cString: sqlite3_errmsg(db))
                     print("\nQuery is not prepared \(errorMessage)")
                   }

                    sqlite3_finalize(queryStatement)
                    sqlite3_close(db)
                    db = nil
               }
        return (string1)
        }
        func getCompLogo(Tkn: String) {
         
                                    var request = URLRequest(url: URL(string: "https://demo.helixsense.com/api/v2/iread")!,timeoutInterval: Double.infinity)
                                    let string1 = "Bearer "
                                    let string2 = Tkn
                                    let combined2 = "\(string1) \(String(describing: string2))"
                                    request.addValue(combined2, forHTTPHeaderField: "Authorization")
                                    let stringFields = """
                                    [
                                    """
                                    let closg = """
                                    ]
                                    """
                                    let  stringRole1 = "&ids="
                                    let stringRole2 = stringFields
                                    let cId = instanceOfUser.readStringData(key: "CompIdz")
                                    let varRole = "\(stringRole1) \(String(describing: stringRole2))\(cId)\(closg)"
                                    let stringDomain1 = "&fields="
                                    let varDomain = "\(stringDomain1)\(["logo"])"
                                    let postData = NSMutableData(data: "model=res.company".data(using: String.Encoding.utf8)!)
                                    postData.append(varRole.data(using: String.Encoding.utf8)!)
                                    postData.append(varDomain.data(using: String.Encoding.utf8)!)
                                    request.httpBody = postData as Data
                                    request.httpMethod = "POST"
                                    let task1 = URLSession.shared.dataTask(with: request) { data, response, error in
                                         guard let data = data else {
                                           print(String(describing: error))
                                           return
                                         }
                                        do {
                                            let jsonc = try JSON(data: data)
                                           let title = jsonc["data"][0]["logo"].stringValue
                                           self.instanceOfUser.writeAnyData(key: "CompLogoz", value: title)
                                            
                                            //5E1!!!
                                            sleep(1)
                                            OperationQueue.main.addOperation {
                                                let storyBoard: UIStoryboard = UIStoryboard(name: "DStoryboard", bundle: nil)
                                                if #available(iOS 10.0, *) {
                                                    /*
                                                    let newViewController = storyBoard.instantiateViewController(withIdentifier: "Dstory") as! DViewController
                                                                                                 self.present(newViewController, animated: true, completion: nil)
                                                    */

                                                    let storyboard = UIStoryboard(name: "cvdDashbrdStoryboard", bundle: nil)
                                                         let mainTabBarController = storyboard.instantiateViewController(identifier: "tabBarStory")
                                                         mainTabBarController.modalPresentationStyle = .fullScreen
                                                         self.present(mainTabBarController, animated: true, completion: nil)
                                               
                                                
                                                } else {
                                                    // Fallback on earlier versions
                                                }
                                               
                                            }
                                            }
                                         catch let error as NSError {
                                            print("Failed to load: \(error.localizedDescription)")
                                        }
                                       }
                                task1.resume()
                 
                 
         }
        
        
       

     func pauseReason(Tkn: String) {
                                       var request = URLRequest(url: URL(string: "https://demo.helixsense.com/api/v2/isearch_read")!,timeoutInterval: Double.infinity)
                                       let string1 = "Bearer "
                                       let string2 = Tkn
                                       let combined2 = "\(string1) \(String(describing: string2))"
                                       request.addValue(combined2, forHTTPHeaderField: "Authorization")
                                       let stringFields = """
                                       ["name"]
                                       """
                                    
                                       let stringDomain1 = "&fields="
                                       let varDomain = "\(stringDomain1)\(String(describing: stringFields))"
                                       let postData = NSMutableData(data: "model=mro.pause.reason".data(using: String.Encoding.utf8)!)
                                       postData.append(varDomain.data(using: String.Encoding.utf8)!)
                                       request.httpBody = postData as Data
                                       request.httpMethod = "POST"

                                     let task1 = URLSession.shared.dataTask(with: request) { data, response, error in
                                       guard let data = data else {
                                         print(String(describing: error))
                                         return
                                       }
                                      do {
                                          // make sure this JSON is in the format we expect
                                          let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                                        
                                        let jsonc = try JSON(data: data)
                                       if (jsonc["data"]  != "" ) {

                                          self.instanceOfUser.writeAnyData(key: "pauseReasonz", value: self.jsonToString(json: json))
                                        } else {
                                         //  self.lblUserErr.text = "  "
                                        //   self.lblUserErr.isHidden = true
                                        //   self.erricn.isHidden = true
                                           self.instanceOfUser.writeAnyData(key: "pauseReasonz", value: "")
                                        }
                                          }
                                       catch let error as NSError {
                                          print("Failed to load: \(error.localizedDescription)")
                                      }
                                     }
                              task1.resume()
               
               
       }
func UserRole(Tkn: String) {
                                var request = URLRequest(url: URL(string: "https://demo.helixsense.com/api/v2/isearch_read")!,timeoutInterval: Double.infinity)
                                let string1 = "Bearer "
                                let string2 = Tkn
                                let combined2 = "\(string1) \(String(describing: string2))"
                                request.addValue(combined2, forHTTPHeaderField: "Authorization")
                                let stringFields = """
                                ["roles"]
                                """
                                let stringDomain = """
                                [["user_id","=",
                                """
                                let stringDomain3 = """
                                ]]
                                """
                                let stringRole1 = "&fields="
                                let stringRole2 = stringFields
                                let varRole = "\(stringRole1) \(String(describing: stringRole2))"
                                let stringDomain1 = "&domain="
                                let stringDomain2 = instanceOfUser.readIntData(key: "uIdz")
                                let varDomain = "\(stringDomain1) \(String(describing: stringDomain))\(stringDomain2)\(stringDomain3)"
                                let postData = NSMutableData(data: "model=user.management".data(using: String.Encoding.utf8)!)
                                postData.append(varRole.data(using: String.Encoding.utf8)!)
                                postData.append(varDomain.data(using: String.Encoding.utf8)!)
                                request.httpBody = postData as Data
                                request.httpMethod = "POST"
                              let task1 = URLSession.shared.dataTask(with: request) { data, response, error in
                                guard let data = data else {
                                  print(String(describing: error))
                                  return
                                }
                               do {
                                   // make sure this JSON is in the format we expect roles
                                  let json = try JSON(data: data)
                                if (json["data"][0]["roles"] != "technician" ) {
                                   print("The role is not a technician")
                                   //   self.lblUserErr.text = "  The User is not a technician"
                                 //     self.lblUserErr.isHidden = false
                                 //     self.erricn.isHidden = false
                                    return
                                 } else {
                                  //  self.lblUserErr.text = "  "
                                 //   self.lblUserErr.isHidden = true
                                 //   self.erricn.isHidden = true
                                    self.instanceOfUser.writeAnyData(key: "employeeRolez", value: "technician")
                                 }
                                   }
                                catch let error as NSError {
                                   print("Failed to load: \(error.localizedDescription)")
                               }
                              }
                       task1.resume()
        
        
}
   
        func CompanyDetails(Tkn: String) {
                                       var request = URLRequest(url: URL(string: "https://demo.helixsense.com/api/v2/userinfo")!,timeoutInterval: Double.infinity)
                                       let string1 = "Bearer "
                                       let string2 = Tkn
                                       let combined2 = "\(string1) \(String(describing: string2))"
                                      request.addValue(combined2, forHTTPHeaderField: "Authorization")
                                      request.httpMethod = "GET"
                                      let task1 = URLSession.shared.dataTask(with: request) { data, response, error in
                                        guard let data = data else {
                                          print(String(describing: error))
                                          return
                                        }
                                       do {
                                        //let jsonc = try JSON(data: data)
                                       // let title = jsonc["child_company_ids"][0]["name"].stringValue
                                        
                                        // let title = jsonc["child_company_ids"][0]["id"].int
                                        //let title = jsonc["address"]["locality"].stringValue
                                       // print(title)
                                        
                                            
                                           // make sure this JSON is in the format we expect
                                              let json = try JSON(data: data)
                                      //  self.instanceOfUser.writeAnyData(key: "UserDetailz", value: self.jsonToString(json: json as AnyObject) )
                                        self.instanceOfUser.writeAnyData(key: "employeeEmailz", value: json["data"]["email"].stringValue )
                                            self.instanceOfUser.writeAnyData(key: "CompNamez", value: json["data"]["company_name"].stringValue )
                                        self.instanceOfUser.writeAnyData(key: "CompIdz", value: json["data"]["company_id"].int ?? 0 )
                                        }
                                        catch let error as NSError {
                                           print("Failed to load: \(error.localizedDescription)")
                                       }
                                      }
                               task1.resume()
                
                
        }
        func jsonToString(json: AnyObject) -> String{
            do {
                let data1 = try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted)
                let convertedString = String(data: data1, encoding: String.Encoding.utf8) as NSString? ?? ""
                return convertedString as String
            } catch let myJSONError {
                debugPrint(myJSONError)
                return ""
            }
        }
        func UserDetails(Tkn: String){
                              var request = URLRequest(url: URL(string: "https://demo.helixsense.com/api/v2/user")!,timeoutInterval: Double.infinity)
                              let string1 = "Bearer "
                              let string2 = Tkn
                              let combined2 = "\(string1) \(String(describing: string2))"
                              request.addValue(combined2, forHTTPHeaderField: "Authorization")
                              request.httpMethod = "GET"
                              let task1 = URLSession.shared.dataTask(with: request) { data, response, error in
                                guard let data = data else {
                                  print(String(describing: error))
                                  return
                                }
                               do {
                                
                                   // make sure this JSON is in the format we expect
                                let jsonc = try JSON(data: data)
                                 let title = jsonc["data"]
                                 if (title.count > 0){
                                    self.instanceOfUser.writeAnyData(key: "employeeIdz", value: title["employee_id"].int ?? 0)
                                    self.instanceOfUser.writeAnyData(key: "employeeNamez", value: title["employee_name"].stringValue )
                                    self.instanceOfUser.writeAnyData(key: "UserNamez", value: title["name"].stringValue )
                                    self.instanceOfUser.writeAnyData(key: "uIdz", value: title["uid"].int!)
                                
                                        }
                                   }
                                catch let error as NSError {
                                   print("Failed to load: \(error.localizedDescription)")
                               }
                              }
                              task1.resume()
                
                
        }
func gpsEnable(){
        // 1
         let status = CLLocationManager.authorizationStatus()
         
         switch status {
             // 1
         case .notDetermined:
                 locationManager.requestWhenInUseAuthorization()
                 return
             
             // 2
         case .denied, .restricted:
             DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
             AlertView.instance.showAlert(title: "Alert", message: "Enable device GPS", alertType: .failure)
                }
             return
         case .authorizedAlways, .authorizedWhenInUse:
             break
        
         }
        }
   
        func topMostController() -> UIViewController {
            var topController: UIViewController = UIApplication.shared.keyWindow!.rootViewController!
            while (topController.presentedViewController != nil) {
                topController = topController.presentedViewController!
            }
            return topController
        }
        func updateUserInterface() {
            if(UIDevice.current.freeDiskSpaceInBytes() > 4000000000)
            {
                //if Network is available
                if (Network.reachability.isReachable){
                    gpsEnable()
                }
                else{
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
                    AlertView.instance.showAlert(title: "Alert", message: "No Internet", alertType: .failure)
                    }
                    
                }
            }
            else
            {
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
                    AlertView.instance.showAlert(title: "Alert", message: "Insufficient Storage", alertType: .failure)
                       }
            }
        }
        
        @objc func statusManager(_ notification: Notification) {
            updateUserInterface()
        }
    

        func makeDB() {
            //the database file

                  let file_URL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                    .appendingPathComponent(instanceOfUser.readStringData(key: "dbNamez"))
                    //opening the database
                    if sqlite3_open(file_URL.path, &db) != SQLITE_OK {
                        print(db ?? "")
                    }
                    //creating table
           
            /*
             if sqlite3_exec(db, self.instanceOfUser.readStringData(key: "CREATE_TABLE_O"), nil, nil, nil) != SQLITE_OK {
                                   let errorMsg = String(cString: sqlite3_errmsg(db)!)
                                   print("There's error creating the table: \(errorMsg)")
                                }
                  //makeDB()
                  self.txtUser.delegate = self
                  self.txtPwd.delegate = self
                  txtUser.text = "helli"
            var statement: OpaquePointer?
            guard let user_name = txtUser.text, !user_name.isEmpty else {
               return
            }
            let query = "INSERT INTO CREATE_TABLE_O (name) VALUES (?)"
            if sqlite3_prepare(db, query, -1, &statement, nil) != SQLITE_OK {
               let errmsg = String(cString: sqlite3_errmsg(db)!)
               print("error preparing insert: \(errmsg)")
               return
            }
            if sqlite3_bind_text(statement, 1, user_name, -1, nil) != SQLITE_OK {
               let errmsg = String(cString: sqlite3_errmsg(db)!)
               print("failure binding name: \(errmsg)")
               return
            }
            if sqlite3_step(statement) != SQLITE_DONE {
               let errmsg = String(cString: sqlite3_errmsg(db)!)
               print("failure inserting users: \(errmsg)")
               return
            }
            let queryq = "SELECT * FROM CREATE_TABLE_O"
               var statementq:OpaquePointer?
               if sqlite3_prepare(db, queryq, -1, &statementq, nil) != SQLITE_OK {
                  let errmsg = String(cString: sqlite3_errmsg(db)!)
                  print("error preparing insert: \(errmsg)")
                  return
               }
               while(sqlite3_step(statementq) == SQLITE_ROW) {
                  let name = String(cString: sqlite3_column_text(statementq, 1))
                  print(name)
               }*/
           // print(self.instanceOfUser.readStringData(key: "CREATE_TABLE_LAST_UPDATE_VALUE"))
            if sqlite3_exec(db,self.instanceOfUser.readStringData(key: "CREATE_TABLE_SPACE_DETAILS") , nil, nil, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error creating table: \(errmsg)")
            }
            if sqlite3_exec(db,self.instanceOfUser.readStringData(key: "CREATE_TABLE_UPLOAD") , nil, nil, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error creating table: \(errmsg)")
            }
            if sqlite3_exec(db,self.instanceOfUser.readStringData(key: "CREATE_TABLE_CHECKLIST") , nil, nil, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error creating table: \(errmsg)")
            }
            if sqlite3_exec(db,self.instanceOfUser.readStringData(key: "CREATE_TABLE_TIMESHEET") , nil, nil, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error creating table: \(errmsg)")
            }
            if sqlite3_exec(db,self.instanceOfUser.readStringData(key: "CREATE_TABLE_SMARTLOGGER") , nil, nil, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error creating table: \(errmsg)")
            }
            if sqlite3_exec(db,self.instanceOfUser.readStringData(key: "CREATE_TABLE_SMARTLOGGER_DETAILS") , nil, nil, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error creating table: \(errmsg)")
            }
            if sqlite3_exec(db,self.instanceOfUser.readStringData(key: "CREATE_TABLE_SMARTLOGGER_CAPTURED") , nil, nil, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error creating table: \(errmsg)")
            }
            if sqlite3_exec(db,self.instanceOfUser.readStringData(key: "CREATE_TABLE_CATEGORY_SUBCATEGORY") , nil, nil, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error creating table: \(errmsg)")
            }
            if sqlite3_exec(db,self.instanceOfUser.readStringData(key: "CREATE_TABLE_SHIFT_HANDOVER") , nil, nil, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error creating table: \(errmsg)")
            }
            if sqlite3_exec(db,self.instanceOfUser.readStringData(key: "CREATE_TABLE_LAST_UPDATE_VALUE") , nil, nil, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error creating table: \(errmsg)")
            }
            if sqlite3_exec(db,self.instanceOfUser.readStringData(key: "CREATE_TABLE_ORDERS") , nil, nil, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error creating table: \(errmsg)")
            }
            }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    }

extension ViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        lblUserErr.isHidden = true
        return true
    }
}

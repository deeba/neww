//
//  ReviewTicketViewController.swift
//  AMTfm
//
//  Created by Serge Vysotsky on 04.06.2020.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//

import UIKit
import SwiftyJSON
final class ReviewTicketViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var rootLocationTitle: UILabel!
    @IBOutlet weak var lastLocationTitle: UILabel!
    @IBOutlet weak var categoryTitle: UILabel!
    @IBOutlet weak var issueTypeLabel: UILabel!
    @IBOutlet weak var subcategoryTitle: UILabel!
    @IBOutlet weak var subcategoryTimeLabel: UILabel!
    @IBOutlet weak var subcategoryPriorityLabel: UILabel!
    @IBOutlet weak var subcategoryPriorityColorView: DesignableView!
    @IBOutlet weak var pickImageButton: UIButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textViewPlaceholderLabel: UILabel!
    
    @IBOutlet weak var lblTm: UILabel!
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    @IBOutlet var collectionBottomConstraint: NSLayoutConstraint!
    var cntr:  Int =  0
    var ticketData: TicketData!
    var substring = ""
    var images = [UIImage]()
    let instanceOfUser = readWrite()
    override func viewDidLoad() {
        super.viewDidLoad()
        ConstrctDta(Tkn:self.instanceOfUser.readStringData(key: "accessTokenz") )
        tmNamesModl.TmNam.removeAll()
        tmNamesModl.TmId.removeAll()
        rootLocationTitle.text = ticketData.locationPath.first?.name
        lastLocationTitle.text = ticketData.locationPath.last!.name + " ("   + instanceOfUser.readStringData(key: "selLocn") + ")"
        categoryTitle.text = ticketData.category?.name
        subcategoryTitle.text = ticketData.subcategory?.name
        subcategoryTimeLabel.text = ticketData.subcategory?.formattedTime
        //subcategoryTimeLabel.text = ticketData.subcategory?.duration
        subcategoryPriorityLabel.text = ticketData.subcategory?.priority.title
        subcategoryPriorityColorView.backgroundColor = ticketData.subcategory?.priority.color
        
        imagesCollectionView.isHidden = true
        collectionBottomConstraint.isActive = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIApplication.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIApplication.keyboardWillHideNotification, object: nil)
    }
      func ConstrctDta(Tkn: String)
          
      {
      var request = URLRequest(url: URL(string: "https://demo.helixsense.com/api/v2/isearch_read")!,timeoutInterval: Double.infinity)
      let string1 = "Bearer "
      let string2 = Tkn
          var closg = ""
      let combined2 = "\(string1) \(String(describing: string2))"
      request.addValue(combined2, forHTTPHeaderField: "Authorization")
      let stringFields = """
      []
      """
    
       closg = """
      ["name"]
      """
        
          
      let  stringRole1 = "&domain="
      let varRole = "\(stringRole1)\(String(describing: stringFields))"
      let stringDomain1 = "&fields="
      let varDomain = "\(stringDomain1)\(String(describing: closg))"
      let postData = NSMutableData(data: "model=mro.maintenance.team".data(using: String.Encoding.utf8)!)
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
                 // make sure this JSON is in the format we expect
              let jsonc = try JSON(data: data)
                let title = jsonc["data"]
               //let title = jsonc["data"][0]["parent_category_id"][1].stringValue
                if (title.count > 0){
                    for i in 0..<title.count {
                      tmNamesModl.TmNam.append(jsonc["data"][i]["name"].stringValue)
                      tmNamesModl.TmId.append(jsonc["data"][i]["id"].int!)
                       }
                   }
               
                 }
              catch let error as NSError {
                 print("Failed to load: \(error.localizedDescription)")
              }
              }
                 task1.resume()

        }
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let frame = notification.userInfo?[UIApplication.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        scrollView.contentInset.bottom = frame.height
        
        let bottomPoint = textView.frame.origin.y + textView.frame.height + 20
        UIView.animate(withDuration: 0.3) {
            self.scrollView.contentOffset.y += frame.height - bottomPoint
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.scrollView.contentInset.bottom = 0
        }
    }
    
    func attachPhoto(_ sourceType: UIImagePickerController.SourceType) {
        resignResponder()
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = sourceType
        present(picker, animated: true)
    }
    
    @IBAction func cancel() {
        navigationController?.popToRootViewController(animated: true)
    }
    func resize(image: UIImage, maxHeight: Float = 350.0, maxWidth: Float = 350.0, compressionQuality: Float = 0.5) -> Data? {
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
    func submitRseTkt(Tkn: String)
     {
         RseTktApi(Tkn:self.instanceOfUser.readStringData(key: "accessTokenz") )
       
    }
    
    func RseTktApi(Tkn: String) {
       let stringFields = """
           {"subject":"New request","type_category":"asset","category_id":
           """
       
        let msgs = Int(ticketData.category!.Id)
    var request = URLRequest(url: URL(string: "https://demo.helixsense.com/api/v2/create")!,timeoutInterval: Double.infinity)
    let string1 = "Bearer "
    let string2 = Tkn
    let combined2 = "\(string1) \(String(describing: string2))"
    request.addValue(combined2, forHTTPHeaderField: "Authorization")
    
       let closg = """
       ,"sub_category_id":
       """
       let closg1 = """
    ,"channel":"mobile_app","issue_type":"
    """
       let closg3 = """
       ","asset_id":"
       """
       
       let MTmId = """
       ","maintenance_team_id":"
       """
       let closg2 = """
              ","at_done_mro":true}
              """
       let  stringsubCatId = Int(ticketData.subcategory!.Id)
    let  stringRole1 = "&values="
       var TmIdd = ""
              var isuTyp = ""
              if instanceOfUser.readStringData(key: "selTemId") == ""
              {
                  TmIdd = "310"
              }
              else
              {
                  TmIdd = instanceOfUser.readStringData(key: "selTemId")
              }
    let varRole = "\(stringRole1)\(stringFields)\(msgs!)\(closg)\(stringsubCatId!)\(closg1)\(issueTypeLabel.text!.lowercased())\(closg3)\(instanceOfUser.readStringData(key: "selLocnId"))\(MTmId)\(TmIdd)\(closg2)"
    let postData = NSMutableData(data: "model=website.support.ticket".data(using: String.Encoding.utf8)!)
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
                   let array = jsonc["data"]
                   let InsrtWOArrayz = array.compactMap{ $0  }
                   for (key, value) in InsrtWOArrayz {
                       self.substring = value.stringValue
                   }
                sleep(1)
               // self.upldImg(Tkn: self.instanceOfUser.readStringData(key: "accessTokenz") )
                // let title = jsonc["data"][0]["name"].stringValue
                //let title = jsonc["data"][0]["parent_category_id"][1].stringValue
               /*

                   */
                  }
               catch let error as NSError {
                  print("Failed to load: \(error.localizedDescription)")
               }
            }
               task1.resume()

      }
    func upldImg(Tkn: String) {
        if Int(substring)!  > 0 {
               if (self.images.count) > 0 {
                     print(self.images.count)
                       for k in 0...self.images.count - 1
                       {
                           let currentDate = NSDate()
                           let dateFormatter = DateFormatter()
                           dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                           let convertedDate = dateFormatter.string(from: currentDate as Date)
                         let imageData: Data? = self.images[k].jpegData(compressionQuality: 0.4)
                         //  let imageStr = imageData?.base64EncodedString(options: .lineLength64Characters) ?? ""
                           
                          //   let imageData: Data? = self.resize(image: self.images[k])
                            var imageStr = imageData?.base64EncodedString(options: .lineLength64Characters) ?? ""
                         imageStr =  imageStr.trimmingCharacters(in: .whitespacesAndNewlines)
                        imageStr =  String(imageStr.filter { !"\r\n\n\t\r".contains($0) })
                              let dataDecoded : Data = Data(base64Encoded: imageStr, options: .ignoreUnknownCharacters)!
                             let decodedimage = UIImage(data: dataDecoded)
                              let stringFields = """
                                  {
                                  "name":"Transformer Check Lists",
                                  "display_name":"Transformer Check Lists",
                                  "type":"binary",
                                  "datas_fname": "
                                  """
                           var request = URLRequest(url: URL(string: "https://demo.helixsense.com/api/v2/create")!,timeoutInterval: Double.infinity)
                           let string1 = "Bearer "
                           let string2 = Tkn
                           let combined2 = "\(string1) \(String(describing: string2))"
                           request.addValue(combined2, forHTTPHeaderField: "Authorization")
                           
                              let closg = """
                              ",
                              "res_model":"website.support.ticket",
                               "ir_attachment_categ":"",
                              "res_id":
                              """
                              let closg1 = """
                           "}
                           """
                            let closg2 = """
                           ,"mimetype":"image/png","datas":"
                           """
                           let  stringRole1 = "&values="
                           let varRole = "\(stringRole1)\(stringFields)\(convertedDate)\(String(describing: closg))\(substring)\(String(describing: closg2))\(imageStr)\(closg1)"
                           let postData = NSMutableData(data: "model=ir.attachment".data(using: String.Encoding.utf8)!)
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
                                       let title = jsonc["data"]
                                       if (title.count > 0)
                                              {
                                                }
                                         }
                                      catch let error as NSError {
                                         print("Failed to load: \(error.localizedDescription)")
                                      }
                                   }
                                      task1.resume()

                             
                       }
                   }
             }
        }
    @IBAction func submit() {
        submitRseTkt(Tkn:self.instanceOfUser.readStringData(key: "accessTokenz"))
       LoaderSpin.shared.showLoader(self)
        APIClient_redesign.shared().getTokenz { status in
                   if status {
                       APIClient.shared().dashBrdApi()
                     }
                   }
        sleep(2)
        let storyboard = UIStoryboard(name: "cvdDashbrdStoryboard", bundle: nil)
        let mainTabBarController = storyboard.instantiateViewController(identifier: "tabBarStory")
        mainTabBarController.modalPresentationStyle = .fullScreen
        self.present(mainTabBarController, animated: true, completion: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.configNavigationBar(title: "Select a Location")
    }
    @IBAction func btnCncl() {
      
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let destination = segue.destination as? PickSourceViewController {
            destination.completion = { [weak self] sourceType in
                self?.attachPhoto(sourceType)
            }
        }
        
        if let destination = segue.destination as? PickIssueTypeViewController {
            destination.completion = { [weak self] issue in
                self?.issueTypeLabel.text = issue
            //    self?.issueTypeLabel.text = issue.title
            }
        }
        if let destination = segue.destination as? SelectMaintenanceTeamViewController {
                   destination.completion = { [weak self] issue in
                       self?.lblTm.text = issue
                   //    self?.issueTypeLabel.text = issue.title
                   }
               }
        if let destination = segue.destination as? SelectCategoryViewController {
            destination.completion = { [weak self] category in
                self?.ticketData.category = category
                self?.categoryTitle.text = category.name
                self?.navigationController?.popToViewController(self!, animated: true)
            }
        }
        
        if let destination = segue.destination as? SelectSubcategoryViewController {
            destination.ticketData = ticketData
            destination.completion = { [weak self] subcategory in
                self?.ticketData.subcategory = subcategory
                self?.subcategoryTitle.text = subcategory.name
                self?.subcategoryTimeLabel.text = subcategory.formattedTime
                //self?.subcategoryTimeLabel.text = subcategory.duration
                self?.subcategoryPriorityLabel.text = subcategory.priority.title
                self?.subcategoryPriorityColorView.backgroundColor = subcategory.priority.color
                self?.navigationController?.popToViewController(self!, animated: true)
            }
        }
    }
}

extension ReviewTicketViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        defer { picker.dismiss(animated: true, completion: nil) }
        guard let pickedImage = info[.originalImage] as? UIImage else { return }
        images.append(pickedImage)
        reloadCollection()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension ReviewTicketViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        textViewPlaceholderLabel.isHidden = !textView.text.isEmpty
    }
}

extension ReviewTicketViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = ImageCollectionCell.dequeue(from: collectionView, for: indexPath)
        cell.imageView.image = images[indexPath.row]
        cell.deleteCompletion = { [weak self] in
            self?.images.remove(at: indexPath.row)
            self?.reloadCollection()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 86, height: 92)
    }
    
    func reloadCollection() {
        imagesCollectionView.isHidden = images.isEmpty
        collectionBottomConstraint.isActive = !images.isEmpty
        imagesCollectionView.reloadData()
        view.layoutIfNeeded()
    }
}

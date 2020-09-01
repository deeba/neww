//
//  attendnceViewController.swift
//  HSpace
//
//  Created by DEEBA on 17.07.20.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//

import UIKit

import SVProgressHUD
class attendnceViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    @IBAction func btncnclAttendnce(_ sender: UIButton) {
        
        LoaderSpin.shared.showLoader(self)
         APIClient.shared().getToken { status in
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
    @IBOutlet weak var lbl_noDataAvilable: UILabel!
    @IBOutlet weak var collView     : UICollectionView!
    @IBOutlet weak var lblDateRange     : UILabel!
    @IBOutlet weak var dateView     : UIView!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var lbl_week: UILabel!
    @IBOutlet weak var viewGraph: UIView!
    @IBOutlet weak var viewTarget: UIButton!
    var mondayDate : Date = Date()
    var arrData = NSArray()
    var strStartDate : String = ""
    var strEndDate : String = ""
    var arrAllGaphData = NSMutableArray()
    var dicAllDates = NSMutableDictionary()
    var scrollView = UIScrollView()
    var AllDates = NSMutableArray()
    var isSelectWeek : Bool = false
    
    let instanceOfUser = readWrite()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.isSelectWeek = true
        self.lbl_noDataAvilable.isHidden = true
        mondayDate = Date.init().startOfWeek1!
        
        self.tblView.tableFooterView = UIView()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        self.strStartDate = formatter.string(from: Date().startOfWeek1!)
        self.strEndDate = formatter.string(from: Date().endOfWeek1!)
        
        self.lblDateRange.text = "\(self.strStartDate) - \(self.strEndDate)"
        
        let cal = NSCalendar.current
        let comp = cal.dateComponents(Set([.weekOfYear]),from: self.mondayDate)
        self.lbl_week.text = "WEEK \(comp.weekOfYear as! Int)"
        
        self.printDatesBetweenInterval(self.strStartDate, self.strEndDate)
        self.getToken()
    }
    
    func printDatesBetweenInterval(_ start: String, _ end: String) {
        
        self.AllDates.removeAllObjects()
        
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy-MM-dd"
        
        var startDate = fmt.date(from: start)
        var endDate = fmt.date(from: end)
        
        let calendar = Calendar.current
        
        while startDate!.compare(endDate!) != .orderedDescending {
            self.AllDates.add(fmt.string(from: startDate!))
            startDate = calendar.date(byAdding: .day, value: 1, to: startDate!)!
            
        }
        
    }
    
    @IBAction func btn_setting(_ sender: Any) {
    }
    @IBAction func btn_calender(_ sender: Any) {
        
        // create the alert
        let alert = UIAlertController(title: "Select Types", message:"Please Select weekly or monthly option", preferredStyle: UIAlertController.Style.alert)
        
        // add the actions (buttons)
        
        alert.addAction(UIAlertAction.init(title: "Weekly", style: .default, handler: { (action) in
            
            
            //self.isSelectWeek = true
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            
            self.strStartDate = formatter.string(from: Date().startOfWeek1!)
            self.strEndDate = formatter.string(from: Date().endOfWeek1!)
            
            let cal = NSCalendar.current
            let comp = cal.dateComponents(Set([.weekOfYear]),from: Date().startOfWeek1!)
            self.lbl_week.text = "WEEK \(comp.weekOfYear as! Int)"
            
            self.lblDateRange.text = "\(self.strStartDate) - \(self.strEndDate)"
            
            self.dicAllDates = NSMutableDictionary()
            self.arrAllGaphData.removeAllObjects()
            self.printDatesBetweenInterval(self.strStartDate, self.strEndDate)
            self.getToken()
            
        }))
        alert.addAction(UIAlertAction.init(title: "Monthly", style: .default, handler: { (action) in
            
            self.isSelectWeek = false
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            
            self.strStartDate = formatter.string(from: Date().startOfMonthz())
            self.strEndDate = formatter.string(from: Date().endOfMonthz())
            
            self.lbl_week.text = "\(Date().startOfMonthz().month.uppercased()) - \(Date().startOfMonthz().year)"

            self.lblDateRange.text = "\(self.strStartDate) - \(self.strEndDate)"
            
            self.dicAllDates = NSMutableDictionary()
            self.arrAllGaphData.removeAllObjects()
            self.printDatesBetweenInterval(self.strStartDate, self.strEndDate)

            self.getToken()
            
        }))
        
        
        self.present(alert, animated: true, completion: nil)
    }
    @IBAction func onClickBack(_ sender: Any) {
         self.dismiss(animated: true, completion: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           self.navigationController?.setNavigationBarHidden(false, animated: false)
           self.configNavigationBar(title: "Attendances")
       }
    @IBAction func btn_backScroll(_ sender: Any) {
        
        if self.isSelectWeek
        {
            // self.lbl_week.text = "WEEK"
            
            
            self.mondayDate = self.mondayDate.addDay(day: -7)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dayInWeek1 = dateFormatter.string(from: self.mondayDate.startOfWeek1!)
            let dayInWeek2 = dateFormatter.string(from: self.mondayDate.endOfWeek1!)
            
            self.lblDateRange.text = "\(dayInWeek1) - \(dayInWeek2)"
            
            let cal = NSCalendar.current
            let comp = cal.dateComponents(Set([.weekOfYear]),from: mondayDate)
            self.lbl_week.text = "WEEK \(comp.weekOfYear as! Int)"
            
            self.strStartDate = dayInWeek1
            self.strEndDate = dayInWeek2
            
            self.dicAllDates = NSMutableDictionary()
            self.arrAllGaphData.removeAllObjects()
            self.printDatesBetweenInterval(self.strStartDate, self.strEndDate)

            self.getToken()
        }
        else{
            
            
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            let strDate = self.strStartDate
            let newDate = dateFormatter.date(from: strDate)
            
            let dayInWeek1 = dateFormatter.string(from: newDate!.previousMonth)
            let nextMonthDate = dateFormatter.date(from: dayInWeek1)
            
            
            self.strStartDate = dateFormatter.string(from: nextMonthDate!.startOfMonth!)
            self.strEndDate = dateFormatter.string(from: nextMonthDate!.endOfMonth!)
            
            self.lbl_week.text = "\(nextMonthDate!.startOfMonth!.month.uppercased()) - \(nextMonthDate!.startOfMonth!.year)"

            self.lblDateRange.text = "\(self.strStartDate) - \(self.strEndDate)"
            
            self.dicAllDates = NSMutableDictionary()
            self.arrAllGaphData.removeAllObjects()
            self.printDatesBetweenInterval(self.strStartDate, self.strEndDate)

            self.getToken()
        }
        
    }
    @IBAction func btn_NextScroll(_ sender: Any) {
        
        if self.isSelectWeek
        {
            
            
            self.mondayDate = self.mondayDate.addDay(day: 7)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dayInWeek1 = dateFormatter.string(from: self.mondayDate.startOfWeek1!)
            let dayInWeek2 = dateFormatter.string(from: self.mondayDate.endOfWeek1!)
            
            self.strStartDate = dayInWeek1
            self.strEndDate = dayInWeek2
            
            self.lblDateRange.text = "\(dayInWeek1) - \(dayInWeek2)"
            
            let cal = NSCalendar.current
            let comp = cal.dateComponents(Set([.weekOfYear]),from: mondayDate)
            self.lbl_week.text = "WEEK \(comp.weekOfYear as! Int)"
            
            self.dicAllDates = NSMutableDictionary()
            self.arrAllGaphData.removeAllObjects()
            self.printDatesBetweenInterval(self.strStartDate, self.strEndDate)

            self.getToken()
        }
        else{
            
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            let strDate = self.strStartDate
            let newDate = dateFormatter.date(from: strDate)
            
            let dayInWeek1 = dateFormatter.string(from: newDate!.nextMonth)
            let nextMonthDate = dateFormatter.date(from: dayInWeek1)
            
            
            self.strStartDate = dateFormatter.string(from: nextMonthDate!.startOfMonth!)
            self.strEndDate = dateFormatter.string(from: nextMonthDate!.endOfMonth!)
            
            self.lbl_week.text = "\(nextMonthDate!.startOfMonth!.month.uppercased()) - \(nextMonthDate!.startOfMonth!.year)"

            self.lblDateRange.text = "\(self.strStartDate) - \(self.strEndDate)"
            
            self.dicAllDates = NSMutableDictionary()
            self.arrAllGaphData.removeAllObjects()
            self.printDatesBetweenInterval(self.strStartDate, self.strEndDate)

            self.getToken()
            
            
        }
    }
    //MARK:- API Calling
    
    func clllingAPI(tokenType:String,token:String) {
        
        var semaphore = DispatchSemaphore (value: 0)
        
        var strParameter = "https://demo.helixsense.com/api/v2/isearch_read?fields=[%22planned_in%22,%22planned_out%22,%22actual_in%22,%22actual_out%22,%22planned_status%22,%22shift_id%22,%22working_hours%22,%22space_id%22,%22space_name%22]&model=mro.shift.employee&order=planned_in%20ASC&domain=[%22%26%22,[%22planned_in%22,%22%3E=%22,%22\(self.strStartDate)%22],[%22planned_in%22,%22%3C=%22,%22\(self.strEndDate)%22],[%20%22employee_id%22,%22=%22,6244]]"
        
        var request = URLRequest(url: URL(string: strParameter)!,timeoutInterval: Double.infinity)
        
        request.addValue("\(tokenType) \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                return
            }
            print(String(data: data, encoding: .utf8)!)
            
            do{
                
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as! NSDictionary
                DispatchQueue.main.async {
                    self.dateView.isHidden = false
                }
                
                self.arrData = json.value(forKey: "data") as! NSArray
                if self.arrData.count > 0 {
                    
                    DispatchQueue.main.async {
                        self.lbl_noDataAvilable.isHidden = true
                        self.viewGraph.isHidden = false
                        self.tblView.isHidden = false
                        
                    }
                    
                    let unique = NSSet.init(array: self.arrData as! [Any])
                    
                    let allObjects = unique.allObjects as! NSArray
                    
                    for index in 0..<allObjects.count
                    {
                        let dic = allObjects.object(at: index) as! NSDictionary
                        let strDate = dic.value(forKey: "planned_in") as! String
                        
                        let split = strDate.components(separatedBy: " ")
                        let strNewDate = split[0] as! String
                        
                        let predicate = NSPredicate.init(format: "planned_in contains[c] %@", strNewDate)
                        let filteredArray = self.arrData.filtered(using: predicate) as! NSArray
                        
                        let totalHours = filteredArray.value(forKeyPath: "@sum.working_hours") as! NSNumber
                        
                        if self.dicAllDates.value(forKeyPath: strNewDate) == nil{
                            
                            self.arrAllGaphData.add(strNewDate)
                            self.dicAllDates.setValue(totalHours, forKey: strNewDate)
                            
                        }
                    }
                    
                    DispatchQueue.main.async {
                        
                        for subview in self.scrollView.subviews{
                            subview.removeFromSuperview()
                        }
                        
                        self.scrollView.frame = CGRect.init(x: 0, y: 0, width: self.viewGraph.frame.size.width, height: self.viewGraph.frame.size.height)
                        self.scrollView.backgroundColor = UIColor.clear
                        
                        var X : CGFloat = 0
                        
                        let isoFormatter = DateFormatter()
                        isoFormatter.dateFormat = "yyyy-MM-dd"
                        
                        let dates = self.arrAllGaphData.compactMap { isoFormatter.date(from: $0 as! String) }
                        
                        let sortedDates = dates.sorted { $0 < $1 }
                        let dateStrings = sortedDates.compactMap { isoFormatter.string(from: $0)}
                        
                        
                        for index in 0..<self.AllDates.count
                        {
                            
                            let strKey = self.AllDates.object(at: index) as! String
                            
                            let mainView = UIView.init(frame: CGRect.init(x: X, y: 0, width: 49, height: 197))
                            let myView = Bundle.loadView(fromNib: "GraphView", withType: GraphView.self) as! GraphView
                            
                            
                            if self.dicAllDates.value(forKey: strKey) != nil{
                                myView.lblWokingHours.text = (self.dicAllDates.value(forKey: strKey) as! NSNumber).stringValue
                                
                                var frame = CGRect()
                                frame = myView.barView.frame
                                let value = (((CFloat(self.dicAllDates.value(forKey: strKey) as! NSNumber))*90.0)/14.0)
                                frame.size.height = CGFloat(value)
                                frame.origin.y = CGFloat(103 - value+15)
                                myView.barView.frame = frame
                            }
                            else{
                                myView.lblWokingHours.text = "0"
                                
                                var frame = CGRect()
                                frame = myView.barView.frame
                                frame.size.height = 0.0
                                myView.barView.frame = frame
                            }
                            
                            
                            let arrDate = strKey.components(separatedBy: "-")
                            let strDay = arrDate[2] as! String
                            
                            myView.lblDate.text = strDay
                            
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "YYYY-MM-dd"
                            let date = dateFormatter.date(from: strKey)
                            
                            myView.lblName.text = date?.dayOfTheWeek()?.uppercased()
                            
                            mainView.addSubview(myView)
                            self.scrollView.addSubview(mainView)
                            X = X + 49
                        }
                        
                        self.scrollView.showsHorizontalScrollIndicator = false
                        self.scrollView.bounces = false
                        self.scrollView.contentSize = CGSize.init(width: X, height: self.viewGraph.frame.size.height)
                        
                        self.viewGraph.addSubview(self.scrollView)
                        
                        let predicate2 = NSPredicate.init(format: "SELF contains[c] %@", self.strStartDate)
                        let filteredArray2 = self.arrAllGaphData.filtered(using: predicate2) as! NSArray
                        
                        if filteredArray2.count > 0
                        {
                            
                            let index = self.arrAllGaphData.index(of: filteredArray2.firstObject)
                            
                            let X = ((CGFloat)(index) * 49.0)
                            
                            self.scrollView.scrollRectToVisible(CGRect.init(x: X, y: 0, width: self.viewGraph.frame.size.width, height: self.viewGraph.frame.size.height), animated: true)
                        }
                        else{
                            self.scrollView.scrollRectToVisible(CGRect.init(x: 0, y: 0, width: self.viewGraph.frame.size.width, height: self.viewGraph.frame.size.height), animated: true)
                            
                        }
                        
                        self.tblView.reloadData()
                        
                        let predicate = NSPredicate.init(format: "planned_in contains[c] %@", self.strStartDate)
                        let filteredArray = self.arrData.filtered(using: predicate) as! NSArray
                        
                        
                        
                        if filteredArray.count > 0
                        {
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
                                
                                let index = self.arrData.index(of: filteredArray.firstObject)
                                self.tblView.scrollToRow(at: IndexPath.init(row: index, section: 0), at: .top, animated: false)
                            }
                            
                        }
                        else{
                            self.tblView.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .top, animated: false)
                            
                        }
                    }
                    
                }
                else{
                    DispatchQueue.main.async {
                        
                        self.arrData = NSArray()
                        self.tblView.reloadData()
                        self.viewGraph.isHidden = true
                        self.tblView.isHidden = true
                        self.lbl_noDataAvilable.isHidden = false
                        
                    }
                }
                
            }catch{
                
            }
            semaphore.signal()
        }
        
        task.resume()
        semaphore.wait()
        
        
    }
    
    func getToken()
    {
        SVProgressHUD.show()
        
        var semaphore = DispatchSemaphore (value: 0)
        
        let strurl = "https://demo.helixsense.com/api/authentication/oauth2/token"
        
        let strParameter = "grant_type=password&username=\(String(describing:self.instanceOfUser.readStringData(key: "Userz")))&password=\(String(describing:self.instanceOfUser.readStringData(key: "Pwdz")))&client_id=clientkey&client_secret=clientsecret"
        
        var request = URLRequest(url: URL(string: strurl)!,timeoutInterval: Double.infinity)
        
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = "POST"
        
        let postData =  strParameter.data(using: .utf8)
        
        request.httpBody = postData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                return
            }
            
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
            }
            
            
            do{
                
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as! NSDictionary
                let tokenType = json.value(forKey: "token_type") as! String
                let token = json.value(forKey: "access_token") as! String
                
                DispatchQueue.main.async {
                    self.clllingAPI(tokenType: tokenType, token: token)
                }
                
                
                
            }catch{
                
            }
            semaphore.signal()
        }
        
        task.resume()
        semaphore.wait()
    }
    
    //MARK:- Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return arrData.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! attendnceTableViewCell
            
            cell.viewCellRound.layer.cornerRadius = 15
            
            let dic = arrData.object(at: indexPath.row) as? NSDictionary
            
            let actualIn = dic?.value(forKey: "actual_in") as? String
            let actualOut = dic?.value(forKey: "actual_out") as? String
            
            let plannedIn = dic?.value(forKey: "planned_in") as? String
            let plannedOut = dic?.value(forKey: "planned_out") as? String
            
            let plannedStatus = dic?.value(forKey: "planned_status") as? String
            let shiftId = dic?.value(forKey: "shift_id") as? NSArray
            
            //MARK:- planned
            
            if plannedIn != nil {
                let arrsplit = plannedIn!.components(separatedBy: " ")
                
                let strDate = arrsplit[0] as! String
                let arrDate = strDate.components(separatedBy: "-")
                let strDay = arrDate[2] as! String
                
                let strTime = arrsplit[1] as! String
                let arrTime = strTime.components(separatedBy: ":")
                
                cell.lbl_date.text = strDay
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "YYYY-MM-dd"
                let date = dateFormatter.date(from: strDate)?.toLocalTime()
                
                cell.lbl_month.text = date?.dayOfTheMonth()?.uppercased()
                
                let dayName = date!.dayOfTheWeek()
                
                dateFormatter.dateFormat = "HH:mm:ss"
                let newDate = dateFormatter.date(from: strTime)?.toLocalTime()
                dateFormatter.dateFormat = "h:mm a"
                let Date12 = dateFormatter.string(from: newDate!)
                
                //PLANNED OUTTIME "planned_out" = "2020-07-08 10:15:00";
                
                let arrsplitOut = plannedOut!.components(separatedBy: " ")
                
                let strDateOut = arrsplitOut[0] as! String
                let arrDateOut = strDateOut.components(separatedBy: "-")
                
                let strTimeOut = arrsplitOut[1] as! String
                let arrTimeOut = strTimeOut.components(separatedBy: ":")
                
                dateFormatter.dateFormat = "HH:mm:ss"
                let dateOut = dateFormatter.date(from: strTimeOut)?.toLocalTime()
                dateFormatter.dateFormat = "h:mm a"
                let Date12Out = dateFormatter.string(from: dateOut!)
                
                
                
                let dateFormatterPlanned = DateFormatter()
                dateFormatterPlanned.dateFormat = "YYYY-MM-dd HH:mm:ss"
                
                let inDate = dateFormatterPlanned.date(from: plannedIn!)?.toLocalTime()
                let outDate = dateFormatterPlanned.date(from: plannedOut!)?.toLocalTime()
                
                let hour = self.getMinutesDifferenceFromTwoDates(start: inDate!, end: outDate!)
                
                
                cell.lbl_dayAndTime.text = "\(dayName as! String), \(Date12) to \(Date12Out) (\(hour)h)"
                if shiftId != nil {
                    let shiftA = shiftId?.lastObject
                    cell.lbl_RegularA.text = "\(plannedStatus as! String) \(shiftA as! String)"
                    
                }
                
            }
            else{
                cell.lbl_dayAndTime.text = ""
            }
            
            //MARK:- Actual
            
            if actualIn != nil {
                let arrsplit = actualIn!.components(separatedBy: " ")
                
                let strDate = arrsplit[0] as! String
                let arrDate = strDate.components(separatedBy: "-")
                
                let strTime = arrsplit[1] as! String
                let arrTime = strTime.components(separatedBy: ":")
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "YYYY-MM-dd"
                let date = dateFormatter.date(from: strDate)?.toLocalTime()
                
                
                let dayName = date!.dayOfTheWeek()
                
                dateFormatter.dateFormat = "HH:mm:ss"
                let newDate = dateFormatter.date(from: strTime)?.toLocalTime()
                dateFormatter.dateFormat = "h:mm a"
                let Date12 = dateFormatter.string(from: newDate!)
                
                // OUTTIME "actual_out" = "2020-07-08 10:15:00";
                if actualOut != nil {
                    let arrsplitOut = actualOut!.components(separatedBy: " ")
                    
                    let strDateOut = arrsplitOut[0] as! String
                    let arrDateOut = strDateOut.components(separatedBy: "-")
                    
                    let strTimeOut = arrsplitOut[1] as! String
                    let arrTimeOut = strTimeOut.components(separatedBy: ":")
                    
                    dateFormatter.dateFormat = "HH:mm:ss"
                    let dateOut = dateFormatter.date(from: strTimeOut)?.toLocalTime()
                    dateFormatter.dateFormat = "h:mm a"
                    let Date12Out = dateFormatter.string(from: dateOut!)
                    
                    let dateFormatterActual = DateFormatter()
                    dateFormatterActual.dateFormat = "YYYY-MM-dd HH:mm:ss"
                    
                    let inDate = dateFormatterActual.date(from: actualIn!)
                    let outDate = dateFormatterActual.date(from: actualOut!)
                    
                    
                    
                    let hour = self.getMinutesDifferenceFromTwoDates(start: inDate!, end: outDate!)
                    
                    cell.lbl_actualDayTime.text = "\(dayName as! String), \(Date12) to \(Date12Out) (\(hour)h)"
                    
                    let shiftA = shiftId?.lastObject
                    
                    cell.lbl_actualRegualrA.text = "\(plannedStatus as! String) \(shiftA as! String)"
                    
                    var dateParse = ""
                    
                    
                }
                
                
            }
            else{
              //  cell.lbl_actualDayTime.text = "-"
            }
            
            
            return cell
        }
        
        
        
        //MARK:- Get day of week using NSDate
        
        func getDayOfWeek(_ today:String) -> Int? {
            let formatter  = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            guard let todayDate = formatter.date(from: today) else { return nil }
            let myCalendar = Calendar(identifier: .gregorian)
            let weekDay = myCalendar.component(.weekday, from: todayDate)
            return weekDay
        }
        
        func getMinutesDifferenceFromTwoDates(start: Date, end: Date) -> String
        {
            
            let diff = Int(end.timeIntervalSince1970 - start.timeIntervalSince1970)
            
            let hours = diff / 3600
            let minutes = (diff - hours * 3600) / 60
            
            return "\(hours):\(minutes)"
        }
        
    }

    //MARK:- If you want the full "Sunday", "Monday", "Tuesday", "Wednesday" etc
    extension Date {
        func dayOfTheMonth() -> String? {
            let dateFormatter = DateFormatter()
            //  dateFormatter.locale = NSLocale(localeIdentifier: "it_IT") as Locale
            dateFormatter.dateFormat = "MMM"
            return dateFormatter.string(from: self as Date)
        }
        func dayOfTheWeek() -> String? {
            let dateFormatter = DateFormatter()
            //  dateFormatter.locale = NSLocale(localeIdentifier: "it_IT") as Locale
            dateFormatter.dateFormat = "EE"
            return dateFormatter.string(from: self as Date)
        }
        
    }


    extension Date {
        
        func startOfMonthz() -> Date {
    //        let interval = Calendar.current.dateInterval(of: .month, for: self)
    //        return (interval?.start.toLocalTime())! // Without toLocalTime it give last months last date
            
            let calendar = Calendar(identifier: .gregorian)
                   let components = calendar.dateComponents([.year, .month], from: self)

                   return  calendar.date(from: components)!
        }
        
        func endOfMonthz() -> Date {
    //        let interval = Calendar.current.dateInterval(of: .month, for: self)
    //        return interval!.end
            
            var components = DateComponents()
                   components.month = 1
                   components.second = -1
            return Calendar(identifier: .gregorian).date(byAdding: components, to: startOfMonth!)!
        }
        
        // Convert UTC (or GMT) to local time
        func toLocalTime() -> Date {
            let timezone    = TimeZone.current
            let seconds     = TimeInterval(timezone.secondsFromGMT(for: self))
            return Date(timeInterval: seconds, since: self)
        }}

    extension attendnceViewController {
        
        func secondsToHoursMinutesSeconds (seconds : Double) -> (Double, Double, Double) {
            return (seconds / 3600.0, (seconds.truncatingRemainder(dividingBy: 3600.0)) / 60.0, (seconds.truncatingRemainder(dividingBy: 3600.0)).truncatingRemainder(dividingBy: 60.0))
        }
        
        
        //Mark - loader
        func showIndicator(){
            SVProgressHUD.show()
        }
        
        func hideIndicator(){
            SVProgressHUD.dismiss()
        }
        
        func showSuccessIndicator(message: String){
            SVProgressHUD.showSuccess(withStatus: message)
        }
        
    }

    extension Date {
        
        var startOfWeek1: Date? {
            let gregorian = Calendar(identifier: .gregorian)
            guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
            return gregorian.date(byAdding: .day, value: 1, to: sunday)
        }
        
        var endOfWeek1: Date? {
            let gregorian = Calendar(identifier: .gregorian)
            guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
            return gregorian.date(byAdding: .day, value: 7, to: sunday)
        }
        
        var nextDate: Date {
            return Calendar.current.date(byAdding: .day, value: 1, to: self) ?? self
        }
        
        var nextMonth: Date {
            return Calendar.current.date(byAdding: .month, value: 1, to: self) ?? self
        }
        
        var previousMonth: Date {
            return Calendar.current.date(byAdding: .month, value: -1, to: self) ?? self
        }
        
        func addDay(day:Int) -> Date {
            return Calendar.current.date(byAdding: .day, value: day, to: self) ?? self
        }
        
        func getCurrentWeek() -> Int
        {
            let calendar = Calendar.current
            let weekOfYear = calendar.component(.weekOfYear, from: type(of: self).init(timeIntervalSinceNow: 0))
            
            return weekOfYear
        }
        
        var month: String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM"
            return dateFormatter.string(from: self)
        }
        
        var year : String
        {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy"
            return dateFormatter.string(from: self)
        }
        
        
    }



    func getHeight(timeMinutes:Double) -> Double {
        //    480 - 150
        //    200 200*150/480
        return (timeMinutes*150) / 480
    }


    extension CGFloat {
        /// Rounds the double to decimal places value
        func rounded(toPlaces places:Int) -> Double {
            let divisor = pow(10.0, Double(places))
            return (Double(self) * divisor).rounded() / divisor
        }
    }

    extension Double {
        /// Rounds the double to decimal places value
        func rounded(toPlaces places:Int) -> Double {
            let divisor = pow(10.0, Double(places))
            return (self * divisor).rounded() / divisor
        }
    }

    extension Bundle {
        
        static func loadView<T>(fromNib name: String, withType type: T.Type) -> T {
            if let view = Bundle.main.loadNibNamed(name, owner: nil, options: nil)?.first as? T {
                return view
            }
            
            fatalError("Could not load view with type " + String(describing: type))
        }
        
    }

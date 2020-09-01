//
//  MyShiftsVC.swift
//  HelixSense
//
//  Created by DEEBA on 14.07.20.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//

import UIKit
import DropDown
import ObjectMapper
import DZNEmptyDataSet

class MyShiftsVC: UIViewController {
    let instanceOfUser = readWrite()
    @IBAction func btnCncl(_ sender: UIButton) {
        
        
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
    var isTest = false
    
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    @IBOutlet weak var weekLbl: UILabel!
    @IBOutlet weak var dateDurationLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var calenderBtn: UIButton!
    @IBOutlet weak var leftArrowBtn: UIButton!
    @IBOutlet weak var rightArrowBtn: UIButton!
    
    let dropDown = DropDown()
    var isDropDwonShown = false
    var isWeekly = true
    var currentWeek:Int?
    var currentMonth:Int?
    
    var shiftData:[ShiftsData]?
    var startDate:Date?
    var endDate:Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isTest{testData()}
        
        tableView.delegate = self
        tableView.dataSource = self
        
        

        weekLbl.text = ""
        dateDurationLbl.text = ""
        
        enableData(false)
        
      //  setupDropDown()
        
        switchToWeekView()
    }
    
    func testData() {
        let testData = [
            [
                "employee_id": 6241,
                "id": 87267,
                "planned_in": "2020-07-06 09:30:00",
                "planned_out": "2020-07-06 17:30:00",
                "planned_status": "Regular",
                "shift_id": 48,
                "shift_name": "B",
                "space_id": 9426,
                "space_name": "Work Station #39",
                "space_number": "WMB-A-00047",
                "space_path_name": "WMB/WBL/F#10/WS/Z#1/Row#7/WS#39",
                "space_status": "Ready"
            ],
            [
                "employee_id": 6241,
                "id": 87268,
                "planned_in": "2020-07-06 17:30:00",
                "planned_out": "2020-07-07 01:30:00",
                "planned_status": "Regular",
                "shift_id": 49,
                "shift_name": "C",
                "space_id": 9426,
                "space_name": "Work Station #39",
                "space_number": "WMB-A-00047",
                "space_path_name": "WMB/WBL/F#10/WS/Z#1/Row#7/WS#39",
                "space_status": "Ready"
            ],
            [
                "employee_id": 6241,
                "id": 87269,
                "planned_in": "2020-07-07 01:45:00",
                "planned_out": "2020-07-07 10:15:00",
                "planned_status": "Regular",
                "shift_id": 47,
                "shift_name": "A",
                "space_id": 9426,
                "space_name": "Work Station #39",
                "space_number": "WMB-A-00047",
                "space_path_name": "WMB/WBL/F#10/WS/Z#1/Row#7/WS#39",
                "space_status": "Ready"
            ],
            [
                "employee_id": 6241,
                "id": 87270,
                "planned_in": "2020-07-08 09:30:00",
                "planned_out": "2020-07-08 17:30:00",
                "planned_status": "Regular",
                "shift_id": 48,
                "shift_name": "B",
                "space_id": 9426,
                "space_name": "Work Station #39",
                "space_number": "WMB-A-00047",
                "space_path_name": "WMB/WBL/F#10/WS/Z#1/Row#7/WS#39",
                "space_status": "Ready"
            ],
            [
                "employee_id": 6241,
                "id": 87272,
                "planned_in": "2020-07-10 09:30:00",
                "planned_out": "2020-07-10 17:30:00",
                "planned_status": "Regular",
                "shift_id": 48,
                "shift_name": "B",
                "space_id": 9426,
                "space_name": "Work Station #39",
                "space_number": "WMB-A-00047",
                "space_path_name": "WMB/WBL/F#10/WS/Z#1/Row#7/WS#39",
                "space_status": "Ready"
            ],
            [
                "employee_id": 6241,
                "id": 87273,
                "planned_in": "2020-07-10 17:30:00",
                "planned_out": "2020-07-11 01:30:00",
                "planned_status": "Regular",
                "shift_id": 49,
                "shift_name": "C",
                "space_id": 9426,
                "space_name": "Work Station #39",
                "space_number": "WMB-A-00047",
                "space_path_name": "WMB/WBL/F#10/WS/Z#1/Row#7/WS#39",
                "space_status": "Ready"
            ],
            [
                "employee_id": 6241,
                "id": 87082,
                "planned_in": "2020-07-11 01:45:00",
                "planned_out": "2020-07-11 10:15:00",
                "planned_status": "Regular",
                "shift_id": 47,
                "shift_name": "A",
                "space_id": 9426,
                "space_name": "Work Station #39",
                "space_number": "WMB-A-00047",
                "space_path_name": "WMB/WBL/F#10/WS/Z#1/Row#7/WS#39",
                "space_status": "Ready"
            ],
            [
                "employee_id": 6241,
                "id": 87083,
                "planned_in": "2020-07-12 09:30:00",
                "planned_out": "2020-07-12 17:30:00",
                "planned_status": "Regular",
                "shift_id": 48,
                "shift_name": "B",
                "space_id": 9426,
                "space_name": "Work Station #39",
                "space_number": "WMB-A-00047",
                "space_path_name": "WMB/WBL/F#10/WS/Z#1/Row#7/WS#39",
                "space_status": "Ready"
            ]
        ]
        
        let dummyData = Mapper<ShiftsData>().mapArray(JSONArray: testData)
        self.shiftData = dummyData
    }
    
    func enableData(_ enable:Bool) {
        leftArrowBtn.isEnabled = enable
        rightArrowBtn.isEnabled = enable
    }
    

    
    func switchToWeekView() {
        isWeekly = true
        currentWeek = NSCalendar.current.component(.weekOfYear, from: Date())
        setDates(start: Date().startOfWeek!, end: Date().endOfWeek!, isWeek: true)
    }
    
    func switchToMonthView() {
        isWeekly = false
        currentMonth = NSCalendar.current.component(.month, from: Date())
        setDates(start: Date().startOfMonth!, end: Date().endOfMonth!, isWeek: false)
    }
    
    func setDates(start:Date, end:Date, isWeek:Bool) {
        startDate = start
        endDate = end
        
        if isWeek{
            weekLbl.text = "Week \(currentWeek!)"
        }else{
            weekLbl.text = "Month \(currentMonth!)"
        }
        
        let datefrmter = DateFormatter()
        datefrmter.locale = Locale(identifier: "en_US_POSIX")
        
        if !isTest{getShiftsData()}
    }
    
    func getShiftsData(){
        activityView.startAnimating()
        
        let datefrmter = DateFormatter()
        datefrmter.locale = Locale(identifier: "en_US_POSIX")
        //First convert date to local Date
        datefrmter.calendar = NSCalendar.current
        datefrmter.timeZone = TimeZone.current
        datefrmter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        let currentZoneStartDateStr = datefrmter.string(from: startDate!)
        let currentZoneStartDate = datefrmter.date(from: currentZoneStartDateStr)
        let currentZoneEndDateStr = datefrmter.string(from: endDate!)
        let currentZoneEndDate = datefrmter.date(from: currentZoneEndDateStr)

        datefrmter.dateFormat = "MMM d, yyyy"
        dateDurationLbl.text = "\(datefrmter.string(from: currentZoneStartDate!)) - \(datefrmter.string(from: currentZoneEndDate!))"
        
        //Now convert to UTC
        datefrmter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        datefrmter.timeZone = TimeZone(identifier: "UTC")
        
        let dateData = ["start_date":datefrmter.string(from: currentZoneStartDate!), "end_date":datefrmter.string(from: currentZoneEndDate!), "type" : isWeekly ? "weekly" : "monthly"]
                
        let bag = [
            "args": "[\(dateData.dict2json())]",
            "method": "my_shift_scheduler",
            "model" : "mro.shift.employee"
            ] as [String : Any]
        
        NetworkManager.shared().GET_SHIFTS_DATA(params: bag, onSuccess: { (data
            ) in
            self.activityView.stopAnimating()
            self.enableData(true)
            self.shiftData = data
            self.tableView.emptyDataSetSource = self
            self.tableView.emptyDataSetDelegate = self
            self.tableView.reloadData()
            
        }, onFailure: { (error) in
            self.activityView.stopAnimating()
            self.enableData(true)
            self.tableView.emptyDataSetSource = self
            self.tableView.emptyDataSetDelegate = self
            UIAlertController.showAlert(title: "Failure", message: error!.localizedDescription, vc: self, buttonTitles: ["OK"], buttonStyles: [.destructive]) { (index) in
            }
        }) { (mess) in
            self.activityView.stopAnimating()
            self.enableData(true)
            self.tableView.emptyDataSetSource = self
            self.tableView.emptyDataSetDelegate = self
            
            UIAlertController.showAlert(title: "Error", message: mess ?? "Something went wrong...", vc: self, buttonTitles: ["OK"], buttonStyles: [.destructive]) { (index) in
            }
        }
    }
    
    @IBAction func leftArrowTapped(_ sender: Any) {
        if isWeekly{
            currentWeek! -= 1
            let prevWeekDate = Calendar.current.date(byAdding: .day, value: -2, to: startDate!)!
            setDates(start: prevWeekDate.startOfWeek!, end: prevWeekDate.endOfWeek!, isWeek: true)
        }else{
            currentMonth! -= 1
            let prevWeekDate = Calendar.current.date(byAdding: .day, value: -2, to: startDate!)!
            setDates(start: prevWeekDate.startOfMonth!, end: prevWeekDate.endOfMonth!, isWeek: false)
        }
    }
    
    @IBAction func rightArrowTapped(_ sender: Any) {
        if isWeekly{
            currentWeek! += 1
            let prevWeekDate = Calendar.current.date(byAdding: .day, value: +2, to: endDate!)!
            setDates(start: prevWeekDate.startOfWeek!, end: prevWeekDate.endOfWeek!, isWeek: true)
        }else{
            currentMonth! += 1
            let prevWeekDate = Calendar.current.date(byAdding: .day, value: +2, to: endDate!)!
            setDates(start: prevWeekDate.startOfMonth!, end: prevWeekDate.endOfMonth!, isWeek: false)
        }
    }
    
    @IBAction func settingsBtnTapped(_ sender: Any) {
         // create the alert
              let alert = UIAlertController(title: "Select Types", message:"Please Select weekly or monthly option", preferredStyle: UIAlertController.Style.alert)
              
              // add the actions (buttons)
              
              alert.addAction(UIAlertAction.init(title: "Weekly", style: .default, handler: { (action) in
                  
                  
                  self.switchToWeekView()
                  
              }))
              alert.addAction(UIAlertAction.init(title: "Monthly", style: .default, handler: { (action) in
                  
                  self.switchToMonthView()
                  
              }))
              
              alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.configNavigationBar(title: "My Shifts")
    }
    @IBAction func calenderBtnTapped(_ sender: Any) {
         // create the alert
              let alert = UIAlertController(title: "Select Types", message:"Please Select weekly or monthly option", preferredStyle: UIAlertController.Style.alert)
              
              // add the actions (buttons)
              
              alert.addAction(UIAlertAction.init(title: "Weekly", style: .default, handler: { (action) in
                  
                  
                  self.switchToWeekView()
                  
              }))
              alert.addAction(UIAlertAction.init(title: "Monthly", style: .default, handler: { (action) in
                  
                  self.switchToMonthView()
                  
              }))
        self.present(alert, animated: true, completion: nil)
    }
}

extension MyShiftsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shiftData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let shiftCell = tableView.dequeueReusableCell(withIdentifier: "MyShiftsCell", for: indexPath) as! MyShiftsCell
        let shift = shiftData![indexPath.row]
        
        //Jun 06 Mon 07:00:00 to Jun 07 Mon 07:00:00 (8h)
        //MMM dd E HH:mm:ss
        let datefrmter = DateFormatter()
        datefrmter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        datefrmter.timeZone = TimeZone(abbreviation: "UTC")

        let fromDate = datefrmter.date(from: shift.planned_in!)
        let toDate = datefrmter.date(from: shift.planned_out!)

        datefrmter.timeZone = TimeZone.current
//        datefrmter.dateFormat = "MMM dd E HH:mm:ss"
                
        let fromDateStr = datefrmter.string(from: fromDate!)
        let toDateStr = datefrmter.string(from: toDate!)
        
        let localFromDate = datefrmter.date(from: fromDateStr)
        let localToDate = datefrmter.date(from: toDateStr)

        var timeDiff = Date().getTimeDifference(fromDate: localFromDate!, toDate: localToDate!)
        timeDiff = "(\(timeDiff))"
        
        datefrmter.amSymbol = "am"
        datefrmter.pmSymbol = "pm"
        datefrmter.dateFormat = "EE, h:mm a"
        let formatedStartDate = datefrmter.string(from: localFromDate!)
        
        datefrmter.dateFormat = "h:mm a"
        let formatedEndDate = datefrmter.string(from: localToDate!)
        
        let daysDifference = Date().getDayDifference(fromDate: localFromDate!, toDate: localToDate!)
        if daysDifference != "" {
            timeDiff = "\(daysDifference) \(timeDiff)"
        }
        
        shiftCell.dateLbl.text = "\(formatedStartDate) - \(formatedEndDate) \(timeDiff)"
        shiftCell.statusLbl.text = shift.planned_status! + " \(shift.shift_name!)"
        
        //Left labels
        datefrmter.dateFormat = "MMM"
        shiftCell.leftMonthLbl.text = datefrmter.string(from: localFromDate!)
        
        datefrmter.dateFormat = "dd"
        shiftCell.leftDayLbl.text = datefrmter.string(from: localFromDate!)
        
        return shiftCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: - DZNEmptyDataSet Delegate Methods
extension MyShiftsVC: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
   /* func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.headline)]
        return NSAttributedString(string: "No Shifts found for this \(isWeekly ? "Week" : "Month")", attributes: attrs)
    }*/
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)]
        return NSAttributedString(string: "No Shifts are available", attributes: attrs)
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return #imageLiteral(resourceName: "myCloc")
    }
    
    func imageTintColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
        return UIColor.gray
        
    }
    
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
}

   /*
    Wednesday, Sep 12, 2018           --> EEEE, MMM d, yyyy
    09/12/2018                        --> MM/dd/yyyy
    09-12-2018 14:11                  --> MM-dd-yyyy HH:mm
    Sep 12, 2:11 PM                   --> MMM d, h:mm a
    September 2018                    --> MMMM yyyy
    Sep 12, 2018                      --> MMM d, yyyy
    Wed, 12 Sep 2018 14:11:54 +0000   --> E, d MMM yyyy HH:mm:ss Z
    2018-09-12T14:11:54+0000          --> yyyy-MM-dd'T'HH:mm:ssZ
    12.09.18                          --> dd.MM.yy
*/
//Mon, 7:00 am to 2:00 pm (+1)
//EE, h:mm a h:mm a

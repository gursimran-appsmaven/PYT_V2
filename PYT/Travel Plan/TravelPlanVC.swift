//
//  TravelPlanVC.swift
//  PYT
//
//  Created by osx on 03/07/17.
//  Copyright © 2017 osx. All rights reserved.
//

import UIKit
import FSCalendar
import SDWebImage
import MBProgressHUD

class TravelPlanVC: UIViewController ,UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,FSCalendarDelegate,FSCalendarDataSource{

    @IBOutlet weak var startDateLbl: UILabel!
    @IBOutlet weak var endDateLbl: UILabel!
    @IBOutlet weak var noOfDaysLbl: UILabel!

    @IBOutlet weak var calendarBackView: UIView!
    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var doneBtn: UIButton!
    
    @IBOutlet weak var startDateBtn: UIButton!
    @IBOutlet weak var endDateBtn: UIButton!
    @IBOutlet weak var viewYourPlanBtn: UIButton!
    
    @IBOutlet weak var noOfLocations: UILabel!
    
    var noOfDays = Int()
    var startBool = Bool()
    var startDate = Date()
    var endDate = Date()
    var boolEdit = Bool()
    var boolPlanDateEdit = Bool()
    var locationFinalDate = NSDate()
    var calendarMonthDate = Date()
    
    var countryId = String()
    var bookingIdFinal = String()
    var placeBookingId = String()
    var planDetails = NSMutableArray()
    var planAllLocations = NSMutableArray()
    var planSelctedLocations = NSMutableArray()
    
    var reloadTableOnly = Bool()

    @IBOutlet weak var locationsCollectionView:  UICollectionView!
    @IBOutlet weak var plansTableView: UITableView!
    @IBOutlet weak var tablePlaceholderView: UIView!
    
    var fromFinalScreen = Bool()
    var change = String()
    var locationDateToBeEditId = String()
    var previousDateForLocation = String()
    
    fileprivate let gregorian = Calendar(identifier: .gregorian)

    override func viewDidLoad() {
        self.tabBarController?.tabBar.isHidden = true
        super.viewDidLoad()
        calendarMonthDate = NSDate() as Date
        
        setUpCalendarProperties()
        calendarBackView.isHidden = true
        getPlanDetails()
        
        calendarView.register(DIYCalendarCell.self, forCellReuseIdentifier: "cell")
        self.calendarView.dropShadow()

        setUpCalendarSelection()

        startBool = true
        
         
        configureVisibleCells()
   //        startButton.setAttributedTitle(attributedTextClass().setAttributeRobotRegularWithMultipleColor("Start", text1Size: 16, text2: " ", text2Size: 12), forState: UIControlState .Normal)
//        
//        endButton.setAttributedTitle(attributedTextClass().setAttributeRobotRegularWithMultipleColor("End", text1Size: 16, text2: " ", text2Size: 12), forState: UIControlState .Normal)
        
//        if boolEdit == true
//        {
//            startButton.userInteractionEnabled = false
//            endButton.userInteractionEnabled = false
//            self.calendarView.allowsMultipleSelection=false
//            startButton.setBackgroundImage(UIImage(named: ""), forState: .Normal)
//            
//            let dateFormatter = NSDateFormatter()
//            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss +0000"
//            dateFormatter.timeZone = NSTimeZone(name: "UTC")
//            let date1 = dateFormatter.dateFromString(String(startDate))// create   date from string
//            let date2 = dateFormatter.dateFromString(String(endDate))// create   date from string
//            
//            // change to a readable time format and change to local time zone
//            dateFormatter.dateFormat = "MMM dd, YYYY"
//            dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!TimeZone()
//            let timeStamp1 = dateFormatter.stringFromDate(date1!)
//            let timeStamp2 = dateFormatter.stringFromDate(date2!)
//            
//            startButton .titleLabel!.lineBreakMode = NSLineBreakMode.ByWordWrapping
//            startButton.titleLabel!.numberOfLines = 2//if you want unlimited number of lines put 0
//            startButton.setAttributedTitle(attributedTextClass().setAttributeRobotRegularWithMultipleColor("Start\n", text1Size: 13, text2: timeStamp1, text2Size: 13), forState: UIControlState .Normal)
//            
//            endButton.titleLabel!.lineBreakMode = NSLineBreakMode.ByWordWrapping
//            endButton.titleLabel!.numberOfLines = 2//if you want unlimited number of lines put 0
//            endButton.setAttributedTitle(attributedTextClass().setAttributeRobotRegularWithMultipleColor("End\n", text1Size: 13, text2: timeStamp2, text2Size: 13), forState: UIControlState .Normal)
//            
//        }
//        else if(boolPlanDateEdit)
//        {
//            let dateFormatter = NSDateFormatter()
//            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss +0000"
//            dateFormatter.timeZone = NSTimeZone(name: "UTC")
//            let date1 = dateFormatter.dateFromString(String(startDate))// create   date from string
//            let date2 = dateFormatter.dateFromString(String(endDate))// create   date from string
//            
//            // change to a readable time format and change to local time zone
//            dateFormatter.dateFormat = "MMM dd, YYYY"
//            dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!TimeZone()
//            let timeStamp1 = dateFormatter.stringFromDate(date1!)
//            let timeStamp2 = dateFormatter.stringFromDate(date2!)
//            
//            startButton .titleLabel!.lineBreakMode = NSLineBreakMode.ByWordWrapping
//            startButton.titleLabel!.numberOfLines = 2//if you want unlimited number of lines put 0
//            startButton.setAttributedTitle(attributedTextClass().setAttributeRobotRegularWithMultipleColor("Start\n", text1Size: 13, text2: timeStamp1, text2Size: 13), forState: UIControlState .Normal)
//            
//            endButton.titleLabel!.lineBreakMode = NSLineBreakMode.ByWordWrapping
//            endButton.titleLabel!.numberOfLines = 2//if you want unlimited number of lines put 0
//            endButton.setAttributedTitle(attributedTextClass().setAttributeRobotRegularWithMultipleColor("End\n", text1Size: 13, text2: timeStamp2, text2Size: 13), forState: UIControlState .Normal)
//            
//            var nextDate = startDate.earlierDate(startDate)
//            print(startDate)
//            print(nextDate)
//            
//            let lastdate =  calendarView.dateByAddingDays(1, toDate: endDate)
//            
//            while nextDate .compare(lastdate) == .OrderedAscending  {
//                
//                print(nextDate)
//                calendarView.selectDate(nextDate)
//                nextDate = calendarView.dateByAddingDays(1, toDate: nextDate)
//                
//            }
//        }

    }

    override func viewWillAppear(_ animated: Bool) {
        endDateBtn.setBackgroundImage(nil, for: .normal)
       
        //        calendarView.isHidden = true
//        doneBtn.isHidden = true
        doneBtn.setTitle("Close", for: .normal)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: DataSource and delegate of tableView
    //MARK:-
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        if(self.planSelctedLocations.count==0)
        {
            tablePlaceholderView.isHidden = false
            viewYourPlanBtn.alpha = 0.25
            viewYourPlanBtn.isEnabled = false
        }
        else
        {
            tablePlaceholderView.isHidden = true
            viewYourPlanBtn.alpha = 1.0
            viewYourPlanBtn.isEnabled = true
        }
        return self.planSelctedLocations.count
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return ((self.planSelctedLocations[section] as AnyObject).value(forKey: "places") as AnyObject).count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 60
        
    }
    
    func tableView( _ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DateWiseListTHeader") as! DateWiseListTHeader
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        
        
        let dat = dateFormatter.date(from: String(describing: ((self.planSelctedLocations[section] as AnyObject).value(forKey: "date") as? String)!))
        
        // change to a readable time format and change to local time zone
        dateFormatter.dateFormat = "dd MMM, yyyy"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        let timeStamp1 = dateFormatter.string(from: dat!)
        
        cell.dateLbl.text = timeStamp1
        cell.contentView.backgroundColor = UIColor.white
        
        return cell.contentView
    }
    func tableView( _ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        return 0.0000001
        
    }
    func tableView( _ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 50
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DateWiseListTCell", for: indexPath) as! DateWiseListTCell
        let place = ((self.planSelctedLocations[indexPath.section] as AnyObject).value(forKey: "places") as AnyObject) as! NSArray
        
        cell.nameLbl.text = ((place[indexPath.row] as AnyObject).value(forKey: "placeTag")) as? String ?? "NA"
         var city = ((place[indexPath.row] as AnyObject).value(forKey: "city")) as? String ?? ""
        if(city != "")
        {
            city = city + ", "
        }
        let country = ((place[indexPath.row] as AnyObject).value(forKey: "country")) as? String ?? ""
        
        cell.locationLbl.text = city + country
        
        let imageUrl = ((place[indexPath.row] as AnyObject).value(forKey: "imageThumb")) as? String ?? ""
        cell.llocationImage.contentMode = .scaleAspectFill
        cell.llocationImage.focusOnFaces = true
        cell.llocationImage.sd_setImage(with: URL (string: imageUrl), placeholderImage: UIImage (named: "dummyBackground1"))
        
        return cell
    }
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {

        
            if (editingStyle == UITableViewCellEditingStyle.delete) {
                let place = ((self.planSelctedLocations[indexPath.section] as AnyObject).value(forKey: "places") as AnyObject) as! NSArray
                
                placeBookingId = ((place[indexPath.row] as AnyObject).value(forKey: "_id")) as? String ?? ""
                setLocationFinalDate(setDate:false)
            }
    }
   
    // MARK: UICollectionView
    
    func numberOfSections(in collectionView: UICollectionView) -> Int   {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView,numberOfItemsInSection section: Int) -> Int
    {
        
        return planAllLocations.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        return CGSize(width: collectionView.frame.size.width , height: collectionView.frame.size.height)
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView,cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlanLocationImagesCC", for: indexPath) as! PlanLocationImagesCC
        
        let locDetails = (planAllLocations[indexPath.row] as? NSDictionary)?.value(forKey: "place") as? NSDictionary
        
        cell.nameLbl.text = "\(locDetails?.value(forKey: "placeTag") as? String ?? "") ,\(locDetails?.value(forKey: "city") as? String ?? "")"
        
        cell.locationLbl.text = "\(locDetails?.value(forKey: "placeTag") as?  String ?? "")"
        
        let imageToShow = locDetails?.value(forKey: "imageLarge")  as? String ?? ""

        cell.locationImage.backgroundColor = UIColor .white
        cell.locationImage.contentMode = .scaleAspectFill
        cell.locationImage.sd_setImage(with: URL(string: imageToShow), placeholderImage: UIImage (named: "dummyBackground1"), options: SDWebImageOptions(rawValue: 0), completed: nil)
        
        cell.calendarBtn.tag = indexPath.row
        cell.bucketBtn.tag = indexPath.row
        cell.crossButton.tag = indexPath.row
        
        
        cell.calendarBtn.addTarget(self, action: #selector(OpenCalendarView), for: .touchUpInside)
        cell.bucketBtn.addTarget(self, action: #selector(AddToBucket), for: .touchUpInside)

        
        
        
        let gradient = cell.viewWithTag(7499) as! GradientView
        
        gradient.gradientLayer.colors = [UIColor.black.withAlphaComponent(0.75).cgColor, UIColor.clear.cgColor]
        gradient.gradientLayer.gradient = GradientPoint.bottomTop.draw()
        
        let up = UISwipeGestureRecognizer(target: self, action: #selector(TravelPlanVC.deleteLocationFromPlan))
        up.direction = UISwipeGestureRecognizerDirection.up
        cell.addGestureRecognizer(up)
        
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
        
        
    }
    //MARK: Calender Delegates
    
    
    /////////////------ manage calendar---------////
     func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        if boolEdit == true {
            locationFinalDate = date.addDays(daysToAdd: 1) as NSDate
            doneBtn.setTitle("Done", for: .normal)
            calendar.reloadData()
            return
        }
            
        else
        {
            
            let todayDate = Date()

            if(startDate.equalToDate(dateToCompare: endDate))
            {
                startDate=date
                endDate=endDate.addDays(daysToAdd: -1)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss +0000"
                dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
                var date1 = dateFormatter.date(from: String(describing: startDate))
                date1 = date1?.addDays(daysToAdd: 1)// create   date from string
                dateFormatter.dateFormat = "MMM dd"
                dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
                let timeStamp1 = dateFormatter.string(from: date1!)
                startDateLbl.text = timeStamp1
                
                calendarView.select(startDate)
                
                startBool=false
                endDateBtn.setBackgroundImage(UIImage(named: "dropdown"), for: .normal)
                startDateBtn.setBackgroundImage(nil, for: .normal)

                configureVisibleCells()
                
                return

            }
            else if  date.isLessThanDate(dateToCompare: startDate) {
                if(endDate.equalToDate(dateToCompare: todayDate))
                {
                    endDate=startDate
                    startDate=date
                }
                else
                {
                    startDate=date
                }
            }
            else if  date.isLessThanDate(dateToCompare: endDate) {
                startBool ? (startDate=date ) : (endDate=date )
            }
            else if(date.isGreaterThanDate(dateToCompare: endDate) )
            {
                if(startBool)
                {
                    startDate=date
                    if(endDate.equalToDate(dateToCompare: todayDate))
                    {
                        startBool=false
                        endDateBtn.setBackgroundImage(UIImage(named: "dropdown"), for: .normal)
                        startDateBtn.setBackgroundImage(nil, for: .normal)
                    }
                    else
                    {
//                        print(startDate)
//                        print(noOfDays)
                        endDate=startDate.addDays(daysToAdd: 1)
//                        print(endDate)

                    }
                }
                else
                {
                    if(endDate.equalToDate(dateToCompare: todayDate))
                    {
                        endDate=date
                        startBool=true
                        startDateBtn.setBackgroundImage(UIImage(named: "dropdown"), for: .normal)
                        endDateBtn.setBackgroundImage(nil, for: .normal)
                    }
                    else
                    {
                        endDate=date
                    }
                }
            }
            
            for date1 in calendarView.selectedDates {
                calendarView .deselect(date1)
            }
            
            var nextDate = startDate
            
            let lastdate =  self.gregorian.date(byAdding: .day, value: 1, to: endDate as Date)
            while nextDate .compare(lastdate!) == .orderedAscending  {
                calendarView.select(nextDate)
                nextDate = self.gregorian.date(byAdding: .day, value: 1, to: nextDate as Date)!
            }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss +0000"
            dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
            let date1 = dateFormatter.date(from: String(describing: startDate))// create   date from string
            let date2 = dateFormatter.date(from: String(describing: endDate))// create   date from string
            
            // change to a readable time format and change to local time zone
            dateFormatter.dateFormat = "MMM dd"
            dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
            let timeStamp1 = dateFormatter.string(from: (date1?.addDays(daysToAdd: 1))!)
            let timeStamp2 = dateFormatter.string(from: (date2?.addDays(daysToAdd: 1))!)
        
            startDateLbl.text = timeStamp1
            endDateLbl.text = timeStamp2

            
            let components = NSCalendar.current.dateComponents([.day], from: date1!, to: date2!)
            noOfDays = components.day! + 1
            noOfDaysLbl.text = "\(components.day! + 1) Days"
            
            if(!boolEdit)
            {
                configureVisibleCells()
            }

            print("Start Date-\(startDate)\n End Date-\(endDate)")
            doneBtn.setTitle("Done", for: .normal)

            
        }
    
    }
    
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        print("Start Date-\(startDate)\n End Date-\(endDate)")

        
        if boolEdit == true {
            calendar.reloadData()
            return
        }
        
        let todayDate = Date()
        
        if  endDate.isLessThanDate(dateToCompare: startDate) && endDate.equalToDate(dateToCompare: todayDate){
            endDate=startDate
            startDate=date
        }
        if(startDate.equalToDate(dateToCompare: endDate))
        {
            startDate=date
            return
        }
            
        else if  date.isGreaterThanDate(dateToCompare: startDate) && date.isLessThanDate(dateToCompare: endDate) {
            
            startBool ? (startDate=date) : (endDate=date)
            
        }
        else if  date.isLessThanDate(dateToCompare: startDate) {
            startDate=date
        }
        else if(date.isGreaterThanDate(dateToCompare: endDate) && date.isGreaterThanDate(dateToCompare: startDate))
        {
            endDate=date
        }
        else if(date.isLessThanDate(dateToCompare: endDate) && date.isLessThanDate(dateToCompare: startDate))
        {
            endDate=startDate
            startDate=date
        }
        
        print("Start Date-\(startDate)\n End Date-\(endDate)")

        for date1 in calendarView.selectedDates {
            calendarView .deselect(date1)
        }
        
        var nextDate = startDate
        
        let lastdate =  self.gregorian.date(byAdding: .day, value: 1, to: endDate as Date)
        while nextDate .compare(lastdate!) == .orderedAscending  {
            calendarView.select(nextDate)
            nextDate = self.gregorian.date(byAdding: .day, value: 1, to: nextDate as Date)!
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss +0000"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        let date1 = dateFormatter.date(from: String(describing: startDate))// create   date from string
        let date2 = dateFormatter.date(from: String(describing: endDate))// create   date from string
        
        // change to a readable time format and change to local time zone
        dateFormatter.dateFormat = "MMM dd"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        let timeStamp1 = dateFormatter.string(from: (date1?.addDays(daysToAdd: 1))!)
        let timeStamp2 = dateFormatter.string(from: (date2?.addDays(daysToAdd: 1))!)
        
        startDateLbl.text = timeStamp1
        endDateLbl.text = timeStamp2
        
        let components = NSCalendar.current.dateComponents([.day], from: date1!, to: date2!)
        noOfDaysLbl.text = "\(components.day! + 1) Days"

        if(!boolEdit)
        {
            configureVisibleCells()
        }
        
        doneBtn.setTitle("Done", for: .normal)

    }

    
    
    
    //MAXIMUM AND MINIMUM DATE
    
    func maximumDate(for calendar: FSCalendar) -> Date {
        if  boolEdit == true {
            return endDate as Date
        }
        else{
            return calendar.maximumDate  as Date
        }
    }
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        print(startDate)
        if boolEdit == true{
            return startDate as Date
        }
        else if(startDate.isLessThanDate(dateToCompare: Date()))
        {
            return startDate as Date
        }
        else
        {
            return Date()
        }
    }
    
    
   
    
    
    // MARK: - Calendar Customisation
    
    // MARK:- FSCalendarDataSource
    func setUpCalendarSelection()
    {
//        var nextDate = Date()
//        startDate = nextDate
//        let lastdate =  self.gregorian.date(byAdding: .day, value: 2, to: nextDate as Date)
//        while nextDate .compare(lastdate!) == .orderedAscending  {
//            calendarView.select(nextDate)
//            nextDate = self.gregorian.date(byAdding: .day, value: 1, to: nextDate as Date)!
//        }
//        endDate = nextDate
//        
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss +0000"
//        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
//        let date1 = dateFormatter.date(from: String(describing: startDate))// create   date from string
//        let date2 = dateFormatter.date(from: String(describing: endDate))// create   date from string
//        
//        // change to a readable time format and change to local time zone
//        dateFormatter.dateFormat = "MMM dd"
//        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
//        let timeStamp1 = dateFormatter.string(from: date1!)
//        let timeStamp2 = dateFormatter.string(from: date2!)
//        
//        endDate = endDate.addDays(daysToAdd: -1)
//        
//        startDateLbl.text = timeStamp1
//        endDateLbl.text = timeStamp2
        
        self.calendarView.allowsMultipleSelection=true
        self.calendarView.reloadData()

    }
    func setUpCalendarStartAndEndDate()
    {
        calendarView.reloadData()

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        
        
        startDate = (dateFormatter.date(from: String(describing: ((self.planDetails.object(at: 0) ) as AnyObject).value(forKey: "startDate") as! String)))!
            
        endDate = (dateFormatter.date(from: String(describing: ((self.planDetails.object(at: 0) ) as AnyObject).value(forKey: "endDate") as! String)))!
        
        // change to a readable time format and change to local time zone
        dateFormatter.dateFormat = "MMM dd"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        let timeStamp1 = dateFormatter.string(from: startDate)
        let timeStamp2 = dateFormatter.string(from: endDate)
        
        startDateLbl.text = timeStamp1
        endDateLbl.text = timeStamp2
        
        let components = NSCalendar.current.dateComponents([.day], from: startDate, to: endDate)
        noOfDaysLbl.text = "\(components.day! + 1) Days"

        startDate = startDate.addDays(daysToAdd: -1)
        endDate = endDate.addDays(daysToAdd: -1)

        print("Start Date-\(startDate)\n End Date-\(endDate)")

        var nextDate = startDate//.addDays(daysToAdd: -1)

        let lastdate =  self.gregorian.date(byAdding: .day, value: 1, to: endDate as Date)
        if(!boolEdit)
        {
            for date1 in calendarView.selectedDates {
                calendarView .deselect(date1)
            }

            while nextDate .compare(lastdate!) == .orderedAscending  {
                calendarView.select(nextDate)
                nextDate = self.gregorian.date(byAdding: .day, value: 1, to: nextDate)!
                
            }
        }
        

    
        print("Start Date-\(startDate)\n End Date-\(endDate)")

        if(fromFinalScreen)
        {
            if(change == "locationDate")
            {
                for date1 in calendarView.selectedDates {
                    calendarView .deselect(date1)
                }
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
                
                
                let dat = dateFormatter.date(from: String(describing: previousDateForLocation))!

                calendarView.select(dat.addDays(daysToAdd: -1))
                self.calendarView.allowsMultipleSelection=false
            }
            calendarView.reloadData()
            configureVisibleCells()
        }
        
    }

    func setUpCalendarProperties()
    {
        calendarView.formatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        self.calendarView.appearance.headerMinimumDissolvedAlpha = 0
        self.calendarView.appearance.selectionColor=UIColor(red: 255/255.0, green: 80/255.0, blue: 80/255.0, alpha: 1.0)
        self.calendarView.appearance.todayColor=UIColor(red: 255/255.0, green: 80/255.0, blue: 80/255.0, alpha: 1.0)
        self.calendarView.appearance.headerTitleColor = UIColor(red: 20/255.0, green: 44/255.0, blue: 69/255.0, alpha: 1.0)
        if(boolEdit)
        {
            self.calendarView.appearance.titleDefaultColor = UIColor(red: 20/255.0, green: 44/255.0, blue: 69/255.0, alpha: 1.0)
        }
        else
        {
            self.calendarView.appearance.titleDefaultColor = UIColor.lightGray
        }
        self.calendarView.appearance.titlePlaceholderColor = UIColor.lightGray.withAlphaComponent(0.25)
        
        self.calendarView.appearance.headerTitleFont = UIFont(name: "SFUIDisplay-Bold", size: 14.0)!
        self.calendarView.appearance.titleFont = UIFont(name: "SFUIDisplay-Regular", size: 11.0)!
        self.calendarView.appearance.weekdayFont = UIFont(name: "SFUIDisplay-Regular", size: 12.0)!
        
        self.calendarView.appearance.weekdayTextColor = UIColor(red: 255/255.0, green: 80/255.0, blue: 80/255.0, alpha: 1.0)
        
        calendarView.today = nil // Hide the today circle
        
        calendarView.locale = .current
        //        calendar.clipsToBounds = true // Remove top/bottom line
        
//        calendarView.swipeToChooseGesture.isEnabled = true // Swipe-To-Choose
        
        self.calendarView.appearance.borderRadius = 0

    }
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(withIdentifier: "cell", for: date, at: position)
        return cell
    }
    
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
        self.configure(cell: cell, for: date, at: position)
    }
    
    
    // MARK:- FSCalendarDelegate
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendarView.frame.size.height = bounds.height
//        self.eventLabel.frame.origin.y = calendar.frame.maxY + 10
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition)   -> Bool {
        return monthPosition == .current
    }
    
    func calendar(_ calendar: FSCalendar, shouldDeselect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        return monthPosition == .current
    }
    

    private func configureVisibleCells() {
        print(calendarView.selectedDates)

        calendarView.visibleCells().forEach { (cell) in
            let date = calendarView.date(for: cell)
            let position = calendarView.monthPosition(for: cell)
            self.configure(cell: cell, for: date, at: position)
        }
    }
    
    private func configure(cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
        
        let diyCell = (cell as! DIYCalendarCell)
        // Custom today circle
//        diyCell.circleImageView.isHidden = !self.gregorian.isDateInToday(date)
        // Configure selection layer


        if position == .current {
            var selectionType = SelectionType.none

            if calendarView.selectedDates.contains(date) {
                let previousDate = self.gregorian.date(byAdding: .day, value: -1, to: date)!
                let nextDate = self.gregorian.date(byAdding: .day, value: 1, to: date)!
                if calendarView.selectedDates.contains(date) {
                    if calendarView.selectedDates.contains(previousDate) && calendarView.selectedDates.contains(nextDate) {
                        selectionType = .middle
                    }
                    else if calendarView.selectedDates.contains(previousDate) && calendarView.selectedDates.contains(date) {
                        selectionType = .rightBorder
                    }
                    else if calendarView.selectedDates.contains(nextDate) {
                        selectionType = .leftBorder
                    }
                    else {
                        selectionType = .single
                    }
                }
            }
            else {
                selectionType = .none
            }
            if selectionType == .none {
                diyCell.selectionLayer.isHidden = true
                return
            }
            diyCell.selectionLayer.isHidden = false
            diyCell.selectionType = selectionType
            
        } else {
//            diyCell.circleImageView.isHidden = true
            diyCell.selectionLayer.isHidden = true
        }
        
    }


   //MARK: Action Methods
    @IBAction func ViewYourTravelPlan(_ sender: Any) {
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "FinalTravelPlanVC") as! FinalTravelPlanVC
        obj.countryId = countryId
        obj.bookingIdFinal = self.bookingIdFinal
        self.navigationController! .pushViewController(obj, animated: true)

    }
     @IBAction func ChangeMonthBtnAction(_ sender: Any) {
        if((sender as AnyObject).tag == 12)
        {
            let cal = Calendar.current
            var comps: DateComponents? = cal.dateComponents([.year, .month, .day], from: calendarMonthDate as Date)
            comps?.month = (comps?.month)! - 1
            calendarMonthDate = cal.date(from: comps!)!
        }
        else
        {
            let cal = Calendar.current
            var comps: DateComponents? = cal.dateComponents([.year, .month, .day], from: calendarMonthDate as Date)
            comps?.month = (comps?.month)! + 1
            calendarMonthDate = cal.date(from: comps!)!
        }

    }
    @IBAction func StartEndDateBtnACtion(_ sender: Any) {
        if((sender as AnyObject).tag == 10)
        {
            startBool=true
            startDateBtn.setBackgroundImage(UIImage(named: "dropdown"), for: .normal)
            endDateBtn.setBackgroundImage(nil, for: .normal)
        }
        else
        {
            startBool=false
            startDateBtn.setBackgroundImage(nil, for: .normal)
            endDateBtn.setBackgroundImage(UIImage(named: "dropdown"), for: .normal)
        }
        if(calendarBackView.isHidden)
        {
            boolEdit = false
            doneBtn.setTitle("Close", for: .normal)
            calendarBackView.isHidden = false
            self.calendarView.allowsMultipleSelection=true
            setUpCalendarProperties()
            var nextDate = startDate
            
            print("Start Date-\(startDate)\n End Date-\(endDate)")

            let lastdate =  self.gregorian.date(byAdding: .day, value: 1, to: endDate as Date)
            while nextDate .compare(lastdate!) == .orderedAscending  {
                calendarView.select(nextDate)
                nextDate = self.gregorian.date(byAdding: .day, value: 1, to: nextDate as Date)!
            }
            calendarView.reloadData()
            configureVisibleCells()
        }

    }
    @IBAction func LeftBtnAction(_ sender: Any) {
        let visibleItems: NSArray = self.locationsCollectionView.indexPathsForVisibleItems as NSArray
      
        if visibleItems.count<1{
            
        }else
        {
        let currentItem: IndexPath = visibleItems.object(at: 0) as! IndexPath
        let nextItem: IndexPath = IndexPath(item: currentItem.item - 1, section: 0)
        // This is where I'm trying to detect the value
        if nextItem.row < 0 {
            return
        }
        self.locationsCollectionView.scrollToItem(at: nextItem, at: .right, animated: true)
        }
    }
    @IBAction func RightBtnAction(_ sender: Any) {
        let visibleItems: NSArray = self.locationsCollectionView.indexPathsForVisibleItems as NSArray
       
        if visibleItems.count<1{
            
        }else
        {
            let currentItem: IndexPath = visibleItems.object(at: 0) as! IndexPath
            let nextItem: IndexPath = IndexPath(item: currentItem.item + 1, section: 0)
            // This is where I'm trying to detect the value
            if nextItem.row == planAllLocations.count {
                return
            }
            self.locationsCollectionView.scrollToItem(at: nextItem, at: .left, animated: true)
        }
       
    }
    @IBAction func DoneBtnAction(_ sender: Any) {
        if(doneBtn.titleLabel?.text=="Close")
        {
            calendarBackView.isHidden = true
            if(self.fromFinalScreen)
            {
                _=self.navigationController?.popViewController(animated: true)
            }

            return
        }
        if(boolEdit)
        {
            self.calendarBackView.isHidden = true
            MBProgressHUD .showAdded(to: self.view, animated: true)
            reloadTableOnly = true
            setLocationFinalDate(setDate:true)
            return
        }
        else  {
            
            MBProgressHUD .showAdded(to: self.view, animated: true)
            SetPlanDatesWindow()
        }
        startDateBtn.setBackgroundImage(nil, for: .normal)
        endDateBtn.setBackgroundImage(nil, for: .normal)


    }
    @IBAction func MapViewBtnACtion(_ sender: Any) {
        
        let nxtObj = self.storyboard?.instantiateViewController(withIdentifier: "PlanMapVC") as! PlanMapVC
        
        nxtObj.locationsArray = planAllLocations
        
        self.navigationController?.pushViewController(nxtObj, animated: true)
        
    }
    @IBAction func BackBtnAction(_ sender: Any) {
        _=self.navigationController?.popViewController(animated: true)
    }
    func OpenCalendarView(sender: UIButton)
    {
        doneBtn.setTitle("Close", for: .normal)
        
        let selectedLocation = planAllLocations[sender.tag]
        print(selectedLocation)
        placeBookingId = ((selectedLocation as AnyObject).value(forKey:"place")! as AnyObject).value(forKey:"_id")as! String
        calendarBackView.isHidden = false
        boolEdit = true
        self.calendarView.allowsMultipleSelection=false
        setUpCalendarProperties()
        var nextDate = startDate
        
        let lastdate =  self.gregorian.date(byAdding: .day, value: 2, to: endDate as Date)
        while nextDate .compare(lastdate!) == .orderedAscending  {
            calendarView.deselect(nextDate)
            nextDate = self.gregorian.date(byAdding: .day, value: 1, to: nextDate as Date)!
        }


        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        
        
        if let DateToSelect = (selectedLocation as AnyObject).value(forKey:"time")
        {
            var dts = dateFormatter.date(from: String(describing: (DateToSelect as! String)))
            dts = dts?.addDays(daysToAdd: -1)
            calendarView.select(dts)
        }

        
        calendarView.reloadData()
        configureVisibleCells()
    }
    func AddToBucket(sender: UIButton)
    {
        let selectedLocation = planAllLocations[sender.tag]
        print(selectedLocation)
    }
    func ViewTravelPlanBtnAction(sender: UIButton)
    {
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "FinalTravelPlanVC") as! FinalTravelPlanVC
        obj.countryId = self.countryId
        self.navigationController?.pushViewController(obj, animated: true)
    }

    
    //MARK: API Methods
    
    func getPlanDetails() {
        
        let defaults = UserDefaults.standard
        let uId = defaults .string(forKey: "userLoginId")
      //  bookingIdFinal = "59636d668e966401841ac192" //temporary booking ig of germany
        let parameter: NSDictionary = ["userId": uId! ,"bookingId":bookingIdFinal]
        print("plans parameters\(parameter)")
        
        let isConnectedInternet = CommonFunctionsClass.sharedInstance().isConnectedToNetwork()
        
        if isConnectedInternet
        {
            
            
            
            let urlString = NSString(string:"\(appUrl)get_booking_detail_V3")
            
            
            let isConnectedInternet = CommonFunctionsClass.sharedInstance().isConnectedToNetwork()
            
            if isConnectedInternet
            {
                
                var urlString = NSString(string:"\(urlString)")
                print("WS URL----->>" + (urlString as String))
                
                urlString = urlString .replacingOccurrences(of: " ", with: "%20") as NSString
                
                let url:NSURL = NSURL(string: urlString as String)!
                let session = URLSession.shared
                session.configuration.timeoutIntervalForRequest=20
                
                
                
                
                
                let request = NSMutableURLRequest(url: url as URL)
                request.httpMethod = "POST"
                request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
                
                
                do {
                    let jsonData = try!  JSONSerialization.data(withJSONObject: parameter, options: [])
                    request.httpBody = jsonData
                    
                    
                    // here "jsonData" is the dictionary encoded in JSON data
                } catch let error as NSError {
                    print(error)
                }
                
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.addValue("application/json", forHTTPHeaderField: "Accept")
                
                
                
                
                
                let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
                    
                    OperationQueue.main.addOperation
                        {
                            
//                            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                            
                            if data == nil
                            {
                                print("server not responding")
                                
                                
                            }
                            else
                            {
                                
                                
                                do {
                                    
                                    let result = NSString(data: data!, encoding:String.Encoding.ascii.rawValue)!
                                    print("Body: \(result)")
                                    
                                    let anyObj: Any = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                                    
                                    
                                    
                                    basicInfo=NSMutableDictionary()
                                    basicInfo=anyObj as! NSMutableDictionary
                                    
                                    let success = basicInfo.object(forKey: "status") as! NSNumber
                                    
                                    if success == 1{
                                        
                                        let plans = basicInfo.value(forKey: "data") as! NSMutableArray
                                        self.planSelctedLocations = basicInfo.value(forKey: "dateVise") as! NSMutableArray
                                        
                                        print(self.planSelctedLocations)
                                        
                                        for loc in self.planSelctedLocations
                                        {
                                            let datStr = ((loc as! NSMutableDictionary)["date"] as? String)!
                                            let dateArr = datStr.components(separatedBy: "/")
                                            print(dateArr)

                                            let newDate = String(format: "%02d/%02d/",Int(dateArr[0])!,Int(dateArr[1])!) + dateArr[2]
                                            print(newDate)
                                            (loc as! NSMutableDictionary)["date"] = newDate
                                        }
                                        let sortedArray = self.planSelctedLocations.sorted{ (($0 as! Dictionary<String, AnyObject>)["date"] as? String)! < (($1 as! Dictionary<String, AnyObject>)["date"] as? String)! }
                                        
                                        print(sortedArray)
                                        self.planSelctedLocations.removeAllObjects()
                                        
                                        for item in sortedArray
                                        {
                                            self.planSelctedLocations.add(item)
                                        }
                                        
                                        self.planDetails=plans
                                        
                                        self.bookingIdFinal = (self.planDetails.object(at: 0) as AnyObject).value(forKey: "_id") as! String
                                        if(self.fromFinalScreen)
                                        {
                                            if(self.change == "planWindow")
                                            {
                                                self.boolEdit = false
                                                self.setUpCalendarStartAndEndDate()
                                                self.calendarBackView.isHidden = false
                                            }
                                            else
                                            {
                                                self.boolEdit = true
                                                self.setUpCalendarStartAndEndDate()
                                                self.calendarBackView.isHidden = false
                                            }
                                            
                                        }

                                        else if (self.planDetails.object(at: 0) as AnyObject).value(forKey: "startDate") as? String != nil
                                        {
                                            self.setUpCalendarStartAndEndDate()
                                            self.calendarBackView.isHidden = true
                                        }
                                        else
                                        {
                                            self.setUpCalendarSelection()
                                            self.calendarBackView.isHidden = false
                                            self.boolEdit = false
                                        }
                                        if plans.count>0{
                                            
                                            let placesArr = ((plans.object(at: 0) as AnyObject).value(forKey: "places") as AnyObject) as! NSArray
                                            print(placesArr)
                                            self.planAllLocations.removeAllObjects()
                                            for i in 0..<placesArr.count {
                                                
                                                self.planAllLocations.add(placesArr[i])
                                            }
                                            
                                            let attrs1 = [NSFontAttributeName: UIFont(name: "SFUIDisplay-Bold", size: 11.0) , NSForegroundColorAttributeName : UIColor(red: 20/255.0, green: 44/255.0, blue: 69/255.0, alpha: 1.0)]
                                            
                                            let attrs2 = [NSFontAttributeName: UIFont(name: "SFUIDisplay-Regular", size: 11.0), NSForegroundColorAttributeName : UIColor(red: 20/255.0, green: 44/255.0, blue: 69/255.0, alpha: 1.0)]
                                            
                                            let attributedString1 = NSMutableAttributedString(string:"\(self.planAllLocations.count) ", attributes:attrs1)
                                            
                                            let attributedString2 = NSMutableAttributedString(string:"Locations", attributes:attrs2)
                                            
                                            attributedString1.append(attributedString2)
                                           
                                            self.noOfLocations.attributedText = attributedString1
                                            
                                            DispatchQueue.main.async(execute: {
                                                if(self.reloadTableOnly)
                                                {
                                                    self.plansTableView.reloadData()
                                                }
                                                else
                                                {
                                                    self.plansTableView.reloadData()
                                                    self.locationsCollectionView.reloadData()
                                                }
                                                
                                            })
                                        }
                                        else
                                        {
                                            CommonFunctionsClass.sharedInstance().showAlert(title: "No plans yet", text: "You haven't plan a travel yet.", imageName: "exclamationAlert")
                                        }
                                        
                                        
                                        
                                        
                                    }
                                    else
                                    {
                                        
                                        CommonFunctionsClass.sharedInstance().showAlert(title: "No plans yet", text: "You haven't plan a travel yet.", imageName: "exclamationAlert")
                                        
                                    }
                                    
                                    
                                    
                                    
                                    
                                } catch
                                {
                                    print("json error: \(error)")
                                    CommonFunctionsClass.sharedInstance().showAlert(title: "Server Alert", text: "Something doesn't seem right, Please try again!", imageName: "alertServer")
                                    
                                    
                                    
                                }
                                
                                
                                
                                
                                
                                
                                
                            }
                    }
                })
                
                task.resume()
            }
            else
            {
                CommonFunctionsClass.sharedInstance().showAlert(title: "No Internet Connection", text: "You are currently offline.", imageName: "alertInternet")
                
//                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            }
            
            
        }
    }
    
    func SetPlanDatesWindow()
    {
        let isConnectedInternet = CommonFunctionsClass.sharedInstance().isConnectedToNetwork()
        
        if isConnectedInternet
        {
            // CommonFunctionsClass.sharedInstance().startIndicator(viewController.view)
            
            //    API to edit time of booking :- edit_booking_dates 4 parameters 1. userId, 2. bookingId, 3. placeId, 4. time
            
            var urlString = NSString(string:"\(appUrl)edit_booking")
            print("WS URL----->>" + (urlString as String))
            
            let parameters: NSDictionary = ["userId": UserDefaults.standard.string(forKey: "userLoginId")!,"bookingId":bookingIdFinal,"startDate":String(describing: startDate.addDays(daysToAdd: 1)),"endDate":String(describing: endDate.addDays(daysToAdd: 1))]
            
            urlString = urlString .replacingOccurrences(of: " ", with: "%20") as NSString
            
            let url:NSURL = NSURL(string: urlString as String)!
            let session = URLSession.shared
            
            session.configuration.timeoutIntervalForRequest=30
            // session.configuration.timeoutIntervalForResource=50
            
            let request = NSMutableURLRequest(url: url as URL)
            request.httpMethod = "POST"
            request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
            
            
            do {
                let jsonData = try!  JSONSerialization.data(withJSONObject: parameters, options: [])
                request.httpBody = jsonData
                
                
                // here "jsonData" is the dictionary encoded in JSON data
            } catch let error as NSError {
                print(error)
            }
            
            
            
            // request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(prmt, options: [])
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            
            
            let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
                
                OperationQueue.main.addOperation
                    {
                        
                        if data == nil
                        {
                            CommonFunctionsClass.sharedInstance().showAlert(title: "Server Alert", text: "Something doesn't seem right, Please try again!", imageName: "alertServer")
                            
                        }
                        else
                        {
                            
                            
                            do {
                                
                                let result = NSString(data: data!, encoding:String.Encoding.ascii.rawValue)!
                                print("Body: \(result)")
                                
                                let anyObj: Any = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                                
                                
                                jsonResult = NSDictionary()
                                jsonResult = anyObj as! NSDictionary
                                
                                let status = jsonResult.value(forKey: "status") as! NSNumber
                                
                                if status == 1{
                                    if(self.fromFinalScreen)
                                    {
                                        MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                                        _ = self.navigationController?.popViewController(animated: true)
                                    }
                                    self.getPlanDetails()
                                    self.endDateBtn.setBackgroundImage(nil, for: .normal)
                                    self.startDateBtn.setBackgroundImage(nil, for: .normal)
                                    self.calendarBackView.isHidden = true
                                    
                                   }
                                else{
                                    print("status = 0")
                                    CommonFunctionsClass.sharedInstance().showAlert(title: "Server Alert", text: jsonResult.value(forKey: "msg") as! String as NSString, imageName: "alertServer")
                                }
                                MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                            }
                            catch
                            {
                                print("json error: \(error)")
                                CommonFunctionsClass.sharedInstance().showAlert(title: "Server Alert", text: jsonResult.value(forKey: "msg") as! String as NSString, imageName: "alertServer")
                                MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                            }
                        }
                }
            })
            
            task.resume()
        }
        else
        {
            CommonFunctionsClass.sharedInstance().showAlert(title: "No Internet Connection", text: "You are currently offline.", imageName: "alertInternet")
            MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
        }
        
    }

    func setLocationFinalDate(setDate: Bool)
    {
        let isConnectedInternet = CommonFunctionsClass.sharedInstance().isConnectedToNetwork()
        
        if isConnectedInternet
        {
            // CommonFunctionsClass.sharedInstance().startIndicator(viewController.view)
            
            //    API to edit time of booking :- edit_booking_dates 4 parameters 1. userId, 2. bookingId, 3. placeId, 4. time
            
            var urlString = NSString(string:"\(appUrl)edit_booking_dates")
            print("WS URL----->>" + (urlString as String))
            
            var parameters =  NSMutableDictionary()
            if(setDate)
            {
                parameters = ["userId": UserDefaults.standard.string(forKey: "userLoginId")!,"bookingId":bookingIdFinal,"placeId":placeBookingId,"time":String(describing: locationFinalDate)]
            }
            else
            {
                parameters = ["userId": UserDefaults.standard.string(forKey: "userLoginId")!,"bookingId":bookingIdFinal,"placeId":placeBookingId]
            }
            
            urlString = urlString .replacingOccurrences(of: " ", with: "%20") as NSString
            
            let url:NSURL = NSURL(string: urlString as String)!
            let session = URLSession.shared
            
            session.configuration.timeoutIntervalForRequest=30
            // session.configuration.timeoutIntervalForResource=50
            
            let request = NSMutableURLRequest(url: url as URL)
            request.httpMethod = "POST"
            request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
            
            
            do {
                let jsonData = try!  JSONSerialization.data(withJSONObject: parameters, options: [])
                request.httpBody = jsonData
                
                
                // here "jsonData" is the dictionary encoded in JSON data
            } catch let error as NSError {
                print(error)
            }
            
            
            
            // request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(prmt, options: [])
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            
            
            let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
                
                OperationQueue.main.addOperation
                    {
                        
                        if data == nil
                        {
                            CommonFunctionsClass.sharedInstance().showAlert(title: "Server Alert", text: "Something doesn't seem right, Please try again!", imageName: "alertServer")
                            
                        }
                        else
                        {
                            
                            
                            do {
                                
                                let result = NSString(data: data!, encoding:String.Encoding.ascii.rawValue)!
                                print("Body: \(result)")
                                
                                let anyObj: Any = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                                
                                
                                jsonResult = NSDictionary()
                                jsonResult = anyObj as! NSDictionary
                                
                                let status = jsonResult.value(forKey: "status") as! NSNumber
                                
                                if status == 1{
                                    
                                   // self.navigationController?.popViewControllerAnimated(true)
                                    MBProgressHUD.hideAllHUDs(for: self.view, animated: true)

                                    if(self.fromFinalScreen)
                                    {
                                        if(self.change == "locationDate")
                                        {
                                            _=self.navigationController?.popViewController(animated: true)
                                        }
                                    }

                                    self.calendarBackView.isHidden = true
                                    self.getPlanDetails()
                                }
                                else{
                                    print("status = 0")
                                    CommonFunctionsClass.sharedInstance().showAlert(title: "Server Alert", text: jsonResult.value(forKey: "msg") as! String as NSString, imageName: "alertServer")
                                }
                            }
                            catch
                            {
                                print("json error: \(error)")
                                CommonFunctionsClass.sharedInstance().showAlert(title: "Server Alert", text: jsonResult.value(forKey: "msg") as! String as NSString, imageName: "alertServer")
                                MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                            }
                        }
                }
            })
            
            task.resume()
        }
        else
        {
            CommonFunctionsClass.sharedInstance().showAlert(title: "No Internet Connection", text: "You are currently offline.", imageName: "alertInternet")
            MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
        }
        
    }

    func deleteLocationFromPlan()
    {
        let isConnectedInternet = CommonFunctionsClass.sharedInstance().isConnectedToNetwork()
        
        let visibleItems: NSArray = self.locationsCollectionView.indexPathsForVisibleItems as NSArray
        let currentItem: IndexPath = visibleItems.object(at: 0) as! IndexPath

        let placeId = ((planAllLocations[currentItem.row] as AnyObject).value(forKey:"place")! as AnyObject).value(forKey:"_id")as! String
        
        if isConnectedInternet
        {
            //    api to delete a place from booking:- delete_booking_place 3 parameters bookingId, userId, placeId
            
            var urlString = NSString(string:"\(appUrl)delete_booking_place")
            print("WS URL----->>" + (urlString as String))
            
            let parameters: NSDictionary = ["userId": UserDefaults.standard.string(forKey: "userLoginId")!,"bookingId":bookingIdFinal,"placeId":placeId]
            
            urlString = urlString .replacingOccurrences(of: " ", with: "%20") as NSString
            
            let url:NSURL = NSURL(string: urlString as String)!
            let session = URLSession.shared
            
            session.configuration.timeoutIntervalForRequest=30
            // session.configuration.timeoutIntervalForResource=50
            
            let request = NSMutableURLRequest(url: url as URL)
            request.httpMethod = "POST"
            request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
            
            
            do {
                let jsonData = try!  JSONSerialization.data(withJSONObject: parameters, options: [])
                request.httpBody = jsonData
                
                
                // here "jsonData" is the dictionary encoded in JSON data
            } catch let error as NSError {
                print(error)
            }
            
            
            
            // request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(prmt, options: [])
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            
            
            let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
                
                OperationQueue.main.addOperation
                    {
                        
                        if data == nil
                        {
                            CommonFunctionsClass.sharedInstance().showAlert(title: "Server Alert", text: "Something doesn't seem right, Please try again!", imageName: "alertServer")
                            
                        }
                        else
                        {
                            do
                            {
                                let result = NSString(data: data!, encoding:String.Encoding.ascii.rawValue)!
                                print("Body: \(result)")
                                
                                let anyObj: Any = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                                
                                
                                jsonResult = NSDictionary()
                                jsonResult = anyObj as! NSDictionary
                                
                                let status = jsonResult.value(forKey: "status") as! NSNumber
                                
                                if status == 1{
                                    
                                    self.planAllLocations.removeObject(at: currentItem.row)
                                    self.locationsCollectionView.deleteItems(at: [currentItem]) 
                                    self.reloadTableOnly = true
                                    self.getPlanDetails()
                                    
                                    DispatchQueue.global(qos: .background).async {
                                        
                                        let uId = Udefaults .string(forKey: "userLoginId")
                                        let objt = storyCountClass()
                                        let dic:NSDictionary = ["userId": uId!]
                                        objt.postRequestForcountStory(parameterString: dic)
                                        objt.postRequestForcountStoryandBucket(dic)
                                    }
                                }
                                else{
                                    print("status = 0")
                                    CommonFunctionsClass.sharedInstance().showAlert(title: "Server Alert", text: jsonResult.value(forKey: "msg") as! String as NSString, imageName: "alertServer")
                                }
                                MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                            }
                            catch
                            {
                                print("json error: \(error)")
                                CommonFunctionsClass.sharedInstance().showAlert(title: "Server Alert", text: jsonResult.value(forKey: "msg") as! String as NSString, imageName: "alertServer")
                                MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                            }
                        }
                }
            })
            
            task.resume()
        }
        else
        {
            CommonFunctionsClass.sharedInstance().showAlert(title: "No Internet Connection", text: "You are currently offline.", imageName: "alertInternet")
            MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
        }

    }
    
    /*
    func deleteLocationFromPlanOnButtonPress(sender: UIButton)
    {
        let isConnectedInternet = CommonFunctionsClass.sharedInstance().isConnectedToNetwork()
        
       
        
        let placeId = ((planAllLocations[sender.tag] as AnyObject).value(forKey:"place")! as AnyObject).value(forKey:"_id")as! String
        
        if isConnectedInternet
        {
            //    api to delete a place from booking:- delete_booking_place 3 parameters bookingId, userId, placeId
            
            var urlString = NSString(string:"\(appUrl)delete_booking_place")
            print("WS URL----->>" + (urlString as String))
            
            let parameters: NSDictionary = ["userId": UserDefaults.standard.string(forKey: "userLoginId")!,"bookingId":bookingIdFinal,"placeId":placeId]
            
            urlString = urlString .replacingOccurrences(of: " ", with: "%20") as NSString
            
            let url:NSURL = NSURL(string: urlString as String)!
            let session = URLSession.shared
            
            session.configuration.timeoutIntervalForRequest=30
            // session.configuration.timeoutIntervalForResource=50
            
            let request = NSMutableURLRequest(url: url as URL)
            request.httpMethod = "POST"
            request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
            
            
            do {
                let jsonData = try!  JSONSerialization.data(withJSONObject: parameters, options: [])
                request.httpBody = jsonData
                
                
                // here "jsonData" is the dictionary encoded in JSON data
            } catch let error as NSError {
                print(error)
            }
            
            
            
            // request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(prmt, options: [])
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            
            
            let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
                
                OperationQueue.main.addOperation
                    {
                        
                        if data == nil
                        {
                            CommonFunctionsClass.sharedInstance().showAlert(title: "Server Alert", text: "Something doesn't seem right, Please try again!", imageName: "alertServer")
                            
                        }
                        else
                        {
                            do
                            {
                                let result = NSString(data: data!, encoding:String.Encoding.ascii.rawValue)!
                                print("Body: \(result)")
                                
                                let anyObj: Any = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                                
                                
                                jsonResult = NSDictionary()
                                jsonResult = anyObj as! NSDictionary
                                
                                let status = jsonResult.value(forKey: "status") as! NSNumber
                                
                                if status == 1{
                                    
                                    self.planAllLocations.removeObject(at: sender.tag)
                                    self.locationsCollectionView.deleteItems(at: [currentItem])
                                    self.reloadTableOnly = true
                                    self.getPlanDetails()
                                    
                                    DispatchQueue.global(qos: .background).async {
                                        
                                        let uId = Udefaults .string(forKey: "userLoginId")
                                        let objt = storyCountClass()
                                        let dic:NSDictionary = ["userId": uId!]
                                        objt.postRequestForcountStory(parameterString: dic)
                                        objt.postRequestForcountStoryandBucket(dic)
                                    }
                                }
                                else{
                                    print("status = 0")
                                    CommonFunctionsClass.sharedInstance().showAlert(title: "Server Alert", text: jsonResult.value(forKey: "msg") as! String as NSString, imageName: "alertServer")
                                }
                                MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                            }
                            catch
                            {
                                print("json error: \(error)")
                                CommonFunctionsClass.sharedInstance().showAlert(title: "Server Alert", text: jsonResult.value(forKey: "msg") as! String as NSString, imageName: "alertServer")
                                MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                            }
                        }
                }
            })
            
            task.resume()
        }
        else
        {
            CommonFunctionsClass.sharedInstance().showAlert(title: "No Internet Connection", text: "You are currently offline.", imageName: "alertInternet")
            MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
        }
        
    }
    
    */
    
    
    
    
    
}



extension Date {
    func isGreaterThanDate(dateToCompare: Date) -> Bool {
        //Declare Variables
        var isGreater = false
        
        //Compare Values
        let str = NSCalendar.current.compare(self as Date, to: dateToCompare as Date, toGranularity: .day)
        if str == ComparisonResult.orderedDescending {
            isGreater = true
        }
        
        //Return Result
        return isGreater
    }
    
    func isLessThanDate(dateToCompare: Date) -> Bool {
        //Declare Variables
        var isLess = false
        
        //Compare Values
        let str = NSCalendar.current.compare(self as Date, to: dateToCompare as Date, toGranularity: .day)
        if str == ComparisonResult.orderedAscending {
            isLess = true
        }
        
        //Return Result
        return isLess
    }
    
    func equalToDate(dateToCompare: Date) -> Bool {
        //Declare Variables
        var isEqualTo = false
        
        //Compare Values
        let str = NSCalendar.current.compare(self as Date, to: dateToCompare as Date, toGranularity: .day)
        if str == ComparisonResult.orderedSame {
            isEqualTo = true
        }
        
        //Return Result
        return isEqualTo
    }
    
    func addDays(daysToAdd: Int) -> Date {
        let secondsInDays: TimeInterval = Double(daysToAdd) * 60 * 60 * 24
        let dateWithDaysAdded: Date = self.addingTimeInterval(secondsInDays)
        
        //Return Result
        return dateWithDaysAdded
    }
    
    func addHours(hoursToAdd: Int) -> Date {
        let secondsInHours: TimeInterval = Double(hoursToAdd) * 60 * 60
        let dateWithHoursAdded: Date = self.addingTimeInterval(secondsInHours)
        
        //Return Result
        return dateWithHoursAdded
    }
}

class PlanLocationImagesCC: UICollectionViewCell
{
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var locationImage: UIImageView!
    @IBOutlet weak var calendarBtn: UIButton!
    @IBOutlet weak var bucketBtn: UIButton!
    @IBOutlet weak var crossButton: UIButton!
    
    
}
class DateWiseListTCell: UITableViewCell
{
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var llocationImage: CustomImageView!
    
}
class DateWiseListTHeader: UITableViewCell
{
    @IBOutlet weak var dateLbl: UILabel!
    
}

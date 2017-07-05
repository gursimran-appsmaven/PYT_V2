//
//  TravelPlanVC.swift
//  PYT
//
//  Created by osx on 03/07/17.
//  Copyright © 2017 osx. All rights reserved.
//

import UIKit
import FSCalendar

class TravelPlanVC: UIViewController ,UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,FSCalendarDelegate,FSCalendarDataSource{

    @IBOutlet weak var startDateLbl: UILabel!
    @IBOutlet weak var endDateLbl: UILabel!
    @IBOutlet weak var noOfDaysLbl: UILabel!

    @IBOutlet weak var calendarBackView: UIView!
    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var doneBtn: UIButton!
    
    @IBOutlet weak var startDateBtn: UIButton!
    @IBOutlet weak var endDateBtn: UIButton!
    
    var startBool = Bool()
    var startDate = NSDate()
    var endDate = NSDate()
    var boolEdit = Bool()
    var editedDate = NSDate()
    
    fileprivate let gregorian = Calendar(identifier: .gregorian)

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpCalendarProperties()
        startBool = true
        
        calendarView.swipeToChooseGesture.isEnabled = true // Swipe-To-Choose

        self.calendarView.appearance.borderRadius = 0
        self.calendarView.delegate = self
        self.calendarView.dataSource = self
        self.calendarView.dropShadow()
//        startButton.setAttributedTitle(attributedTextClass().setAttributeRobotRegularWithMultipleColor("Start", text1Size: 16, text2: " ", text2Size: 12), forState: UIControlState .Normal)
        
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
//            dateFormatter.timeZone = NSTimeZone.localTimeZone()
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
//            dateFormatter.timeZone = NSTimeZone.localTimeZone()
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
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: DataSource and delegate of tableView
    //MARK:-
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 4
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 60
        
    }
    
    func tableView( _ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DateWiseListTHeader") as! DateWiseListTHeader
        return cell
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
        
        
        return cell
    }
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
    }
    
    // MARK: UICollectionView
    
    func numberOfSections(in collectionView: UICollectionView) -> Int   {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView,numberOfItemsInSection section: Int) -> Int
    {
        
        return 5
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        return CGSize(width: collectionView.frame.size.width , height: collectionView.frame.size.height)
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView,cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlanLocationImagesCC", for: indexPath) as! PlanLocationImagesCC
        
        cell.nameLbl.text = "\(indexPath.row)"
        let gradient = cell.viewWithTag(7499) as! GradientView
        
        gradient.gradientLayer.colors = [UIColor.black.withAlphaComponent(0.75).cgColor, UIColor.clear.cgColor]
        gradient.gradientLayer.gradient = GradientPoint.bottomTop.draw()
        
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
        
        
    }
    //MARK: Calender Delegates
    
    
    /////////////------ manage calendar---------////
     func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        let date = date as NSDate
        if boolEdit == true {
            editedDate = date as NSDate
            return
        }
            
        else
        {
            
            print(startDate)
            print(endDate)
        
            
            let todayDate = NSDate()
            
            if(startDate.equalToDate(dateToCompare: endDate))
            {
                startDate=date as NSDate
                return
            }
            else if  date.isLessThanDate(dateToCompare: startDate) {
                if(endDate.equalToDate(dateToCompare: todayDate))
                {
                    endDate=startDate
                    startDate=date as NSDate
                }
                else
                {
                    startDate=date as NSDate
                }
            }
            else if  date.isLessThanDate(dateToCompare: endDate) {
                startBool ? (startDate=date as NSDate) : (endDate=date as NSDate)
            }
            else if(date.isGreaterThanDate(dateToCompare: endDate) )
            {
                endDate=date as NSDate
            }
            
            for date1 in calendarView.selectedDates {
                calendarView .deselect(date1)
            }
            
            var nextDate = startDate.earlierDate(startDate as Date)
            
            let lastdate =  calendarView.date(byAddingDays: 1, to: endDate as Date)
            
            while nextDate .compare(lastdate) == .orderedAscending  {
                
                print(nextDate)
                
                calendar.select(nextDate)
                nextDate = calendar.date(byAddingDays: 1, to: nextDate)
                
                
            }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss +0000"
            dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
            let date1 = dateFormatter.date(from: String(describing: startDate))// create   date from string
            let date2 = dateFormatter.date(from: String(describing: endDate))// create   date from string
            
            // change to a readable time format and change to local time zone
            dateFormatter.dateFormat = "MMM dd, YYYY"
            dateFormatter.timeZone = NSTimeZone.local
            let timeStamp1 = dateFormatter.string(from: date1!)
            let timeStamp2 = dateFormatter.string(from: date2!)
        
            startDateLbl.text = timeStamp1
            endDateLbl.text = timeStamp2

            
            let components = NSCalendar.current.dateComponents([.day], from: date1!, to: date2!)
            noOfDaysLbl.text = "\(components.day! + 1) Days"
            
            configureVisibleCells()

            print("Start Date-\(startDate)\n End Date-\(endDate)")
            
        }
    
    }
    
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        let date = date as NSDate
        
        if boolEdit == true {
            return
        }
        
        let todayDate = NSDate()
        
        if  endDate.isLessThanDate(dateToCompare: startDate) && endDate.equalToDate(dateToCompare: todayDate){
            endDate=startDate
            startDate=date as NSDate
        }
        if(startDate.equalToDate(dateToCompare: endDate))
        {
            startDate=date as NSDate
            return
        }
            
        else if  date.isGreaterThanDate(dateToCompare: startDate) && date.isLessThanDate(dateToCompare: endDate) {
            
            startBool ? (startDate=date as NSDate) : (endDate=date)
            
        }
        else if  date.isLessThanDate(dateToCompare: startDate) {
            startDate=date as NSDate
        }
        else if(date.isGreaterThanDate(dateToCompare: endDate) && date.isGreaterThanDate(dateToCompare: startDate))
        {
            endDate=date as NSDate
        }
        else if(date.isLessThanDate(dateToCompare: endDate) && date.isLessThanDate(dateToCompare: startDate))
        {
            endDate=startDate
            startDate=date as NSDate
        }
        
        for date1 in calendarView.selectedDates {
            calendarView .deselect(date1)
        }
        
        var nextDate = startDate.earlierDate(startDate as Date)
        
        let lastdate =  calendarView.date(byAddingDays: 1, to: endDate as Date)
        
        while nextDate .compare(lastdate) == .orderedAscending  {
            
            print(nextDate)
            
            calendar.select(nextDate)
            nextDate = calendar.date(byAddingDays: 1, to: nextDate)
            
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss +0000"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        let date1 = dateFormatter.date(from: String(describing: startDate))// create   date from string
        let date2 = dateFormatter.date(from: String(describing: endDate))// create   date from string
        
        // change to a readable time format and change to local time zone
        dateFormatter.dateFormat = "MMM dd, YYYY"
        dateFormatter.timeZone = NSTimeZone.local
        let timeStamp1 = dateFormatter.string(from: date1!)
        let timeStamp2 = dateFormatter.string(from: date2!)
        
        startDateLbl.text = timeStamp1
        endDateLbl.text = timeStamp2
        
        let components = NSCalendar.current.dateComponents([.day], from: date1!, to: date2!)
        noOfDaysLbl.text = "\(components.day! + 1) Days"

        configureVisibleCells()
        
        
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
        if boolEdit == true {
            return startDate as Date
        }
        else
        {
//            if calendar.selectedDates.count == 2 {
//                return startDate as Date
//            }
            return Date()
        }
    }
    
    
   
    
    
    // MARK: - Calendar Customisation
    
    // MARK:- FSCalendarDataSource
    func setUpCalendarProperties()
    {
        self.calendarView.allowsMultipleSelection=true
        self.calendarView.appearance.headerMinimumDissolvedAlpha = 0
        self.calendarView.appearance.selectionColor=UIColor(red: 255/255.0, green: 80/255.0, blue: 80/255.0, alpha: 1.0)
        self.calendarView.appearance.todayColor=UIColor(red: 255/255.0, green: 80/255.0, blue: 80/255.0, alpha: 1.0)
        self.calendarView.appearance.headerTitleColor = UIColor(red: 20/255.0, green: 44/255.0, blue: 69/255.0, alpha: 1.0)
        self.calendarView.appearance.titleDefaultColor = UIColor.lightGray
        self.calendarView.appearance.titlePlaceholderColor = UIColor.lightGray.withAlphaComponent(0.25)
        
        self.calendarView.appearance.headerTitleFont = UIFont(name: "SFUIDisplay-Bold", size: 14.0)!
        self.calendarView.appearance.titleFont = UIFont(name: "SFUIDisplay-Regular", size: 11.0)!
        self.calendarView.appearance.weekdayFont = UIFont(name: "SFUIDisplay-Regular", size: 12.0)!
        
        self.calendarView.appearance.weekdayTextColor = UIColor(red: 255/255.0, green: 80/255.0, blue: 80/255.0, alpha: 1.0)
        
        calendarView.today = nil // Hide the today circle
        calendarView.register(DIYCalendarCell.self, forCellReuseIdentifier: "cell")
        //        calendar.clipsToBounds = true // Remove top/bottom line
        
        calendarView.swipeToChooseGesture.isEnabled = true // Swipe-To-Choose
        
        self.calendarView.appearance.borderRadius = 0
        self.calendarView.dropShadow()

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
        calendarView.visibleCells().forEach { (cell) in
            let date = calendarView.date(for: cell)
            let position = calendarView.monthPosition(for: cell)
            self.configure(cell: cell, for: date, at: position)
        }
    }
    
    private func configure(cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
        
        let diyCell = (cell as! DIYCalendarCell)
        // Custom today circle
        diyCell.circleImageView.isHidden = !self.gregorian.isDateInToday(date)
        // Configure selection layer
        if position == .current {
            
            var selectionType = SelectionType.none
            print(calendarView.selectedDates)
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
            diyCell.circleImageView.isHidden = true
            diyCell.selectionLayer.isHidden = true
        }
    }


   //MARK: Action Methods
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
    }
    @IBAction func LeftBtnAction(_ sender: Any) {
    }
    @IBAction func RightBtnAction(_ sender: Any) {
    }
    @IBAction func DoneBtnAction(_ sender: Any) {
    }
    @IBAction func MapViewBtnACtion(_ sender: Any) {
    }
    @IBAction func BackBtnAction(_ sender: Any) {
    }
    
}
extension NSDate {
    func isGreaterThanDate(dateToCompare: NSDate) -> Bool {
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
    
    func isLessThanDate(dateToCompare: NSDate) -> Bool {
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
    
    func equalToDate(dateToCompare: NSDate) -> Bool {
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
    
    func addDays(daysToAdd: Int) -> NSDate {
        let secondsInDays: TimeInterval = Double(daysToAdd) * 60 * 60 * 24
        let dateWithDaysAdded: NSDate = self.addingTimeInterval(secondsInDays)
        
        //Return Result
        return dateWithDaysAdded
    }
    
    func addHours(hoursToAdd: Int) -> NSDate {
        let secondsInHours: TimeInterval = Double(hoursToAdd) * 60 * 60
        let dateWithHoursAdded: NSDate = self.addingTimeInterval(secondsInHours)
        
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

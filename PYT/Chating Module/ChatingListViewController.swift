//
//  ChatingListViewController.swift
//  PYT
//
//  Created by Niteesh on 23/01/17.
//  Copyright © 2017 appsMaven. All rights reserved.
//

import UIKit
import HMSegmentedControl


class ChatingListViewController: UIViewController {

    @IBOutlet weak var chatingListTable: UITableView!
    
    @IBOutlet weak var segMentControllView: HMSegmentedControl!
    
    @IBOutlet weak var chatingIndicator: UIActivityIndicatorView!
    
    
    var segmentArray = NSMutableArray()
    var segmentName = NSMutableArray()
    var usersChat = NSMutableArray()
    
    var chatLocation = NSString()
    var chatLocationType = NSString()
    var refreshControl = UIRefreshControl()
    
    
    override func viewWillAppear(_ animated: Bool) {
        chatingIndicator.isHidden = false
        chatingIndicator.startAnimating()
        chatingListTable.userInteractionEnabled=false
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let uId = defaults .stringForKey("userLoginId")
        
        let prmDict: NSDictionary = ["userId": uId!]
        
        self.postRequestGetMessages(prmDict, viewController: self)
        
        
        
        
        
        //MANAGE DEVICETOKEN
        
        
        let tokendevice = defaults.stringForKey("deviceToken")!
        print(tokendevice)
        
        if defaults.boolForKey("savedDeviceToken") == true {
            
        }
            
        else
        {
            if tokendevice == "" {
                
                print("unable to send the devicetoken")
            }
            else
            {
                let parameterDict: NSDictionary = ["userId": uId!, "deviceToken": ["token": tokendevice, "device": "iphone"]]
                
                let objforDeviceToken = firstMainScreenViewController()// self.postApiFordeviceToken(parameterDict)
                objforDeviceToken.postApiFordeviceToken(parameterDict)
                
            }
            
        }
        
        
        
        
        
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        segMentControllView.backgroundColor = UIColor .clearColor()
        self.navigationController?.navigationBarHidden=true
        
        /////0------  Pull to refresh Control ------////////
        
        
        refreshControl.attributedTitle = NSAttributedString(string: "")// "Fetching Feeds")
        //refreshControl.addTarget(self, action: #selector(ChatingListViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        //self.chatingListTable.addSubview(refreshControl)
        
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ChatingListViewController.refresh),name:"pushReload", object: nil)
        
        
        // Do any additional setup after loading the view.
    }

   
    
    
    //MARK: Pull to refresh
    
    func refresh()
    {
        
        
        //self.viewWillAppear(false)
        
        // refreshControl.endRefreshing()
        chatingIndicator.hidden=false
        chatingIndicator.startAnimating()
        chatingListTable.userInteractionEnabled=false
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let uId = defaults .stringForKey("userLoginId")
        
        let prmDict: NSDictionary = ["userId": uId!]
        
        self.postRequestGetMessages(prmDict, viewController: self)
    }
    
    
    
    //MARK:
    
    
    
    
    
    func updateSegment() -> Void {
        
        
        
       
        let viewWidth = CGRectGetWidth(self.view.frame)
        
        
        print(segmentName.count)
        print(segmentName)
        
        segMentControllView.sectionTitles = NSArray (array: segmentName) as [AnyObject]// segmentName as! [String]
        segMentControllView.autoresizingMask = [.FlexibleRightMargin, .FlexibleWidth]
        segMentControllView.frame = CGRectMake(0, 60, viewWidth, 37)
        
        segMentControllView.segmentEdgeInset = UIEdgeInsetsMake(0, 5, 0, 5)
        
        segMentControllView.selectionStyle = HMSegmentedControlSelectionStyle.FullWidthStripe
        
        
        segMentControllView.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocation.Down
        
        
        segMentControllView.selectionIndicatorColor = UIColor(red: 157/255, green: 194/255, blue: 134/255, alpha: 1.0)
        segMentControllView.selectionIndicatorHeight=3.0
        segMentControllView.verticalDividerEnabled = true
        segMentControllView.verticalDividerColor = UIColor.clearColor()
        segMentControllView.verticalDividerWidth = 0.8
        segMentControllView.backgroundColor = UIColor .clearColor()
        
        //segMentControllView.selectedSegmentIndex=selectedindxSearch
        let selectedAttributes: NSDictionary = [
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: UIFont(name: "Roboto-Bold", size: 16)!
        ]
        
        
        let segAttributes: NSDictionary = [
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: UIFont(name:"Roboto-Regular", size: 15.0)!
        ]
        
        
        segMentControllView .selectedTitleTextAttributes = selectedAttributes as [NSObject : AnyObject]
        segMentControllView .titleTextAttributes = segAttributes as [NSObject : AnyObject]
        
        
        segMentControllView.addTarget(self, action: #selector(self.segmentedControlChangedValue), forControlEvents: .ValueChanged)
  
        self.segMentControllView.setNeedsDisplay()
        
        if segMentControllView.selectedSegmentIndex==segmentArray.count {
            segMentControllView.setSelectedSegmentIndex(0, animated: true)
        }
        
        self.reloadTable()
        
        
        
    }
    
    
     func segmentedControlChangedValue(segmentedControl: HMSegmentedControl) {
     self .reloadTable()
        
    }
    
    func reloadTable() -> Void {
        chatingListTable.userInteractionEnabled=true
        usersChat = NSMutableArray()
//        print(segmentArray.count)
//        print(segMentControllView.selectedSegmentIndex)
       
      
        
        let tmpArr = segmentArray .objectAtIndex(segMentControllView.selectedSegmentIndex).valueForKey("conver") as! NSMutableArray
        
        usersChat = tmpArr
        
        print(usersChat.count)
        print(usersChat)
        
        self.chatingListTable .reloadData()
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    //MARk:-
    //MARK:- Data source and delegates of the tableView
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return usersChat.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        
        let cell:chatingTableCell = tableView.dequeueReusableCellWithIdentifier("chatingListCell") as! chatingTableCell
        
        print(usersChat.objectAtIndex(indexPath.row))
        
        
        let imageName2 = usersChat.objectAtIndex(indexPath.row).valueForKey("with")!.objectAtIndex(0).valueForKey("picture") as? String ?? ""
        
        let url2 = NSURL(string: imageName2)
        let pImage : UIImage = UIImage(named:"backgroundImage")!
        cell.profilePic.sd_setImageWithURL(url2, placeholderImage: pImage)
        
        
        
        
        
        
        
        cell.profilePic.layer.cornerRadius=cell.profilePic.frame.size.width/2
        cell.profilePic.clipsToBounds=true
        
        cell.msgSendReceive.layer.cornerRadius=cell.msgSendReceive.frame.size.width/2
        cell.msgSendReceive.clipsToBounds=true
        
        
        
        cell.userNameLabel.text = usersChat.objectAtIndex(indexPath.row).valueForKey("with")!.objectAtIndex(0).valueForKey("name") as? String ?? ""
        
        
        let msgArr = usersChat.objectAtIndex(indexPath.row).valueForKey("message") as! NSMutableArray
        
        let lastMsg = msgArr.lastObject!.valueForKey("msg") as? String ?? ""
        
        var time = msgArr.lastObject!.valueForKey("timeStamp") as? String ?? ""
        print(time)
        //formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        
        
         var date = NSDate()
         let formatter = NSDateFormatter()
         formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
         formatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
         formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
         print(formatter.dateFromString(time))
        date = formatter.dateFromString(time)!
 
        
        let calendar = NSCalendar.autoupdatingCurrentCalendar()
        
        //let someDate = dateFormatter.dateFromString(date2)
        if calendar.isDateInYesterday(date) {
            time = "Yesterday"
        }else if(calendar.isDateInToday(date))
        {
            time = "Today"
        }
        else{
            formatter.dateFormat = "MMM dd, YYYY"
           time = formatter.stringFromDate(date)
           
        }
        
        
        
        
        
//        let components = calendar.components([.Day , .Month , .Year], fromDate: date)
//        
//        let year =  components.year
//        let month = components.month
//        let day = components.day
//        
//        print(year)
//        print(month)
//        print(day)
        
//        let todayDate = NSDate()
//        let yearCheck = calendar.component(.Year, fromDate: todayDate)
//        
//        if year != yearCheck {
//            time = String(year)
//        }
        
        
        
        cell.lastMsgTime.text = time
        
        let msgType = msgArr.lastObject!.valueForKey("msgType") as! NSNumber
        
        if msgType == 1 {
            print("Text message")
            
             cell.messageLabel.text = lastMsg
        }
        else
        {
            print("Image message")
            cell.messageLabel.text = "Image"
        }
        
        
        cell.msgSendReceive.hidden=true
        
        
        
    
        
        return cell
        
    }
    
    
    
    
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
            return true
        
        
    }
    
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        
        let deleteAction = UITableViewRowAction(style: .Default, title: "Delete") {action in
            
           let username = self.usersChat.objectAtIndex(indexPath.row).valueForKey("with")!.objectAtIndex(0).valueForKey("name") as? String ?? "NA"

            
            
            SweetAlert().showAlert("Confirm Delete?", subTitle: "All your messages with \(username) will be deleted. This action cannot be undone.", style: AlertStyle.CustomImag(imageFile: "alertDelete"), buttonTitle:"Okay", buttonColor: UIColor .clearColor() , otherButtonTitle:  "Cancel", otherButtonColor: UIColor .clearColor()) { (isOtherButton) -> Void in
                if isOtherButton == true {
                    
                    
                    
                        let convid = self.usersChat.objectAtIndex(indexPath.row).valueForKey("converId") as? String ?? ""
                        
                        let defaults = NSUserDefaults.standardUserDefaults()
                        let uId = defaults .stringForKey("userLoginId")
                        
                        
                        let parmDict: NSDictionary = ["userId": uId!, "converId": convid ]
                        
                        self.postRequestDeleteMessages(parmDict, viewController: self)
                        
                        
                        
        
                    
                }
                else {
                    
                    print("Cancel Pressed")
                }
            }

            
            
            
            
        }
        
        
        return [deleteAction]
    }
    
    
    
    
    
    
     func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        
        let user2Id = usersChat.objectAtIndex(indexPath.row).valueForKey("with")!.objectAtIndex(0).valueForKey("_id") as? String ?? ""
        let usname = usersChat.objectAtIndex(indexPath.row).valueForKey("with")!.objectAtIndex(0).valueForKey("name") as? String ?? ""
        
        //let defaults = NSUserDefaults.standardUserDefaults()
      
       // let myName = defaults .stringForKey("userLoginName")!
        
        
        
    var receiverProfileImage = ""
        
        if usersChat.objectAtIndex(indexPath.row).valueForKey("with")!.objectAtIndex(0).valueForKey("picture") != nil {
    receiverProfileImage = usersChat.objectAtIndex(indexPath.row).valueForKey("with")!.objectAtIndex(0).valueForKey("picture") as? String ?? ""
        }
        
        let convId = usersChat.objectAtIndex(indexPath.row).valueForKey("converId") as? String ?? ""
      
        let locName = usersChat.objectAtIndex(indexPath.row).valueForKey("placeName") as? String ?? ""
        chatLocation = usersChat.objectAtIndex(indexPath.row).valueForKey("placeId") as? String ?? ""
        chatLocationType = usersChat.objectAtIndex(indexPath.row).valueForKey("placeType") as? String ?? ""
            
            
        let nxtObj = self.storyboard?.instantiateViewControllerWithIdentifier("ChatViewController") as! ChatViewController
       // nxtObj.CountTableArray = sendArray
        nxtObj.receiver_Id = user2Id
        nxtObj.locationName = locName
        nxtObj.locationType = chatLocationType
        nxtObj.receiverName = usname
        nxtObj.locationId = chatLocation
        nxtObj.convertationId = convId
        nxtObj.receiverProfile = receiverProfileImage
        self.navigationController! .pushViewController(nxtObj, animated: true)
        nxtObj.hidesBottomBarWhenPushed = true
    
    }
    

    
    
    
    
    
    
    //MARK: Api to get the chats 
    func postRequestGetMessages(parameterString : NSDictionary , viewController : UIViewController)
    {
        
        print(parameterString)
        
        let isConnectedInternet = CommonFunctionsClass.sharedInstance().isConnectedToNetwork()
        
        if isConnectedInternet
        {
            let request = NSMutableURLRequest(URL: NSURL(string: "\(appUrl)get_older_conversation")!)
            
            
            request.HTTPMethod = "POST"
            let postString = parameterString
            
            do {
                let jsonData = try!  NSJSONSerialization.dataWithJSONObject(postString, options: [])
                request.HTTPBody = jsonData
                
                
                // here "jsonData" is the dictionary encoded in JSON data
            } catch let error as NSError {
                print(error)
            }
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            
            
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
                guard error == nil && data != nil else {                                                          // check for fundamental networking error
                    print("error=\(error)")
                    return
                }
                
                if let httpStatus = response as? NSHTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(response)")
                }
                
                //let responseString = String(data: data!, encoding: NSUTF8StringEncoding)
               // print("responseString = \(responseString)")
                
                
                dispatch_async(dispatch_get_main_queue(), {
                    
                    do {
                        
                       let result = NSString(data: data!, encoding:NSASCIIStringEncoding)!
                        print("Body: \(result)")
                        
                        let anyObj: AnyObject = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
                        
                        basicInfo = NSMutableDictionary()
                        basicInfo = anyObj as! NSMutableDictionary
                        
                        let status = basicInfo .valueForKey("status") as! NSNumber
                        self.segmentName = NSMutableArray()
                        self.segmentArray = NSMutableArray()
                       
                        
                        
                        if status == 1{
                            
                            self.segMentControllView.hidden=false
                            
                            let arr: NSMutableArray = basicInfo .valueForKey("chat") as! NSMutableArray
                            
                           print(arr)
                            
                            
                            
                            
                            for i in 0..<arr.count{
                                
                                let nameLoc = arr.objectAtIndex(i).valueForKey("placeName") as! NSMutableArray
                                
                                var locationSegmentName = "NA"
                                
                                if (nameLoc.count > 0){
                                    locationSegmentName = nameLoc.objectAtIndex(0) as? String ?? " "
                                    
                                }
                                
                                
                                self.segmentName .addObject(locationSegmentName)
                                
                                
                                
                                let locationChat: NSMutableDictionary = arr.objectAtIndex(i) as! NSMutableDictionary
                                
                                
                                self.segmentArray .addObject(locationChat)
                                
                                
                            }
                            
                            if arr.count<1 {
                                self.chatingListTable.hidden=true
                            }
                            else
                            {
                                self.chatingListTable.hidden=false
                                //print(self.segmentArray)
                               
                              
                                
                                self .updateSegment()
                           
                            }
                           
                            
                        }
                        else
                        {
                            
                            
                            self.segMentControllView.hidden=true
                            
                            CommonFunctionsClass.sharedInstance().showAlert("Err ...", text: "No chats found.", imageName: "alertChat")
                            
                            
                             self.chatingListTable.hidden=true
                            
                        }
                        
                        
                        
                        
                        
                        
                    } catch {
                        print("json error: \(error)")
                        CommonFunctionsClass.sharedInstance().showAlert("Server Alert", text: "Something doesn't seem right, Please try again!", imageName: "alertServer")
                      
                        
                    }
                    
                    
                    self.chatingIndicator.hidden=true
                    self.chatingIndicator.stopAnimating()
                    self.tabBarController?.tabBar.items?[3].badgeValue = nil
                    let defaults = NSUserDefaults.standardUserDefaults()
                    let uId = defaults .stringForKey("userLoginId")
                    SocketIOManager.sharedInstance.sendCounter(uId!)
                
                    
                })
                
                
                
                
                
                
                
            }
            task.resume()
            
        }
        else
        {
            CommonFunctionsClass.sharedInstance().showAlert("No Internet Connection", text: "You are currently offline.", imageName: "alertInternet")
        }
    }
    
    
    
    
    
    
    
    
    
    //MARK:- Delete the chat of a location
    
    
    func postRequestDeleteMessages(parameterString : NSDictionary , viewController : UIViewController)
    {
        chatingIndicator.hidden=false
        chatingIndicator.startAnimating()
        chatingListTable.userInteractionEnabled=false
        
        
        print(parameterString)
        
        let isConnectedInternet = CommonFunctionsClass.sharedInstance().isConnectedToNetwork()
        
        if isConnectedInternet
        {
            let request = NSMutableURLRequest(URL: NSURL(string: "\(appUrl)delete_conversation")!)
            
            
            request.HTTPMethod = "POST"
            let postString = parameterString
            
            do {
                let jsonData = try!  NSJSONSerialization.dataWithJSONObject(postString, options: [])
                request.HTTPBody = jsonData
                
                
                // here "jsonData" is the dictionary encoded in JSON data
            } catch let error as NSError {
                print(error)
            }
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            
            
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
                guard error == nil && data != nil else {
                    // check for fundamental networking error
                    print("error=\(error)")
                    return
                }
                
                if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(response)")
                }
              
                
                
                dispatch_async(dispatch_get_main_queue(), {
                    
                    do {
                        
                        let result = NSString(data: data!, encoding:NSASCIIStringEncoding)!
                        print("Body: \(result)")
                        
                        let anyObj: AnyObject = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
                        
                        basicInfo = NSMutableDictionary()
                        basicInfo = anyObj as! NSMutableDictionary
                        
                        let status = basicInfo .valueForKey("status") as! NSNumber
                       
                        
                        if status == 1{
                            
                            let defaults = NSUserDefaults.standardUserDefaults()
                            let uId = defaults .stringForKey("userLoginId")
                            
                            let prmDict: NSDictionary = ["userId": uId!]
                            
                            self.postRequestGetMessages(prmDict, viewController: self)
                                
                                
                            }
                            
                           
                        else
                        {
                            
                            CommonFunctionsClass.sharedInstance().alertViewOpen("Unable to delete", viewController: self)
                            self.chatingIndicator.hidden=true
                            self.chatingIndicator.stopAnimating()
                            
                        }
                        
                        self.chatingListTable.reloadData()
                        
                        
                        
                        
                    } catch {
                        print("json error: \(error)")
                        CommonFunctionsClass.sharedInstance().showAlert("Server Alert", text: "Something doesn't seem right, Please try again!", imageName: "alertServer")
                      
                        indicatorClass.sharedInstance().hideIndicator()
                        
                      
                        
                    }
                    
                    
             
                    
                    
                })
                
                
                
                
                
                
                
            }
            task.resume()
            
        }
        else
        {
            CommonFunctionsClass.sharedInstance().showAlert("No Internet Connection", text: "You are currently offline.", imageName: "alertInternet")
        }
    }
    
    
    
    
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


class chatingTableCell: UITableViewCell {
    //chatingListCell
    
    @IBOutlet weak var profilePic: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var msgSendReceive: UIImageView!
    
    @IBOutlet weak var lastMsgTime: UILabel!
    
}




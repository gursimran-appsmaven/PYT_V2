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
    @IBOutlet weak var chatingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var bottomShadow: GradientView!
    
    
    var chatLocation = NSString()
    var chatLocationType = NSString()
    var refreshControl = UIRefreshControl()
    var chattingListArray = NSMutableArray()
    var olderArr = NSMutableArray()
    
    override func viewWillAppear(_ animated: Bool) {
        chatingIndicator.isHidden = false
        chatingIndicator.startAnimating()
        chatingListTable.isUserInteractionEnabled=false
        
            let uId = Udefaults .string(forKey: "userLoginId")
        
        let prmDict: NSDictionary = ["userId": uId!]
        
        self.postRequestGetMessages(parameterString: prmDict, viewController: self)
        
        
        
        
        
        //MANAGE DEVICETOKEN
        
        
        let tokendevice = Udefaults.string(forKey: "deviceToken")!
        print(tokendevice)
        
        if Udefaults.bool(forKey: "savedDeviceToken") == true {
            
        }
            
        else
        {
            if tokendevice == "" {
                
                print("unable to send the devicetoken")
            }
            else
            {
                let parameterDict: NSDictionary = ["userId": uId!, "deviceToken": ["token": tokendevice, "device": "iphone"]]
                
                let objforDeviceToken = mainHomeViewController()// self.postApiFordeviceToken(parameterDict)
                //objforDeviceToken.postApiFordeviceToken(parameterDict)
                
            }
            
        }
        
        self.tabBarController?.setTabBarVisible(visible: true, animated: true)
        
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bottomShadow.gradientLayer.colors = [UIColor.black.withAlphaComponent(0.15).cgColor, UIColor.clear.cgColor]
        bottomShadow.gradientLayer.gradient = GradientPoint.bottomTop.draw()

        /////0------  Pull to refresh Control ------////////
        
        
        refreshControl.attributedTitle = NSAttributedString(string: "")// "Fetching Feeds")
        //refreshControl.addTarget(self, action: #selector(ChatingListViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        //self.chatingListTable.addSubview(refreshControl)
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatingListViewController.refresh),name:NSNotification.Name(rawValue: "pushReload"), object: nil)
        
        
        // Do any additional setup after loading the view.
    }

   
    
    
    //MARK: Pull to refresh
    
    func refresh()
    {
        
        
        //self.viewWillAppear(false)
        
        // refreshControl.endRefreshing()
        chatingIndicator.isHidden=false
        chatingIndicator.startAnimating()
        chatingListTable.isUserInteractionEnabled=false
      
        let uId = Udefaults .string(forKey: "userLoginId")
        
        let prmDict: NSDictionary = ["userId": uId!]
        
        self.postRequestGetMessages(parameterString: prmDict, viewController: self)
    }
    
    
    
    //MARK:
    
    
    
    
    
    
    func reloadTable() -> Void {
        chatingListTable.isUserInteractionEnabled=true
        //self.chatingListTable .reloadData()
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    //MARk:-
    //MARK:- Data source and delegates of the tableView
    
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int
    {
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return chattingListArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell:chatingTableCell = tableView.dequeueReusableCell(withIdentifier: "chatingListLocations") as! chatingTableCell
        
        
        cell.locationPic.layer.cornerRadius = cell.locationPic.frame.size.width/2
        cell.locationPic.clipsToBounds = true
       cell.activeCounts.layer.cornerRadius = cell.activeCounts.frame.size.height/2
        cell.activeCounts.clipsToBounds=true
        
        
        
        let imageUrl = ""
        
        let locnameArr = (self.chattingListArray.object(at: indexPath.row) as AnyObject).value(forKey: "placeName") as! NSArray
        var locationName = ""
        if locnameArr.count>0{
            locationName = locnameArr.object(at: 0) as? String ?? ""
        }
        cell.locationName.text = locationName
        
        let activeCounts = (self.chattingListArray.object(at: indexPath.row) as AnyObject).value(forKey: "conver") as! NSArray
        cell.activeChatsLabel.text = "\(String(activeCounts.count)) active chats"

        let usersNamesArr = NSMutableString()
        for j in 0..<activeCounts.count {
            
            let nameStr = (((activeCounts.object(at: j) as AnyObject).value(forKey: "with") as! NSArray).object(at: 0) as AnyObject).value(forKey: "name") as? String ?? ""
            if nameStr != "" {
                if j==activeCounts.count-1 {
                    usersNamesArr.append("\(nameStr)")
                }
                usersNamesArr .append("\(nameStr), ")
            }
        }
        
        cell.usersNameslabel.text = usersNamesArr as String
        
        //cell.activeCounts.text = "\(String(activeCounts.count)) active chats"
        
        
        
        
//        cell.layer.transform = CATransform3DMakeScale(0.1,0.1,1)
//        UIView.animate(withDuration: 0.3, animations: {
//            cell.layer.transform = CATransform3DMakeScale(1.05,1.05,1)
//        },completion: { finished in
//            UIView.animate(withDuration: 0.1, animations: {
//                cell.layer.transform = CATransform3DMakeScale(1,1,1)
//            })
//        })
        
        
        //formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        
        
//         var date = NSDate()
//         let formatter = NSDateFormatter()
//         formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
//         formatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
//         formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
//         print(formatter.dateFromString(time))
//        date = formatter.dateFromString(time)!
// 
//        
//        let calendar = NSCalendar.autoupdatingCurrentCalendar()
//        
//        //let someDate = dateFormatter.dateFromString(date2)
//        if calendar.isDateInYesterday(date) {
//            time = "Yesterday"
//        }else if(calendar.isDateInToday(date))
//        {
//            time = "Today"
//        }
//        else{
//            formatter.dateFormat = "MMM dd, YYYY"
//           time = formatter.stringFromDate(date)
//           
//        }
        
        
        
    
        
        return cell
        
    }
    
    
    
    
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
            return false//true
        
        
    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") {action in
            
           let LocName = ""

            
            
            SweetAlert().showAlert("Confirm Delete?", subTitle: "All your messages with \(LocName) will be deleted. This action cannot be undone.", style: AlertStyle.customImag(imageFile: "alertDelete"), buttonTitle:"Okay", buttonColor: UIColor .clear , otherButtonTitle:  "Cancel", otherButtonColor: UIColor .clear) { (isOtherButton) -> Void in
                if isOtherButton == true {
                    
                    
                    //hit api her to delete the whole chat
                        
                    
                    
                }
                else {
                    
                    print("Cancel Pressed")
                }
            }

            
            
            
            
        }
        
        
        return [deleteAction]
    }
    
    
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath)
    {
        
        
        let locnameArr = (self.chattingListArray.object(at: indexPath.row) as AnyObject).value(forKey: "placeName") as! NSArray
        var locationName2 = ""
        if locnameArr.count>0{
            locationName2 = locnameArr.object(at: 0) as? String ?? ""
        }
        
         let activeCounts = (self.chattingListArray.object(at: indexPath.row) as AnyObject).value(forKey: "conver") as! NSMutableArray
        
        
        
        let nxtObj = self.storyboard?.instantiateViewController(withIdentifier: "chatingUserListViewController") as! chatingUserListViewController
       nxtObj.locationName = locationName2 as NSString
        nxtObj.chatingArray = activeCounts
        self.navigationController! .pushViewController(nxtObj, animated: true)
        self.tabBarController?.setTabBarVisible(visible: false, animated: true)

    
    }
    

    
    
    
    
    
    
    //MARK: Api to get the chats 
    func postRequestGetMessages(parameterString : NSDictionary , viewController : UIViewController)
    {
        
        print(parameterString)
        
        let isConnectedInternet = CommonFunctionsClass.sharedInstance().isConnectedToNetwork()
        
        if isConnectedInternet
        {
            let request = NSMutableURLRequest(url: NSURL(string: "\(appUrl)get_older_conversation")! as URL)
            
            
            request.httpMethod = "POST"
            let postString = parameterString
            
            do {
                let jsonData = try!  JSONSerialization.data(withJSONObject: postString, options: [])
                request.httpBody = jsonData
                
                
                // here "jsonData" is the dictionary encoded in JSON data
            } catch let error as NSError {
                print(error)
            }
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            
            
           let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
                guard error == nil && data != nil else {                                                          // check for fundamental networking error
                    print("error=\(error)")
                    return
                }
                
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(response)")
                }
                
            
                
                
                  DispatchQueue.main.async {
                    
                    do {
                        
                       let result = NSString(data: data!, encoding:String.Encoding.ascii.rawValue)!
                        print("Body: \(result)")
                        
                       let anyObj: Any = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                        
                        basicInfo = NSMutableDictionary()
                        basicInfo = anyObj as! NSMutableDictionary
                        
                        let status = basicInfo .value(forKey: "status") as! NSNumber
                       
                        
                        
                        if status == 1
                        {
                            
                            let arr: NSMutableArray = basicInfo .value(forKey: "chat") as! NSMutableArray
                            
                            self.chattingListArray = NSMutableArray()
                            
                            for i in 0..<arr.count
                            {
                              self.chattingListArray .add(arr.object(at: i))
                            }
                            print(self.chattingListArray)
                            if arr.count<1 {
                                self.chatingListTable.isHidden=true
                            }
                            else
                            {
                                self.chatingListTable.isHidden=false
                                self.chatingListTable.isUserInteractionEnabled=true
                                self.chatingListTable.reloadData()
                           
                            }
                           
                            
                        }
                        else
                        {
                            
                            
                            CommonFunctionsClass.sharedInstance().showAlert(title: "Err ...", text: "No chats found.", imageName: "alertChat")
                            
                            
                             self.chatingListTable.isHidden=true
                            
                        }
                        
                        
                        
                        
                        
                        
                    } catch {
                        print("json error: \(error)")
                        CommonFunctionsClass.sharedInstance().showAlert(title: "Server Alert", text: "Something doesn't seem right, Please try again!", imageName: "alertServer")
                      
                        
                    }
                    
                    
                    self.chatingIndicator.isHidden=true
                    self.chatingIndicator.stopAnimating()
                    self.tabBarController?.tabBar.items?[3].badgeValue = nil
                    let uId = Udefaults .string(forKey: "userLoginId")
                    SocketIOManager.sharedInstance.sendCounter(uId!)
                
                    
                }
                
                
                
                
                
                
                
            }
            task.resume()
            
        }
        else
        {
            CommonFunctionsClass.sharedInstance().showAlert(title: "No Internet Connection", text: "You are currently offline.", imageName: "alertInternet")
        }
    }
    
    
    
    
    
    
    
    
    /*
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
    
    */
    
    
    
    
    
    
    
    
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
    //chatingListLocations
    
    @IBOutlet weak var locationPic: UIImageView!
    
    @IBOutlet weak var locationName: UILabel!
    
    @IBOutlet weak var activeChatsLabel: UILabel!
    
    @IBOutlet weak var nextArrow: UIImageView!
    
    @IBOutlet weak var usersNameslabel: UILabel!
    
    @IBOutlet weak var activeCounts: UILabel!
    
    
}




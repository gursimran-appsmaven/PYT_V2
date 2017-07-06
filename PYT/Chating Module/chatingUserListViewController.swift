//
//  chatingUserListViewController.swift
//  PYT
//
//  Created by osx on 29/06/17.
//  Copyright © 2017 osx. All rights reserved.
//

import UIKit
import MBProgressHUD

class chatingUserListViewController: UIViewController {

    
    var chatingArray = NSMutableArray()
    var locationName = NSString()
    var indexOfRow = Int()
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var chatingListTableview: UITableView!
    @IBOutlet weak var bottomShadow: GradientView!
 @IBOutlet weak var chatingIndicator: UIActivityIndicatorView!
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.setTabBarVisible(visible: false, animated: true)
        
        let uId = Udefaults .string(forKey: "userLoginId")
        
        let prmDict: NSDictionary = ["userId": uId!]
        chatingIndicator.isHidden = false
        chatingIndicator.startAnimating()
        self.postRequestGetMessages(parameterString: prmDict, viewController: self)
        
    }
    override func viewDidLoad()
    {
        
        super.viewDidLoad()

        headerLabel.text = locationName as String
        
        bottomShadow.gradientLayer.colors = [UIColor.black.withAlphaComponent(0.2).cgColor, UIColor.clear.cgColor]
        bottomShadow.gradientLayer.gradient = GradientPoint.bottomTop.draw()

        
        // Do any additional setup after loading the view.
    }

    
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    //MARk:-
    //MARK:- Data source and delegates of the tableView
    
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int
    {
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return chatingArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell:chatingNames = tableView.dequeueReusableCell(withIdentifier: "chatingListNames") as! chatingNames
        
        
        cell.userProfile.layer.cornerRadius = cell.userProfile.frame.size.width/2
        cell.userProfile.clipsToBounds = true
        cell.unreadMessagesCount.layer.cornerRadius = cell.unreadMessagesCount.frame.size.height/2
        cell.unreadMessagesCount.clipsToBounds=true
        
        
        
        let imageUrl = (((chatingArray.object(at: indexPath.row) as AnyObject).value(forKey: "with") as! NSArray).object(at: 0) as AnyObject).value(forKey: "picture") as? String ?? ""
       cell.userProfile.sd_setImage(with: URL (string: imageUrl), placeholderImage: UIImage (named: "dummyProfile2"))
        //sd_setImage(with: NSURL (string: imageUrl), placeholderImage: UIImage (named: "dummyProfile2"))
        
        
        cell.userName.text = (((chatingArray.object(at: indexPath.row) as AnyObject).value(forKey: "with") as! NSArray).object(at: 0) as AnyObject).value(forKey: "name") as? String ?? ""
        
        
        
        cell.messageLabel.text = (((chatingArray.object(at: indexPath.row) as AnyObject).value(forKey: "message") as! NSArray).object(at: 0) as AnyObject).value(forKey: "msg") as? String ?? ""
        
        
        
        
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
        
        return true
        
        
    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") {action in
            
            let LocName = (((self.chatingArray.object(at: indexPath.row) as AnyObject).value(forKey: "with") as! NSArray).object(at: 0) as AnyObject).value(forKey: "name") as? String ?? ""
            
            
            
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
        
        
        
                let user2Id = ((((chatingArray.object(at: indexPath.row) as AnyObject).value(forKey: "with") as! NSArray).object(at: 0)) as AnyObject).value(forKey: "_id") as? String ?? ""
        
        let usname = ((((chatingArray.object(at: indexPath.row) as AnyObject).value(forKey: "with") as! NSArray).object(at: 0)) as AnyObject).value(forKey: "name") as? String ?? ""
        
       
        
         let myName = Udefaults .string(forKey: "userLoginName")!
        
        
        
        var receiverProfileImage = ""
        
                if ((((chatingArray.object(at: indexPath.row) as AnyObject).value(forKey: "with") as! NSArray).object(at: 0)) as AnyObject).value(forKey: "picture") != nil
                {
            receiverProfileImage = ((((chatingArray.object(at: indexPath.row) as AnyObject).value(forKey: "with") as! NSArray).object(at: 0)) as AnyObject).value(forKey: "pucture") as? String ?? ""
                }
        
                let convId = (chatingArray.object(at: indexPath.row) as AnyObject).value(forKey: "converId") as? String ?? "" //usersChat.objectAtIndex(indexPath.row).valueForKey("converId") as? String ?? ""
        
                let locName = (chatingArray.object(at: indexPath.row) as AnyObject).value(forKey: "placeName") as? String ?? ""
               let chatLocation = (chatingArray.object(at: indexPath.row) as AnyObject).value(forKey: "placeId") as? String ?? ""
               let chatLocationType = (chatingArray.object(at: indexPath.row) as AnyObject).value(forKey: "placeType") as? String ?? ""
        
        
        
                let nxtObj = self.storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
               // nxtObj.CountTableArray = sendArray
                nxtObj.receiver_Id = user2Id as NSString
                nxtObj.locationName = locName as NSString
                nxtObj.locationType = chatLocationType as NSString
                nxtObj.receiverName = usname as NSString
                nxtObj.locationId = chatLocation as NSString
                nxtObj.convertationId = convId as NSString
                nxtObj.receiverProfile = receiverProfileImage as NSString
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
                       // print("Body: \(result)")
                        
                        let anyObj: Any = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                        
                        basicInfo = NSMutableDictionary()
                        basicInfo = anyObj as! NSMutableDictionary
                        
                        let status = basicInfo .value(forKey: "status") as! NSNumber
                        
                        
                        
                        if status == 1
                        {
                            
                            let arr: NSMutableArray = basicInfo .value(forKey: "chat") as! NSMutableArray
                            
                            var chattingListArray = NSMutableArray()
                            
                            for i in 0..<arr.count
                            {
                                chattingListArray .add(arr.object(at: i))
                            }
                          //  print(chattingListArray)
                            if arr.count<1 {
                               
                            }
                            else
                            {
                                print(self.indexOfRow)
                                let activeCounts = (chattingListArray.object(at: self.indexOfRow) as AnyObject).value(forKey: "conver") as! NSMutableArray
                                self.chatingArray = activeCounts
                            }
                            self.chatingListTableview.reloadData()
                            
                        }
                        else
                        {
                            
                            
                            CommonFunctionsClass.sharedInstance().showAlert(title: "Err ...", text: "No chats found.", imageName: "alertChat")
                            
                            
                            self.backBtnAction(self)
                            
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
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

class chatingNames: UITableViewCell {
    //chatingListNames
    
    @IBOutlet weak var userProfile: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var unreadMessagesCount: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var frwdImage: UIImageView!
    
    
    
}


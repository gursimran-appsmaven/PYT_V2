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
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var chatingListTableview: UITableView!
    @IBOutlet weak var bottomShadow: GradientView!

    
    override func viewDidLoad()
    {
        self.tabBarController?.setTabBarVisible(visible: false, animated: true)

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


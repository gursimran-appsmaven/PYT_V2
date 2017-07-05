//
//  travelPlansViewController.swift
//  PYT
//
//  Created by osx on 30/05/17.
//  Copyright © 2017 appsMaven. All rights reserved.
//

import UIKit
import MBProgressHUD


class travelPlansViewController: UIViewController {

    @IBOutlet weak var travelPlansTableView: UITableView!
    
    var plansArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        travelPlansTableView.rowHeight = 100
        
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        MBProgressHUD .showAdded(to: self.view, animated: true)
        self.getBookings()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: Back button Action
    
    @IBAction func backButtonAction(sender: AnyObject) {
        
        self.navigationController! .popViewController(animated: true)
        
    }

    
    
    
    //MARK:- TableView datasource and delgates
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return plansArray.count
    }
       
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TravelPlansListTC") as! TravelPlansListTC
        

//        print(plansArray)
//        
//        let place = (plansArray.objectAtIndex(indexPath.row) as AnyObject).value("name") as? String ?? "NA"
//        cell.travelLocation.text = place
//        
//        
//        
//        let startDate = (plansArray.objectAtIndex(indexPath.row) as AnyObject).value("startDate") as? String ?? ""
//        let endDate = plansArray.objectAtIndex(indexPath.row).valueForKey("endDate") as? String ?? ""
//        
//       
//        let dateFormatter = NSDateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
//        dateFormatter.timeZone = NSTimeZone(name: "UTC")
//        let date2 = dateFormatter.dateFromString(String(startDate))
//        let date3 = dateFormatter.dateFromString(String(endDate))// create   date from string
//     
//        // change to a readable time format and change to local time zone
//        dateFormatter.dateFormat = "MMM dd, YYYY"
//        dateFormatter.timeZone = NSTimeZone.localTimeZone()
//        var timeStamp = dateFormatter.stringFromDate(date2!)
//        var timeStamp2 = dateFormatter.stringFromDate(date3!)
//       
//        
//        let calendar = NSCalendar.autoupdatingCurrentCalendar()
//        let todayDate = NSDate()
//        
//        //let someDate = dateFormatter.dateFromString(date2)
////        if calendar.isDateInYesterday(date2!) {
////            timeStamp = "Yesterday"
////        }else
//        
//    
//        if( date2!.earlierDate(todayDate) .isEqualToDate(date2!))  {
//            print("date1 is earlier than date2")
//            timeStamp = "Plan over"
//            
//             cell.travelInfo.text = timeStamp
//            
//        }
//        else
//        {
//         cell.travelInfo.text = "\(timeStamp) - \(timeStamp2)"
//        }
       

        
        
       
        
        
        
        
        
        
//        let imageToShow = plansArray.objectAtIndex(indexPath.row).valueForKey("places")!.objectAtIndex(0).valueForKey("place")!.valueForKey("imageThumb") as? String ?? ""
//        
//        
//        let imgurl = NSURL (string: imageToShow)
//        
//        cell.travelImage.backgroundColor = UIColor .whiteColor()
//        cell.travelImage.sd_setImageWithURL(imgurl, placeholderImage: UIImage (named: "backgroundImage"))
        
        
        
     return cell
        
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
     
//        let nxtObj2 = self.storyboard?.instantiateViewControllerWithIdentifier("BookingViewController") as! BookingViewController
//        //                                    nxtObj2.arrayOfStories = self.selectedArrayCalender
//        nxtObj2.bookingIdFinal = (plansArray.objectAtIndex(indexPath.row).valueForKey("_id") as? String)!
//        
//        
//        dispatch_async(dispatch_get_main_queue(), {
//            
//            self.navigationController! .pushViewController(nxtObj2, animated: true)
//            
//            self.dismissViewControllerAnimated(true, completion: {})
//            
//            self.tabBarController?.tabBar.hidden = true
//            
//            
//        })

        
    }
    
    func tableView(tableView: UITableView, canEditRowAt indexPath: NSIndexPath) -> Bool
    {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//        if (editingStyle == UITableViewCellEditingStyle.Delete) {
//            // handle delete (by removing the data from your array and updating the tableview)
//            let bookingId = plansArray.objectAtIndex(indexPath.row).valueForKey("_id") as? String
//            deleteBooking(bookingId!,indexPath: indexPath)
//        }
    }
    
    
    
    
    
    //Mark: Function to get the booking from server
    
    func getBookings() {
        
        let defaults = UserDefaults.standard
        let uId = defaults .string(forKey: "userLoginId")
        
          let parameter: NSDictionary = ["userId": uId!]
        
        let isConnectedInternet = CommonFunctionsClass.sharedInstance().isConnectedToNetwork()
        
        if isConnectedInternet
        {
            
            
            
            let urlString = NSString(string:"\(appUrl)show_booking_history")
            
            
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
                            
                            MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                            
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
                                        if plans.count>0{
                                        
                                            self.plansArray = plans
                                            
                                            self.plansArray = NSMutableArray(array: self.plansArray.reversed())

                                            self.travelPlansTableView .reloadData()
                                            
                                            
                                        }
                                        else
                                        {
                                          CommonFunctionsClass.sharedInstance().showAlert(title: "No plans yet", text: "You haven't plan a travel yet.", imageName: "alertWrong")
                                        }
                                        
                                        
                                        
                                        
                                    }
                                    else
                                    {
                                    
                                         CommonFunctionsClass.sharedInstance().showAlert(title: "No plans yet", text: "You haven't plan a travel yet.", imageName: "alertWrong")
                                        
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
                
                MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
            }
            
            
        }
    }
    
    
    func deleteBooking(bookingId: String , indexPath: NSIndexPath)
    {
        let defaults = UserDefaults.standard
        let uId = defaults .string(forKey: "userLoginId")
        
        let parameter: NSDictionary = ["userId": uId!,"bookingId":bookingId]
        
        let isConnectedInternet = CommonFunctionsClass.sharedInstance().isConnectedToNetwork()
        
        if isConnectedInternet
        {
            
            let urlString = NSString(string:"\(appUrl)delete_booking")
            
            
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
                            
                            MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                            
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
                                        
   ////////////////////////////
                                        self.plansArray.removeObject(at: indexPath.row)
                                        self.travelPlansTableView.deleteRows(at: [indexPath as IndexPath], with: UITableViewRowAnimation.automatic)
                                        
                                        
                                    }
                                    else
                                    {
                                        
                                        CommonFunctionsClass.sharedInstance().showAlert(title: "No plans yet", text: "You haven't plan a travel yet.", imageName: "alertWrong")
                                        
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
                
                MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
            }
            
            
        }
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


class TravelPlansListTC: UITableViewCell {
    
    @IBOutlet weak var travelImage: UIImageView!
    @IBOutlet weak var travelLocation: UILabel!
    @IBOutlet weak var travelInfo: UILabel!
    @IBOutlet weak var travelDate: UILabel!
    
}


//
//  travelPlansViewController.swift
//  PYT
//
//  Created by osx on 30/05/17.
//  Copyright © 2017 appsMaven. All rights reserved.
//

import UIKit
import MBProgressHUD
import SDWebImage


class TravelPlansListVC: UIViewController {

    @IBOutlet weak var travelPlansTableView: UITableView!
    
    var plansArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        //self.tabBarController?.setTabBarVisible(visible: false, animated: true)
//        travelPlansTableView.rowHeight = 100
        
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        MBProgressHUD .showAdded(to: self.view, animated: true)
        self.getPlans()
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
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int
    {
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.plansArray.count
    }
       
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TravelPlansListTC") as! TravelPlansListTC
        

        print(plansArray)

        cell.travelLocation.text = (plansArray.object(at: indexPath.row) as AnyObject).value(forKey:"name") as? String ?? "NA"

        if (plansArray.object(at: indexPath.row) as AnyObject).value(forKey:"startDate") as? String != nil
        {
            let startDate = (plansArray.object(at: indexPath.row) as AnyObject).value(forKey:"startDate") as? String ?? ""
            let endDate = (plansArray.object(at: indexPath.row) as AnyObject).value(forKey:"endDate") as? String ?? ""
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
            let date2 = dateFormatter.date(from: String(startDate))
            let date3 = dateFormatter.date(from: String(endDate))// create   date from string
            
            // change to a readable time format and change to local time zone
            dateFormatter.dateFormat = "E, d MMM yyyy"
            dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
            let timeStamp = dateFormatter.string(from: date2!)
            let timeStamp2 = dateFormatter.string(from: date3!)
            
            cell.travelDate.text = "\(timeStamp) - \(timeStamp2)"
        }
        else
        {
             cell.travelDate.text = "NA"
        }
        
       
        var locations = String()
        
        for item in ((plansArray.object(at: indexPath.row) as AnyObject).value(forKey:"places") as? NSArray)!
        {
            if let loc = (((((item as AnyObject).value(forKey: "place") as AnyObject).value(forKey: "placeTag")) as? String) )
            {
                locations = locations + loc + ", "
            }
        }
        
        locations = String(locations.characters.dropLast(2))
        
        cell.travelInfo.text = locations
       
        
        
        
        
        
        
//        let imageToShow = plansArray.objectAtIndex(indexPath.row).valueForKey("places")!.objectAtIndex(0).valueForKey("place")!.valueForKey("imageThumb") as? String ?? ""
//        
//        
//        let imgurl = NSURL (string: "")
        
        cell.travelImage.backgroundColor = UIColor .white
        cell.travelImage.sd_setImage(with: URL(string: ""), placeholderImage: UIImage (named: "dummyBackground1"), options: SDWebImageOptions(rawValue: 0), completed: nil)
        
        
     return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
     
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "FinalTravelPlanVC") as! FinalTravelPlanVC
        obj.countryId = (plansArray.object(at: indexPath.row) as AnyObject).value(forKey:"countryId") as! String
        obj.backBool = true
        obj.bookingIdFinal = (plansArray.object(at: indexPath.row) as AnyObject).value(forKey:"_id") as! String

        self.navigationController! .pushViewController(obj, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: NSIndexPath) -> Bool
    {
        return true
    }
    
    func tableView(_ tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            let bookingId = (plansArray.object(at: indexPath.row) as AnyObject).value(forKey:"_id") as! String
            deleteBooking(bookingId: bookingId,indexPath: indexPath)
        }
    }
    
    
    
    
    
    //Mark: Function to get the booking from server
    
    func getPlans() {
        
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
                                    CommonFunctionsClass.sharedInstance().showAlert(title: "Server Alert", text: "Something doesn't seem right, Please try again!", imageName: "exclamationAlert")
                                    
                                    
                                    
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
                                        DispatchQueue.global(qos: .background).async {
                                            
                                            let uId = Udefaults .string(forKey: "userLoginId")
                                            let objt = storyCountClass()
                                            
                                            let dic:NSDictionary = ["userId": uId!]
                                            objt.postRequestForcountStory(parameterString: dic)
                                            objt.postRequestForcountStoryandBucket(dic)
                                            
                                        }

                                        
                                        self.plansArray.removeObject(at: indexPath.row)
                                        self.travelPlansTableView.deleteRows(at: [indexPath as IndexPath], with: UITableViewRowAnimation.automatic)
                                        
                                        
                                    }
                                    else
                                    {
                                        
                                        CommonFunctionsClass.sharedInstance().showAlert(title: "No plans yet", text: "You haven't plan a travel yet.", imageName: "exclamationAlert")
                                        
                                    }
                                    
                                    
                                    
                                    
                                } catch
                                {
                                    print("json error: \(error)")
                                    CommonFunctionsClass.sharedInstance().showAlert(title: "Server Alert", text: "Something doesn't seem right, Please try again!", imageName: "exclamationAlert")
                                    
                                    
                                    
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


//
//  FinalTravelPlanVC.swift
//  PYT
//
//  Created by osx on 06/07/17.
//  Copyright © 2017 osx. All rights reserved.
//

import UIKit
import SDWebImage
import MBProgressHUD

class FinalTravelPlanVC: UIViewController {

    var countryId = String()
    var locationsArray = NSMutableArray()
    @IBOutlet weak var topGradient: GradientView!
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var topScrollingImg: UIImageView!
    @IBOutlet weak var topDateWindowLbl: UILabel!
    @IBOutlet weak var topNameLbl: UILabel!
    
    var planSelctedLocations = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK: Back button Action
    
    @IBAction func backButtonAction(sender: AnyObject) {
        
        self.navigationController! .popViewController(animated: true)
        
    }
    
    @IBAction func MapBtnAction(_ sender: Any) {
    }
    
    @IBAction func EditFinalPlanBtnACtion(_ sender: Any) {
    }
    
    
    //MARK:- TableView datasource and delgates
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int
    {
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.locationsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TravelPlansListTC") as! TravelPlansListTC
        
        
//        print(locationsArray)
//        
//        cell.travelLocation.text = (locationsArray.object(at: indexPath.row) as AnyObject).value(forKey:"name") as? String ?? "NA"
//        
//        if (locationsArray.object(at: indexPath.row) as AnyObject).value(forKey:"startDate") as? String != nil
//        {
//            let startDate = (locationsArray.object(at: indexPath.row) as AnyObject).value(forKey:"startDate") as? String ?? ""
//            let endDate = (locationsArray.object(at: indexPath.row) as AnyObject).value(forKey:"endDate") as? String ?? ""
//            
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
//            dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
//            let date2 = dateFormatter.date(from: String(startDate))
//            let date3 = dateFormatter.date(from: String(endDate))// create   date from string
//            
//            // change to a readable time format and change to local time zone
//            dateFormatter.dateFormat = "E, d MMM yyyy"
//            dateFormatter.timeZone = NSTimeZone.local
//            let timeStamp = dateFormatter.string(from: date2!)
//            let timeStamp2 = dateFormatter.string(from: date3!)
//            
//            cell.travelDate.text = "\(timeStamp) - \(timeStamp2)"
//        }
//        else
//        {
//            cell.travelDate.text = "NA"
//        }
//        
//        
//        var locations = String()
//        
//        for item in ((locationsArray.object(at: indexPath.row) as AnyObject).value(forKey:"places") as? NSArray)!
//        {
//            if let loc = (((((item as AnyObject).value(forKey: "place") as AnyObject).value(forKey: "placeTag")) as? String) )
//            {
//                locations = locations + loc + ", "
//            }
//        }
//        
//        locations = String(locations.characters.dropLast())
//        
//        cell.travelInfo.text = locations
//        
//        
//        
//        
//        
//        
//        
//        //        let imageToShow = plansArray.objectAtIndex(indexPath.row).valueForKey("places")!.objectAtIndex(0).valueForKey("place")!.valueForKey("imageThumb") as? String ?? ""
//        //
//        //
//        //        let imgurl = NSURL (string: "")
//        
//        cell.travelImage.backgroundColor = UIColor .white
//        cell.travelImage.sd_setImage(with: URL(string: ""), placeholderImage: UIImage (named: "dummyBackground1"), options: SDWebImageOptions(rawValue: 0), completed: nil)
//        
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        
    }

    //MARK: API Methods
    
//    func getPlanDetails() {
//        
//        let defaults = UserDefaults.standard
//        let uId = defaults .string(forKey: "userLoginId")
//        
//        let parameter: NSDictionary = ["userId": uId! ,"countryId":countryId]
//        
//        let isConnectedInternet = CommonFunctionsClass.sharedInstance().isConnectedToNetwork()
//        
//        if isConnectedInternet
//        {
//            
//            
//            
//            let urlString = NSString(string:"\(appUrl)get_booking_detail_V3")
//            
//            
//            let isConnectedInternet = CommonFunctionsClass.sharedInstance().isConnectedToNetwork()
//            
//            if isConnectedInternet
//            {
//                
//                var urlString = NSString(string:"\(urlString)")
//                print("WS URL----->>" + (urlString as String))
//                
//                urlString = urlString .replacingOccurrences(of: " ", with: "%20") as NSString
//                
//                let url:NSURL = NSURL(string: urlString as String)!
//                let session = URLSession.shared
//                session.configuration.timeoutIntervalForRequest=20
//                
//                
//                
//                
//                
//                let request = NSMutableURLRequest(url: url as URL)
//                request.httpMethod = "POST"
//                request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
//                
//                
//                do {
//                    let jsonData = try!  JSONSerialization.data(withJSONObject: parameter, options: [])
//                    request.httpBody = jsonData
//                    
//                    
//                    // here "jsonData" is the dictionary encoded in JSON data
//                } catch let error as NSError {
//                    print(error)
//                }
//                
//                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//                request.addValue("application/json", forHTTPHeaderField: "Accept")
//                
//                
//                
//                
//                
//                let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
//                    
//                    OperationQueue.main.addOperation
//                        {
//                            
//                            //                            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
//                            
//                            if data == nil
//                            {
//                                print("server not responding")
//                                
//                                
//                            }
//                            else
//                            {
//                                
//                                
//                                do {
//                                    
//                                    let result = NSString(data: data!, encoding:String.Encoding.ascii.rawValue)!
//                                    print("Body: \(result)")
//                                    
//                                    let anyObj: Any = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
//                                    
//                                    
//                                    
//                                    basicInfo=NSMutableDictionary()
//                                    basicInfo=anyObj as! NSMutableDictionary
//                                    
//                                    let success = basicInfo.object(forKey: "status") as! NSNumber
//                                    
//                                    if success == 1{
//                                        
//                                        let plans = basicInfo.value(forKey: "data") as! NSMutableArray
//                                        self.planSelctedLocations = basicInfo.value(forKey: "dateVise") as! NSMutableArray
//                                        
//                                        let sortedArray = self.planSelctedLocations.sorted{ (($0 as! Dictionary<String, AnyObject>)["date"] as? String)! < (($1 as! Dictionary<String, AnyObject>)["date"] as? String)! }
//                                        
//                                        self.planSelctedLocations.removeAllObjects()
//                                        
//                                        for item in sortedArray
//                                        {
//                                            self.planSelctedLocations.add(item)
//                                        }
//                                        
//                                        self.planDetails=plans
//                                        
//                                        self.bookingIdFinal = (self.planDetails.object(at: 0) as AnyObject).value(forKey: "_id") as! String
//                                        
//                                        if (self.planDetails.object(at: 0) as AnyObject).value(forKey: "startDate") as? String != nil
//                                        {
//                                            self.setUpCalendarStartAndEndDate()
//                                            self.calendarBackView.isHidden = true
//                                        }
//                                        else
//                                        {
//                                            self.setUpCalendarSelection()
//                                            self.calendarBackView.isHidden = false
//                                            self.boolEdit = false
//                                        }
//                                        if plans.count>0{
//                                            
//                                            let placesArr = ((plans.object(at: 0) as AnyObject).value(forKey: "places") as AnyObject) as! NSArray
//                                            print(placesArr)
//                                            for i in 0..<placesArr.count {
//                                                
//                                                self.planAllLocations.add(placesArr[i])
//                                            }
//                                            
//                                            let attrs1 = [NSFontAttributeName: UIFont(name: "SFUIDisplay-Bold", size: 11.0) , NSForegroundColorAttributeName : UIColor(red: 20/255.0, green: 44/255.0, blue: 69/255.0, alpha: 1.0)]
//                                            
//                                            let attrs2 = [NSFontAttributeName: UIFont(name: "SFUIDisplay-Regular", size: 11.0), NSForegroundColorAttributeName : UIColor(red: 20/255.0, green: 44/255.0, blue: 69/255.0, alpha: 1.0)]
//                                            
//                                            let attributedString1 = NSMutableAttributedString(string:"\(self.planAllLocations.count) ", attributes:attrs1)
//                                            
//                                            let attributedString2 = NSMutableAttributedString(string:"Locations", attributes:attrs2)
//                                            
//                                            attributedString1.append(attributedString2)
//                                            
//                                            self.noOfLocations.attributedText = attributedString1
//                                            
//                                            DispatchQueue.main.async(execute: {
//                                                if(self.reloadTableOnly)
//                                                {
//                                                    self.plansTableView.reloadData()
//                                                }
//                                                else
//                                                {
//                                                    self.plansTableView.reloadData()
//                                                    self.locationsCollectionView.reloadData()
//                                                }
//                                                
//                                            })
//                                        }
//                                        else
//                                        {
//                                            CommonFunctionsClass.sharedInstance().showAlert(title: "No plans yet", text: "You haven't plan a travel yet.", imageName: "alertWrong")
//                                        }
//                                        
//                                        
//                                        
//                                        
//                                    }
//                                    else
//                                    {
//                                        
//                                        CommonFunctionsClass.sharedInstance().showAlert(title: "No plans yet", text: "You haven't plan a travel yet.", imageName: "alertWrong")
//                                        
//                                    }
//                                    
//                                    
//                                    
//                                    
//                                    
//                                } catch
//                                {
//                                    print("json error: \(error)")
//                                    CommonFunctionsClass.sharedInstance().showAlert(title: "Server Alert", text: "Something doesn't seem right, Please try again!", imageName: "alertServer")
//                                    
//                                    
//                                    
//                                }
//                                
//                                
//                                
//                                
//                                
//                                
//                                
//                            }
//                    }
//                })
//                
//                task.resume()
//            }
//            else
//            {
//                CommonFunctionsClass.sharedInstance().showAlert(title: "No Internet Connection", text: "You are currently offline.", imageName: "alertInternet")
//                
//                //                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
//            }
//            
//            
//        }
//    }

}
class  FinalTravelPLanCell: UITableViewCell {
    @IBOutlet weak var locDateLbl: UILabel!
    @IBOutlet weak var locNameLbl: UILabel!
    @IBOutlet weak var editLocDateBtn: UIButton!
    @IBOutlet weak var bookLocBtn: UIButton!
    @IBOutlet weak var locDescriptionLbl: UILabel!
    @IBOutlet weak var locDescriptionDropDown: UIButton!
    @IBOutlet weak var locImage: UIImageView!
    
}

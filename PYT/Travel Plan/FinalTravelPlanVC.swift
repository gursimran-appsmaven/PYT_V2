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
    var bookingIdFinal = String()

    var locationsArray = NSMutableArray()
    @IBOutlet weak var topGradient: GradientView!
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var topScrollingImg: UIImageView!
    @IBOutlet weak var topDateWindowLbl: UILabel!
    @IBOutlet weak var topNameLbl: UILabel!
    
    @IBOutlet weak var topY: NSLayoutConstraint!
    var planDetails = NSMutableArray()
    var timer = Timer()
    
    @IBOutlet weak var locationsTableView: UITableView!
    var imgCount:  Int! = 0
    
    var topVisible = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.topVisible = true
        topGradient.gradientLayer.colors = [UIColor.black.withAlphaComponent(0.75).cgColor, UIColor.clear.cgColor]
        topGradient.gradientLayer.gradient = GradientPoint.bottomTop.draw()

        timer = Timer.scheduledTimer(timeInterval: 5.4, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        getPlanDetails()
    }
    override func viewDidDisappear(_ animated: Bool) {
        timer.invalidate()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.125:52
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(scrollView.contentOffset.y > 10 )
        {
            if(topVisible)
            {
                UIView.animate(withDuration: 0.8, animations: {
                    self.topY.constant =  -self.view.frame.width * 52/125
                    self.topVisible = false
                    self.view.layoutIfNeeded()
                })

            }
        }
        else if(scrollView.contentOffset.y < 10)
        {
            if(!topVisible)
            {
                UIView.animate(withDuration: 0.8, animations: {
                    self.topY.constant =  0
                    self.topVisible = true
                    self.view.layoutIfNeeded()
                })
            }
        }
    }

    func changeImage()
    {
        if(locationsArray.count == 0)
        {
            return
        }
        if(imgCount < locationsArray.count - 1)
        {
            imgCount = imgCount+1
        }
        else
        {
            imgCount = 0
        }
        let imageToShow = ((locationsArray.object(at: imgCount) as AnyObject).value(forKey:"place") as AnyObject).value(forKey: "imageLarge") as? String ?? ""

        topScrollingImg.sd_setImage(with: URL(string: imageToShow), placeholderImage: UIImage (named: "dummyBackground1"), options: SDWebImageOptions(rawValue: 0), completed: nil)
    }
    //MARK: Back button Action
    
    @IBAction func backButtonAction(sender: AnyObject) {
        
        self.navigationController! .popViewController(animated: true)
        
    }
    
    @IBAction func MapBtnAction(_ sender: Any) {
    }
    
    @IBAction func EditFinalPlanBtnACtion(_ sender: Any) {
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "TravelPlanVC") as! TravelPlanVC
        obj.fromFinalScreen = true
        obj.change = "planWindow"
        obj.countryId = ((self.planDetails.object(at: 0) as AnyObject).value(forKey: "countryId") as? String)!
        obj.bookingIdFinal = ((self.planDetails.object(at: 0) as AnyObject).value(forKey: "_id") as? String)!
        self.navigationController?.pushViewController(obj, animated: true)
        
    }
    
    func editLocationDate(sender: UIButton)
    {
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "TravelPlanVC") as! TravelPlanVC
        obj.fromFinalScreen = true
        obj.change = "locationDate"
        obj.countryId = ((self.planDetails.object(at: 0) as AnyObject).value(forKey: "countryId") as? String)!
        obj.bookingIdFinal = ((self.planDetails.object(at: 0) as AnyObject).value(forKey: "_id") as? String)!
        obj.previousDateForLocation = ((locationsArray.object(at: sender.tag) as AnyObject).value(forKey:"time")  as? String )!
        obj.placeBookingId = (((locationsArray.object(at: sender.tag) as AnyObject).value(forKey:"place") as AnyObject).value(forKey: "_id") as? String)!
        
        self.navigationController?.pushViewController(obj, animated: true)
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
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FinalTravelPLanCell") as! FinalTravelPLanCell
        
//        @IBOutlet weak var editLocDateBtn: UIButton!
//        @IBOutlet weak var bookLocBtn: UIButton!
//        @IBOutlet weak var locDescriptionLbl: UILabel!
//        @IBOutlet weak var locDescriptionDropDown: UIButton!

        var name = ((locationsArray.object(at: indexPath.row) as AnyObject).value(forKey:"place") as AnyObject).value(forKey: "placeTag") as? String ?? ""
        if !(name=="")
        {
            name = name + ", "
        }
        name = name + (((locationsArray.object(at: indexPath.row) as AnyObject).value(forKey:"place") as AnyObject).value(forKey: "city") as? String ?? "")
        
        cell.locNameLbl.text = name
        
        if (locationsArray.object(at: indexPath.row) as AnyObject).value(forKey:"time")  as? String != nil
        {
            let dat = (locationsArray.object(at: indexPath.row) as AnyObject).value(forKey:"time")  as? String ?? ""
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
            let date2 = dateFormatter.date(from: String(dat))
            
            // change to a readable time format and change to local time zone
            dateFormatter.dateFormat = "E, d MMM yyyy"
            dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
            let timeStamp = dateFormatter.string(from: date2!)
            
            cell.locDateLbl.text = "\(timeStamp)"
        }
        else
        {
            cell.locDateLbl.text = "NA"
        }
        
        let imageToShow = ((locationsArray.object(at: indexPath.row) as AnyObject).value(forKey:"place") as AnyObject).value(forKey: "imageLarge") as? String ?? ""
        
        cell.locImage.backgroundColor = UIColor .white
        cell.locImage.sd_setImage(with: URL(string: imageToShow), placeholderImage: UIImage (named: "dummyBackground1"), options: SDWebImageOptions(rawValue: 0), completed: nil)
        
        cell.editLocDateBtn.tag = indexPath.row
        cell.editLocDateBtn.addTarget(self, action: #selector(editLocationDate), for: .touchUpInside)
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        
    }

    //MARK: API Methods
    
    func getPlanDetails() {
        
        let defaults = UserDefaults.standard
        let uId = defaults .string(forKey: "userLoginId")
        
        let parameter: NSDictionary = ["userId": uId! ,"bookingId":bookingIdFinal]
        
        let isConnectedInternet = CommonFunctionsClass.sharedInstance().isConnectedToNetwork()
        
        if isConnectedInternet
        {
            
            
            let urlString = NSString(string:"\(appUrl)get_final_booking_schedule")
            
            
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
                                       
                                        if plans.count>0{
                                            
                                            self.planDetails=plans
                                            
                                            self.locationsArray.removeAllObjects()
                                            
                                            self.locationsArray = ((self.planDetails.object(at: 0) as AnyObject).value(forKey: "places") as? NSMutableArray)!
                                            
                                            if (self.planDetails.object(at: 0) as AnyObject).value(forKey: "startDate") as? String != nil
                                            {
                                                let dateFormatter = DateFormatter()
                                                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                                                dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
                                                
                                                
                                                let startDate = (dateFormatter.date(from: String(describing: ((self.planDetails.object(at: 0) ) as AnyObject).value(forKey: "startDate") as! String)))!
                                                
                                                let endDate = (dateFormatter.date(from: String(describing: ((self.planDetails.object(at: 0) ) as AnyObject).value(forKey: "endDate") as! String)))!
                                                
                                                // change to a readable time format and change to local time zone
                                                dateFormatter.dateFormat = "E, d MMM yyyy"
                                                dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
                                                let timeStamp1 = dateFormatter.string(from: startDate)
                                                let timeStamp2 = dateFormatter.string(from: endDate)
                                                
                                                self.topDateWindowLbl.text = "\(timeStamp1) - \(timeStamp2)"
                                                
                                            }
                                            else
                                            {
                                                self.topDateWindowLbl.text = "NA"
                                            }
                                           
                                            self.topNameLbl.text = ((plans.object(at: 0) as AnyObject).value(forKey: "name") as AnyObject) as? String ?? ""
                                            
                                                                                    
                                            DispatchQueue.main.async(execute: {
                                                self.locationsTableView.reloadData()
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

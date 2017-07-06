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

    var locationsArray = NSMutableArray()
    @IBOutlet weak var topGradient: GradientView!
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var topScrollingImg: UIImageView!
    @IBOutlet weak var topDateWindowLbl: UILabel!
    @IBOutlet weak var topNameLbl: UILabel!
    
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

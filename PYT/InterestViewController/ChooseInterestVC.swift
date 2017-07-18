//
//  ChooseInterestVC.swift
//  PYT
//
//  Created by osx on 22/06/17.
//  Copyright © 2017 osx. All rights reserved.
//

import UIKit
import SDWebImage
import MBProgressHUD

class ChooseInterestVC: UIViewController , UICollectionViewDelegate,UICollectionViewDataSource{

    var comingFrom = NSString()
    var postArray = NSMutableArray()
    
    var categId = NSMutableArray()
    var tagsArr:NSMutableArray = [] //
    var checked = NSMutableArray()
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
       self.tabBarController?.setTabBarVisible(visible: false, animated: true)
        
        
        let defaults=UserDefaults.standard
        
        checked = defaults.mutableArrayValue(forKey: "Interests")
        categId = defaults.mutableArrayValue(forKey: "IntrestsId")
        tagsArr = defaults.mutableArrayValue(forKey: "categoriesFromWeb") //all category
        //defaults .setValue(nil, forKey: "Interests")
        postArray = defaults.mutableArrayValue(forKey: "PostInterest")
        
        
        if checked.count<1 {
            
            if tagsArr.count<1 {
                let defaults = UserDefaults.standard
                let uId = defaults .string(forKey: "userLoginId")
                
                apiClass.sharedInstance().postRequestCategories(parameterString: uId!)
                
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(2 * NSEC_PER_SEC)) / Double(NSEC_PER_SEC), execute: {() -> Void in
                    self.categoryCollectionView.reloadData()
                    
                })
                
                //if not then login from facebook
                
                
            }
            else{
//                self.categoryBtnAction(self)
            }
        }
            
        else{
            
//                DispatchQueue.main.async(execute: {
//                    
//                    let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
//                    loadingNotification.mode = MBProgressHUDMode.indeterminate
//                    loadingNotification.label.text = "Fetching Feeds"
//                    
//                    //hit api to get the data from the web
//                    
//                    
//                    let strarr2 = NSMutableArray()
//                    strarr2 .add(self.categId .object(at: 0))
//                    
//                    
//                    let type = UserDefaults.standard.value(forKey: "selectedLocationType") as? String ?? ""
//                    
//                    let defaults = UserDefaults.standard
//                    let uId = defaults .string(forKey: "userLoginId")
//                       self.interestCase=true
//                    
//                    
//                    let headerId = UserDefaults.standard.value(forKey: "selectedLocationId") as? String ?? ""
//                    
//                    //hit the api for shorted interests from web
//                    
//                    
//                    let parameterDict: NSMutableDictionary = ["userId": uId!, "placeId": headerId, "placeType": type, "category": strarr2, "skip": 0 ]
//                    print(parameterDict)
//                    
//                    
//                    
//                    
//                    apiClassInterest.sharedInstance().postRequestInterestWiseData(parameterDict, viewController: self)
//                    
////                    self.segMentManage()
//                    
//                })
            }
    }

    
    
    
    //MARK: Actions of button
    
    
    @IBAction func doneButton(_ sender: Any)
    {
        
        if comingFrom == "Post Screen" {
             Udefaults .setValue(postArray, forKey: "PostInterest")
            self.navigationController?.popViewController(animated: true)
        }
        else if(comingFrom == "Profile"){
            Udefaults .setValue(checked, forKey: "Interests")
            Udefaults .setValue(categId, forKey: "IntrestsId")
             Udefaults.set(true, forKey: "refreshInterest")
            self.navigationController?.popViewController(animated: true)
        }
        else
        {
        if checked.count<1
        {
            
            
            
            CommonFunctionsClass.sharedInstance().showAlert(title: "Fill required fields", text: "Please select minimum one interest.", imageName: "oopsAlert")
            
        }
        else
        {
        Udefaults .setValue(checked, forKey: "Interests")
        Udefaults .setValue(categId, forKey: "IntrestsId")
          Udefaults.set(true, forKey: "refreshInterest")

         self.navigationController?.popViewController(animated: true)
    }
            
            
        }
        
    }
    
    
    @IBAction func closeButton(_ sender: Any)
    {
        
        if comingFrom == "Post Screen" {
            //Udefaults .setValue(postArray, forKey: "PostInterest")
            self.navigationController?.popViewController(animated: true)
        }
        else if(comingFrom == "Profile")
        {
            self.navigationController?.popViewController(animated: true)
        }
        else
        {
        
    if checked.count<1
    {
        CommonFunctionsClass.sharedInstance().showAlert(title: "Opps!", text: "Please select minimum one interest.", imageName: "exclamationAlert")
        
        }
    else{
        self.navigationController?.popViewController(animated: true)
        }
        }
        
    }
    
    
    
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int   {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView,numberOfItemsInSection section: Int) -> Int
    {
        
        return tagsArr.count
    }
    
    
    // MARK: UICollectionViewDelegateFlowLayout
    //MARK:
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        
        
        let width1 = collectionView.frame.size.width/3  - 1
        
        let height3 : CGFloat = collectionView.frame.size.width/3 * 0.83
        
        
        return CGSize(width: width1 , height: height3) // The size of one cell
        
    }

    
    
    func collectionView(_ collectionView: UICollectionView,cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "chooseInterestCell", for: indexPath) as! chooseInterestCell

        //print(tagsArr)
        cell.interestName.text = (tagsArr .object(at: indexPath.row) as AnyObject).value(forKey: "displayName") as? String
       
         let catId = (tagsArr .object(at: indexPath.row) as AnyObject).value(forKey: "_id") as! String
        
        if comingFrom == "Post Screen"
        {
            if postArray.count>0
            {
                let parr = postArray.value(forKey: "_id") as! NSArray
                
                if parr.contains(catId)
                {
                    cell.interestImg.image=self.setCategoryImage(catId as NSString , active: true)
                    cell.interestName.textColor = UIColor(red: 255/255.0, green: 80/255.0, blue: 80/255.0, alpha: 1.0)
                }
                else
                {
                    cell.interestImg.image = self.setCategoryImage(catId as NSString , active: false)
                    cell.interestName.textColor = UIColor(red: 85/255.0, green: 85/255.0, blue: 85/255.0, alpha: 1.0)
                }
                
            }
            else
            {
                cell.interestImg.image = self.setCategoryImage(catId as NSString , active: false)
                cell.interestName.textColor = UIColor(red: 85/255.0, green: 85/255.0, blue: 85/255.0, alpha: 1.0)
            }
        }
            
            //from interest Screen
        else
        {
        
        if categId .contains((tagsArr .object(at: indexPath.row) as AnyObject).value(forKey: "_id") as! String)
        {
            
            cell.interestImg.image=self.setCategoryImage(catId as NSString , active: true)
            cell.interestName.textColor = UIColor(red: 255/255.0, green: 80/255.0, blue: 80/255.0, alpha: 1.0)
        }
        else
        {
            cell.interestImg.image = self.setCategoryImage(catId as NSString , active: false)
            cell.interestName.textColor = UIColor(red: 85/255.0, green: 85/255.0, blue: 85/255.0, alpha: 1.0)

        }
        }
        
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
        if comingFrom == "Post Screen"
        {
            let parr = postArray.value(forKey: "_id") as! NSArray
            
            if parr .contains((tagsArr .object(at: indexPath.row) as AnyObject).value(forKey: "_id") as! String)
            {
                let indx = parr .index(of: (tagsArr .object(at: indexPath.row) as AnyObject).value(forKey: "_id") as! String)
                
                
                postArray .removeObject(at: indx)
            }
            else
            {
                if postArray.count == 3 {
                     CommonFunctionsClass.sharedInstance().showAlert(title: "Interests limit exceeded!", text: "You can select only up to 3 interests at once.", imageName: "exclamationAlert")
                }
                else
                {
                    
                let objId = ((tagsArr .object(at: indexPath.row) as AnyObject).value(forKey: "_id") as? String ?? "")
                let objectInt = ((tagsArr .object(at: indexPath.row) as AnyObject).value(forKey: "displayName") as? String)
                postArray .add(["displayName": objectInt, "_id": objId])
                print(postArray)
                }
            }
            
            
            
        }
        //interest screen
        else
        {
        
        if categId .contains((tagsArr .object(at: indexPath.row) as AnyObject).value(forKey: "_id") as! String)
        {
            
            let objId = ((tagsArr .object(at: indexPath.row) as AnyObject).value(forKey: "_id") as? String ?? "")
            
            let objectInt = ((tagsArr .object(at: indexPath.row) as AnyObject).value(forKey: "displayName") as? String)
            checked .remove(objectInt!)
            categId .remove(objId)
            
            
            
        } else
        {
            //                let object = tagsArr .objectAtIndex(indexPath.row).valueForKey("name") as? String ?? ""
            //                checked .addObject(object)
            
           // print(tagsArr .object(at: indexPath.row))
            
            let objId = ((tagsArr .object(at: indexPath.row) as AnyObject).value(forKey: "_id") as? String ?? "")
            let objectInt = ((tagsArr .object(at: indexPath.row) as AnyObject).value(forKey: "displayName") as? String)
            checked .add(objectInt!)
            categId .add(objId)
            
            
        }
        }
        
        categoryCollectionView.reloadData()

        
        
    }

    
    func setCategoryImage(_ categoryIds: NSString , active: Bool) -> UIImage {
        
        var catimage = UIImage()
        
        var nameString = String()
        
        switch categoryIds {
            
        case "58de647dbb35ba786a4788cd": //FoodANDWine
            nameString = "foodwine"
            break
            
        case "58de647dbb35ba786a4788ce": //CityLife
            nameString = "citylife"
            break
            
        case "58de647dbb35ba786a4788cf": //Nightlife ent.
            nameString = "Night"
            break
            
        case "58de647dbb35ba786a4788d0": //history art
            nameString = "adventure" //////////////////////////to be changed
            break
        case "58de647dbb35ba786a4788d1": //nature
            nameString = "nature"
            break
            
        case "58de647dbb35ba786a4788d2": //Mountains
            nameString = "Mountains"
            break
            
        case "58de647dbb35ba786a4788d3": //Beaches
            nameString = "Beaches"
            break
            
        case "58de647dbb35ba786a4788d4": //Lakes Rivers
            nameString = "Lake"
            break
            
        case "58de647dbb35ba786a4788d5": //Wild Life
            nameString = "wildlife"
            break
            
        case "58de647dbb35ba786a4788d6": //Deserts
            nameString = "Desert"
            break
            
        case "58de647dbb35ba786a4788d7": //road trips
            nameString = "Roadtrips"
            break
            
        case "58de647ebb35ba786a4788d8": //crusies
            nameString = "Curise"
            break
            
        case "58de647ebb35ba786a4788d9": // Sports
            nameString = "Sports"
            break
            
        case "58de647ebb35ba786a4788da": //Hotel Wellness
            nameString = "hotelandspa"
            break
            
        case "58de647ebb35ba786a4788db": //Retail therapy
            nameString = "Retail"
            break
            
        case "58de647ebb35ba786a4788dc": //Kids friendly
            nameString = "kids"
            break
            
        default: //other
            nameString = "other"
            break
            
        }
        nameString = active ? nameString+"a" : nameString
        catimage = UIImage(named: nameString)!
        return catimage
        
    }

}

class chooseInterestCell: UICollectionViewCell
{
    @IBOutlet weak var interestName: UILabel!
    @IBOutlet weak var interestImg: UIImageView!

}

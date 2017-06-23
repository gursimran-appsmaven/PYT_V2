//
//  intrestViewController.swift
//  PYT
//
//  Created by Niteesh on 04/11/16.
//  Copyright © 2016 appsMaven. All rights reserved.
//

import UIKit
import HMSegmentedControl
import SDWebImage
import MBProgressHUD

class intrestViewController: UIViewController, apiClassInterestDelegate ,UITableViewDataSource,UITableViewDelegate {

//class intrestViewController: UIViewController {


    //apiClassDelegate
    
    //top views
    @IBOutlet var headerLabel: UILabel!
    @IBOutlet var segmentControl: HMSegmentedControl!
    @IBOutlet var tableOfIntrests: UITableView!
    
    
    
   
    @IBOutlet weak var emptyView: UIView!
    
    
    
    //Data Arrays
    var imageOfCatgory = UIImage()
    var selectedLocation = NSString()
    var photosArray = NSMutableArray()
    var categorySelected = NSString()
    var appearBool = Bool() // For select category view
    //var locationarray = NSMutableArray()
    var categoryArray = NSMutableArray()
    var multiplePhotosArray = NSMutableArray()
    var  longTapedView = UIView()
    var allCategoryDictionary = NSMutableDictionary()
    var indexCount = NSMutableArray()
    var showMore = Int()
    
    
    
    
    
    var categId = NSMutableArray()
    var interestCase = Bool()
    
    
    //POPUP views for categories
    @IBOutlet var categorytableView: UITableView!
    var tagsArr:NSMutableArray = [] //
    var checked = NSMutableArray()
    var index1 = Int()
    var index2 = Int()
    
    
    
    @IBOutlet var bucketOutlet: UIButton!
    @IBOutlet var bucketCount: UILabel!
    @IBOutlet var storyCountLabel: UILabel!
    var storyBucketBool = Bool()
    
    @IBOutlet weak var addToBucketLblInPopup: UILabel!
    
    
    
    
    /////-----pop up view
    
    @IBOutlet var popUpView: UIView!
    
    @IBOutlet var addToStory: UIImageView!
    @IBOutlet var likeImage: UIImageView!
    @IBOutlet var addToBucket: UIImageView!
    @IBOutlet var addStoryLabelInPopup: UILabel!
    @IBOutlet var likeLabel: UILabel!
    
    @IBOutlet weak var deleteImage: UIImageView!
    @IBOutlet weak var deleteViewInDetail: UIView!
    @IBOutlet var deleteViewBottom: NSLayoutConstraint!
    // var recognizer = UISwipeGestureRecognizer()
    
    
    
    var likeCount = NSMutableArray() //Array to temporary save the likes
    
    @IBAction func chooseInterestAction(_ sender: AnyObject) {
    
        let nxtObj = self.storyboard?.instantiateViewController(withIdentifier: "ChooseInterestVC") as! ChooseInterestVC
        
        //DispatchQueue.main.async(execute: {
            self.navigationController! .pushViewController(nxtObj, animated: true)
            self.dismiss(animated: true, completion: {})
        //})
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.tabBarController?.tabBar.isHidden = false
        
        
        //self.emptyView.hidden=false
        
        apiClassInterest.sharedInstance().delegate=self
        
        
       
        let firstLaunch = Udefaults.bool(forKey: "refreshInterest")
        
        if firstLaunch {
            print("refresh")
            
            
            Udefaults.set(false, forKey: "refreshInterest")
            Udefaults.synchronize()
            
            
            photosArray .removeAllObjects()
            multiplePhotosArray .removeAllObjects()
            tableOfIntrests .reloadData()
            allCategoryDictionary = NSMutableDictionary()
            
            //Header Text
            let headerText = UserDefaults.standard.value(forKey: "selectedLocation") as? String ?? ""
            
            
            
            
           
            
             //apiClass.sharedInstance().delegate=self //delegate for response api
            
            
            
            
            let name = Udefaults.string(forKey: "userLoginId")
            if name==nil
            {
                // print("DONE")
                
                self.tabBarController?.tabBar.isHidden = true
                
                let nxtObj = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                
                DispatchQueue.main.async(execute: {
                    self.navigationController! .pushViewController(nxtObj, animated: true)
                    self.dismiss(animated: true, completion: {})
                })
                
                
                
                
            }
                //if user is logged in
            else
            {
                
                self.tabBarController?.tabBar.isHidden = false
                
                /////////-------- already selected categories ------/////////
                checked = Udefaults.mutableArrayValue(forKey: "Interests")
                categId = Udefaults.mutableArrayValue(forKey: "IntrestsId")
                
                tagsArr = Udefaults.mutableArrayValue(forKey: "categoriesFromWeb")
                //defaults .setValue(nil, forKey: "Interests")
                
                if checked.count<1 {
                    
                    
                    
                    if tagsArr.count<1 {
                        let defaults = UserDefaults.standard
                        let uId = defaults .string(forKey: "userLoginId")
                        
                        apiClass.sharedInstance().postRequestCategories(parameterString: uId!)
                        
                        
//                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(2 * NSEC_PER_SEC)) / Double(NSEC_PER_SEC), execute: {() -> Void in
//                            self.categorytableView.reloadData()
//                            
//                        })
                        
                        //if not then login from facebook
                        
                        
                    }
                    else{
                        self.chooseInterestAction(self)
                    }
                }
//                else{
//                    self.chooseInterestAction(self)
//                }
                
                else{
                     self.segMentManage()
                    tableOfIntrests.isUserInteractionEnabled=true
                    segmentControl.isUserInteractionEnabled=true
                    if appearBool==false {
                        DispatchQueue.main.async(execute: {
                            
                            let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
                            loadingNotification.mode = MBProgressHUDMode.indeterminate
                            loadingNotification.label.text = "Fetching Feeds"
                            
                            //hit api to get the data from the web
                            
                            
                            let strarr2 = NSMutableArray()
                            strarr2 .add(self.categId .object(at: 0))
                            
                            
                            // let strarr = self.categId .objectAtIndex(0) //componentsJoinedByString(",")
                            let type = UserDefaults.standard.value(forKey: "selectedLocationType") as? String ?? ""
                            
                            let defaults = UserDefaults.standard
                            let uId = defaults .string(forKey: "userLoginId")
                            
                            // let parameterString = "userId=\(uId!)&placeName=\(headerText)&placeType=\(type)&category=\(strarr)"//testing
                            //print(parameterString)
                            self.interestCase=true
                            
                            
                            let headerId = UserDefaults.standard.value(forKey: "selectedLocationId") as? String ?? ""
                            
                            //hit the api for shorted interests from web
                            
                            
                            let parameterDict: NSMutableDictionary = ["userId": uId!, "placeId": headerId, "placeType": type, "category": strarr2, "skip": 0 ]
                            print(parameterDict)
                            
                            // MBProgressHUD.hideAllHUDsForView(self.view, animated: false)
                            
                            
                            
                            apiClassInterest.sharedInstance().postRequestInterestWiseData(parameterDict, viewController: self)
                            
                            
                            // apiClassInterest.sharedInstance().postRequestInterestWiseData(parameterString, viewController: self)
                            self.segMentManage()
                            
                        })
                    }
                    appearBool=false
                }
                
                
                
                
                
                
                //self .shortData(tabledata)
                
                
                
            }
            
            
            headerLabel.text=headerText
            
            
            
            
            
            
        }
        else{
            
            print(" not refresh the intrests")
            
        }
        
        
        
        
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1 * NSEC_PER_SEC)) / Double(NSEC_PER_SEC), execute: {() -> Void in
            
            
            
//            if countArray.object(at: "storyCount") != nil {
//                if let stCount = countArray.value(forKey: "storyCount"){
//                    
//                    self.storyCountLabel.text=String(describing: stCount)
//                }
//                
//            }
            
            
//            if countArray.object(forKey: "bucketCount") != nil {
//                if let bktCount = countArray.value(forKey: "bucketCount"){
//                    
//                    bucketListTotalCount=String(describing: bktCount)
//                }
//                
//            }
//            
//            self.bucketCount.text=bucketListTotalCount
            
            
            
            
            
            
        })
        
        
        
    }
    
    
        func segMentManage() {
            
            /////segmentControl
            var arrayInt = NSMutableArray()
            arrayInt = ["Musium", "Hotel"]
            var tabledata2 = NSArray()
            
            if checked.count<1 {
                tabledata2 = arrayInt as NSArray
            }
            else{
                tabledata2 = checked as NSArray
                
            }
            
            //let viewWidth = CGRectGetWidth(self.view.frame);
            let title2 = tabledata2
            
            
            print(title2)
            
            segmentControl.clipsToBounds=true
            segmentControl.sectionTitles = title2 as! [String]
            segmentControl.autoresizingMask = [.flexibleRightMargin, .flexibleWidth]
            segmentControl.selectionStyle = HMSegmentedControlSelectionStyle.fullWidthStripe
            
            segmentControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocation.down
            segmentControl.selectionIndicatorColor = UIColor(red: 255/255, green: 80/255, blue: 80/255, alpha: 1.0)
            segmentControl.selectionIndicatorHeight=3.0
            segmentControl.isVerticalDividerEnabled = true
            segmentControl.verticalDividerColor = UIColor.clear
            segmentControl.verticalDividerWidth = 0.8
            segmentControl.backgroundColor = UIColor.clear
            segmentControl.titleTextAttributes = [NSFontAttributeName: UIFont(name: "SFUIDisplay-Bold", size: 13.0)! , NSForegroundColorAttributeName : UIColor.black.withAlphaComponent(0.5)]
            segmentControl.selectedTitleTextAttributes = [NSFontAttributeName: UIFont(name: "SFUIDisplay-Bold", size: 13.0)! , NSForegroundColorAttributeName : UIColor.black]
            segmentControl.selectionStyle = HMSegmentedControlSelectionStyle.fullWidthStripe
            
            
            

            categorySelected = checked.object(at: 0) as! NSString
            segmentControl.setSelectedSegmentIndex(0, animated: false)
            
           // segmentControl.addTarget(self, action: #selector(self.segmentedControlChangedValue), for: .valueChanged)
            
            
        }
        

    
    
    
    
    
    
    
    
    //MARK:- Response from the interest API
    //MARK:-
    
    func serverResponseArrivedInterest(_ Response:AnyObject)
    {
        
        
        
        //////////---------- REsponse for the add and interest database-----------////////
        
        if interestCase==true {
            
            jsonResult = NSDictionary()
            jsonResult = Response as! NSDictionary
            
            
            photosArray .removeAllObjects()
            
            //locationarray .removeAllObjects()
            var newTempArr = NSMutableArray()
            
            
            let status = jsonResult.value(forKey: "status") as! NSNumber
            
            
            
            if status == 1 {
                
                jsonMutableArray = NSMutableArray()
                jsonMutableArray = ((jsonResult.value(forKey: "data")! as AnyObject).object(at: 0) as AnyObject).value(forKey: "data") as! NSMutableArray
                
                
                
                if jsonMutableArray.count<1 {
                    tableOfIntrests.isHidden=true
                    
                }
                else{
                    let inter = categorySelected
                    
                    if categoryArray .contains(inter) {
                        
                    }else{
                        categoryArray .add(inter)
                    }
                    
                    //print(jsonMutableArray)
                    
                    
                    var dataArray2 = NSMutableArray()
                    let arrayOfKeys:NSArray = self.allCategoryDictionary.allKeys as NSArray
                    if (arrayOfKeys.contains(String(describing: categId.object(at: segmentControl.selectedSegmentIndex)))) {
                        dataArray2 = self.allCategoryDictionary .value(forKey: String(describing: categId.object(at: segmentControl.selectedSegmentIndex))) as! NSMutableArray
                        
                        print(dataArray2)
                        newTempArr = dataArray2
                        
                    }
                    
                    
                    
                    
                    
                    for i in 0..<jsonMutableArray.count {
                        
                        
                        
                        let dataOfLocations = NSMutableArray()
                        
                        dataOfLocations .add(jsonMutableArray[i] as! NSMutableDictionary)
                        
                        //print(dataOfLocations.count)
                        
                        if dataOfLocations.count>0 {
                            
                            newTempArr .add(dataOfLocations)//as Array)
                            
                            print(newTempArr.count)
                            
                            
                            
                            //print(String(categId.objectAtIndex(segmentControl.selectedSegmentIndex)))
                            
                            
                            let show = ((jsonResult.value(forKey: "data")! as AnyObject).object(at: 0) as AnyObject).value(forKey: "showMore") as! NSNumber
                            showMore = 0
                            if show == 1 {
                                showMore = 1
                            }
                            
                            allCategoryDictionary .setObject(newTempArr, forKey:"\(String(describing: categId.object(at: segmentControl.selectedSegmentIndex)))" as NSCopying)
                            
                           // allCategoryDictionary .setObject(showMore, forKey:"ShowMore\(String(describing: categId.object(at: segmentControl.selectedSegmentIndex)))" as NSCopying)
                            
                           
                            allCategoryDictionary.setObject(showMore, forKey: "ShowMore\(String(describing: categId.object(at: segmentControl.selectedSegmentIndex)))" as NSCopying)
                         
                            
                            
                         
                            
                            
                            
                            
                            
                            
                            
                        }
                        else{
                            
                            newTempArr .add("")
                            allCategoryDictionary .setObject(newTempArr, forKey: "\(String(describing: categId.object(at: segmentControl.selectedSegmentIndex)))" as NSCopying)
                            
                            //   print(String(categId.objectAtIndex(segmentControl.selectedSegmentIndex)))
                            
                            // allCategoryDictionary[String(categId.objectAtIndex(segmentControl.selectedSegmentIndex))] = locationarray
                            
                            //print(allCategoryDictionary)
                            
                        }
                        
                        
                        
                    }
                    
                    
                    
                    
                    likeCount .removeAllObjects()
                  //  emptyView.isHidden = true
                    self .shortData(newTempArr)
                    
                    
                }
                
                
                
                
                
            }
            else if(status == 5) //5
            {
                
                //logout the user from the app
                
               // let nxtObj2 = self.storyboard?.instantiateViewController(withIdentifier: "settingsViewController") as! settingsViewController
                
                self.tabBarController?.tabBar.isHidden = true
                
                let nxtObj = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                
                
                logOut = false
                
                let defaults = UserDefaults.standard
                
                let uId = defaults .string(forKey: "userLoginId")!
                let token = defaults.string(forKey: "deviceToken")!
                
                let deviceTokenDict = NSMutableDictionary()
                
                deviceTokenDict.setValue(token, forKey: "token")
                deviceTokenDict.setValue("iphone", forKey: "device")
                
                let parameter:NSMutableDictionary = ["deviceToken":deviceTokenDict ,"userId":uId]
                
                
                
              //  nxtObj2.logoutApi(parameter)
                
                
                
                
                
                
                
                
                UserDefaults.standard.set(nil, forKey: "arrayOfIntrest")
                
                
                DispatchQueue.main.async(execute: {
                    self.dismiss(animated: true, completion: {})
                    
                    self.navigationController! .pushViewController(nxtObj, animated: true)
                    OperationQueue.main.cancelAllOperations()
                    
                    
                })
                
                
                
                
                
            }
            else{
                
               // emptyView.isHidden = false
                
            }
            
            
            
            
            
            
            
            
            
        }
        
        
        
        MBProgressHUD.hide(for: self.view, animated: true)
        
    }
    
    

    
    
    
    
    
    //MARK: DataSource and delegate of tableView
    //MARK:-
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        //if tableView==categorytableView {
          //  return tagsArr.count
        //}
            
       // else{
       //
            if photosArray.count<1 {
                return 0
            }
            else
            {
                
                
                if  showMore == 1 {
                    return photosArray.count + 1
                }
                else{
                    return photosArray.count
                }
                
            }
            
        //}
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //if tableView == categorytableView
       // {
        //    return 60
       // }
        if indexPath.row == photosArray.count {
            return 60
        }
        else
        {
            
            return self.view.frame.width * 0.72
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
            
       
            
            if indexPath.row == photosArray.count
            {
                let cell = UITableViewCell() //
                cell.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width - 9, height: 50)
                
              
                
                
                cell.layer.shouldRasterize = true
                cell.layer.rasterizationScale = UIScreen.main.scale
                
                
                let spinner = UIActivityIndicatorView()
                
                spinner.isHidden = false
                
                spinner.activityIndicatorViewStyle = .gray
                spinner.frame = CGRect(x: cell.frame.size.width/2 - 20 , y: cell.frame.size.height/2 - 17, width: 40, height: 40)
                cell.addSubview(spinner)
                
                
                
                spinner.startAnimating()
                
                
                DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async(execute: {
                    
                    
                    
                    let strarr2 = NSMutableArray()
                    strarr2 .add(self.categId .object(at: self.segmentControl.selectedSegmentIndex))
                    let type = UserDefaults.standard.value(forKey: "selectedLocationType") as? String ?? ""
                    
                    let defaults = UserDefaults.standard
                    let uId = defaults .string(forKey: "userLoginId")
                    
                    
                    let headerId = UserDefaults.standard.value(forKey: "selectedLocationId") as? String ?? ""
                    
                    
                    
                    let parameterDict: NSMutableDictionary = ["userId": uId!, "placeId": headerId, "placeType": type, "category": strarr2, "skip":self.photosArray.count ]
                    print(parameterDict)
                    
                    
                    apiClassInterest.sharedInstance().postRequestInterestWiseData(parameterDict, viewController: self)
                    
                    
                    
                    
                })
                
                
                
                
                
                return cell
                
            }
                //Simple cells
            else
            {
                let cell:cellClassTableViewCell = tableView.dequeueReusableCell(withIdentifier: "intrestCell") as! cellClassTableViewCell
                
                
               
                
                cell.categoryImage.image = imageOfCatgory //.setImage(imageOfCatgory, for: UIControlState())
                
                cell.locationLabel.text=((((photosArray.object(at: indexPath.row) as AnyObject).value(forKey: "photos")! as AnyObject).object(at: 0) as AnyObject).value(forKey: "placeTag") as? String)?.capitalized ?? ""
                
                
           
                
                
                
                
                
                var locationCity = "\((((photosArray.object(at: indexPath.row) as AnyObject).value(forKey: "photos")! as AnyObject).object(at: 0) as AnyObject).value(forKey: "city") as? String ?? " ")".capitalized
                
                //// to add state if city not found
                if locationCity == "" || locationCity == " " {
                    
                    locationCity = "\((((photosArray.object(at: indexPath.row) as AnyObject).value(forKey: "photos")! as AnyObject).object(at: 0) as AnyObject).value(forKey: "state") as? String ?? " ")".capitalized
                    
                    
                    /////To add country if state and city not found
                    if locationCity == "" || locationCity == " " {
                        
                        locationCity = "\((((photosArray.object(at: indexPath.row) as AnyObject).value(forKey: "photos")! as AnyObject).object(at: 0) as AnyObject).value(forKey: "country") as? String ?? " ")".capitalized
                        
                        
                        
                    }
                    
                    
                }
                
                
                
                //let locationCountry = "\(photosArray.objectAtIndex(indexPath.row).valueForKey("country") as? String ?? "")"
                
                
                
                
                
                ////Attributed string---///
//                let segAttributes: NSDictionary = [
//                    NSForegroundColorAttributeName: UIColor.darkGray,
//                    NSFontAttributeName: UIFont(name:"Roboto-Light", size: 12.0)!
//                ]
//                
//                let segAttributes2: NSDictionary = [
//                    NSForegroundColorAttributeName: UIColor.black,
//                    NSFontAttributeName: UIFont(name:"Roboto-Regular", size: 14.0)!
//                ]
//                
//                let attributedString1 = NSMutableAttributedString(string:"", attributes:segAttributes as? [String : AnyObject])
//                
//                let attributedString2 = NSMutableAttributedString(string:locationCity, attributes:segAttributes2 as? [String : AnyObject])
//                
//                attributedString1.append(attributedString2)
//                cell.locationLabel.attributedText = attributedString1
                cell.locationLabel.text = locationCity
                
                
                
                
                
                
                let currentIndex = (indexCount.object(at: indexPath.row) as AnyObject).value(forKey: "index") as! Int
                
                
                let multiImg = multiplePhotosArray.object(at: indexPath.row) as! NSMutableArray
                
                
                let museumImage = (multiImg.object(at: currentIndex) as AnyObject).value(forKey: "imageThumb") as? String ?? ""
                //photosArray.objectAtIndex(indexPath.row).valueForKey("photos")!.objectAtIndex(0).valueForKey("imageThumb")! as? String ?? "" //("imageLarge")!
                let url2 = URL(string: museumImage )
                
                
                //  let museumName = photosArray.objectAtIndex(indexPath.row).valueForKey("")
                
                let pImage : UIImage = UIImage(named:"dummyBackground2")! //placeholder image
                
                
                cell.locationImage.sd_setImage(with: url2, placeholderImage: pImage)
                
                //cell.layer.cornerRadius=5
                cell.clipsToBounds=true
                cell.locationImage.clipsToBounds=true
                cell.locationImage.backgroundColor = UIColor.white
                cell.tag=1000*self.segmentControl.selectedSegmentIndex+indexPath.row
                
                let longView = UIView()
                longView.frame=cell.frame
                longView.tag=1000*self.segmentControl.selectedSegmentIndex+indexPath.row
                //cell .addSubview(longView)
                
                
              //  let longTapGest = UILongPressGestureRecognizer(target: self, action: #selector(intrestViewController.longTap(_:)))
                
               // cell.addGestureRecognizer(longTapGest)
                
                
                
                
                
                
                
                //MARK:  ////////// MANAGE LIKE AND ITS COUNT////////
                var countLik = NSNumber()
                //MANAGE from the crash
                
             
                
                if (((self.photosArray.object(at: indexPath.row) as AnyObject).value(forKey: "photos")! as AnyObject).object(at: 0) as AnyObject).value(forKey: "likeCount") != nil
                {
                    countLik = (((self.photosArray.object(at: indexPath.row) as AnyObject).value(forKey: "photos")! as AnyObject).object(at: 0) as AnyObject).value(forKey: "likeCount") as! NSNumber
                }
                else
                {
                    countLik=0
                }
                
                
                
                
                let likeimg = cell.viewWithTag(7477) as! UIImageView
                let likecountlbl = cell.viewWithTag(7478) as! UILabel
               
                let uId = Udefaults .string(forKey: "userLoginId")
                
                let imageId2 = (((self.photosArray.object(at: indexPath.row) as AnyObject).value(forKey: "photos")! as AnyObject).object(at: 0) as AnyObject).value(forKey: "photoId") as? String ?? " "
                
                var likedByMe2 = NSArray()
                
                // print(self.photosArray .objectAtIndex(indexPath.row).valueForKey("userLiked"))
                
                if (((self.photosArray .object(at: indexPath.row) as AnyObject).value(forKey: "photos")! as AnyObject).object(at: 0) as AnyObject).value(forKey: "userLiked") != nil { // as? NSNull != NSNull(){
                    
                    likedByMe2 = (((self.photosArray[indexPath.row] as AnyObject).value(forKey: "photos")! as AnyObject).object(at: 0) as AnyObject).value(forKey: "userLiked") as! NSArray
                    
                }
                
                
                //SHOW THE COUNT OF LIKED
                likecountlbl.text=String(describing: countLik)
                likeimg.image=UIImage (named: "like_count")
                
                
                ///////-  Show liked by me-/////
                if likedByMe2.count>0
                {
                    if likedByMe2.contains(uId!)
                    {
                        
                        let arlik = likeCount.value(forKey: "imageId") as! NSArray
                        
                        if arlik.contains(imageId2) {
                            
                            let indexOfImageId = (likeCount.value(forKey: "imageId") as AnyObject).index(of: imageId2)
                            
                            if (likeCount.object(at: indexOfImageId) as AnyObject).value(forKey: "like") as! Bool == true {
                                likeimg.image=UIImage (named: "likedCount")
                                let staticCount = (likeCount.object(at: indexOfImageId) as AnyObject).value(forKey: "count") as? NSNumber
                                likecountlbl.text=String(describing: staticCount!)// String(self.addTheLikes(staticCount!))
                                
                                
                                
                            }
                            else{
                                likeimg.image=UIImage (named: "like_count")
                                let staticCount = (likeCount.object(at: indexOfImageId) as AnyObject).value(forKey: "count") as? NSNumber
                                likecountlbl.text=String(describing: staticCount!) //(self.addTheLikes(staticCount!))
                            }
                        }
                            
                            //if not contains the imageId
                        else
                        {
                            likeCount .add(["imageId":imageId2,"userId":uId!, "like": true, "count": countLik])
                            print(likeCount)
                            likecountlbl.text=String(describing: countLik)
                            likeimg.image=UIImage (named: "likedCount")
                        }
                        
                        
                        
                    }
                        
                    else
                    {
                        let arlik = likeCount.value(forKey: "imageId") as! NSArray
                        
                        if arlik.contains(imageId2) {
                        
                       // if (likeCount.value(forKey: "imageId") as AnyObject).contains(imageId2) {
                            
                            let indexOfImageId = (likeCount.value(forKey: "imageId") as AnyObject).index(of: imageId2)
                            
                            if (likeCount.object(at: indexOfImageId) as AnyObject).value(forKey: "like") as! Bool == true {
                                likeimg.image=UIImage (named: "likedCount")
                                let staticCount = (likeCount.object(at: indexOfImageId) as AnyObject).value(forKey: "count") as? NSNumber
                                likecountlbl.text=String(describing: staticCount!)
                                
                            }
                            else{
                                let staticCount = (likeCount.object(at: indexOfImageId) as AnyObject).value(forKey: "count") as? NSNumber
                                likecountlbl.text=String(describing: staticCount!)
                                likeimg.image=UIImage (named: "like_count")
                            }
                        }
                        
                        
                        
                        
                        
                        
                    }
                    
                    
                    
                }
                else
                {
                    let arlik = likeCount.value(forKey: "imageId") as! NSArray
                    
                    if arlik.contains(imageId2) {
                    //if (likeCount.value(forKey: "imageId") as AnyObject).contains(imageId2) {
                        
                        let indexOfImageId = (likeCount.value(forKey: "imageId") as AnyObject).index(of: imageId2)
                        
                        if (likeCount.object(at: indexOfImageId) as AnyObject).value(forKey: "like") as! Bool == true {
                            likeimg.image=UIImage (named: "likedCount")
                            let staticCount = (likeCount.object(at: indexOfImageId) as AnyObject).value(forKey: "count") as? NSNumber
                            likecountlbl.text=String(describing: staticCount!)
                            
                        }
                        else{
                            let staticCount = (likeCount.object(at: indexOfImageId) as AnyObject).value(forKey: "count") as? NSNumber
                            likecountlbl.text=String(describing: staticCount!)
                            likeimg.image=UIImage (named: "like_count")
                        }
                    }
                    
                    
                    
                }
                
                
                
                return cell
            }
        //}
    }
    
    
    //    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
    //        if(tableView == categorytableView)
    //        {
    //
    //        }
    //
    //    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == categorytableView {
            
            
            
            
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
                
                print(tagsArr .object(at: indexPath.row))
                
                let objId = ((tagsArr .object(at: indexPath.row) as AnyObject).value(forKey: "_id") as? String ?? "")
                let objectInt = ((tagsArr .object(at: indexPath.row) as AnyObject).value(forKey: "displayName") as? String)
                checked .add(objectInt!)
                categId .add(objId)
                
                
                
            }
            
            
            categorytableView .reloadData()
            
            
            
            
        }
            
            
            
            //////
            
        else
            
        {
            
            print(photosArray[indexPath.row])
            
            
            //self.photosArray .objectAtIndex(indexPath.row).valueForKey("photos")!.objectAtIndex(0).valueForKey("userLiked")
            
            let str = (((self.photosArray[indexPath.row] as AnyObject).value(forKey: "photos")! as AnyObject).object(at: 0) as AnyObject).value(forKey: "description") as? String ?? "No Description Found"//description
            let profileImage = ((((self.photosArray .object(at: indexPath.row) as AnyObject).value(forKey: "photos")! as AnyObject).object(at: 0) as AnyObject).value(forKey: "user")! as AnyObject).value(forKey: "picture")! as! NSString//profile image Link
            
            
            
            //////////////////////----------------Location----------------------------///////////////////
            var location = NSString()
            var sendgeoTag = (((self.photosArray[indexPath.row] as AnyObject).value(forKey: "photos")! as AnyObject).object(at: 0) as AnyObject).value(forKey: "placeTag") as? String ?? " "
            
            
            let fullName22 = sendgeoTag
            let fullNameArr22 = fullName22.characters.split{$0 == ","}.map(String.init)
            
            if fullNameArr22.count>0 {
                sendgeoTag = fullNameArr22[0]
            }
            
            
            var lat = NSNumber()
            var long = NSNumber()
            
            
            if (((self.photosArray.object(at: indexPath.row) as AnyObject).value(forKey: "photos")! as AnyObject).object(at: 0) as AnyObject).value(forKey: "latitude") != nil && (self.photosArray.object(at: indexPath.row) as AnyObject).value(forKey: "latitude") as? NSNull != NSNull()   {
                
                lat = (((self.photosArray.object(at: indexPath.row) as AnyObject).value(forKey: "photos")! as AnyObject).object(at: 0) as AnyObject).value(forKey: "latitude") as! NSNumber  //as? String ?? "0.0"
                
                long = (((self.photosArray.object(at: indexPath.row) as AnyObject).value(forKey: "photos")! as AnyObject).object(at: 0) as AnyObject).value(forKey: "longitude") as! NSNumber //as? String ?? "0.0"
            }
            else
            {
                lat=0
                long=0
            }
            
            
            
            
            // remove the another part of string
            let changeStr:NSString = sendgeoTag as NSString
            let ddd = changeStr.replacingOccurrences(of: "&", with: " and ") //replace & with and
            sendgeoTag = ddd
            location = ""
            //"\(self.captitalString(sendgeoTag as? String as NSString? ?? "")), \(self.captitalString((self.photosArray.object(at: indexPath.row) as AnyObject).value(forKey: "city") as? String ?? "")), \(self.captitalString(self.photosArray.object(at: indexPath.row).value(forKey: "country") as? String ?? ""))"
            
            
            var arrImg = NSString()
            arrImg = (((self.photosArray.object(at: indexPath.row) as! NSDictionary).value(forKey: "photos")! as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "imageLarge") as? String as NSString? ?? ""
            
            //(((self.photosArray[indexPath.row] as AnyObject).value(forKey: "photos")! as AnyObject).object(at: 0) as AnyObject).value(forKey: "imageLarge") as? String ?? "" //locationSingleImage
            var arrImgStand = NSString()
            //arrImgStand = (((self.photosArray[indexPath.row] as AnyObject).value(forKey: "photos")! as AnyObject).object(at: 0) as AnyObject).value(forKey: "imageThumb") as? String ?? "" // image standard
           
            arrImgStand = (((self.photosArray.object(at: indexPath.row) as! NSDictionary).value(forKey: "photos")! as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "imageThumb") as? String as NSString? ?? "" // image standard
            
            
            
            
            print(arrImgStand)
            
            
            let name = ((((self.photosArray .object(at: indexPath.row) as AnyObject).value(forKey: "photos")! as AnyObject).object(at: 0) as AnyObject).value(forKey: "user")! as AnyObject).value(forKey: "name") as? String ?? " " //userName
            
            
            
            //MANAGE Source for images
            
            var sourceType = "Other"
            
            let Source = (((self.photosArray .object(at: indexPath.row) as AnyObject).value(forKey: "photos")! as AnyObject).object(at: 0) as AnyObject).value(forKey: "source") as? String ?? " " //source
            if Source == "PYT" {
                
                
                sourceType = Source
                
            }
            
            
            
            
            
            
            let txt = headerLabel.text
            
            //print(multiplePhotosArray.objectAtIndex(indexPath.row))
            // print(multiplePhotosArray.count)
            let multiImg = multiplePhotosArray.object(at: indexPath.row) as! NSMutableArray
            
            
            
            // print(multiImg)
            let newTmpArr = NSMutableArray()
            
            for ll in 0..<(multiImg as AnyObject).count {
                
                // print(multiImg.objectAtIndex(ll))
                // print(multiImg.objectAtIndex(ll).valueForKey("imageLarge"))
                
                
                
                //newTmpArr.add(["large":"\(multiImg.object(at: ll).value(forKey: "imageLarge")! as? String ?? "")", "standard": "\(multiImg.object(at: ll).value(forKey: "imageThumb")! as? String ?? "")"])
                
                let imgurlLarge = ((multiImg.object(at: ll)) as AnyObject).value(forKey: "imageLarge") as? String ?? ""
                let imgurlThumb = ((multiImg.object(at: ll)) as AnyObject).value(forKey: "imageThumb") as? String ?? ""
                
                newTmpArr .add(["large": imgurlLarge, "standard": imgurlThumb])
                
                
                
                
                
            }
            
            // print(newTmpArr)
            
            
            
            //let multiImgStandard: NSMutableArray = (multiplePhotosArray.objectAtIndex(indexPath.row) as? NSMutableArray)!
            //print(arrImgStand)
            
            let multiImgArr = NSMutableArray()
            let multiImgStandArr = NSMutableArray()
            
            for i in 0..<newTmpArr.count {
                let imgLinkStr = (newTmpArr .object(at: i) as AnyObject).value(forKey: "large") as? String ?? ""
                let imgLinkStandard = (newTmpArr .object(at: i) as AnyObject).value(forKey: "standard") as? String ?? ""
                print("large===\(imgLinkStr)====== standard==\(imgLinkStandard)")
                
                if arrImg as String == imgLinkStr {
                    
                }
                else
                {
                    multiImgArr .add(imgLinkStr)
                    multiImgStandArr .add(imgLinkStandard)
                }
                
                
                
                
            }
            
            multiImgArr .insert(arrImg, at: 0)
            multiImgStandArr .insert(arrImgStand, at: 0)
            print(multiImgStandArr)
            
            let categoriesArray:NSArray = (((photosArray.object(at: indexPath.row) as AnyObject).value(forKey: "photos")! as AnyObject).object(at: 0) as AnyObject).value(forKey: "category") as! NSArray
            let countryName = (((photosArray.object(at: indexPath.row) as AnyObject).value(forKey: "photos")! as AnyObject).object(at: 0) as AnyObject).value(forKey: "country") as? String ?? ""
            var cityName = (((photosArray.object(at: indexPath.row) as AnyObject).value(forKey: "photos")! as AnyObject).object(at: 0) as AnyObject).value(forKey: "city") as? String ?? ""
            
            
            
            
            
            let arrayData = NSMutableArray()
            
            
            let strcat = (categoriesArray.value(forKey: "displayName") as AnyObject).componentsJoined(by: ",")
            print(strcat)
            
            
            
            
            let imId = (((photosArray[indexPath.row] as AnyObject).value(forKey: "photos")! as AnyObject).object(at: 0) as AnyObject).value(forKey: "photoId") as? String ?? ""
            
            let type = UserDefaults.standard.value(forKey: "selectedLocationType") as? String ?? ""
            let headerId = UserDefaults.standard.value(forKey: "selectedLocationId") as? String ?? ""
            
            
            
            
            
            
            //Likes count
            
            var countLik = NSNumber()
            if (((photosArray[indexPath.row] as AnyObject).value(forKey: "photos")! as AnyObject).object(at: 0) as AnyObject).value(forKey: "count") != nil  {
                
                countLik = (((photosArray[indexPath.row] as AnyObject).value(forKey: "photos")! as AnyObject).object(at: 0) as AnyObject).value(forKey: "likeCount") as! NSNumber  //as? String ?? "0.0"
                
                
            }else
            {
                countLik=0
                
            }
            
            
            
            //            let otherUserId = photosArray[indexPath.row].valueForKey("userId")!.objectAtIndex(0).valueForKey("_id") as? String ?? ""
            
            let otherUserId = ((((photosArray.object(at: indexPath.row) as AnyObject).value(forKey: "photos")! as AnyObject).value(forKey: "user")! as AnyObject).object(at: 0) as AnyObject).value(forKey: "_id") as? String ?? ""
            
            var mutableDic = NSMutableDictionary()
            
            
            if cityName=="" {
                cityName=txt!
            }
            
            
            print("City Name=\(cityName)")
            
            
            var catArrSt = NSArray()
            
            print(categoriesArray)
            
            catArrSt = categoriesArray
            
            
            if self.likeCount.count>0 {
                if (self.likeCount.value(forKey: "imageId") as AnyObject).contains(imId) {
                    
                    let index = (self.likeCount.value(forKey: "imageId") as AnyObject).index(of: imId)
                    
                    if (self.likeCount.object(at: index) as AnyObject).value(forKey: "like") as! Bool == true {
                        
                        mutableDic = ["Description":str, "profileImage": profileImage, "location": location, "locationImage": arrImg, "Venue": cityName, "CountryName": countryName, "geoTag": sendgeoTag,"imageId":imId ,"latitude":lat, "longitude":long, "userName":name, "Type": sourceType, "multipleImagesLarge": multiImgArr, "Category": strcat, "likeBool":true, "otherUserId":otherUserId, "likeCount":countLik, "cityName": cityName, "standardImage":arrImgStand, "multipleImagesStandard": multiImgStandArr, "categoryMainArray": catArrSt, "placeType": type, "placeId": headerId]
                        
                        arrayData .add(mutableDic)
                    }
                        
                        
                    else
                    {
                        
                        mutableDic = ["Description":str, "profileImage": profileImage, "location": location, "locationImage": arrImg, "Venue": cityName, "CountryName": countryName, "geoTag": sendgeoTag,"imageId":imId ,"latitude":lat, "longitude":long, "userName":name, "Type": sourceType, "multipleImagesLarge": multiImgArr, "Category": strcat, "likeBool":false, "otherUserId":otherUserId, "likeCount":countLik, "cityName": cityName, "standardImage":arrImgStand, "multipleImagesStandard": multiImgStandArr, "categoryMainArray": catArrSt, "placeType": type, "placeId": headerId]
                        
                        arrayData .add(mutableDic)
                        
                        
                    }
                    
                    
                }
                else
                {
                    mutableDic = ["Description":str, "profileImage": profileImage, "location": location, "locationImage": arrImg, "Venue": cityName, "CountryName": countryName, "geoTag": sendgeoTag,"imageId":imId ,"latitude":lat, "longitude":long, "userName":name, "Type": sourceType, "multipleImagesLarge": multiImgArr, "Category": strcat, "likeBool":false, "otherUserId":otherUserId, "likeCount":countLik, "cityName": cityName, "standardImage":arrImgStand, "multipleImagesStandard": multiImgStandArr, "categoryMainArray": catArrSt, "placeType": type, "placeId": headerId]
                    
                    arrayData .add(mutableDic)
                }
                
            }
            else
            {
                mutableDic = ["Description":str, "profileImage": profileImage, "location": location, "locationImage": arrImg, "Venue": cityName, "CountryName": countryName, "geoTag": sendgeoTag,"imageId":imId ,"latitude":lat, "longitude":long, "userName":name, "Type": sourceType, "multipleImagesLarge": multiImgArr, "Category": strcat, "likeBool":false, "otherUserId":otherUserId, "likeCount":countLik, "cityName": cityName, "standardImage":arrImgStand, "multipleImagesStandard": multiImgStandArr, "categoryMainArray": catArrSt, "placeType": type, "placeId": headerId]
                
                arrayData .add(mutableDic)
                
            }
            
            
            
            print(arrayData)
            
           
            
            //let nxtObj2 = self.storyboard?.instantiateViewController(withIdentifier: "detailViewController") as! detailViewController
           // nxtObj2.arrayWithData=arrayData
           // nxtObj2.fromStory=false
           // nxtObj2.countLikes=likeCount
            //nxtObj2.fromInterest = true
            
            DispatchQueue.main.async(execute: {
                
                //self.navigationController! .pushViewController(nxtObj2, animated: true)
                self.appearBool=true
            })
            
            
        }
        
        
        
    }
    
    

    
    
    
    
        
        

        
        
    
    
    ////Add this method in view did appear to get the messages
    
    override func viewDidAppear(_ animated: Bool) {
        //super.viewDidAppear(animated)
        
        
        /*
         SocketIOManager.sharedInstance.getChatMessageNotify { (messageInfo) -> Void in
         dispatch_async(dispatch_get_main_queue(), { () -> Void in
         
         let count: String = String(messageInfo["count"]!)
         
         self.tabBarController?.tabBar.items?[3].badgeValue = count
         
         
         
         
         })
         }
         */
 
        
    }
    
    
    
    

    
    
    //MARK:reload from another class(detailview class)
    //MARK:-
    
    func loadInterest(_ notification: Notification){
        //load data here
        
        // print(likeCount.lastObject)
        
        self.tableOfIntrests .reloadData()
        
        
    }
    
    
    
    func loadCount(_ notification: Notification){
        //load data here
        
      
        
        if countsDictionary.object(forKey: "storyCount") != nil {
            if let stCount = countsDictionary.value(forKey: "storyCount"){
                
                //self.storyCountLabel.text=String(describing: stCount)
            }
            
        }
        
        
        if countsDictionary.object(forKey: "bucketCount") != nil {
            if let stCount = countsDictionary.value(forKey: "bucketCount"){
                
               
            }
            
        }
        
        
        //self.bucketCount.text=bucketListTotalCount
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden=true //hide the navigationBar
        
        
        
        
        
        
        
        likeCount .removeAllObjects() // clear the liked
        
        NotificationCenter.default.addObserver(self, selector: #selector(intrestViewController.loadInterest(_:)),name:NSNotification.Name(rawValue: "loadInterest"), object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(intrestViewController.loadCount(_:)),name:NSNotification.Name(rawValue: "loadCount"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(intrestViewController.loadDeletedCell(_:)),name:NSNotification.Name(rawValue: "loadDeleteInterest"), object: nil)
        
        
        
        //swipe gesture
        
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(intrestViewController.didSwipe(_:))) // put : at the end of method name
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(intrestViewController.didSwipe(_:))) // put : at the end of method name
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeft)
        
        
        
    }
    
    
    
    func didSwipe(_ gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            
            switch swipeGesture.direction {
                
            case UISwipeGestureRecognizerDirection.right :
                 print("User swiped Right -- index")
                
                 if segmentControl.selectedSegmentIndex > 0 {
                    
                    segmentControl.setSelectedSegmentIndex(UInt(segmentControl.selectedSegmentIndex - 1), animated: true)
                    
                    self.segmentedControlChangedValue(segmentControl)
                    
                 }
                 
                break
        
        
            case UISwipeGestureRecognizerDirection.left:
                print("User swiped Left ++ index")
                if segmentControl.selectedSegmentIndex < checked.count - 1 {
                    
                     segmentControl.setSelectedSegmentIndex(UInt(segmentControl.selectedSegmentIndex + 1), animated: true)
                    self.segmentedControlChangedValue(segmentControl)
                }
                
                break
                
                
            default:
                break
                
                
            }
        
            
            
        }
        
        /*
         
        if let swipeGesture = recognizer as? UISwipeGestureRecognizer
        {
            
            let point = recognizer.locationInView(self.tableOfIntrests)
            let indexPath = self.tableOfIntrests.indexPathForRowAtPoint(point)!
            
            print(indexPath.row)
            
            let multiImg = multiplePhotosArray.objectAtIndex(indexPath.row) as! NSMutableArray
            print(multiImg.valueForKey("imageThumb"))
            print("multiple \(multiImg)")
            print("My index: \(indexCount.objectAtIndex(indexPath.row))")
           // print("My index: \(indexCount)")
            
            if multiImg.count > 1 {
                
                let currentIndex = indexCount.objectAtIndex(indexPath.row).valueForKey("index") as! Int
                
                let totalIndex = indexCount.objectAtIndex(indexPath.row).valueForKey("totalPhotos") as! Int
                
                switch swipeGesture.direction {
                    
                    
                    
                case UISwipeGestureRecognizerDirection.Right :
                    print("User swiped right")
                    
                    
                    if currentIndex > 0   {
                        
                        print("Swipr top left index will increase")
                        
                        let newdic:NSMutableDictionary = ["index": Int(currentIndex-1), "totalPhotos": totalIndex]
                        
                        
                        indexCount.removeObjectAtIndex(indexPath.row)
                        print(indexCount)
                        indexCount.insertObject(newdic, atIndex: indexPath.row)
                        print("\n\n new count=\(indexCount)")
                       
                        
                        tableOfIntrests.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Right)
                        
                    }
                    
                    
                    
                    
                    
                    
                case UISwipeGestureRecognizerDirection.Left:
                    print("User swiped Left")
                    
                    
                        if currentIndex < totalIndex-1   {
                        
                        print("Swipr top left index will increase")
                        
                            let newdic:NSMutableDictionary = ["index": Int(currentIndex+1), "totalPhotos": totalIndex]
                            
                            
                            indexCount.removeObjectAtIndex(indexPath.row)
                            print(indexCount)
                            indexCount.insertObject(newdic, atIndex: indexPath.row)
                            print("\n\n new count=\(indexCount)")
                            
                            
                           
                            tableOfIntrests.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Left)
                            
                    }
                    
                    
                    
                    
                default:
                    break //stops the code/codes nothing.
                    
                    
                }
                
                
            }
            
            
            
            
            
            
        } */
        
        
    }
    
    
    
    
    
    
    func loadDeletedCell(_ notification: Notification) {
        
        
        
        self .deletImageManage()
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    //MARK:- Manage the segment control
    func segmentedControlChangedValue(_ segmentedControl: HMSegmentedControl) {
        
        print(segmentedControl.selectedSegmentIndex)
        
        categorySelected = checked .object(at: segmentedControl.selectedSegmentIndex) as! NSString
        print(categorySelected)
        
        
        
        //print(allCategoryDictionary)
        
        let arrayOfKeys:NSArray = self.allCategoryDictionary.allKeys as NSArray
        if (arrayOfKeys.contains(String(describing: categId.object(at: segmentedControl.selectedSegmentIndex)))) {
            let dataArray2: NSMutableArray = self.allCategoryDictionary .value(forKey: String(describing: categId.object(at: segmentedControl.selectedSegmentIndex))) as! NSMutableArray
            
            print(dataArray2)
           MBProgressHUD.showAdded(to: self.view, animated: true)
            
            
            let showM = self.allCategoryDictionary .value(forKey: "ShowMore\(String(describing: categId.object(at: segmentedControl.selectedSegmentIndex)))") as! NSNumber
            
            showMore = 0
            if showM == 1 {
                showMore = 1
            }
            
                      //NSOperationQueue.mainQueue().cancelAllOperations() //clear all the queues
            //dispatch_async(dispatch_get_main_queue(), {
            self.shortData(dataArray2)
            // })
        }
        else
        {
            
            let strarr2 = NSMutableArray()
            strarr2 .add(self.categId .object(at: segmentedControl.selectedSegmentIndex))
            
            //let strarr = self.categId .objectAtIndex(segmentedControl.selectedSegmentIndex) //.componentsJoinedByString(",")
            let type = UserDefaults.standard.value(forKey: "selectedLocationType") as? String ?? ""
            
            let defaults = UserDefaults.standard
            let uId = defaults .string(forKey: "userLoginId")
            
            //Header Text
           // let headerText = NSUserDefaults.standardUserDefaults().valueForKey("selectedLocation") as? String ?? ""
            
            //let parameterString = "userId=\(uId!)&placeName=\(headerText)&placeType=\(type)&category=\(strarr)"//testing
            // print(parameterString)
            
            
            
            
            let headerId = UserDefaults.standard.value(forKey: "selectedLocationId") as? String ?? ""
            
            //hit the api for shorted interests from web
            
            let parameterDict: NSMutableDictionary = ["userId": uId!, "placeId": headerId, "placeType": type, "category": strarr2, "skip":0 ]
            print(parameterDict)
            
            
            
            
            let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
            loadingNotification.mode = MBProgressHUDMode.indeterminate
            loadingNotification.label.text = "Fetching Feeds"
            
            
            
            
            tableOfIntrests.isHidden=true
            
            
            
            
            apiClassInterest.sharedInstance().postRequestInterestWiseData(parameterDict, viewController: self)
            tableOfIntrests.contentOffset.y=0
            
            
            
            // apiClassInterest.sharedInstance().postRequestInterestWiseData(parameterString, viewController: self)
            
        }
        
        
        
        
        
        //self .shortData(self.locationarray)
        
        
        
    }
    
    
    
       
    
    
    //MARK:- Btn Actions
//    
//    @IBAction func doneAction(_ sender: AnyObject) {
//        
//        if checked.count<1 {
//            CommonFunctionsClass.sharedInstance().showAlert("Opps!", text: "Please select minimum one interest.", imageName: "alertFill")
//        }
//        else
//        {
//            let defaults = UserDefaults.standard
//            defaults .setValue(checked, forKey: "Interests")
//            defaults .setValue(categId, forKey: "IntrestsId")
//            
//            
//            // self.categoryView.frame = CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height )
//            
//           
//            
//            UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions(), animations: {() -> Void in
//                self.categoryView.frame = CGRect(x: 0, y: self.categoryView.frame.size.height, width: self.view.bounds.width, height: self.categoryView.frame.size.height )
//                print(self.categoryView.frame)
//                }, completion: {(finished: Bool) -> Void in
//                    self.categoryView.isHidden=true
//                    
//                    self.tableOfIntrests.isUserInteractionEnabled=true
//                    self.segmentControl.isUserInteractionEnabled=true
//                    
//                    //  print(checked)
//                    //    print(categId)
//                    
//                    
//                    DispatchQueue.main.async(execute: {
//                        
//                        
//                        //10153101414156609
//                        
//                        self.categoryArray .removeAllObjects()
//                        let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
//                        loadingNotification.mode = MBProgressHUDMode.indeterminate
//                        loadingNotification.label.text = "Fetching Feeds"
//                        
//                        self.allCategoryDictionary = NSMutableDictionary()
//                        
//                        
//                        let strarr = self.categId.componentsJoined(by: ",")
//                        print(strarr)
//                        let defaults = UserDefaults.standard
//                        let uId = defaults .string(forKey: "userLoginId")
//                        
//                        let parameterString:NSDictionary = ["userId":uId!, "interest":self.categId]
//                        
//                        print(parameterString)
//                        apiClassInterest.sharedInstance().postRequestInterest(parameterString, viewController: self)
//                        
//                        
//                        
//                        
//                        
//                        DispatchQueue.main.async(execute: {
//                            
//                            //hit api to get the data from the web
//                            let strarr2 = NSMutableArray()
//                            strarr2 .add(self.categId .object(at: 0))
//                            
//                            
//                            
//                            
//                            let headerType = UserDefaults.standard.value(forKey: "selectedLocationType") as? String ?? ""
//                            
//                            let headerId = UserDefaults.standard.value(forKey: "selectedLocationId") as? String ?? ""
//                            
//                            
//                            // let parameterString2 = "userId=\(uId!)&placeName=\(headerText)&placeType=\(headerType)&category=\(strarr2)"//testing
//                            // print(parameterString2)
//                            self.interestCase=true
//                            //get the shorted data from the api
//                            
//                            let parameterDict: NSMutableDictionary = ["userId": uId!, "placeId": headerId, "placeType": headerType, "category": strarr2, "skip": 0 ]
//                            print(parameterDict)
//                            
//                            
//                            
//                            
//                            
//                            apiClassInterest.sharedInstance().postRequestInterestWiseData(parameterDict, viewController: self)
//                            self.tableOfIntrests.contentOffset.y=0
//                        })
//                        
//                        
//                        
//                        self .segMentManage()
//                        // self .shortData(self.tabledata)
//                    })
//                    
//            })
//            
//            
//            
//            
//            
//            
//            
//            
//            
//            
//        }
//        
//    }
    
    
    //open the popup view of categories
    
   
    
    
    
    
    
   
    
    
    
    
    
    
    
    func captitalString(_ nameString:NSString) -> String {
        
        var nameString2 = nameString
        nameString2 = nameString.capitalized as NSString
        return nameString2 as String
        
    }
    
    
    
    
    
    
    func setCategoryIcons(_ categoryIds: NSString) -> UIImage {
        
        var catimage = UIImage()
        var nameString = NSString()
        
        
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
        
        catimage = UIImage (named: nameString as String)!
        
        return catimage
        
    }
    
    
    
    
    
    
    
    
    
    /////////////////////////////////////////////////////////////////////////
    //MARK:- Function to short the data with categories
    //MARK:-
    
    func shortData(_ dataArray: NSMutableArray) -> Void {
        
    
        
       
        
        let index = self.segmentControl.selectedSegmentIndex
        
        
        photosArray .removeAllObjects()
        photosArray = NSMutableArray()
        multiplePhotosArray .removeAllObjects()
        //tableOfIntrests .reloadData()
        tableOfIntrests.isHidden=false
        indexCount.removeAllObjects()
        
        let selectedText = checked.object(at: index) as? String
        let cat = categId.object(at: index) as? String
        
        imageOfCatgory = self.setCategoryIcons(cat! as NSString)
        print(categoryArray)
        if categoryArray .contains(selectedText!) {
            
            
            //let index2 = categoryArray.indexOfObject(selectedText!)
            
            
            
            var userArray = NSMutableArray()
            let st: AnyObject? = dataArray.object(at: 0) as AnyObject?
            
            
            
            
            
            if st is NSArray {
                // obj is a string array. Do something with stringArray
                print("array")
                
                
                
                
                userArray = dataArray
                
                
                if userArray.count<1 {
                    
                    
                    self.emptyView.isHidden=false
                    
                    
                }
                else
                {
                    
                    
                    
                    for i in 0..<userArray.count {
                        
                        //print(userArray)
                        
                        let tem = userArray.object(at: i) as! NSMutableArray
                        
                        photosArray .addObjects(from: tem as [AnyObject])
                        
                        // print(photosArray)
                        
                        let userImagesArr = NSMutableArray()
                        
                        userImagesArr .addObjects(from: (userArray.object(at: i) as AnyObject).value(forKey: "photos")! as! [AnyObject] )
                        
                        multiplePhotosArray .addObjects(from: userImagesArr as [AnyObject])
                        
                        let countDic: NSMutableDictionary = ["totalPhotos": (multiplePhotosArray.object(at: multiplePhotosArray.count-1) as AnyObject).count, "index":0]
                        indexCount .add(countDic)
                       
                        
                        print("multiImages array Count=====\(multiplePhotosArray.count)")
                        
                        
                        
                        //                        for j in 0..<userImagesArr.count {
                        //
                        //
                        //
                        //                        }
                        
                        
                        
                    }
                    
                    
                    
                    
                }
                self.tableOfIntrests .reloadData()
                
                
                
            }
                
            else {
                print("not array")
                photosArray.removeAllObjects()
                self.emptyView.isHidden=false
                
                // CommonFunctionsClass.sharedInstance().alertViewOpen("No content found", viewController: self)
                tableOfIntrests .reloadData()
                // obj is not a string array
            }
            
            
            
            
            
        }
            
        else
        {
            
        }
        
        
        
       
        
        MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
        
        
    }
    
    
    
    
    
    
    
    
    
    
     
    
    
    
    
    
    
    
    
    //////////-------Long Tap gesture------//////
    //MARK:- Long Tap
    //MARK:-
    
    func longTap(_ sender: UILongPressGestureRecognizer)-> Void {
        
        headerLabel.text=UserDefaults.standard.value(forKey: "selectedLocation") as? String ?? ""
        
        if sender.state == .began
        {
            
            let a:Int? = (sender.view?.tag)! / 1000
            let b:Int? = (sender.view?.tag)! % 1000
            
            
            
            index1 = a!
            index2 = b!
            
            longTapedView=sender.view!
            
            print(self.photosArray.object(at: index2))
            let imageId = (((self.photosArray.object(at: index2) as AnyObject).value(forKey: "photos")! as AnyObject).object(at: 0) as AnyObject).value(forKey: "photoId") as? String ?? ""
            let defaults = UserDefaults.standard
            let uId = defaults .string(forKey: "userLoginId")
            
            
            if countsDictionary.object(forKey: "storyImages") != nil  {
                
                let countst = countArray.value(forKey: "storyImages") as! NSArray
                addStoryLabelInPopup.text="Add To Plan"
                addToStory.image=UIImage (named: "selectionStory")
                
                if countst.count>0 {
                    
                    print(countst)
                    if countst.contains(imageId) {
                        
                        addStoryLabelInPopup.text="Remove From Plan"
                        addToStory.image=UIImage (named: "removeStory")
                        
                    }
                    
                    
                }
            }
            
            
            
            
            ///Bucket manage
            
            if countsDictionary.object(forKey: "bucketImages") != nil  {
                
                let countst = countArray.value(forKey: "bucketImages") as! NSArray
                addToBucketLblInPopup.text="Add To Bucket List"
                addToBucket.isUserInteractionEnabled=true
                
                if countst.count>0 {
                    
                    print(countst)
                    if countst.contains(imageId)
                    {
                        addToBucketLblInPopup.text="Remove From Bucket"
                        addToBucket.isUserInteractionEnabled=false
                    }
                    
                    
                }
            }
            
            
            
            
            
            
            //MANAGE Delete Image icon
            let source = (((self.photosArray .object(at: index2) as AnyObject).value(forKey: "photos")! as AnyObject).object(at: 0) as AnyObject).value(forKey: "source") as? String ?? " "
            print("Source ----\(source)")
//            deleteViewBottom.constant = -(deleteViewInDetail.frame.size.height)
//            deleteViewInDetail.isHidden=true
            
            
            
            
//            if source != NSNull() || source != ""  {
//                
//                
//                
//                if source == "PYT" {
//                    
//                    print(((((self.photosArray .object(at: index2) as AnyObject).value(forKey: "photos")! as AnyObject).object(at: 0) as AnyObject).value(forKey: "user")! as AnyObject).value(forKey: "_id")) //change "name" to _id if want to edit picture
//                    
//                    if ((((self.photosArray .object(at: index2) as AnyObject).value(forKey: "photos")! as AnyObject).object(at: 0) as AnyObject).value(forKey: "user")! as AnyObject).value(forKey: "name") as? String == uId! {
//                        
//                        print("Enter if match the user id")
//                        
//                        if deleteViewBottom.constant<9
//                        {
//                            deleteViewBottom.constant = 9
//                            deleteViewInDetail.isHidden=false
//                        }
//                        
//                        
//                        
//                    }
//                    
//                    
//                    
//                    
//                    
//                    ///can delete
//                    
//                }
//                
//                
//            }
            
            
            
            
            
            
            
            ///Like manage
            
            likeLabel.text="Like"
            likeImage.image=UIImage (named: "selectionLike")
            
            if (likeCount.value(forKey: "imageId") as AnyObject).contains(imageId) {
                let index = (self.likeCount.value(forKey: "imageId") as AnyObject).index(of: imageId)
                if (self.likeCount.object(at: index) as AnyObject).value(forKey: "like") as! Bool == true {
                    likeLabel.text="Unlike"
                    likeImage.image=UIImage (named: "unlikeSelection")
                }
                
                
            }
            
            
            
            self.detailSelectBtnAction(true)
        }
        
    }
    
    
    
    
    func tabBarController(_ aTabBar: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        //        if !self.hasValidLogin() && (viewController != aTabBar.viewControllers[0]) {
        //            // Disable all but the first tab.
        //            return false
        //        }
        
        
        print("---------------Its comes here------------------")
        return true
    }
    
    
    
    func detailSelectBtnAction(_ showView:Bool) -> Void
    {
        
        
        //// hide the view
        if showView==false {
            
            self.tabBarController?.tabBar.isHidden = false
            
            self.popUpView.isHidden = true
            
            let popUpView2 = popUpView
            //let centre : CGPoint = CGPoint(x: self.view.center.x, y: self.view.center.y)
            let centre : CGPoint = CGPoint(x: (self.tabBarController?.view.center.x)!, y: (self.tabBarController?.view.center.y)!)
            
            popUpView2?.center = centre
            popUpView2?.layer.cornerRadius = 0.0
            let trans = popUpView2?.transform.scaledBy(x: 1.0, y: 1.0)
            popUpView2?.transform = trans!
            self.view .addSubview(popUpView2!)
            UIView .animate(withDuration: 0.3, delay: 0.0, options:     UIViewAnimationOptions(), animations: {
                
                popUpView2?.transform = (popUpView2?.transform.scaledBy(x: 0.1, y: 0.1))!
                
                
                }, completion: {
                    (value: Bool) in
                    //popUpView .removeFromSuperview()
                    
                    
                    popUpView2?.transform = CGAffineTransform.identity
            })
            
            
            
            //self.tabBarController?.tabBar.userInteractionEnabled=true
            
            
            
        }
            
            ////Show the View
        else
        {
            
            self.tabBarController?.view.backgroundColor=UIColor.black
            
            self.popUpView.isHidden=false
            self.tabBarController?.tabBar.isHidden = true
            
            
            
            let popUpView2 = popUpView
            let centre : CGPoint = CGPoint(x: self.view.center.x, y: self.view.center.y)
            
            // let centre : CGPoint = CGPoint(x: (self.tabBarController?.view.center.x)!, y: (self.tabBarController?.view.center.y)!)
            
            popUpView2?.center = centre
            popUpView2?.layer.cornerRadius = 0.0
            let trans = popUpView2?.transform.scaledBy(x: 0.01, y: 0.01)
            popUpView2?.transform = trans!
            self.view .addSubview(popUpView2!)
            UIView .animate(withDuration: 0.3, delay: 0.0, options:     UIViewAnimationOptions(), animations: {
                
                popUpView2?.transform = (popUpView2?.transform.scaledBy(x: 100.0, y: 100.0))!//CGAffineTransformIdentity
                
                }, completion: {
                    (value: Bool) in
                    
                    
                    
            })
            ///------first End----/////
            
            
            
            
            self.tabBarController?.view.bringSubview(toFront: popUpView)
            
            
            let tapGestureRecognizer = UITapGestureRecognizer()
            tapGestureRecognizer.addTarget(self, action: #selector(intrestViewController.tempFunc))
            
            popUpView.addGestureRecognizer(tapGestureRecognizer)
            
            
            
            let tapGestureRecognizer2 = UITapGestureRecognizer(target:self, action:#selector(intrestViewController.storyImageTapped))
            addToStory.isUserInteractionEnabled = true
            addToStory.addGestureRecognizer(tapGestureRecognizer2)
            
            self.popUpView.bringSubview(toFront: addToStory)
            
            
            
            let tapGestureRecognizer3 = UITapGestureRecognizer(target:self, action:#selector(intrestViewController.likeImageTapped))
            likeImage.isUserInteractionEnabled = true
            likeImage.addGestureRecognizer(tapGestureRecognizer3)
            
            self.popUpView.bringSubview(toFront: likeImage)
            
            
            
            let tapGestureRecognizer4 = UITapGestureRecognizer(target:self, action:#selector(intrestViewController.bucketImageTapped))
            addToBucket.isUserInteractionEnabled = true
            addToBucket.addGestureRecognizer(tapGestureRecognizer4)
            
            self.popUpView.bringSubview(toFront: addToBucket)
            
            
            
            let tapGestureRecognizer5 = UITapGestureRecognizer(target:self, action:#selector(intrestViewController.deleteImageTapped))
            deleteImage.isUserInteractionEnabled = true
            deleteImage.addGestureRecognizer(tapGestureRecognizer5)
            
            self.popUpView.bringSubview(toFront: deleteImage)
            
            
            
            
            //self.tabBarController?.tabBar.userInteractionEnabled=false
            // self.tabBarController?.tabBar.alpha = 0.6
            
        }
        
        
        
        
    }
    
    
    //MARK:- Tap gesture functions to manage the popup view
    
    ///Temp function to
    func tempFunc() -> Void {
        
        self .detailSelectBtnAction(false)
        
    }
    
    ///story image tapped
    func storyImageTapped()
    {
        // Your action
        
        storyBucketBool=true
        
        print("Story image tapped")
        
        
        
        
       
      
        var imageId = NSString()
       
        
        let ownerId = ""//((((photosArray.object(at: index2) as AnyObject).value(forKey: "photos")! as AnyObject).value(forKey: "user")! as AnyObject).object(at: 0) as AnyObject).value(forKey: "_id") as? String ?? ""
        
        
        imageId = ""//(((photosArray[index2] as AnyObject).value(forKey: "photos")! as AnyObject).object(at: 0) as AnyObject).value(forKey: "photoId") as? String ?? ""
        
        
        
        self.detailSelectBtnAction(true)
        
        
     
        
        let headerType = UserDefaults.standard.value(forKey: "selectedLocationType") as? String ?? ""
        
        let defaults = UserDefaults.standard
        let uId = defaults .string(forKey: "userLoginId")
        
        
        
        
        
        
        
        let headerId = UserDefaults.standard.value(forKey: "selectedLocationId") as? String ?? ""
        
        let nxtObjMain = self.storyboard?.instantiateViewController(withIdentifier: "mainHomeViewController") as! mainHomeViewController
        
        if addStoryLabelInPopup.text=="Add To Plan" {
            
            let dat: NSDictionary = ["userId": "\(uId!)", "imageId": imageId, "placeId": headerId, "placeType": headerType, "ownerId": ownerId ]
            
            
            print("Post parameters to select the images for story--- \(dat)")
            self.proceedBtnAction(self)
            //add image to story
            apiClass.sharedInstance().postRequestWithMultipleImage(parameterString: "", parameters: dat, viewController: self)
            //storyCountLabel.text=String(nxtObjMain.addTheLikes(countst))
        }
            
        else
        {
            
         
            
            let dataStr: NSDictionary = ["userId": uId!, "imageId": imageId]
            print(dataStr)
            
           // apiClassStory.sharedInstance().postRequestDeleteStory(dataStr, viewController: self)
           // storyCountLabel.text=String(nxtObjMain.subtractTheLikes(countst))
            
        }
        
        
        self.tempFunc()
        
        
        
        
        
    }
    
    
    
    
    ///Like image tapped
    func likeImageTapped()
    {
        
        // Your action
        
        print("like image tapped")
        
    
        let defaults = UserDefaults.standard
        let uId = defaults .string(forKey: "userLoginId")
        let userNameMy = defaults.string(forKey: "userLoginName")
        let imageId = (photosArray[index2] as AnyObject).value(forKey: "id") as? String ?? ""
        let otherUserId = (photosArray[index2] as AnyObject).value(forKey: "userId") as? String ?? ""
        
        
        print("like image tapped")
        
        
        
        
        ///MANAGE LIKE View
        
        
        let likecountlbl = longTapedView.viewWithTag(7478) as! UILabel
        
        // hide and show the view of like
        
        
        let likeimg = longTapedView.viewWithTag(7477) as! UIImageView
        let nxtObjMain = self.storyboard?.instantiateViewController(withIdentifier: "mainHomeViewController") as! mainHomeViewController
        
        
        
        
        //MARK: LIKE COUNT MANAGE
        
        var countLik = NSNumber()
        
        if (self.photosArray.object(at: index2) as AnyObject).value(forKey: "likeCount") != nil  {
            
            countLik = (self.photosArray.object(at: index2) as AnyObject).value(forKey: "likeCount") as! NSNumber  //as? String ?? "0.0"
            
            
        }else
        {
            countLik=0
            
        }
        
        
        
        if likeCount.count>0 {
            if (likeCount.value(forKey: "imageId") as AnyObject).contains(imageId) {
                
                let index = (self.likeCount.value(forKey: "imageId") as AnyObject).index(of: imageId)
                
                if (likeCount.object(at: index) as AnyObject).value(forKey: "like") as! Bool == true {
                    
                    let staticCount = (likeCount.object(at: index) as AnyObject).value(forKey: "count") as? NSNumber
                    likecountlbl.text=String(nxtObjMain.subtractTheLikes(staticCount!))
                    
                    
                    likeCount .removeObject(at: index)
                    
                    likeCount .add(["userId":uId!, "imageId":imageId, "like":false, "count": nxtObjMain.subtractTheLikes(staticCount!)])
                    
                    
                    
                    
                    likeimg.image=UIImage (named: "like_count")
                    
                    let dat: NSDictionary = ["userId": "\(uId!)", "photoId":"\(imageId)", "userLiked":"\(uId!)", "status":"0", "imageOwn": "\(otherUserId)", "userName": "\(userNameMy!)"]
                    print("Post to like picture---- \(dat)")
                    apiClass.sharedInstance().postRequestLikeUnlikeImage(parameters: dat, viewController: self)
                    
                    
                }
                else
                {
                    let staticCount = (likeCount.object(at: index) as AnyObject).value(forKey: "count") as? NSNumber
                    likecountlbl.text=String(nxtObjMain.addTheLikes(staticCount!))
                    
                    likeCount .removeObject(at: index)
                    likeCount .add(["userId":uId!, "imageId":imageId, "like":true, "count": nxtObjMain.addTheLikes(staticCount!)])
                    
                    
                    print(likeCount.lastObject)
                    
                    likeimg.image=UIImage (named: "likedCount")
                    
                    let dat: NSDictionary = ["userId": "\(uId!)", "photoId":"\(imageId)", "userLiked":"\(uId!)", "status":"1", "imageOwn": "\(otherUserId)", "userName": "\(userNameMy!)"]
                    
                    
                    print("Post to like picture---- \(dat)")
                    
                    apiClass.sharedInstance().postRequestLikeUnlikeImage(parameters: dat, viewController: self)
                    
                    
                }
            }
                // if not liked already
            else{
                likeCount .add(["userId":uId!, "imageId":imageId, "like":true, "count": nxtObjMain.addTheLikes(countLik)])
                likecountlbl.text=String(nxtObjMain.addTheLikes(countLik))
                likeimg.image=UIImage (named: "likedCount")
                
                let dat: NSDictionary = ["userId": "\(uId!)", "photoId":"\(imageId)", "userLiked":"\(uId!)", "status":"1", "imageOwn": "\(otherUserId)", "userName": "\(userNameMy!)"]
                
                
                print("Post to like picture---- \(dat)")
                
                apiClass.sharedInstance().postRequestLikeUnlikeImage(parameters: dat, viewController: self)
                
            }
            
        }
            
        else
            
        {
            
            likeCount .add(["userId":uId!, "count":nxtObjMain.addTheLikes(countLik), "like": true, "imageId": imageId])
            likecountlbl.text=String(nxtObjMain.addTheLikes(countLik))
            likeimg.image=UIImage (named: "likedCount")
            
            let dat: NSDictionary = ["userId": "\(uId!)", "photoId":"\(imageId)", "userLiked":"\(uId!)", "status":"1", "imageOwn": "\(otherUserId)", "userName": "\(userNameMy!)"]
            
            
            print("Post to like picture---- \(dat)")
            
            apiClass.sharedInstance().postRequestLikeUnlikeImage(parameters: dat, viewController: self)
        }
        
        
        
        
        
        self.tempFunc()
        
        
        
    }
    
    
    
    ///bucket image tapped
    func bucketImageTapped()
    {
        // Your action
        
        storyBucketBool=false // add to bucket
        print("bucket image tapped")
        
        
        
        
        
        var imageId = NSString()
        var otherUserId = NSString()
        
        
        
        
        
        imageId = ""//(((self.photosArray.object(at: index2) as! NSDictionary).value(forKey: "photos")! as AnyObject).object(at: 0) as AnyObject).value(forKey: "photoId") as? String ?? ""
        
        otherUserId = "" //((((self.photosArray.object(at: index2) as AnyObject).value(forKey: "photos")! as AnyObject).value(forKey: "user")! as AnyObject).object(at: 0) as AnyObject).value(forKey: "_id") as? String ?? ""
        
        
        
        self.detailSelectBtnAction(true)
        
        
        
        
        let defaults = UserDefaults.standard
        let uId = defaults .string(forKey: "userLoginId")
        
        
        
        var countst = NSNumber()
        countst = 0
        
        
        if addToBucketLblInPopup.text=="Add To Bucket List"
        {
            
            let parameterDic: NSDictionary = ["userId": uId!,"imageOwn": otherUserId, "imageId": imageId ]
            
            print("parameter of add t0 bucket=\(parameterDic)")
            
            MBProgressHUD.showAdded(to: self.view, animated: true)
            
            //add image to bucket
           // bucketListApiClass.sharedInstance().postRequestForAddBucket(parameterDic, viewController: self)
            self.proceedBtnAction(self)
            
        }
            
        else
        {
            
            //delete from bucket
            
            let parameter: NSDictionary = ["userId": uId!, "imageId": imageId]
            
           // bucketListApiClass.sharedInstance().postRequestForDeletBucketListFromFeed(parameter, viewController: self)
            
            
        }
        
        
        self.tempFunc()
        
        
        
        
    }
    
    
    //MARK: delete image tapped
    //MARK:
    func deleteImageTapped()
    {
        // Your action
        
        self.tempFunc()
        
        
      //  let nxtObj2 = self.storyboard?.instantiateViewController(withIdentifier: "imageEditViewController") as! imageEditViewController
        //nxtObj2.screenName = "Interest"
        
        
        
       // print(self.photosArray.objectAtIndex(self.index2))
        
        
        //self.navigationController! .pushViewController(nxtObj2, animated: true)
        
        
        
        
        
        
    }
    
    
    
    func deletImageManage()
    {
    
        
        let strarr = self.categId .object(at: 0) //.componentsJoinedByString(",")
        let type = UserDefaults.standard.value(forKey: "selectedLocationType") as? String ?? ""
        
        let defaults = UserDefaults.standard
        let uId = defaults .string(forKey: "userLoginId")
        let headerText = UserDefaults.standard.value(forKey: "selectedLocation") as? String ?? ""
        
        let parameterString = "userId=\(uId!)&placeName=\(headerText)&placeType=\(type)&category=\(strarr)"//testing
        print(parameterString)
        self.interestCase=true
        
        //hit the api for shorted interests from web
        
        //apiClassInterest.sharedInstance().postRequestInterestWiseData(parameterString, viewController: self)
        //self.segMentManage()
        
        
        
        
        
        
        
        /*
         //print(photosArray)
         print(index2)
         print(index1)
         
         print(allCategoryDictionary.allKeys)
         print(allCategoryDictionary)
         
         
         
         var tempArr = NSMutableArray()
         tempArr = allCategoryDictionary.valueForKey(String(categId .objectAtIndex(index2)) ) as! NSMutableArray
         
         print(tempArr.objectAtIndex(0))
         
         // photosArray .removeObjectAtIndex(index2)
         // print(photosArray)
         
         let phoArr: NSMutableArray = tempArr.objectAtIndex(0) as! NSMutableArray
         
         print(phoArr)
         print(phoArr.count)
         
         phoArr .removeObjectAtIndex(0)
         
         
         tempArr.objectAtIndex(0) .replaceObjectAtIndex(index2, withObject: phoArr)
         
         let indexPath = NSIndexPath(forRow: index2, inSection: 0)
         
         tableOfIntrests.deselectRowAtIndexPath(indexPath, animated: true)
         
         
         self.allCategoryDictionary .setObject(tempArr, forKey: String(categId.objectAtIndex(segmentControl.selectedSegmentIndex)))
         
         let index = self.segmentControl.selectedSegmentIndex
         
         
         
         
         
         
         
         if tempArr.objectAtIndex(0).count == 0 {
         
         tempArr.objectAtIndex(0) .replaceObjectAtIndex(index, withObject: "")
         
         
         }
         
         print(tempArr)
         
         // else{
         
         // tempArr.objectAtIndex(index).removeObjectAtIndex(index2)
         
         // }
         
         
         
         
         self .shortData(tempArr)
         */
        
    }
    
    
    
    
    
    
    //MARK: Pull to refresh
    
    func refreshInterest(_ sender:AnyObject)
    {
        
        
    }
    
    
    
    
    func proceedBtnAction(_ sender: AnyObject)
    {
        
        
        let indexPathTable = IndexPath(row: index2, section: 0)
        
        
//        let cell : IntrestTableViewCell =  tableOfIntrests.cellForRow(at: indexPathTable)! as! IntrestTableViewCell
//        // grab the imageview using cell
//        
//        let imgV = cell.museumImage as UIImageView
//        
//        
//        
//        
//        // get the exact location of image
//        var rect : CGRect =  imgV.superview!.convert(imgV.frame, from: nil)
//        rect = CGRect(x: self.view.frame.size.width/2, y: (rect.origin.y * -1)-10, width: imgV.frame.size.width, height: imgV.frame.size.height)
//        print(String.localizedStringWithFormat("rect is %f %f %f %f", rect.origin.x,rect.origin.y,rect.size.width,rect.size.height ))
//        
//        // create new duplicate image
//        let starView : UIImageView = UIImageView(image: imgV.image)
//        starView.frame = rect //CGRectMake(imgV.frame.origin.x, imgV.frame.origin.y, 70, 70)
//        starView.frame.size.height=50
//        starView.frame.size.width=50
//        starView.layer.cornerRadius=5;
//        starView.layer.borderWidth=1;
//        
//        self.view.addSubview(starView)
//        
//        
//        var rect2 : CGRect =  starView.superview!.convert(starView.frame, from: nil)
//        
//        
//        
//        
//        
//        var endPoint = CGPoint()
//        
//        if storyBucketBool == true { //Add to story
//            rect2 = CGRect(x: 5, y: (rect2.origin.y * -1)-10, width: starView.frame.size.width, height: starView.frame.size.height)
//            endPoint = CGPoint(x: 30, y: 30)
//        }
//        else
//        { //Add to bucket
//            let fltV: CGFloat = self.view.frame.size.width-30
//            rect2 = CGRect(x: self.view.frame.size.width - 6, y: (rect2.origin.y * -1)-10, width: starView.frame.size.width, height: starView.frame.size.height)
//            endPoint = CGPoint(x: fltV, y: 30)
//        }
//        
//        
//        
//        
//        
//        
//        // create a new CAKeyframeAnimation that animates the objects position
//        
//        let pathAnimation = CAKeyframeAnimation(keyPath: "position")
//        pathAnimation.calculationMode = kCAAnimationPaced
//        pathAnimation.fillMode = kCAFillModeForwards
//        pathAnimation.isRemovedOnCompletion = false
//        pathAnimation.duration = 1.0
//        pathAnimation.delegate=self
//        
//        let curvedPath:CGMutablePath = CGMutablePath()
//        CGPathMoveToPoint(curvedPath, nil, CGFloat(1.0), CGFloat(1.0))
//        CGPathMoveToPoint(curvedPath, nil, starView.frame.origin.x, starView.frame.origin.y)
//        CGPathAddCurveToPoint(curvedPath, nil, endPoint.x, starView.frame.origin.y, endPoint.x, starView.frame.origin.y, endPoint.x, endPoint.y)
//        pathAnimation.path = curvedPath
//        
//        // apply transform animation
//        let basic : CABasicAnimation = CABasicAnimation(keyPath: "transform");
//        let transform : CATransform3D = CATransform3DMakeScale(2,2,1 ) //0.25, 0.25, 0.25);
//        basic.setValue(NSValue(caTransform3D: transform), forKey: "scaleText");
//        basic.duration = 1.0
//        
//        starView.layer.add(pathAnimation, forKey: "curveAnimation")
//        starView.layer.add(basic, forKey: "transform");
//        
//        let control: UIControl = UIControl()
//        
//        let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(1.15 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
//        DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
//            
//            // imgV .removeFromSuperview()
//            
//            control.sendAction(#selector(UIView.removeFromSuperview), to: starView, for: nil)
//            //            control.sendAction(#selector(mainHomeViewController.reloadBadgeNumber), to: self, forEvent: nil)
//        })
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    //
    //    func serverResponseArrived(Response:AnyObject)
    //    {
    //
    //
    //        jsonMutableArray = NSMutableArray()
    //        jsonMutableArray = Response as! NSMutableArray
    //
    //        tagsArr = jsonMutableArray
    //        let defaults = NSUserDefaults.standardUserDefaults()
    //        defaults .setValue(tagsArr, forKey: "categoriesFromWeb")//
    //        self.categoryBtnAction(self)
    //        
    //    }
    
    
    
    
    
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








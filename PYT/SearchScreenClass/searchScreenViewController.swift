//
//  searchScreenViewController.swift
//  PYT
//
//  Created by osx on 16/06/17.
//  Copyright © 2017 osx. All rights reserved.
//

import UIKit
import CoreLocation
import IQKeyboardManager
import SDWebImage


var selectedindxSearch = Int()

class searchScreenViewController: UIViewController, UINavigationControllerDelegate, UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet var heightOfcontentView: NSLayoutConstraint!
    
    //SEARCH BAR VIEW
    @IBOutlet weak var search_Bar: UISearchBar!
    
    //search cancelButton
    @IBOutlet weak var cancelButtonSearch: UIButton!
    @IBOutlet weak var cancelWidth: NSLayoutConstraint!
    
    
    
    //BannerSearch top bar when searching
    
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet var menuButton: UIButton!
    @IBOutlet weak var topSpaceofView: NSLayoutConstraint!
    
    
    
    //indicator objects
    var messageFrame = UIView()
    var activityIndicator = UIActivityIndicatorView()
    var strLabel = UILabel()
    
    
    var trendingArray = NSMutableArray()
    var popularArray = NSMutableArray()
    var arrayOfIntrest = NSMutableArray()
    
    
    
    @IBOutlet var trendingLabel: UILabel!
    @IBOutlet weak var bloggerslabel: UILabel!
    
    
    @IBOutlet weak var scrollMainView: UIScrollView!
    @IBOutlet weak var scrollFirstView: UIView!
    
    
    
    
    @IBOutlet weak var trendingPlacesCollectionView: UICollectionView!
    
    @IBOutlet weak var bloggersCollectionView: UICollectionView!
    
    
    
    
    //Autoprompt view
    
    @IBOutlet weak var autoPromptTable: UITableView!
    @IBOutlet weak var autoPromptView: UIView!
    
   // @IBOutlet weak var heightofPromptTableview: NSLayoutConstraint!
    
    @IBOutlet weak var topSpaceOfAutoPrompt: NSLayoutConstraint!
    
    
    
    
    
    @IBOutlet weak var promptIndicator: UIActivityIndicatorView!
    var task = URLSessionTask()
    var promptArray = NSMutableArray()
    var locationAutoPrompt = NSString()
    var locationType = NSString()
    var locationId = NSString()
    
    
    //Buttons
    @IBOutlet weak var button1: CustomButton!
    @IBOutlet weak var button2: CustomButton!
    @IBOutlet weak var button3: CustomButton!
    @IBOutlet weak var button4: CustomButton!
    @IBOutlet weak var button5: CustomButton!
    
    //black labels
    @IBOutlet weak var btn1Overlay: GradientView!
    @IBOutlet weak var btn2Overlay: GradientView!
    @IBOutlet weak var btn3Overlay: GradientView!
    @IBOutlet weak var btn4Overlay: GradientView!
    @IBOutlet weak var btn5Overlay: GradientView!
    
    //Cross buttons
    @IBOutlet weak var deleteBtn1: CustomButton!
    @IBOutlet weak var deleteBtn2: CustomButton!
    @IBOutlet weak var deleteBtn3: CustomButton!
    @IBOutlet weak var deleteBtn4: CustomButton!
    @IBOutlet weak var deleteBtn5: CustomButton!
    
    //Labels outlet
    
    var buttonPressedTag = Int()
    
    @IBOutlet weak var locLabel1: UILabel!
    @IBOutlet weak var locLabel2: UILabel!
    @IBOutlet weak var locLabel3: UILabel!
    @IBOutlet weak var locLabel4: UILabel!
    @IBOutlet weak var locLabel5: UILabel!
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        IQKeyboardManager.shared().isEnableAutoToolbar=false
        IQKeyboardManager.shared().shouldResignOnTouchOutside=true
        
        btn1Overlay.gradientLayer.colors = [UIColor.black.withAlphaComponent(0.5).cgColor, UIColor.clear.cgColor]
        btn1Overlay.gradientLayer.gradient = GradientPoint.bottomTop.draw()
        btn2Overlay.gradientLayer.colors = [UIColor.black.withAlphaComponent(0.5).cgColor, UIColor.clear.cgColor]
        btn2Overlay.gradientLayer.gradient = GradientPoint.bottomTop.draw()
        btn3Overlay.gradientLayer.colors = [UIColor.black.withAlphaComponent(0.5).cgColor, UIColor.clear.cgColor]
        btn3Overlay.gradientLayer.gradient = GradientPoint.bottomTop.draw()
        btn4Overlay.gradientLayer.colors = [UIColor.black.withAlphaComponent(0.5).cgColor, UIColor.clear.cgColor]
        btn4Overlay.gradientLayer.gradient = GradientPoint.bottomTop.draw()
        btn5Overlay.gradientLayer.colors = [UIColor.black.withAlphaComponent(0.5).cgColor, UIColor.clear.cgColor]
        btn5Overlay.gradientLayer.gradient = GradientPoint.bottomTop.draw()

        
        
        
        
        
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        blurEffectView.alpha = 0.8
        blurEffectView.frame = autoPromptView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        autoPromptView.addSubview(blurEffectView)
        self.autoPromptView .bringSubview(toFront: autoPromptTable)
        self.autoPromptView.bringSubview(toFront: search_Bar)
        self.autoPromptView.bringSubview(toFront: cancelButtonSearch)
        
        
        
        
        
        
        
        
        // bloggerslabel.attributedText=attributedTextClass().setAttributeRobotLight("  Travel Gurus\n", text1Size: 16, text2: "  Inspiration from the best travel bloggers", text2Size: 15)
        
        
        
        
        self.automaticallyAdjustsScrollViewInsets = false //adjust navigation bar
        
        //disable pop of navigation
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        
        
       //  DispatchQueue.main.async {
        
        //////////------- temp handle intrets:
        
       
        
        let tabledata2 = UserDefaults.standard.array(forKey: "arrayOfIntrest")
        
        
        
        if (tabledata2?.count)!<1
        {
            //do nothing
            
            
        }
        else
        {
            let tabledata:NSMutableArray = [UserDefaults.standard.array(forKey:"arrayOfIntrest")!]
            
            for i in 0..<(tabledata[0] as AnyObject).count
            {
                
                var srrObj = NSMutableDictionary()
                print((tabledata[0] as AnyObject).object(at: i))
                srrObj = (tabledata[0] as AnyObject).object(at: i) as! NSMutableDictionary //((tabledata[0] as AnyObject) .object(i) as! NSMutableDictionary).mutableCopy() as! NSMutableDictionary
                print(srrObj)
                
                self.arrayOfIntrest .add(srrObj.mutableCopy())
                print(self.arrayOfIntrest)
                self.setLocationInButtons(btnTag: i)
                
                
                
            }
            
        }
        
        
        
        
        
        
        
        
        
        let uId = Udefaults .string(forKey: "userLoginId")
        
        
        
        //get the trending places here
        
        let trendingDataSaved = UserDefaults.standard.object(forKey: "arrayOfTrending")
        
        let popularSaved = UserDefaults.standard.object(forKey: "arrayOfPopular")
        
        
        if (trendingDataSaved != nil && popularSaved != nil) {
            
            self.trendingArray=NSMutableArray(array: trendingDataSaved as! NSArray)
            self.popularArray=NSMutableArray(array: popularSaved as! NSArray)
            // self.updateTrending()
            self.trendingPlacesCollectionView.reloadData()
            self.showPopular()
            
            self.adjustHeightOftableView()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                self.postApiForTrendingLocationsSearch(userid: uId! as NSString)
                //apiClassInterest.sharedInstance().postApiForTrendingLocations(self, userid: uId!)
            }
            
        }
        else
        {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.postApiForTrendingLocationsSearch(userid: uId! as NSString)
                
            } //api to get the trending and popular places
            
        }
        
        
        
        
        self.adjustHeightOftableView()
        
        URLCache.shared.removeAllCachedResponses()//clear cache
        
        
        
        self.navigationController?.isNavigationBarHidden = true
        
        //self.tabBarController?.setTabBarVisible(visible: false, animated: true)
        self.tabBarController?.tabBar.isHidden = true
        
        
        
        selectedindxSearch=0
        
        
        
        // }
        
        
        
        
        
        
        //NotificationCenter.defaultCenter.addObserver(self, selector: #selector(firstMainScreenViewController.keyboardDidHide(_:)), name: UIKeyboardDidHideNotification, object: nil) //uncomment this
        
        
        
        //MANAGE DEVICETOKEN
        
        let tokendevice = Udefaults.string(forKey: "deviceToken")!
        print(tokendevice)
        // let uId = Udefaults .string(forKey: "userLoginId")
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
                
                self.postApiFordeviceToken(param: parameterDict)
                
            }
            
        }
        
        
        button1.tag = 0
        button1.addTarget(self, action: #selector(self.searchLocationAction(_:)), for: UIControlEvents.touchUpInside)
        deleteBtn1.addTarget(self, action: #selector(self.deleteLocation(sender:)), for: .touchUpInside)
        
        button2.tag = 1
        button2.addTarget(self, action: #selector(self.searchLocationAction(_:)), for: UIControlEvents.touchUpInside)
        deleteBtn2.addTarget(self, action: #selector(self.deleteLocation(sender:)), for: .touchUpInside)
        
        button3.tag = 2
        button3.addTarget(self, action: #selector(self.searchLocationAction(_:)), for: UIControlEvents.touchUpInside)
        deleteBtn3.addTarget(self, action: #selector(self.deleteLocation(sender:)), for: .touchUpInside)
        
        button4.tag = 3
        button4.addTarget(self, action: #selector(self.searchLocationAction(_:)), for: UIControlEvents.touchUpInside)
        deleteBtn4.addTarget(self, action: #selector(self.deleteLocation(sender:)), for: .touchUpInside)
        
        button5.tag = 4
        button5.addTarget(self, action: #selector(self.searchLocationAction(_:)), for: UIControlEvents.touchUpInside)
        deleteBtn5.addTarget(self, action: #selector(self.deleteLocation(sender:)), for: .touchUpInside)
        
        
        
        bloggersCollectionView.reloadData()
        
        
        
        

    }
    
    override func viewDidDisappear(_ animated: Bool)
    {

        
        //  UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        
    }
    
    
    
    //MARK:- ViewDidLoad method
    //MARK:-
    
    
    override func viewDidLoad()
    {
        
        
        super.viewDidLoad()
        
        
        locationAutoPrompt = "Empty"
        autoPromptTable.rowHeight = 50
        
        
        search_Bar.layer.cornerRadius = 0.0
        search_Bar.clipsToBounds = true
        search_Bar.barTintColor = UIColor .clear
        //[self.searchBar setReturnKeyType:UIReturnKeyDone];
        search_Bar.returnKeyType = UIReturnKeyType .done
        search_Bar.showsCancelButton = false
        cancelWidth.constant = 0
        search_Bar.delegate = self
        
        
        self.manageContentOfButtons()
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    func keyboardDidHide(notif: NSNotification) {
        
        if promptArray.count<1
        {
            // self.hideTheView()
            self.scrollMainView.isScrollEnabled=true
            promptArray.removeAllObjects()
            autoPromptTable .reloadData()
        }
        
    }
    
    
    //MARK: Hide and unhide the view wwhen start typing
    
    
     func hideTheView() {
     
     UIView.animate(withDuration: 0.4, animations: {() -> Void in
     self.topSpaceOfAutoPrompt.constant = 200
     self.autoPromptView.isHidden=true
     self.search_Bar.showsCancelButton = false
     self.cancelWidth.constant = 0
     self.view.layoutIfNeeded()
     })
     }
     
     
     func showTheView()
     {
     UIView.animate(withDuration: 0.6, animations: {() -> Void in
     self.autoPromptView.isHidden=false
     self.topSpaceOfAutoPrompt.constant = 0
     self.search_Bar.showsCancelButton = false
     self.cancelWidth.constant = 43
     self.promptIndicator.isHidden=true
     self.autoPromptTable.contentInset = UIEdgeInsetsMake(0, 0, 10, 0)
     
        self.promptArray = self.popularArray
        self.autoPromptTable .reloadData()
        
        self.view.layoutIfNeeded()
     })
     
     
     }
     
    
    
    
    
    //MARK:
    //MARK:- Update the height of TableView Rows with increase of intrests
    
    func adjustHeightOftableView() -> Void
    {
        
                  self.heightOfcontentView.constant = 950 //
            
            UserDefaults.standard.set(arrayOfIntrest, forKey: "arrayOfIntrest")
            
        
                  UserDefaults.standard.set(arrayOfIntrest, forKey: "arrayOfIntrest")
            
        
        
        
        
    }
    
    
    
  
    
    
    
    //MARK:
    //MARK: Collection View Delegates And Datasource
    //MARK:
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int   {
        return 1
    }
    
    

    
    func collectionView(_ collectionView: UICollectionView,numberOfItemsInSection section: Int) -> Int
    {
        if collectionView == trendingPlacesCollectionView{
            return trendingArray.count
        }
        else{
            return 4
        }
        
    }
    
    
    
    
    internal func collectionView(_ collectionView: UICollectionView,cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        
        
        if collectionView == trendingPlacesCollectionView {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "trendingCell",for: indexPath as IndexPath) as! locationsCell
            
            
        var nameSt = (trendingArray.object(at: indexPath.row) as! NSDictionary).value(forKey: "fullName") as?  String ?? " " // trendingArray.objectAtIndex(indexPath.row).valueForKey("fullName") as? String ?? " "
            
            
            let ArrToSeperate = nameSt .components(separatedBy: ",")
            if ArrToSeperate.count>0
            {
                nameSt=ArrToSeperate[0] as String
            }
            
            
            
            let pImage : UIImage = UIImage(named:"Profile")! //placeholder image
            let imageLoc = (trendingArray.object(at: indexPath.row) as! NSDictionary).value(forKey: "imageLarge") as? String ?? " " //objectAtIndex(indexPath.row).valueForKey("imageLarge") as? String ?? ""
            
            let url = NSURL(string: imageLoc as String)
            
            
            
            cell.locationLabel.text=nameSt
            
            cell.locationImage.sd_setImage(with: url as! URL, placeholderImage: pImage)
            // cell.locationImage.sd_setImage(with: url, placeholderImage: pImage)
            
            
            cell.locationImage.contentMode = .scaleToFill
            cell.locationImage.layer.cornerRadius=0
            cell.locationImage.clipsToBounds=true
            
            cell.gradientView.gradientLayer.colors = [UIColor.black.cgColor, UIColor.clear.cgColor]
            cell.gradientView.gradientLayer.gradient = GradientPoint.bottomTop.draw()
            
            
            return cell
            
        }
        else
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bloggerCell",for: indexPath as IndexPath) as! BloggersCell
            
            
            cell.contentViewInBlooger.layer.shadowColor = UIColor.lightGray.cgColor
            cell.contentViewInBlooger.layer.shadowOpacity = 1
            cell.contentViewInBlooger.layer.shadowOffset = CGSize.zero
            cell.contentViewInBlooger.layer.shadowRadius = 2
            cell.contentViewInBlooger.layer.shadowPath = UIBezierPath(rect: cell.contentViewInBlooger.bounds).cgPath
            cell.contentViewInBlooger.layer.shouldRasterize = true
            
            
            
            
            cell.userNameLbl.text = "Blogger Name"
            cell.userImageProfile.layer.cornerRadius = cell.userImageProfile.frame.size.width/2
            cell.locationImage.contentMode = .scaleAspectFill
            //cell.locationImage.layer.masksToBounds = true
            cell.locationImage.clipsToBounds = true
            
            if indexPath.row == 0 {
                cell.locationImage.image = UIImage (named: "dummyBackground1")
                cell.userImageProfile.image = UIImage (named: "dummyProfile1")
            }
            else if indexPath.row == 1
            {
                cell.userImageProfile.image = UIImage (named: "dummyProfile2")
                cell.locationImage.image = UIImage (named: "dummyBackground2")
            }
            else{
                cell.userImageProfile.image = UIImage (named: "dummyProfile1")
                cell.locationImage.image = UIImage (named: "dummyBackground1")
            }
            
            cell.userImageProfile.contentMode = .scaleAspectFill
         
            cell.userImageProfile.clipsToBounds = true
            
            cell.layoutSubviews()
            cell.setNeedsLayout()
            
            return cell
        }
        
        
        
        
        
    }
    
    
    
    
    
    // MARK: UICollectionViewDelegateFlowLayout
    //MARK:
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == trendingPlacesCollectionView{
            
            print(trendingPlacesCollectionView.frame.height)
            
            let width1 = collectionView.frame.size.width/1.16
            let height3: CGFloat = trendingPlacesCollectionView.frame.height 
            
            return CGSize(width: width1 , height: height3)
            
        }
        else
        {
            
            let width1 = collectionView.frame.size.width/2.2
            let height3: CGFloat = bloggersCollectionView.frame.size.height
            
            return CGSize(width: width1 , height: height3)
        }
        

        
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        
        if collectionView == trendingPlacesCollectionView{
            
            print(trendingPlacesCollectionView.frame.height)
            
            let width1 = collectionView.frame.size.width/1.16
            let height3: CGFloat = trendingPlacesCollectionView.frame.height
            
            return CGSize(width: width1 , height: height3)
            
        }
        else
        {
            
            let width1 = collectionView.frame.size.width/2.2
            let height3: CGFloat = bloggersCollectionView.frame.size.height
            
            return CGSize(width: width1 , height: height3)
        }
        
        
        
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        // return UIEdgeInsetsMake(0,8,0,8);  // top, left, bottom, right
        return UIEdgeInsetsMake(0, 4, 0, 4)
        // top, left, bottom, right
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        if collectionView == trendingPlacesCollectionView{
            
            var locationSt = ((trendingArray.object(at: indexPath.row)) as AnyObject).value(forKey: "fullName") as? String ?? "" //trendingArray.objectAtIndex(indexPath.row).valueForKey("fullName") as? String ?? ""
            
            let ArrToSeperate = locationSt .components(separatedBy: ",")
            if ArrToSeperate.count>0 {
                locationSt=ArrToSeperate[0] as String
            }
            
            let fullName = ((trendingArray.object(at: indexPath.row)) as AnyObject).value(forKey: "fullName") as? String ?? ""//trendingArray.objectAtIndex(indexPath.row).valueForKey("fullName") as? String ?? ""
            
            
            
            let typelo = ((trendingArray.object(at: indexPath.row)) as AnyObject).value(forKey: "type") as? String ?? ""//trendingArray.objectAtIndex(indexPath.row).valueForKey("type") as? String ?? ""
            
            let locId = ((trendingArray.object(at: indexPath.row)) as AnyObject).value(forKey: "_id") as? String ?? ""//trendingArray.objectAtIndex(indexPath.row).valueForKey("_id") as? String ?? ""
            
            
            
            var containBool = Bool()
            
            for diction in arrayOfIntrest {
                let dic2 =  diction as! NSDictionary
                print(dic2)
                if dic2["placeId"]as? String == locId
                {
                    print("contains")
                    
                  //  CommonFunctionsClass.sharedInstance().showAlert(title: "Opps!", text: "Please enter different name.", imageName: "alertFill")
                    
                    self.messageFrame.removeFromSuperview()
                    containBool = true
                    var indexTre = Int()
                    
                    indexTre = arrayOfIntrest.index(of: diction)
                    print(indexTre)
                    print(arrayOfIntrest)
                    selectedindxSearch=indexTre
                    
                    self.nextPageAction(sender: self)
                    
                    
                    break
                }
                
                
            }
            
            
            
            
            
            
//            if (arrayOfIntrest .value(forKey: "placeId") as AnyObject).contains(locId) {
//                
//                // CommonFunctionsClass.sharedInstance().alertViewOpen("Already selected", viewController: self)
//                var indexTre = Int()
//                
//                indexTre = 0//(arrayOfIntrest.value(forKey: "placeId") as AnyObject).index(locId)
//                print(indexTre)
//                print(arrayOfIntrest)
//                selectedindxSearch=indexTre
//                
//                self.nextPageAction(sender: self)
//                
//            }
//                
//            else

            
            if containBool == false {
        
                        let imageLoc = ""// trendingArray.objectAtIndex(indexPath.row).valueForKey("imageLarge") as? String ?? ""
                
                if arrayOfIntrest.count<5 {
                    
                    
                    
                    var dic = NSMutableDictionary()
                    // dic = ["location":locationSt,"lat": "0.0", "long": "0.0", "type": "country", "country": locationSt, "delete":false]
                    
                    dic = ["location":locationSt, "type": typelo, "placeId":"\(locId)",  "delete":false, "fullName": fullName, "imageUrl": imageLoc ]
                    print(dic)
                    
                    self.arrayOfIntrest .insert(dic, at: 0)
                     UserDefaults.standard.set(arrayOfIntrest, forKey: "arrayOfIntrest")
                    print(self.arrayOfIntrest)
                    
                    
                    
                    
                    //self.nextPageAction(sender: self)
                    //self .adjustHeightOftableView()
                }
                    
                    
                    
                    
                    
                    
                    //More than 5
                else
                {
                    
                    
                    var containBool2 = Bool()
                    
                    for diction in trendingArray {
                        let dic2 =  diction as! NSDictionary
                        print(dic2)
                        if dic2["_id"]as? String == locId
                        {
                            print("contains")
                            
                           
                            containBool = true
                            var indexTre = Int()
                            
                            indexTre = arrayOfIntrest.index(of: diction)
                            print(indexTre)
                            print(arrayOfIntrest)
                            arrayOfIntrest .removeObject(at: indexTre)
                            
                            var dic = NSMutableDictionary()
                            
                            
                            dic = ["location":locationSt, "type": typelo, "placeId":"\(locId)",  "delete":false, "fullName": fullName, "imageUrl": imageLoc ]
                            print(dic)
                            
                            self.arrayOfIntrest .insert(dic, at: 0)
                            
                            
                            selectedindxSearch=0
                            containBool2 = true
                            
                            break
                        }
                        
                        
                    }
                    
                    
                    
                    if containBool2 == false {
                        print(trendingArray.count)
                        
                       // for i in 0..<trendingArray.count {
                            
                          //  if i == trendingArray.count - 1 {
                                
                                // if not contain any trending
                                arrayOfIntrest.removeLastObject()
                                selectedindxSearch=0
                                
                                var dic = NSMutableDictionary()
                                
                                dic = ["location":locationSt, "type": typelo, "placeId":"\(locId)",  "delete":false, "fullName": fullName, "imageUrl": imageLoc ]
                                print(dic)
                                self.arrayOfIntrest .insert(dic, at: 0)
                                //self.nextPageAction(sender: self)
                                
                                
                            //}
                       // }
                        
                        
                    }
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    /*
                    for i in 0..<trendingArray.count {
                        
                        let locId2 = ((trendingArray.object(at: indexPath.row)) as AnyObject).value(forKey: "_id") as? String ?? ""//trendingArray.objectAtIndex(i).valueForKey("_id") as? String ?? ""
                        
                        if (arrayOfIntrest .value(forKey: "placeId") as AnyObject).contains(locId2) {
                            
                            var indexTre = Int()
                            indexTre = 0 //arrayOfIntrest.valueForKey("placeId").indexOfObject(locId2)
                            arrayOfIntrest.removeObject(at: indexTre)
                            selectedindxSearch=indexTre
                            
                            
                            
                            var dic = NSMutableDictionary()
                            
                            
                            dic = ["location":locationSt, "type": typelo, "placeId":"\(locId)",  "delete":false, "fullName": fullName, "imgLink": imageLoc ]
                            print(dic)
                            
                            self.arrayOfIntrest .insert(dic, at: 0)
                            
                            
                            
                            self.nextPageAction(sender: self)
                            break
                        }
                        else{
                            
                            if i == trendingArray.count - 1 {
                                
                                // if not contain any trending
                                arrayOfIntrest.removeLastObject()
                                selectedindxSearch=0
                                
                                var dic = NSMutableDictionary()
                                
                                dic = ["location":locationSt, "type": typelo, "placeId":"\(locId)",  "delete":false, "fullName": fullName, "imgLink": imageLoc ]
                                print(dic)
                                self.arrayOfIntrest .insert(dic, at: 0)
                                self.nextPageAction(sender: self)
                                
                                
                            }
                            
                        }
                        
                        
                        
                        
                    } */
                    
                    
                    
                    
                    
                    
                    
                    
                }
                
                
            }
            
            
        }
        
        
        
    }
    
    
    
    
    
    func removeSearchLocation(sender: UIButton) {
        
        
        SweetAlert().showAlert("Are you sure?", subTitle: "Once deleted, these locations will not appear in your list.", style: AlertStyle.customImag(imageFile: "alertDelete"), buttonTitle:"Okay", buttonColor: UIColor .clear , otherButtonTitle:  "Cancel", otherButtonColor: UIColor .clear) { (isOtherButton) -> Void in
            if isOtherButton == true {
                
                self.arrayOfIntrest .removeObject(at: sender.tag)
                self.adjustHeightOftableView()
                
            }
            else {
                
                print("Cancel Pressed")
            }
        }
        
        
        
        
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    //MARK:
    //MARK: Search Bar Delegates
    //MARK:
    
    
    
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
        print("Enter")
        
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        
        
        print("Search bar did begin editing method called")
        
        if  arrayOfIntrest.count == 5 {
            
            
            // search_Bar.resignFirstResponder()
            //autoPromptView.isHidden = true
            
            search_Bar.performSelector(onMainThread: #selector(self.resignFirstResponder), with: nil, waitUntilDone: false)
            
            
            
            // [searchBar performSelectorOnMainThread:@selector(resignFirstResponder) withObject:nil waitUntilDone:NO];
            
            
            CommonFunctionsClass.sharedInstance().showAlert(title: "Too many locations!", text: "You can search for up to 5 locations at once if you'd like to search and explore more, please delete one or moreof the previous locations you've searched.", imageName: "oopsAlert")
            
            
            
            // IQKeyboardManager.sharedManager().enable=false
            
            
        }
        else
        {
            
            
            locationAutoPrompt="Empty"
            
            promptArray .removeAllObjects()
            
            
           // self.showPopular()
            
            self.autoPromptTable.contentInset = UIEdgeInsetsMake(0, 0, 10, 0)
            
            
            //scrollMainView.isScrollEnabled=false//disable the scrollView
            
            let SearchString: NSString = search_Bar.text! as NSString
            
            if SearchString.length >= 3 {
                
                // promptIndicator.isHidden=false
                // promptIndicator.startAnimating()
                
                let uId = Udefaults .string(forKey: "userLoginId")
                
                
                if task != nil {
                    
                    if task.state == URLSessionTask.State.running {
                        task.cancel()
                        print("\n\n Task 1 cancel\n\n")
                    }
                }
                
                let parameterString = NSString(string:"query=\(SearchString)&userId=\(uId!)") as String
                print(parameterString)
                
                
                
                
                
            }
                
            else if(SearchString.length < 3){
                
                
                
            }
            
            
            
            
        }
        
        
        
        
        
    }
    
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //customDelegate.didChangeSearchText(searchText)
        
        print("While entering the characters this method gets called")
        self.checkTextField(searchBar: search_Bar)
        
        
    }
    
    
    
    @IBAction func cancelSearchAction(_ sender: Any) {
        
        self.cancelSearchFunction()
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        self.cancelSearchFunction()
        
    }
    
    
    func cancelSearchFunction() {
        
        
    UIView.animate(withDuration: 0.1, animations: {() -> Void in
       
        self.search_Bar.showsCancelButton = false
        self.cancelWidth.constant = 0
        self.topSpaceOfAutoPrompt.constant = 200
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.4, animations: {() -> Void in
         self.autoPromptView.isHidden=true
        })

          })
        
        
        search_Bar .resignFirstResponder()
        search_Bar .showsCancelButton = false
        
    }
    
    
    
    //Add serached location action
    
    
    func searchLocationAction(_ sender: UIButton) {
        
        print(sender.tag)
        buttonPressedTag = sender.tag
        if autoPromptView.isHidden==true
        {
            self.showTheView()
            
        }
        
        
        
        
    }

    
    
    
    
    
    
    func checkTextField(searchBar: UISearchBar) {
        
        let characterset = NSCharacterSet(charactersIn: " abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ ")
        
        let stringText:NSString = searchBar.text! as NSString
        
        if stringText==" " {
            print("Empty textField")
            searchBar.text = ""
        }
            
            
        else
        {
            
            var SearchString = NSString()
            
            
            if (stringText.rangeOfCharacter(from: characterset.inverted).location != NSNotFound){
                print("Could not handle special characters")
                let newStr = stringText .substring(to: stringText .length - 1)
                
                searchBar.text = newStr
                SearchString = newStr as NSString
            }
                
            else{
                SearchString = searchBar.text! as NSString
            }
            
            
            print(SearchString)
            
            
            locationAutoPrompt="Empty"
            
            
            
            if autoPromptView.isHidden==true {
                
                
                
                
                //UIView.animateWithDuration(0.4, animations: {() -> Void in
                
                self.autoPromptView.isHidden=true
                self.view.layoutIfNeeded()
                // })
                
                
                
                
            }
            
            
            
            
            
            if SearchString.length >= 3 {
               // self.scrollMainView.isScrollEnabled=false
                promptIndicator.isHidden=false
                promptIndicator.startAnimating()
                
                let uId = Udefaults .string(forKey: "userLoginId")
                
//                
//                if task != nil {
//                    
//                    if task.state == .running{ //URLSessionTask.State.running{
//                        task.cancel()
//                        print("\n\n Task 1 cancel\n\n")
//                    }
//                    
//                    
//                    if task.state == URLSessionTask.State.running {
//                        task.cancel()
//                        
//                    }
//                }
                
                let parameterString = NSString(string:"query=\(SearchString)&userId=\(uId!)") as String
                print(parameterString)
                
                
                
                self .postApiForAutoPromptLocations(searchString: parameterString)
                
                
            }
            
            
        }
        
        
        
    }
    
    
    
    func setLocationInButtons(btnTag: Int)
    {
       // print(arrayOfIntrest)
        
        let LocationNameString = ((arrayOfIntrest.object(at: btnTag)) as AnyObject).value(forKey: "location") as? String ?? ""// arrayOfIntrest.objectAtIndex(.row).valueForKey("location") as? String ?? ""
        
        let locImage = ((arrayOfIntrest.object(at: btnTag)) as AnyObject).value(forKey: "imageUrl") as? String ?? ""
       
        let urlImg = NSURL (string: locImage)
        
        
        switch btnTag {
        case 0:
            
            button1 .setImage(nil, for: .normal) //imageView?.image = nil
            button1.sd_setImage(with: urlImg as URL!, for: .normal)
            button1.backgroundColor = UIColor .red
            locLabel1.text = LocationNameString
            //button1 .setTitle(LocationNameString, for: .normal)
            deleteBtn1.tag = 0
            deleteBtn1.isHidden = false
            btn1Overlay.isHidden = false
            
            break
        case 1:
            button2.setImage(nil, for: .normal)
            button2.sd_setImage(with: urlImg as URL!, for: .normal)
            button2.backgroundColor = UIColor .red
            locLabel2.text = LocationNameString
            //button2 .setTitle(LocationNameString, for: .normal)
            deleteBtn2.tag = 1
            deleteBtn2.isHidden = false
            btn2Overlay.isHidden = false
            break
        case 2:
            button3.setImage(nil, for: .normal)
            button3.sd_setImage(with: urlImg as URL!, for: .normal)
            button3.backgroundColor = UIColor .red
            locLabel3.text = LocationNameString
            //button3 .setTitle(LocationNameString, for: .normal)
            deleteBtn3.tag = 2
            deleteBtn3.isHidden = false
            btn3Overlay.isHidden = false
            break
        case 3:
            button4.setImage(nil, for: .normal)
            button4.sd_setImage(with: urlImg as URL!, for: .normal)
            button4.backgroundColor = UIColor .red
            locLabel4.text = LocationNameString
            //button4 .setTitle(LocationNameString, for: .normal)
            deleteBtn4.tag = 3
            deleteBtn4.isHidden = false
            btn4Overlay.isHidden = false
            break
       
        default:
            button5.setImage(nil, for: .normal)
            button5.sd_setImage(with: urlImg as URL!, for: .normal)
            button5.backgroundColor = UIColor .red
            locLabel5.text = LocationNameString
            //button5 .setTitle(LocationNameString, for: .normal)
            deleteBtn5.tag = 4
            deleteBtn5.isHidden = false
            btn5Overlay.isHidden = false
            break
        }
        
        
        
        
        
        
        
       
//        locationLabel.text = LocationNameString.capitalizedString
//        
//        cell.locationImage.sd_setImageWithURL(urlImg, placeholderImage: UIImage(named: "img1Temp"))
//        cell.locationImage.layer.cornerRadius = 4.0
//        cell.locationImage.clipsToBounds = true
//        cell.minusBtn.layer.cornerRadius = cell.minusBtn.frame.size.width/2
//        cell.minusBtn.alpha = 1
//        cell.bringSubviewToFront(cell.minusBtn)
//        cell.minusBtn.tag = indexPath.row
        
        
        
        
        
        
        
        
    }
    
    
    
    
    
    
    
    
    
    //    //MARK:- RETURN KEY
    //    func textFieldShouldReturn(textField: UITextField) -> Bool {
    //        self.view.endEditing(true)
    //        self.cancelAutoPromptAction(self)
    //        return false
    //    }
    
    
    
    
    
    
    
    
    func postApiForAutoPromptLocations(searchString: String)
    {
        
        
        
        let isConnectedInternet = CommonFunctionsClass.sharedInstance().isConnectedToNetwork()
        
        if isConnectedInternet
        {
            
            
            let urlString = NSString(string:"\(appUrl)auto_suggestion")//latest version
            
            print("WS URL----->>" + (urlString as String))
            
            
            let url:NSURL = NSURL(string: urlString as String)!
            let session = URLSession.shared
            
            let request = NSMutableURLRequest(url: url as URL)
            request.httpMethod = "POST"
            request.cachePolicy = URLRequest.CachePolicy.reloadIgnoringCacheData// NSURLRequest.CachePolicy.ReloadIgnoringCacheData
            
            
            let needsLove = searchString
            let safeURL = needsLove .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) //needsLove.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
            
            
            print("Final search-----> " + (safeURL! as String))
            
            
            print(safeURL)
            request.httpBody = safeURL?.data(using: String.Encoding.utf8)
            
            
            
            
            
            
            
            task = URLSessionTask()//.cancel()
            task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
                
                OperationQueue.main.addOperation
                    {
                        
                        self.promptIndicator.isHidden=true
                        self.promptIndicator.stopAnimating()
                        
                        if data == nil
                        {
                            // CommonFunctionsClass.sharedInstance().alertViewOpen("Server is not responding", viewController: self)
                            
                        }
                        else
                        {
                            
                            
                            do {
                                
                                
                                
                                
                                let anyObj: Any = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                                
                                
                                jsonResult = NSDictionary()
                                jsonResult = anyObj as! NSDictionary
                                let status = jsonResult .value(forKey: "status") as! NSNumber
                                
                                if status == 1{
                                    
                                    
                                    self.promptArray.removeAllObjects()
                                    self.autoPromptTable .reloadData()
                                    self.locationAutoPrompt="Empty"
                                    self.promptArray = jsonResult .value(forKey: "result") as! NSMutableArray
                                    print(self.promptArray.count)
                                  //   print("prompt array\n \n \(self.promptArray)")
                                    
                                    self.autoPromptTable .reloadData()
                                   // self.emptyView.isHidden=true
                                    
                                    
                                }
                                    
                                else
                                {
                                    if self.promptArray.count<1
                                    {
                                        print("No result found")
                                        
                                    }
                                    else
                                    {
                                        self.autoPromptTable .reloadData()
                                        
                                    }
                                    
                                    
                                    
                                   // self.emptyView.isHidden=false
                                    
                                    
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
            
            
        }
        
        
        
    }
    
    
    
    //MARK:-
    
    
    
    
    
    
    /*
     
     DONE action will add the entered location into the array after verifying it from the google reverse api
     and also check the entered location is valid or not
     
     PROCEED action will move to the new view controller
     
     */
    
    
    
    
    
    
    //// action of proceed button to move next third
    
    
    @IBAction func nextPageAction(_ sender: Any)
    {
    
        if arrayOfIntrest.count<1
        {
            CommonFunctionsClass.sharedInstance().showAlert(title: "Opps!", text: "Please add minimum one location.", imageName: "exclamationAlert")
            
           
        }
        else
        {
            //hit api
            let uId = Udefaults .string(forKey: "userLoginId")
            
            
            
            let typeArr = NSMutableArray()
            
            
            for i in 0..<arrayOfIntrest.count {
                
                //    print((arrayOfIntrest.objectAtIndex(i) as AnyObject).valueForKey("location"))
                
                print(arrayOfIntrest.object(at: i))
                let locName = ((arrayOfIntrest.object(at: i)) as AnyObject).value(forKey: "fullName") as? String ?? ""
                let locType = ((arrayOfIntrest.object(at: i)) as AnyObject).value(forKey: "type") as? String ?? ""
               
                
                let locId = ((arrayOfIntrest.object(at: i)) as AnyObject).value(forKey: "placeId") as? String ?? ""
                let locImg = ((arrayOfIntrest.object(at: i)) as AnyObject).value(forKey: "imageUrl") as? String ?? ""
                
                typeArr .add(["type": locType, "placeId": locId, "fullName": locName, "imageUrl": locImg])
                
            }
            
            
          
            
            
            
            let dic: NSDictionary = ["userId":uId!,"location": typeArr ]
            
            
            print(dic)
            
            
            
            
            
            // dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), {
            
            apiClass.sharedInstance().postRequestSearchedLocations(parameterString: "userId=\(uId!)", totalLocations: dic , viewController: self)
            
            //})
            
            UserDefaults.standard.set(arrayOfIntrest, forKey: "arrayOfIntrest")
            
             let nxtObj = self.storyboard?.instantiateViewController(withIdentifier: "MainTabBarViewController") as! MainTabBarViewController
            
            
            
            
            self.navigationController! .pushViewController(nxtObj, animated: true)
            //self.dismiss(animated: true, completion: {})
            URLCache.shared.removeAllCachedResponses()
            
            
        }
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    //MARK:- indicator with some text function
    //MARK:-
    
    func progressBarDisplayer(msg:String, _ indicator:Bool )
    {
        print(msg)
        strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 200, height: 50))
        strLabel.text = msg
        strLabel.textColor = UIColor.white
        messageFrame = UIView(frame: CGRect(x: self.view.frame.midX - 90, y: self.view.frame.midY - 25 , width: 180, height: 50))
        messageFrame.layer.cornerRadius = 15
        messageFrame.backgroundColor = UIColor(white: 0, alpha: 0.7)
        if indicator
        {
            activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)
            activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            activityIndicator.startAnimating()
            messageFrame.addSubview(activityIndicator)
        }
        messageFrame.addSubview(strLabel)
        self.view.addSubview(messageFrame)
    }
    
    
    
    
    
    
    
    //MARK:- Buttons action to remove the intrests
    func deleteLocation(sender:UIButton) -> Void {
        
        print(sender.tag)
        
        arrayOfIntrest .removeObject(at: sender.tag)
        UserDefaults.standard.set(arrayOfIntrest, forKey: "arrayOfIntrest")
        self .adjustHeightOftableView()
        
       self.manageContentOfButtons()
        
        switch sender.tag
        {
        case 0:
            button1 .setImage(UIImage (named: "Add") , for: .normal) //
            button1.backgroundColor = UIColor .lightGray.withAlphaComponent(0.2)
            locLabel1.text = ""
            //button1.setTitle("", for: .normal)
            deleteBtn1.isHidden = true
            break
            
        case 1:
            button2 .setImage(UIImage (named: "Add") , for: .normal) //
            button2.backgroundColor = UIColor .lightGray.withAlphaComponent(0.2)
            locLabel2.text = ""
            //button2.setTitle("", for: .normal)
            deleteBtn2.isHidden = true
            break
            
        case 2:
            button3 .setImage(UIImage (named: "Add") , for: .normal) //
            button3.backgroundColor = UIColor .lightGray.withAlphaComponent(0.2)
            locLabel3.text = ""
            //button3.setTitle("", for: .normal)
            deleteBtn3.isHidden = true
            break
            
        case 3:
            button4 .setImage(UIImage (named: "Add") , for: .normal) //
            button4.backgroundColor = UIColor .lightGray.withAlphaComponent(0.2)
            locLabel4.text = ""
            //button4.setTitle("", for: .normal)
            deleteBtn4.isHidden = true
            break
            
        default:
            button5 .setImage(UIImage (named: "Add") , for: .normal) //
            button5.backgroundColor = UIColor .lightGray.withAlphaComponent(0.2)
            locLabel5.text = ""
            //button5.setTitle("", for: .normal)
            deleteBtn5.isHidden = true
            break
        }
        
        
        
        
        
        
        
        for i in 0..<self.arrayOfIntrest.count
        {
            self.setLocationInButtons(btnTag: i)
        }

        
    }
 
    
    
    func manageContentOfButtons()
    {
        deleteBtn1.isHidden = true
        deleteBtn2.isHidden = true
        deleteBtn3.isHidden = true
        deleteBtn3.isHidden = true
        deleteBtn4.isHidden = true
        deleteBtn5.isHidden = true
       
        btn1Overlay.isHidden = true
        btn2Overlay.isHidden = true
        btn3Overlay.isHidden = true
        btn4Overlay.isHidden = true
        btn5Overlay.isHidden = true
        
        
        
        button1 .setImage(UIImage (named: "Add") , for: .normal) //
        button1.backgroundColor = UIColor .lightGray.withAlphaComponent(0.2)
       // button1.setTitle("", for: .normal)
        locLabel1.text = ""
        
        button2 .setImage(UIImage (named: "Add") , for: .normal) //
        button2.backgroundColor = UIColor .lightGray.withAlphaComponent(0.2)
        locLabel2.text = ""
        // button2.setTitle("", for: .normal)
        
        button3 .setImage(UIImage (named: "Add") , for: .normal) //
        button3.backgroundColor = UIColor .lightGray.withAlphaComponent(0.2)
        locLabel3.text = ""
        //button3.setTitle("", for: .normal)
        
        button4 .setImage(UIImage (named: "Add") , for: .normal) //
        button4.backgroundColor = UIColor .lightGray.withAlphaComponent(0.2)
        locLabel4.text = ""
        //button4.setTitle("", for: .normal)
        
        button5 .setImage(UIImage (named: "Add") , for: .normal) //
        button5.backgroundColor = UIColor .lightGray.withAlphaComponent(0.2)
        locLabel5.text = ""
        //button5.setTitle("", for: .normal)
        
    }
    
    
    
    
    
    
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        
        return 1
        
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
       
            return promptArray.count
       
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        
            let cellPrompt:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "promptCell")!
            
            
            
            let searchLabel = cellPrompt.viewWithTag(5555) as! UILabel
            
            if promptArray.count - 1 < indexPath.row {
                
            }
            else
            {
                
                searchLabel.text = (promptArray.object(at: indexPath.row) as! NSDictionary).value(forKey: "fullName") as? String ?? ""//promptArray.objectAtIndex(indexPath.row).valueForKey("fullName") as? String ?? ""
            }
            
            return cellPrompt
        
        
    }
    
    
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
            print(promptArray)
            let selectedString = ((promptArray.object(at: indexPath.row)) as AnyObject).value(forKey: "fullName") as? String ?? ""//promptArray.objectAtIndex(indexPath.row).valueForKey("fullName") as? String ?? ""
            print(selectedString)
        let selectedImage = ((promptArray.object(at: indexPath.row)) as AnyObject).value(forKey: "imageUrl") as? String ?? ""
            
            locationAutoPrompt = selectedString as NSString
            
            
        
            let str = ((promptArray.object(at: indexPath.row)) as AnyObject).value(forKey: "type") as? String ?? ""//promptArray.objectAtIndex(indexPath.row).valueForKey("type") as? String ?? ""
            
           let locationId = ((promptArray.object(at: indexPath.row)) as AnyObject).value(forKey: "_id") as? String ?? "" //promptArray.objectAtIndex(indexPath.row).valueForKey("_id") as? String ?? ""
            
            
            
            locationType = str as NSString
            
            
            print(locationType)
            print(locationId)
            
            
            self.hideTheView()
//            
//            self.autoPromptView.isHidden=true
//            self.search_Bar.showsCancelButton = false
//            self.cancelWidth.constant = 0
//           
//            self.view.layoutIfNeeded()
            
            
            
            
            
            
            
          
            promptArray.removeAllObjects()
            promptArray = popularArray
            autoPromptTable .reloadData()
            
            
            
            
            
            /////////////  Automatic add locations ////////
           var containBool = Bool()
        if arrayOfIntrest.count<1 {
            containBool = false
        }
        else
        {
            for diction in arrayOfIntrest {
             let dic2 =  diction as! NSDictionary
                print(dic2)
              
                
                if dic2["placeId"]as? String == locationId
                {
                    print("contains")
                    
                        CommonFunctionsClass.sharedInstance().showAlert(title: "Opps!", text: "Please enter different name.", imageName: "exclamationAlert")
                    
                        self.messageFrame.removeFromSuperview()
                        containBool = true
                        
                    
                    break
                }
                
                }
            }


            if containBool == false {
                
                var dict = NSMutableDictionary()
            //dict = ["location":locationAutoPrompt,"lat": "0.0", "long": "0.0", "type": locationType, "country":"\(locationAutoPrompt)",  "delete":false ]
                
                let fullName = locationAutoPrompt
                let ArrToSeperate = locationAutoPrompt .components(separatedBy: ",")
                if ArrToSeperate.count>0 {
                    locationAutoPrompt=ArrToSeperate[0] as String as NSString
                }
                
                
                
                dict = ["location":locationAutoPrompt, "type": locationType, "placeId":"\(locationId)",  "delete":false, "fullName": fullName as String , "imageUrl": selectedImage ]
                
                
                
                
                if self.arrayOfIntrest.count<5{
                    DispatchQueue.global(qos: .background).async {
                        self .apiToGetTheLocationPhoto(parameters: fullName)
                    }
                    
                    
                    
                    
                    if buttonPressedTag <= self.arrayOfIntrest.count-1 {
                        self.arrayOfIntrest.removeObject(at: buttonPressedTag)
                        self.arrayOfIntrest.insert(dict, at: buttonPressedTag)
                    }
                    else
                    {
                        self.arrayOfIntrest .add(dict)
                    }
                    
                    UserDefaults.standard.set(arrayOfIntrest, forKey: "arrayOfIntrest")
                    selectedindxSearch=0
                    
                    for i in 0..<self.arrayOfIntrest.count
                    {
                        self.setLocationInButtons(btnTag: i)
                    }
                    
                    
                }
                
                
                //hide if there are 5 locations in the array
                
                
                self.adjustHeightOftableView()
                
                search_Bar.text = nil
                
            }
        
    
    
        
        
        
        
    }
    
    
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    //MARK:
    //MARK: Show popular places
    
    func showPopular()  {
        
        let popularSaved = UserDefaults.standard.object(forKey: "arrayOfPopular")
        if popularSaved != nil {
            self.popularArray=NSMutableArray(array: popularSaved as! NSArray)
            if popularArray.count > 0 {
                self.promptArray.removeAllObjects()
                self.autoPromptTable .reloadData()
                self.locationAutoPrompt="Empty"
                self.promptArray = popularArray
                
                
                self.autoPromptTable .reloadData()
            }
        }
        
        
        
        
        
    }
    
    
    
    //MARK: Get trending:
    
    func postApiForTrendingLocationsSearch( userid: NSString)
    {
        let isConnectedInternet = CommonFunctionsClass.sharedInstance().isConnectedToNetwork()
        
        if isConnectedInternet
        {
            
            
            let request = NSMutableURLRequest(url: NSURL(string: "\(appUrl)get_trending_places_V2")! as URL)//New version
            
            
            
            request.httpMethod = "POST"
            
            
            let newDict:NSDictionary = ["userId": userid]
            
            
            
            do {
                let jsonData = try!  JSONSerialization.data(withJSONObject: newDict, options: [])
                request.httpBody = jsonData
                
                
                // here "jsonData" is the dictionary encoded in JSON data
            } catch let error as NSError {
                print(error)
            }
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            
            
            
            //request.httpBody = userid.dataUsingEncoding(NSUTF8StringEncoding)
            let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
                guard error == nil && data != nil else {                                                          // check for fundamental networking error
                    print("error=\(error)")
                    return
                }
                
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    
                }
                
                
                
                DispatchQueue.main.async {
                    
                    do {
                        
                        let result = NSString(data: data!, encoding:String.Encoding.ascii.rawValue)!
                        print("Body: \(result)")
                        
                        let anyObj: Any = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                        
                        
                        
                        jsonResult = NSDictionary()
                        jsonResult = (anyObj as? NSDictionary)!
                        
                        
                        let status = jsonResult.value(forKey: "status") as! NSNumber
                        
                        if status == 1{
                            
                            let trdArr = jsonResult.value(forKey: "data") as! NSMutableArray
                            
                            
                            self.popularArray = jsonResult.value(forKey: "popular") as! NSMutableArray
                            
                            UserDefaults.standard.set(self.popularArray, forKey: "arrayOfPopular")
                            
                            
                            // self.showPopular()
                            
                            
                            if self.trendingArray == trdArr {
                                print("equal")
                                if self.trendingArray.count<1{
                                    self.trendingArray=trdArr
                                    UserDefaults.standard.set(self.trendingArray, forKey: "arrayOfTrending")
                                    print(self.trendingArray.count)
                                    
                                    print(self.trendingArray)
                                    
                                    
                                    self.trendingPlacesCollectionView.reloadData()
                                    //self.updateTrending()
                                    
                                    self.adjustHeightOftableView()

                                }
                                
                                
                            }else
                            {
                                print("not equal")
                                
                                self.trendingArray=trdArr
                                UserDefaults.standard.set(self.trendingArray, forKey: "arrayOfTrending")
                                print(self.trendingArray.count)
                                
                                print(self.trendingArray)
                                
                                
                                self.trendingPlacesCollectionView.reloadData()
                                //self.updateTrending()
                                
                                self.adjustHeightOftableView()
                                
                            }
                            
                            
                        }
                        else
                        {
                            print("Unable to get the trending places from the server")
                        }
                        
                        
                        
                        
                        
                        
                    } catch {
                        print("json error: \(error)")
                        CommonFunctionsClass.sharedInstance().showAlert(title: "Server Alert", text: "Something doesn't seem right, Please try again!", imageName: "alertServer")
                        
                        
                        
                        
                        
                    }
                    
                    
                    
                    
                }
                
                
                
                
                
                
                
            }
            task.resume()
            
        }
        else
        {
            CommonFunctionsClass.sharedInstance().showAlert(title: "No Internet Connection", text: "You are currently offline.", imageName: "alertInternet")
        }
        
    }
    
    
    
    
    
    
    //MARK: Save the device Token
    
    func postApiFordeviceToken( param: NSDictionary)
    {
        let isConnectedInternet = CommonFunctionsClass.sharedInstance().isConnectedToNetwork()
        
        if isConnectedInternet
        {
            
            let request = NSMutableURLRequest(url: NSURL(string: "\(appUrl)set_deviceToken")! as URL)//New version
            
            
            
            request.httpMethod = "POST"
            
            
            
            
            
            
            do {
                let jsonData = try!  JSONSerialization.data(withJSONObject: param, options: [])
                request.httpBody = jsonData
                
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
                    
                }
                
                
                
                DispatchQueue.main.async {
                    
                    do {
                        
                        let result = NSString(data: data!, encoding:String.Encoding.ascii.rawValue)!
                        print("Body: \(result)")
                        
                        let anyObj: Any = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                        
                        
                        
                        jsonResult = NSDictionary()
                        jsonResult = (anyObj as? NSDictionary)!
                        
                        
                        let status = jsonResult.value(forKey: "status") as! NSNumber
                        
                        if status == 1{
                            
                            print("save the token")
                            
                            
                            Udefaults.set(true, forKey: "savedDeviceToken")
                            
                            
                        }
                        else
                        {
                            print("Unable to save token")
                        }
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                    } catch {
                        print("json error: \(error)")
                        
                        
                        
                        
                        
                    }
                    
                    
                    
                    
                }
                
                
                
                
                
                
                
            }
            task.resume()
            
        }
        else
        {
            CommonFunctionsClass.sharedInstance().showAlert(title: "No Internet Connection", text: "You are currently offline.", imageName: "alertInternet")
        }
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //MARK: Get trending:
    
    func apiToGetTheLocationPhoto( parameters: NSString)
    {
        let isConnectedInternet = CommonFunctionsClass.sharedInstance().isConnectedToNetwork()
        
        if isConnectedInternet
        {
            //            let request = NSMutableURLRequest(URL: NSURL(string: "\(appUrl)trending")!)//old version
            print(parameters)
            
            let parameter2 = parameters .replacingOccurrences(of: " ", with: "")
            
            
            
            print(parameter2)
            
            let request = NSMutableURLRequest(url: NSURL(string: "https://api.flickr.com/services/feeds/photos_public.gne?tags=\(parameter2),travel&is_getty=true&tagmode=all&format=json&content_type=1&safe_search=1&geo_context=2")! as URL)
            
            
            
            print(request)
            
            request.httpMethod = "GET"
            
            request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData// NSURLRequest.CachePolicy.ReloadIgnoringCacheData
            
            let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
                guard error == nil && data != nil else {                                                          // check for fundamental networking error
                    print("error=\(error)")
                    return
                }
                
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    
                }
                
                
                
                DispatchQueue.main.async {
                    
                    do {
                        /* let refinedData = data!.subdataWithRange(NSMakeRange("jsonFlickrFeed(".length, (data!.length - 1) - ("jsonFlickrFeed(".length)))
                         
                         let anyObj: Any = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                         
                         jsonResult = NSDictionary()
                         jsonResult = (anyObj as? NSDictionary)!
                         
                         let dataArr:NSMutableArray = jsonResult.valueForKey("items") as! NSMutableArray
                         
                         
                         if dataArr.count > 0{
                         
                         print(dataArr.objectAtIndex(0).valueForKey("link"))
                         let imgLink = dataArr.objectAtIndex(0).valueForKey("media")!.valueForKey("m") as? String ?? ""
                         print(imgLink)
                         
                         
                         let dict: NSMutableDictionary = self.arrayOfIntrest.objectAtIndex(0) as! NSMutableDictionary
                         
                         dict.setValue(imgLink, forKey: "imgLink")
                         self.arrayOfIntrest.removeObjectAtIndex(0)
                         
                         self.arrayOfIntrest.insertObject(dict, atIndex: 0)
                         print(self.arrayOfIntrest.objectAtIndex(0))
                         self.searchedLocationsCollectionView .reloadData()
                         UserDefaults.standard.set(self.arrayOfIntrest, forKey: "arrayOfIntrest")
                         
                         }
                         
                         
                         */
                    } catch {
                        print("json error: \(error)")
                        
                    }
                    
                    
                    
                    
                }
                
                
                
            }
            task.resume()
            
        }
        else
        {
            // CommonFunctionsClass.sharedInstance().showAlert(title: "No Internet Connection", text: "You are currently offline.", imageName: "alertInternet")
        }
        
    }
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        URLCache.shared.removeAllCachedResponses()
        
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



////////////////-------- inherit tableView cell class

class locationsCell: UICollectionViewCell {
    
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var locationImage: UIImageView!
    @IBOutlet weak var gradientView: GradientView!
    
    @IBOutlet weak var minusBtn: UIButton!
    
    @IBOutlet weak var forwdImg: UIImageView!
    @IBOutlet weak var greadientImage: UIImageView!
    
    @IBOutlet weak var exploreBacklabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
}


class BloggersCell: UICollectionViewCell {
    
    @IBOutlet var locationImage: UIImageView!
    @IBOutlet weak var userImageProfile: UIImageView!
    
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var contentViewInBlooger: UIView!
    
    @IBOutlet weak var userLikes: UILabel!
    
    @IBOutlet weak var userBlogs: UILabel!
}




extension NSAttributedString
{
    func makeAttributedString(str: String) -> NSAttributedString {
        let descriptor = UIFontDescriptor(name: "Roboto-Bold", size: 16)
        let boldFontName = UIFont(descriptor: descriptor, size: 16)
        let boldedRange = NSMakeRange(0, 1)
        //    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:str];
        let attrString = NSMutableAttributedString()
        let productDesc = NSAttributedString(string: "\(str)")
        attrString.append(productDesc)
        attrString.beginEditing()
        attrString.addAttribute(NSFontAttributeName, value: boldFontName, range: boldedRange)
        attrString.addAttribute(NSForegroundColorAttributeName, value: UIColor.white, range: (str as NSString).range(of: str))
        attrString.endEditing()
        return attrString
    }
}

extension UIView
{
    func applyPlainShadow(view: UIView) {
        
        self.layer.masksToBounds=false
        self.layer.shadowColor=UIColor.black.cgColor
        self.layer.shadowOpacity=0.4
        self.layer.shadowRadius=10
        self.layer.shadowOffset=self.layer.frame.size
        
    }
    func applyHoverShadow(view: UIView) {
        let size = view.bounds.size
        let width = size.width
        let height = size.height
        
        let ovalRect = CGRect(x: 5, y: height + 5, width: width - 10, height: 15)
        let path = UIBezierPath(roundedRect: ovalRect, cornerRadius: 10)
        
        let layer = view.layer
        layer.shadowPath = path.cgPath
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 1
        layer.shadowRadius = 5
        layer.shadowOffset = CGSize(width: 0, height: 0)
    }
}





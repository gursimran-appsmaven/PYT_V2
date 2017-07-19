//
//  mainHomeViewController.swift
//  PYT
//
//  Created by Niteesh on 06/07/16.
//  Copyright © 2016 appsMaven. All rights reserved.
//

import UIKit
import SDWebImage
import MBProgressHUD
import HMSegmentedControl



//class mainHomeViewController: UIViewController  {

class mainHomeViewController: UIViewController, SDWebImageManagerDelegate, apiClassDelegate, UITabBarControllerDelegate {

   // @IBOutlet var mainViewWithGradient: UIView!
    
    
    
    var storedOffsets = [Int: CGFloat]()
    var tipsView = UIView()
    var showTooltips = Bool()
    var showApiHitted = Bool()
    var segmentBool = Bool()
    var planAllLocation = Bool()
    var planTap = Bool()
    var PlanDeleteBool = Bool()
    
    //Main View outlets
    @IBOutlet var imagesTableView: UITableView!
    @IBOutlet weak var searchButtonOutlet: UIButton!
    @IBOutlet var segmentControl: HMSegmentedControl!
    
    @IBOutlet weak var storiesCollectionView: UICollectionView!
    @IBOutlet weak var storiesView: UIView!
    @IBOutlet weak var ContentView: UIView!
    @IBOutlet weak var planCountLbl: CustomLabel!    
    @IBOutlet weak var changePlanImage: CustomImageView!
    
    
//    var oldContentOffset = CGPointZero
//    var topConstraintRange = (CGFloat(2)..<CGFloat(73))
//    
//    func scrollViewDidScroll(scrollView: UIScrollView) {
//        
//        let delta =  scrollView.contentOffset.y - oldContentOffset.y
//        
//        //we compress the top view
//        if delta > 0 && topConstraintRange. > topConstraintRange.lowerBound && scrollView.contentOffset.y > 0 {
//            topConstraintRange -= delta
//            scrollView.contentOffset.y -= delta
//        }
//        
//        //we expand the top view
//        if delta < 0 && topConstraintRange < topConstraintRange.upperBound && scrollView.contentOffset.y < 0{
//            topConstraintRange -= delta
//            scrollView.contentOffset.y -= delta
//        }
//        
//        oldContentOffset = scrollView.contentOffset
//    }
    
    
    @IBOutlet weak var emptyView: UIImageView!
    @IBOutlet var firstView: UIView!
    
    //View open on More options
    @IBOutlet var detailView: UIView!
    @IBOutlet weak var dynamicDetailSubview: CustomView!
    @IBOutlet weak var likeButtonDetailView: UIButton!
   // @IBOutlet weak var commentButtonDetailView: UIButton!
    @IBOutlet weak var addToPlanBtn: UIButton!
    @IBOutlet weak var addToBucketBtn: UIButton!
    @IBOutlet weak var editButtonDetailview: UIButton!
    
    @IBOutlet weak var editBottomSpace: NSLayoutConstraint!
    
    
    var dataArray = NSMutableArray()
    var arrayOfimages1 = NSMutableArray()
    var userDetailArray = NSMutableArray()
   // var tagForBtnCollection = Int()
    //var tagForBtnIndex = Int()
    
    
    
    
    
    var colorArray = [
        UIColor.green.withAlphaComponent(0.5) ,
        UIColor.blue.withAlphaComponent(0.5) ,
        UIColor.red.withAlphaComponent(0.5) ,
        UIColor.orange.withAlphaComponent(0.5) ,
        UIColor.yellow.withAlphaComponent(0.5) ,
        UIColor.purple.withAlphaComponent(0.5) ,
        UIColor.cyan.withAlphaComponent(0.5)
        
    ] //array of border colors for profile pictures of users
    
    
    
    var photos = NSMutableArray()
    var tabledata = NSMutableArray()
    
    var refreshControl: UIRefreshControl! //reload table by pull to refresh
    
    //used for send the parameters in api
    var globalLocation = NSString()
    var globalPlaceid = NSString()
    var globalLongitude = NSString()
    var globalType = NSString()
    var globalCountry = NSString()
    var globalFullName = NSString()
    var selectedIndexOfLocation = Int()
    var toolTimer = Timer()
    
    
    
    ////////Pop up View items to Story, Edit, Like, Bucket
    
   
    var storyBool = Bool()
    
    
    
    var storyBucketBool = Bool()
    
    var collectionIndex = Int()
    var tableIndex = Int()
    var longTapedView = UIView()
    var storyVisible = Bool()
    @IBOutlet weak var contentTop: NSLayoutConstraint!
    
     func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if(scrollView.contentOffset.y > 70 )
//        {
//            if(storyVisible)
//            {
//                UIView.animate(withDuration: 0.8, animations: {
//                    self.contentTop.constant =  -70
//                    self.storyVisible = false
//                    self.view.layoutIfNeeded()
//                })
//            }
//        }
//        else if(scrollView.contentOffset.y > 0 && scrollView.contentOffset.y < 70)
//        {
//            if(!storyVisible)
//            {
//                UIView.animate(withDuration: 0.8, animations: {
//                    self.contentTop.constant =  2
//                    self.storyVisible = true
//                    self.view.layoutIfNeeded()
//                })
//            }
//
//        }
    }
    
    
    
    
    var selectedCell =  NSMutableArray() //seleted array of cells
    var likeCount = NSMutableArray()//Array to temporary save the likes
    var reuseData = NSMutableDictionary()//dictionary to avoid again and again call the api of search
    var pageNumber:Int = 1
    //var defaults = UserDefaults.standard
    var uId = ""
    
    
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        
        self.automaticallyAdjustsScrollViewInsets = false;
        self.tabBarController?.tabBar.isHidden = false
        //self.tabBarController?.setTabBarVisible(visible: true, animated: true)
        //hide the navigationBar
        self.detailView.isHidden = true
            //Ensures that views are not underneath the tab bar
         apiClass.sharedInstance().delegate=self //delegate for response api
        
        let tagsArr: NSMutableArray = Udefaults.mutableArrayValue(forKey: "categoriesFromWeb")
        
        if tagsArr.count<1
        {
            apiClass.sharedInstance().postRequestCategories(parameterString: uId)
        }
        
        
        
       //print("\\\\\\\\\\---------------Selected Index from search----=\(selectedindxSearch)")
        
        URLCache.shared.removeAllCachedResponses() //clear cache

        //call api for first time
        
        if userDetailArray.count<1
        {
             self.callApi(globalPlaceid, type: globalType)
        }
        
        
       
    
        
        
        //Manage tool tips
        if Udefaults.integer(forKey: "indexToolTips") == 5 || Udefaults.integer(forKey: "indexToolTips") == 6 {
        }
        else{
        self.manageToolsTipsShow()
        }
        
         planAllLocation = false
        storiesCollectionView.reloadData()
    }
    
    
    
    
    func manageToolsTipsShow()
    {
        //mange tool tips
        
        if Udefaults .integer(forKey: "indexToolTips") < 7 {
            showTooltips = true
            
            //Udefaults.setInteger(9, forKey: "indexToolTips")
            
            if userDetailArray.count > 0 {
                
                if Udefaults.integer(forKey: "indexToolTips") == 0
                {
               // toolTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.addToolTip), userInfo: nil, repeats: false)
                }
                    
                else if Udefaults.integer(forKey: "indexToolTips") == 1
                {
                   // toolTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.addToolTip), userInfo: nil, repeats: false)
                    
                }
                    
                else if  Udefaults.integer(forKey: "indexToolTips") == 2
                {
                    
                   // toolTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.addToolTip), userInfo: nil, repeats: false)
                    
                }
                    
                else if Udefaults.integer(forKey: "indexToolTips") == 3
                {
                   // toolTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.addToolTip), userInfo: nil, repeats: false)
                    
                }
                    
                else if Udefaults.integer(forKey: "indexToolTips") == 4
                {
                   // toolTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.addToolTip), userInfo: nil, repeats: false)
                  
                }
                    
                    
                else if Udefaults.integer(forKey: "indexToolTips") == 5
                {
                    //toolTimer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(self.addToolTip), userInfo: nil, repeats: false)
                    
                }
                    
                else if Udefaults.integer(forKey: "indexToolTips") == 6
                {
                   // toolTimer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(self.addToolTip), userInfo: nil, repeats: false)
                    
                }
                    
                    
                    
                    
                else
                {
                    
                    //self.addToolTip(Udefaults .integerForKey("indexToolTips"))
                }
                
                
                
                
            }
            
            
            
        }
        else{
            showTooltips = false
        }
        
        
    }
    
    
    
    
    override func viewWillDisappear(_ animated: Bool)
    {
        toolTimer.invalidate()
         self.detailView.isHidden = true
         URLCache.shared.removeAllCachedResponses()//clear cache
    }
    
    
    
    
    
    
    //MARK:-/////////////// function for hit api when segment change//////////////////
    //MARK:-
    func segmentedControlChangedValue(_ segmentedControl: HMSegmentedControl)
    {
        PlanDeleteBool = true //false
        planAllLocation = false //false to show the plans of that place
        if countArray.count>0 {
            
//            let placeIds = (countArray.value(forKey: "countryId")) as! NSArray
//            print(placeIds)
//            print(globalPlaceid)
//            if placeIds.contains(globalPlaceid) {
//                print("Contains story")
            
                storiesCollectionView .reloadData()
           // }
            
        }
        
        segmentBool = true
        storedOffsets.removeAll()
        self.dataArray = NSMutableArray()
        self.arrayOfimages1 .removeAllObjects()
        self.userDetailArray .removeAllObjects()
        self.imagesTableView .reloadData()
        
        
        
        let indexLoc = Int(segmentedControl.selectedSegmentIndex)
        globalLocation = ((tabledata .object(at: indexLoc)) as AnyObject).value(forKey: "location") as! NSString
        let ArrToSeperate = globalLocation .components(separatedBy: ",")
        if ArrToSeperate.count>0 {
            globalLocation=ArrToSeperate[0] as String as NSString
        }
       
        
        

        
      
        
    globalPlaceid = ((tabledata .object(at: indexLoc)) as AnyObject).value(forKey: "placeId") as! NSString
      
        globalType = ((tabledata .object(at: indexLoc)) as AnyObject).value(forKey: "type") as! NSString
         globalFullName = ((tabledata .object(at: indexLoc)) as AnyObject).value(forKey: "fullName") as! NSString
        
        selectedCell .removeAllObjects() // clear the selected images
        likeCount .removeAllObjects() // clear the liked
        
       
        
        
        ////Set true to reload the data in iterest screen
        
        Udefaults.set(true, forKey: "refreshInterest")
      Udefaults.synchronize()
        
        //call api
        
         self.callApi(globalPlaceid, type: globalType)
        //self.callApi(globalLocation, latitide: globalLatitide, longitude: globalLongitude, type: globalType, country: globalCountry)
    }
    
    
    

    
    
    

    
    
    
    
      
    
    //MARK:- main viewDidload function
    //MARK:-
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        PlanDeleteBool = true
        self.navigationController?.isNavigationBarHidden=true
        
        apiClass.sharedInstance().delegate=self //delegate for response api
    
        uId = Udefaults .string(forKey: "userLoginId")!
        print(Udefaults .integer(forKey: "indexToolTips"))
       
        let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = "Fetching..."
        
        
        
        
        //---- manage view behind the status and navigation bar----////
        self.edgesForExtendedLayout = UIRectEdge()
        self.extendedLayoutIncludesOpaqueBars=false
        self.automaticallyAdjustsScrollViewInsets = false// adjust navigation bar
        
      
        
        
        
       ////---- get data of saved intrests -----///////
        
        tabledata = Udefaults.array(forKey: "arrayOfIntrest") as! NSMutableArray
        //(Userdefaults.standard.array(forKey: "arrayOfIntrest")! as [Any])
        //print(tabledata)
        
        globalLocation = (tabledata .object(at: selectedindxSearch) as AnyObject).value(forKey: "location") as! NSString
        
        let ArrToSeperate = globalLocation .components(separatedBy: ",")
        if ArrToSeperate.count>0 {
            globalLocation=ArrToSeperate[0] as String as NSString
        }

        
        
        globalPlaceid = (tabledata .object(at: selectedindxSearch) as AnyObject).value(forKey: "placeId") as! NSString
        UserDefaults.standard.set(self.globalPlaceid, forKey: "selectedLocationId")
        
        
         globalFullName = (tabledata .object(at: selectedindxSearch) as AnyObject).value(forKey: "fullName") as! NSString
        
        //globalLongitude = tabledata .objectAtIndex(selectedindxSearch) .valueForKey("long") as! NSString
        globalType = (tabledata .object(at: selectedindxSearch) as AnyObject).value(forKey: "type") as! NSString
        //globalCountry = tabledata .objectAtIndex(selectedindxSearch) .valueForKey("country") as! NSString
       
        UserDefaults.standard.set(self.globalLocation, forKey: "selectedLocation")
        
        
    

        
        
        /////0------  Pull to refresh Control ------////////
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "")// "Fetching Feeds")
        refreshControl.addTarget(self, action: #selector(mainHomeViewController.refresh(_:)), for: UIControlEvents.valueChanged)
        self.imagesTableView.addSubview(refreshControl)
        
        
        
      
       
       
      
         self.imagesTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
      
        
        
        //bucketListCount.layer.cornerRadius=bucketListCount.frame.size.width/2
        //bucketListCount.clipsToBounds=true
       // storyListCount.layer.cornerRadius=storyListCount.frame.size.width/2
       // storyListCount.clipsToBounds=true
        
        
        
        ////--- segment control ---//
        
        //let viewWidth = CGRectGetWidth(self.view.frame)
        
       ////print(tabledata)
        let temAr = NSMutableArray()
        for cc in 0..<tabledata.count {
           
            let fullNmStr = (tabledata.object(at: cc) as AnyObject).value(forKey: "location") as? String ?? ""
            
            let ArrToSeperate2 = fullNmStr .components(separatedBy: ",")
            if ArrToSeperate2.count>0 {
                temAr .add(ArrToSeperate2[0] as String)
            }
            
        }
       
        
        
       
        
        segmentControl.clipsToBounds=true
        segmentControl.sectionTitles = temAr as! [String]
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
        segmentControl.setSelectedSegmentIndex(UInt(selectedindxSearch), animated: true)
    
        segmentControl.addTarget(self, action: #selector(self.segmentedControlChangedValue), for: .valueChanged)
    
        
        
        
       
        
        let widthTotal = self.view.frame.size.width / 2
        
        self.imagesTableView.rowHeight = widthTotal + 78
        
        NotificationCenter.default.addObserver(self, selector: #selector(mainHomeViewController.loadList(_:)),name:NSNotification.Name(rawValue: "load"), object: nil)

         NotificationCenter.default.addObserver(self, selector: #selector(mainHomeViewController.loadCount(_:)),name:NSNotification.Name(rawValue: "loadCount"), object: nil)

       // let notName = NSNotification.Name("loadCount")
        //NotificationCenter.default.addObserver(self, selector: #selector(self.loadCount(_:)), name: notName, object: nil)
        
        
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(mainHomeViewController.loadDeletedCell(_:)),name:NSNotification.Name(rawValue: "loadDeleteinHome"), object: nil)
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(mainHomeViewController.loadfromEdit(_:)),name:NSNotification.Name(rawValue: "refreshFromEdit"), object: nil)
        
        
        
         NotificationCenter.default.addObserver(self, selector: #selector(mainHomeViewController.moveToTop(_:)),name:NSNotification.Name(rawValue: "refreshToTop"), object: nil)
        
        
        
      //add actions to the popup buttons
        likeButtonDetailView.addTarget(self, action: #selector(self.likeButtonPressed(_:)), for: .touchUpInside)
        //commentButtonDetailView.addTarget(self, action: #selector(self.addCommentTapped(_:)), for: .touchUpInside)
        addToPlanBtn.addTarget(self, action: #selector(self.storyButtonTapped(_:)), for: .touchUpInside)
        addToBucketBtn.addTarget(self, action: #selector(self.bucketButtonTapped(_:)), for: .touchUpInside)
        editButtonDetailview.addTarget(self, action: #selector(self.editButtonTapped(_:)), for: .touchUpInside)

      
        
        
    }
    
    
    
    //Function to add tooltips into the controller
    
    func addToolTip()
    {
    let tipsNumber = Udefaults .integer(forKey: "indexToolTips")
        
        for view in self.tipsView.subviews
        {
            view.removeFromSuperview()
        }
        
        //tipsView.removeFromSuperview()
        
        tipsView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        tipsView.backgroundColor = UIColor .init(colorLiteralRed: 0/255, green: 0/255, blue: 0/255, alpha: 0.85)
        self.view.window?.addSubview(tipsView)
//        if !self.view.window?.didAddSubview(tipsView) {
//
//        }
        
    tipsView.isHidden = false
        
        
        
        switch tipsNumber {
        //Tool tip for like
        case 0:
            
            let img = UIImageView()
            img.image = UIImage (named: "likeTool")
            img.frame = CGRect(x: 12 , y: imagesTableView.frame.origin.y + 60, width: (img.image?.size.width)!, height: img.image!.size.height)
            
            tipsView .addSubview(img)
            
            
            let buttonTips = UIButton()
            buttonTips.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            buttonTips.tag =  1000*0+0
           
            buttonTips.addTarget(self, action: #selector(self.tempLike), for: UIControlEvents .touchUpInside)
            tipsView .addSubview(buttonTips)
            
            Udefaults .set(1, forKey: "indexToolTips")
            

            
            break
            
            //Tool tip for chat
            
            
        case 1:
            
            
            let img = UIImageView()
            img.image = UIImage (named: "moreTool")
            img.frame = CGRect(x: ((tipsView.frame.size.width / 1.25 - img.image!.size.width) + 3 ) ,y: imagesTableView.frame.origin.y + 63, width: (img.image?.size.width)!, height: img.image!.size.height)
            
            tipsView .addSubview(img)
            
            
            let buttonTips = UIButton()
            buttonTips.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            
            buttonTips.addTarget(self, action: #selector(mainHomeViewController.tempMore), for: UIControlEvents .touchUpInside)
            tipsView .addSubview(buttonTips)
            
            Udefaults .set(2, forKey: "indexToolTips")
            
            
           
            
            
            break
            
            
            
            //Tool tip for search
            
        case 2:
            
            let img = UIImageView()
            img.image = UIImage (named: "chatTool")
            img.frame = CGRect( x: ((tipsView.frame.size.width - img.image!.size.width) - 4), y: imagesTableView.frame.origin.y + 22, width: (img.image?.size.width)!, height: img.image!.size.height)
            
            tipsView .addSubview(img)
            
            
            let buttonTips = UIButton()
            buttonTips.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            buttonTips.tag =  0
            buttonTips.addTarget(self, action: #selector(self.tempchat), for: UIControlEvents .touchUpInside)
            tipsView .addSubview(buttonTips)
            
            Udefaults .set(3, forKey: "indexToolTips")
            
            break
            
           //tool tip for more info
        case 3:
            
            let img = UIImageView()
            img.image = UIImage (named: "searchTool")
            img.frame = CGRect(x: ((tipsView.frame.size.width - img.image!.size.width) - 52) , y: 30, width: (img.image?.size.width)!, height: img.image!.size.height)
            
            tipsView .addSubview(img)
            
            
            let buttonTips = UIButton()
            buttonTips.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            buttonTips.addTarget(self, action: #selector(mainHomeViewController.tempSearch), for: UIControlEvents .touchUpInside)
            tipsView .addSubview(buttonTips)
            
            Udefaults .set(4, forKey: "indexToolTips")
            
            
            
            break
            
            
            
        case 4:
            
            
            let img = UIImageView()
            img.image = UIImage (named: "postTool")
            img.frame = CGRect(x: (tipsView.frame.size.width / 2 - img.image!.size.width / 2 - 7) , y: (tipsView.frame.size.height - img.image!.size.height - 2) , width: (img.image?.size.width)!, height: img.image!.size.height)
            
            
            tipsView .addSubview(img)
            
            
            let buttonTips = UIButton()
            buttonTips.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            
            buttonTips.addTarget(self, action: #selector(mainHomeViewController.tempPostScreen), for: UIControlEvents .touchUpInside)
            tipsView .addSubview(buttonTips)
            
            Udefaults .set(5, forKey: "indexToolTips")
            //
            
           
            
            
            
            break
            
            
        case 5:
            
            let img = UIImageView()
            img.image = UIImage (named: "storyTool")
            img.frame = CGRect(x: 9 , y: 30, width: (img.image?.size.width)!, height: img.image!.size.height)
            
            tipsView .addSubview(img)
            
            
            let buttonTips = UIButton()
            buttonTips.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            buttonTips.addTarget(self, action: #selector(mainHomeViewController.tempStoryScreen), for: UIControlEvents .touchUpInside)
            tipsView .addSubview(buttonTips)
            
            Udefaults .set(6, forKey: "indexToolTips")
            
            
            
            break
            
        case 6:
            
            let img = UIImageView()
            img.image = UIImage (named: "bucketTool")
            img.frame = CGRect(x: ((tipsView.frame.size.width - img.image!.size.width) - 15) , y: 32, width: (img.image?.size.width)!, height: img.image!.size.height)
            
            
            tipsView .addSubview(img)
            
            
            let buttonTips = UIButton()
            buttonTips.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            
            buttonTips.addTarget(self, action: #selector(mainHomeViewController.tempBucket), for: UIControlEvents .touchUpInside)
            tipsView .addSubview(buttonTips)
            
            Udefaults .set(7, forKey: "indexToolTips")
            
            break
        
        
        default:
        print("default")
            
        
            
        }
        
        
        
        
        
        
    }
    
    
    
    func tempLike() {
        
       // tipsView.isHidden = true
        // toolTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.addToolTip), userInfo: nil, repeats: false)
        
        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(2.0 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
//            
//            self.addToolTip(1)
//        }
       
        
    }
    
    func tempMore() {
        tipsView.isHidden = true
       // toolTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.addToolTip), userInfo: nil, repeats: false)
        
    }
    
    func tempchat() {
         tipsView.isHidden = true
       // toolTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.addToolTip), userInfo: nil, repeats: false)
        
    }
    
    
    func tempSearch() {
         tipsView.isHidden = true
       // toolTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.addToolTip), userInfo: nil, repeats: false)
        
    }
    
    func tempStoryScreen() {
        self.tipsView.isHidden = true
    }
    
    func tempPostScreen() {
        self.tipsView.isHidden = true
    }
    
    func tempBucket() {
        
        self.tipsView .removeFromSuperview()
        showTooltips = false
    }

    
    
    
    
    
    
    
    
    
    
    
//MARK: -   ///// Function to get the notification for the chat mesages is received
//MARK:
    
    
    
    ////Add this method in view did appear to get the messages
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        SocketIOManager.sharedInstance.getChatMessageNotify { (messageInfo) -> Void in
            // dispatch_async(dispatch_get_main_queue(), { () -> Void in
            
            let count: String = String(describing: messageInfo["count"]!)
            
            self.tabBarController?.tabBar.items?[3].badgeValue = count
            
            
            
            
            //  })
        }
    }

    
    
    
    
    
   //MARK:
        
    /////////////////////////////////////////////////////////////////////////
    //MARK:reload from another class(detailview class)
    //MARK:-
    func loadList(_ notification: Notification){
        //load data here
        
      //print(likeCount.lastObject)
        
        self.imagesTableView .reloadData()
    
        
    }
   
    
    
    func loadDeletedCell(_ notification: Notification) {
        
        self .deletePhotoTemporary()
        
    }
    
    
    func loadfromEdit(_ notification: Notification) {
        
        self .refresh(self)
        
       //  self.callApi(globalPlaceid, type: globalType)
        self.imagesTableView.reloadData()
    }
    
    //move to top if agaion press home button
    func moveToTop(_ notification: Notification) {
        
        self.imagesTableView.setContentOffset(CGPoint.zero, animated: true)
        
    }
    
    @IBAction func feedButtonAction(_ sender: AnyObject) {
     self.imagesTableView.setContentOffset(CGPoint.zero, animated: true)
    }
    
    
    func moveToIndex(_ sender:UIButton) {
       
         let indexPath = IndexPath(row: sender.tag, section: 0)
        let cell = imagesTableView.cellForRow(at: indexPath) as! cellClassTableViewCell
       cell.imagesCollectionView .setContentOffset(CGPoint.zero, animated: true)

    }
    
    
    
    
    //MARK:reload from another class(Story Count class)
    //MARK:-
    
    func loadCount(_ notification: Notification){
        //load data here
        
      
       print(countArray.count)
      
        
        if countArray.count>0
        {
            
            let placeIds = (countArray.value(forKey: "_id")) as! NSArray
            
            if placeIds.contains(globalPlaceid) {
                print("Contains story")
                
            }
            
            storiesCollectionView.reloadData()
             let indexPath = IndexPath(row: tableIndex, section: 0)
            if  dataArray.count != 0
            {
                if planTap == true {
//                    let a:Int? = (sender.tag) / 1000
//                    let b:Int? = (sender.tag) % 1000
//                    
//                    collectionIndex = b!
//                    tableIndex = a!

                 
                    var BtnPln = UIButton()
                    if longTapedView is UIButton {
                        BtnPln = longTapedView as! UIButton
                        if (BtnPln.currentImage?.isEqual(UIImage(named: "travelplanbuttonactive")))! {
                            BtnPln.setImage(UIImage (named: "travelplanbutton"), for: .normal)
                        }
                        else
                        {
                            BtnPln.setImage(UIImage (named: "travelplanbuttonactive"), for: .normal)
                        }
                    }
                    else
                    {
                        print(self.longTapedView.subviews)
                         let indexPathCollection = IndexPath(row: collectionIndex, section: 0)//collectionView Index
                         let indexPathTable = IndexPath(row: tableIndex, section: 0)//tableView Index
                        let cell:cellClassTableViewCell = imagesTableView.cellForRow(at: indexPathTable) as! cellClassTableViewCell
                        cell.imagesCollectionView.reloadItems(at: [indexPathCollection])
                        
                       // BtnPln = self.longTapedView.viewWithTag(2000*tableIndex+collectionIndex)! as! UIButton
                        
                    }
                    
                    
                    
                    
                
                    
                    planTap = false
                }
                
                
               
                
            }
            
            
        }
        
       
        
        
        
       
        
        

//        countDictionary
//        if countArray.object(forKey: "bucketCount") != nil {
//            if let stCount = countArray.value(forKey: "bucketCount"){
//                
//                bucketListTotalCount=String(describing: stCount)
//            }
//            
//        }
        
        
        
        
        
       
    }

    
    
    
    
    
    
    
    
    
    
    /////////////////////////////////////////////////////////////////////////
    
    func tabBarController(_ aTabBar: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        //        if !self.hasValidLogin() && (viewController != aTabBar.viewControllers[0]) {
        //            // Disable all but the first tab.
        //            return false
        //        }
        
        
       //print("---------------Its comes here------------------")
        return true
    }
    
    
    
    
    
    
    
    
    
    
    /////////////////////////////////////////////////////////////////////////
        //MARK:- Pulltorefresh function
        //MARK:-
    
        func refresh(_ sender:AnyObject)
        {
            // Code to refresh table view
            
            selectedCell .removeAllObjects()
            likeCount .removeAllObjects()
            
           
            
            let arrayOfKeys:NSArray = reuseData.allKeys as NSArray
            if (arrayOfKeys.contains(globalLocation)) {
                
                reuseData[globalLocation]=nil
                
                
                
            }
            
           print(reuseData.allKeys)
            
            imagesTableView.isUserInteractionEnabled = false
            //check the count of story is avaliable or not
             if countArray.count < 1  {
                
                self.callApi(globalPlaceid, type: globalType)
                
               
            }
                
             else
             {
                let objt = storyCountClass()
               // let objt2 = UserProfileDetailClass()
               
                let dic:NSDictionary = ["userId": uId]
                objt.postRequestForcountStory(parameterString: dic)
                objt.postRequestForcountStoryandBucket(dic)
                //objt2.postRequestForGetTheUserProfileData(uId)
        
                self.callApi(globalPlaceid, type: globalType)
                
            }
           
            self.view .bringSubview(toFront: imagesTableView)
            
        }
    
   
    
    //MARK:
    //////////////////////////////////////////////////////////////////////////
    //MARK:-delegate and datasource of tableView
    //MARK:-
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int
    {
        return 1
    }
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        if(section==0)
//        {
//            return 78.5
//        }
//        return 0.000000000000000001
//    }
//    
//    func tableView( _ tableView: UITableView, viewForFooterInSection section: Int) -> UIView?
//    {
//        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 20))
//        footerView.backgroundColor = UIColor(red: 208/255.0 , green: 208/255.0 , blue: 208/255.0 , alpha: 0.36)
//        return footerView
//        
//    }
//    func tableView( _ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
//    {
//        return 0.0000000001
//    }
//
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//
//
//        if(section==0)
//        {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "storyTableHeaderCell") as! storyTableHeaderCell
//
//            cell.storiesCollectionView.delegate = self
//            cell.storiesCollectionView.dataSource = self
//            cell.storiesCollectionView.tag = 1221
//            cell.storiesCollectionView.collectionViewLayout.invalidateLayout()
////            OperationQueue.main.addOperation({ () -> Void in
////                cell.storiesCollectionView.reloadData()
////            })
//
//            return cell
//        }
//        let view = UIView()
//        view.frame = CGRect(x: 0 , y: 0 , width: view.frame.width , height: 0)
//        view.backgroundColor = UIColor.blue
//        return view
//
//    }
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
     {
        if(pageNumber == 0)
        {
            return dataArray.count
        }
        else
        {
            if dataArray.count==0 {
                return dataArray.count
            }
            
            return dataArray.count + 1
        }
        
    }
   
    
    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat
    {
        if indexPath.row < dataArray.count
        {
            let widthTotal = self.view.frame.size.width / 2
            self.imagesTableView.rowHeight = widthTotal + 100
            return widthTotal + 100
        }
        else
        {
            return 50.0
        }
     }
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell
    {
      
        if indexPath.row < dataArray.count
        {
            let cell:cellClassTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellHome") as! cellClassTableViewCell
            
            cell.userNameLabel.text = (self.userDetailArray .object(at: indexPath.row) as AnyObject).value(forKey: "name") as? String
            cell.useraddressLabel.text = (self.userDetailArray .object(at: indexPath.row) as AnyObject).value(forKey: "email") as? String
            cell.useraddressLabel.isHidden=true
            
//            let pImage : UIImage = UIImage(named:"dummyBackground2")! //placeholder image
//            
//            /////------ user profile pics---/////
//            print(self.userDetailArray.object(at: indexPath.row))
//            
//            let profileImage = (self.userDetailArray .object(at: indexPath.row) as AnyObject).value(forKey: "profile")! as! NSString
//
//            //            let block: SDWebImageCompletionBlock! = {(image: UIImage!, error: NSError!, cacheType: SDImageCacheType!, imageURL: URL!) -> Void in
////                
////            }
//            
//            if profileImage .isEqual(to: "")
//            {
//                cell.userProfilePic.image = pImage
//            }
//            else
//            {
//                let url = URL(string: profileImage as String)
//                cell.userProfilePic.sd_setImage(with: url, placeholderImage: pImage) //sd_setImage(with: url, placeholderImage: pImage, completed: block)
//            }
//            
//            
//            ///////---- give a border with color to user profile picture----///////
//            
//            cell.userProfilePic.layer.borderWidth = 1.3
            let random = { () -> Int in
                return Int(arc4random_uniform(UInt32(self.colorArray.count)))
            }
            let color = self.colorArray[random()]//get color randomly
            cell.userProfilePic.layer.borderColor = color  .cgColor
            cell.userProfilePic.layer.cornerRadius = cell.userProfilePic.frame.size.width/2
            cell.userProfilePic.clipsToBounds=true
            cell.ChatButton.tag=indexPath.row // chat button
            cell.ChatButton.addTarget(self, action: #selector(self.chatButtonAction), for: .touchUpInside)
            cell.ChatButton.isHidden=false
            let idUser = (self.userDetailArray .object(at: indexPath.row) as AnyObject).value(forKey: "id") as? String ?? ""
            if uId == idUser {
                cell.ChatButton.isHidden=true
            }
            
                
            cell.userProfileButton.tag = indexPath.row
            cell.userProfileButton.addTarget(self, action: #selector(mainHomeViewController.openProfileOfuser(_:)), for: UIControlEvents .touchUpInside)
            
            cell.ChatButton.layer.cornerRadius=cell.ChatButton.frame.size.height/2
            cell.ChatButton.clipsToBounds=true
           
            
            
            
            
            cell.imagesCollectionView.delegate=self
            cell.imagesCollectionView.dataSource=self
            

            DispatchQueue.main.async(execute: {
                cell.imagesCollectionView.tag=indexPath.row
                cell.imagesCollectionView.collectionViewLayout.invalidateLayout()
            cell.imagesCollectionView.reloadData()
           })
            if segmentBool == true {
                if indexPath.row > 2
                {
                    self.segmentBool = false
                }
                cell.imagesCollectionView.setContentOffset(CGPoint.zero, animated: false)
            }
            
           // cell.layer.shouldRasterize = true
           // cell.layer.rasterizationScale = UIScreen.main.scale

            return cell
        }
        
        else
        {
            pageNumber = dataArray.count
           // print(pageNumber)
            
            let cell = UITableViewCell() //
            cell.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width - 9, height: 50)
            
            cell.contentView.backgroundColor = UIColor .init(colorLiteralRed: 240/255, green: 240/255, blue: 240/255, alpha: 1)
            
            
            cell.layer.shouldRasterize = true
            cell.layer.rasterizationScale = UIScreen.main.scale
            
            
            let spinner = UIActivityIndicatorView()
            
            spinner.isHidden = false
            
            spinner.activityIndicatorViewStyle = .gray
            spinner.frame = CGRect(x: cell.frame.size.width/2 - 20 , y: cell.frame.size.height/2 - 17, width: 40, height: 40)
            cell.addSubview(spinner)
            
            
            if self.dataArray.count >= 1 {
                spinner.startAnimating()
            }
            
            DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async(execute: {
                let parameterString:NSDictionary = ["userId": self.uId, "type": self.globalType, "placeId": self.globalPlaceid, "fullName": self.globalFullName, "skip": self.pageNumber]
                
                print(parameterString)
                
                logOut = false
                let urlstringFeed = "\(appUrl)search_feed_screen_v2" //search_feed_screen"
                self.pageNumber = 1
               
                self.reuseData.setObject(self.pageNumber, forKey: "ShowMore\(self.globalLocation)" as NSCopying)
                if self.showApiHitted == false{
                    apiClass.sharedInstance().getRequest(parameterString: parameterString, urlStringMultiple: urlstringFeed as NSString, viewController: self)
                    self.showApiHitted = true
                }
                
            })
            
            

            
            
            
            /////////////////-------
            
            
             return cell
            
    }
    
        
    }
    
    

    
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath)
    {
       
        
    }
    
    
    
    
    
    
     func tableView(_ tableView: UITableView,
                            willDisplayCell cell: UITableViewCell,
                                            forRowAtIndexPath indexPath: IndexPath) {
        
       guard let tableViewCell = cell as? cellClassTableViewCell else { return }
        if indexPath.row == dataArray.count {
            
        }
        else
        {
            
            let pImage : UIImage = UIImage(named:"dummyBackground2")! //placeholder image
            
            /////------ user profile pics---/////
            
            let profileImage = (self.userDetailArray .object(at: indexPath.row) as AnyObject).value(forKey: "profile")! as! NSString
            
    
            if profileImage .isEqual(to: "")
            {
                tableViewCell.userProfilePic.image = pImage
            }
            else
            {
                let url = URL(string: profileImage as String)
                tableViewCell.userProfilePic.sd_setImage(with: url, placeholderImage: pImage)
            }
            
            
            ///////---- give a border with color to user profile picture----///////
            
            tableViewCell.userProfilePic.layer.borderWidth = 1.3
            
            
            
            
            tableViewCell.collectionViewOffset = storedOffsets[indexPath.row] ?? 0
        }
        
        
        
    }
    
    
     func tableView(_ tableView: UITableView,
                            didEndDisplayingCell cell: cellClassTableViewCell,
                                                 forRowAtIndexPath indexPath: IndexPath) {
        
        guard let tableViewCell = cell as? cellClassTableViewCell else { return }
        
        if indexPath.row < dataArray.count
        {
            if indexPath.row > storedOffsets.count {
                
            }
            else
            {
                  //storedOffsets[indexPath.row] = tableViewCell.collectionViewOffset
            }
           
        }
       
        
    }
    
    
    
    
    //MARK:
    
    //MARK: Profile of user
    func openProfileOfuser(_ sender: UIButton) {
        
        print(sender.tag)
        
        let idUser = (self.userDetailArray .object(at: sender.tag) as AnyObject).value(forKey: "id") as? String ?? ""
        let profileImage = (self.userDetailArray .object(at: sender.tag) as AnyObject).value(forKey: "profile")! as! NSString
        
        
//        let nxtObj2 = self.storyboard?.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
//       
//        nxtObj2.otheruserId = idUser as NSString
//        nxtObj2.boolProfileOther = true
//        nxtObj2.otherUserProfile = profileImage
//        nxtObj2.otherUsername = ((self.userDetailArray .object(at: sender.tag) as AnyObject).value(forKey: "name") as? String)!
//        
//        self.navigationController! .pushViewController(nxtObj2, animated: true)
        
        
        
    }
    
    
    
    
    
    
    
    
    
    /////////////////////////////////////////////////////////////////////////
    
    //MARK:-/////////////////////  buttons Action here //////////////
    //MARK:
    //MARK:- Chat button
    func chatButtonAction(_ sender: UIButton!)
    {
      
        tipsView .isHidden = true
        
        
        let user2Id = (userDetailArray.object(at: sender.tag) as AnyObject).value(forKey: "id") as? String ?? ""
        let usname = (userDetailArray.object(at: sender.tag) as AnyObject).value(forKey: "name") as? String ?? ""
        let receiverProfileImage = (userDetailArray .object(at: sender.tag) as AnyObject).value(forKey: "profile")! as? String ?? ""
        
        
        
        
        var arrImgThumbnail = NSArray()
        var arrImgLarge = NSArray()
        
         arrImgLarge = (self.arrayOfimages1[sender.tag] as AnyObject).value(forKey: "largeImage") as! NSArray
        arrImgThumbnail = (self.arrayOfimages1[sender.tag] as AnyObject).value(forKey: "thumbnails") as! NSArray
        
        let sendArray = NSMutableArray()
        
        if arrImgLarge.count == arrImgThumbnail.count {
           
            for i in 0 ..< arrImgLarge.count {
                
                sendArray .add(["Thumbnail": arrImgThumbnail.object(at: i) as? String ?? "", "Large": arrImgLarge.object(at: i) as? String ?? ""])
                
                
            }
            
            
            
        }
        else{
            
        }
        
        
        let nxtObj = self.storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        nxtObj.CountTableArray = sendArray
        nxtObj.receiver_Id = user2Id as NSString
        nxtObj.locationName = globalLocation
        nxtObj.locationType = globalType
        nxtObj.receiverName = usname as NSString
        nxtObj.receiverProfile = receiverProfileImage as NSString
        nxtObj.locationId = globalPlaceid
        self.navigationController! .pushViewController(nxtObj, animated: true)
       // nxtObj.hidesBottomBarWhenPushed = true
        
        
    }
    
    
    
    
    
    //MARK:-
    ////MARK:-Go to search Screen action here
    
    @IBAction func SearchScreenAction(_ sender: AnyObject)
    {
        
       
        tipsView .removeFromSuperview()
        tipsView = UIView()
        self.tabBarController?.tabBar.isHidden = true
        let nxtObj = self.storyboard?.instantiateViewController(withIdentifier: "searchScreenViewController") as! searchScreenViewController
       
         //DispatchQueue.main.async(execute: {
            self.navigationController! .pushViewController(nxtObj, animated: true)
       // self.tabBarController?.setTabBarVisible(visible: false, animated: true)

        
        
       // })
        
    }
    
    
    @IBAction func ReloadStoriesCollection(_ sender: AnyObject)
    {
        PlanDeleteBool = true//false
        if planAllLocation == false {
            planAllLocation = true//true to show the all plans
            changePlanImage.image = UIImage (named: "PlanActive")
            storiesCollectionView.reloadData()
            
        }
        else
        {
            
            planAllLocation = false//false to show the plans of that place
            storiesCollectionView.reloadData()
            changePlanImage.image = UIImage (named: "Plan")
        }
        

    }

    
    
    
    
    //MARK:- Stoy Action Button----//////
    
    @IBAction func storyBtnAction(_ sender: AnyObject) {
        
//        tipsView .isHidden = true
//        
//        let nxtObj = self.storyboard?.instantiateViewController(withIdentifier: "storyViewcontrollerViewController") as! storyViewcontrollerViewController
//        
//        DispatchQueue.main.async(execute: {
//            self.navigationController! .pushViewController(nxtObj, animated: true)
//            nxtObj.hidesBottomBarWhenPushed = true
//        })
        
    }
    
    
    
    
    
    
    
    
    //MARK:- Bucket button--//
    
    @IBAction func bucketListButton(_ sender: AnyObject) {
//    
//        let nxtObj = self.storyboard?.instantiateViewController(withIdentifier: "BucketListViewController") as! BucketListViewController
//        
//        DispatchQueue.main.async(execute: {
//            self.navigationController! .pushViewController(nxtObj, animated: true)
//            nxtObj.hidesBottomBarWhenPushed = true
//        })
    
    
    }
    
    
    
    
    
    
    
    
    
    
    
    //MARK:- ////////////////// Functions to manage like, unlike, add to story, add to bucket ////////////////
    
    
    
    //MARK:- Tap gesture functions to manage the popup view
    
    
    
    func tempFunc() -> Void {
        
        self .detailSelectBtnAction(false)
        
    }
    
    
    
    
    
    
    
    //MARK: Like Button tapped
    func likeButtonPressed(_ sender: UIButton)  {
        
        
        //    func likeImageTapped()
        //{
        // Your action
        
        
        
        var arrId = NSArray()
        arrId = (self.arrayOfimages1[tableIndex] as AnyObject).value(forKey: "id") as! NSArray
        let imageId = arrId[collectionIndex] as? String ?? ""
        let userNameMy = Udefaults.string(forKey: "userLoginName")
        
        let otherUserId = (userDetailArray.object(at: tableIndex) as AnyObject).value(forKey: "id") as? String ?? ""
        
        
        
        
        
        
        
        let likecountlbl = longTapedView.viewWithTag(7478) as! UILabel
        
        // hide and show the view of like
        
        
        let likeimg = longTapedView.viewWithTag(7477) as! UIImageView
        
        
        
        //MARK: LIKE COUNT MANAGE
        
        var countLik = NSNumber()
        
        let likeCountValue = (self.arrayOfimages1[tableIndex] as AnyObject).value(forKey: "likeCount") as! NSArray
        if likeCountValue[collectionIndex] as? NSNull != NSNull()  {
            
            countLik = likeCountValue[collectionIndex] as! NSNumber  //as? String ?? "0.0"
            
            
        }else
        {
            countLik=0
            
        }
        
        
        
        if likeCount.count>0 {
            let likecountarr = likeCount.value(forKey: "imageId") as! NSArray
            if likecountarr.contains(imageId) {
                
                // if (likeCount.value(forKey: "imageId") as AnyObject).contains(imageId) {
                
                let index = (self.likeCount.value(forKey: "imageId") as AnyObject).index(of: imageId)
                
                if (likeCount.object(at: index) as AnyObject).value(forKey: "like") as! Bool == true {
                    
                    let staticCount = (likeCount.object(at: index) as AnyObject).value(forKey: "count") as? NSNumber
                    likecountlbl.text=String(self.subtractTheLikes(staticCount!))
                    
                    
                    likeCount .removeObject(at: index)
                    
                    likeCount .add(["userId":uId, "imageId":imageId, "like":false, "count": self.subtractTheLikes(staticCount!)])
                    
                    
                    
                    
                    likeimg.image=UIImage (named: "Like")
                    
                    let dat: NSDictionary = ["userId": "\(uId)", "photoId":"\(imageId)", "userLiked":"\(uId)", "status":"0", "imageOwn": "\(otherUserId)", "userName": "\(userNameMy!)"]
                    DispatchQueue.main.async(execute: {
                        apiClass.sharedInstance().postRequestLikeUnlikeImage(parameters: dat, viewController: self)
                    })
                    
                }
                else
                {
                    let staticCount = (likeCount.object(at: index) as AnyObject).value(forKey: "count") as? NSNumber
                    likecountlbl.text=String(self.addTheLikes(staticCount!))
                    
                    likeCount .removeObject(at: index)
                    likeCount .add(["userId":uId, "imageId":imageId, "like":true, "count": self.addTheLikes(staticCount!)])
                    
                    
                    
                    likeimg.image=UIImage (named: "likefill")
                    
                    let dat: NSDictionary = ["userId": "\(uId)", "photoId":"\(imageId)", "userLiked":"\(uId)", "status":"1", "imageOwn": "\(otherUserId)", "userName": "\(userNameMy!)"]
                    
                    
                    DispatchQueue.main.async(execute: {
                        apiClass.sharedInstance().postRequestLikeUnlikeImage(parameters: dat, viewController: self)
                    })
                    
                }
            }
                // if not liked already
            else{
                likeCount .add(["userId":uId, "imageId":imageId, "like":true, "count": self.addTheLikes(countLik)])
                likecountlbl.text=String(self.addTheLikes(countLik))
                likeimg.image=UIImage (named: "likefill")
                
                let dat: NSDictionary = ["userId": "\(uId)", "photoId":"\(imageId)", "userLiked":"\(uId)", "status":"1", "imageOwn": "\(otherUserId)", "userName": "\(userNameMy!)"]
                
                
                DispatchQueue.main.async(execute: {
                    apiClass.sharedInstance().postRequestLikeUnlikeImage(parameters: dat, viewController: self)
                })
            }
            
        }
            
        else
            
        {
            
            likeCount .add(["userId":uId, "count":self.addTheLikes(countLik), "like": true, "imageId": imageId])
            likecountlbl.text=String(self.addTheLikes(countLik))
            likeimg.image=UIImage (named: "likefill")
            
            let dat: NSDictionary = ["userId": "\(uId)", "photoId":"\(imageId)", "userLiked":"\(uId)", "status":"1", "imageOwn": "\(otherUserId)", "userName": "\(userNameMy!)"]
            
            
            DispatchQueue.main.async(execute: {
                apiClass.sharedInstance().postRequestLikeUnlikeImage(parameters: dat, viewController: self)
            })
        }
        
        
        
        
        
        
        
        
        self.tempFunc()
        
        
        
        
        
    }
    
    
    //MARK: Add comment button Tapped
    
    func addCommentTapped(_ sender: UIButton) {
        
         self.tempFunc()
        
        
    }
    
    
    
    
    ///MARK:- Story Button tapped
    
    func storyButtonTapped(_ sender: AnyObject)
    {
        // Your action
        
       //"Story image tapped")
        planTap = true
        storyBucketBool = true //make true when add to story
        
        var imageId = NSString()
        
        let ownersId = (userDetailArray.object(at: tableIndex) as AnyObject).value(forKey: "id") as? String ?? ""
        var arrId = NSArray()
        arrId = (self.arrayOfimages1[tableIndex] as AnyObject).value(forKey: "id") as! NSArray
        
        imageId = arrId[collectionIndex] as! String as NSString
       
       // print(self.arrayOfimages1[tableIndex])
        
        let countIdArr = (self.arrayOfimages1[tableIndex] as AnyObject).value(forKey: "countId") as! NSArray
        let CountryId = countIdArr[collectionIndex] as! String as NSString

        
        let countNameArr = (self.arrayOfimages1[tableIndex] as AnyObject).value(forKey: "country") as! NSArray
        let cname = countNameArr[collectionIndex] as! String as NSString
        
        
        var countst = NSNumber()
        countst = 0
       
        let placeIds = (countArray.value(forKey: "countryId")) as! NSArray
        
       
         //addToPlanBtn .setTitle("Add To Plan", for: .normal)
         var dat = NSDictionary()
        if countsDictionary.object(forKey: "bookings") != nil
        {
            let countst = countsDictionary.value(forKey: "bookings") as! NSArray
            if countst.count>0
            {
                if countst.contains(imageId) {
                    //remove plan api
                   // addToPlanBtn .setTitle("Remove From Plan", for: .normal)
                    let indx = placeIds .index(of: CountryId)
                    let bookingid = ((countArray.object(at: indx)) as AnyObject).value(forKey: "_id") as? String ?? ""
                    let pId = ((countArray.object(at: indx)) as AnyObject).value(forKey: "_id") as? String ?? ""
                    apiClass.sharedInstance().deleteLocationFromPlan(placeId: imageId, bookingIdFinal: bookingid as NSString)
                }
                else
                {
                //add plan 
                    if placeIds.contains(CountryId)
                    {
                        print("Contains story")
                        let indx = placeIds .index(of: CountryId)
                        print(indx)
                        
                        let bookingid = ((countArray.object(at: indx)) as AnyObject).value(forKey: "_id") as? String ?? ""
                        
                        dat = ["userId": "\(uId)", "imageId": imageId, "countryId": CountryId, "countryName": cname, "imageOwn": ownersId, "bookingId": bookingid ]
                        
                    }
                    else
                    {
                        dat = ["userId": "\(uId)", "imageId": imageId, "countryId": CountryId, "countryName": cname, "imageOwn": ownersId ]
                    }
                    
                    
                    
                    
                    
                    //type=self,globaltype
                    var postDict = NSDictionary()
                    
                    postDict = dat
                    
                    
                    
                    print("Post parameters to select the images for story--- \(postDict)")
                    
                    //add image to story
                    
                    
                    DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async(execute: {
                        apiClass.sharedInstance().postRequestWithMultipleImage(parameterString: "", parameters: postDict, viewController: self)
                    })
                    
                    self.proceedBtnAction(tableIndex, collectionViewIndex: collectionIndex)
                    
                    self.detailSelectBtnAction(true)
                }
                
            }
                
            else
            {
                
                if placeIds.contains(CountryId)
                {
                    print("Contains story")
                    let indx = placeIds .index(of: CountryId)
                    print(indx)
                    
                    let bookingid = ((countArray.object(at: indx)) as AnyObject).value(forKey: "_id") as? String ?? ""
                    
                    dat = ["userId": "\(uId)", "imageId": imageId, "countryId": CountryId, "countryName": cname, "imageOwn": ownersId, "bookingId": bookingid ]
                    
                }
                else
                {
                    dat = ["userId": "\(uId)", "imageId": imageId, "countryId": CountryId, "countryName": cname, "imageOwn": ownersId ]
                }
                
                
                
                
                
                //type=self,globaltype
                var postDict = NSDictionary()
                
                postDict = dat
                
                
                
                print("Post parameters to select the images for story--- \(postDict)")
                
                //add image to story
                
                
                DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async(execute: {
                    apiClass.sharedInstance().postRequestWithMultipleImage(parameterString: "", parameters: postDict, viewController: self)
                })
                
                self.proceedBtnAction(tableIndex, collectionViewIndex: collectionIndex)
                
                self.detailSelectBtnAction(true)
            }
        
        }
        else
        {
            //if there is no booking yet
             dat = ["userId": "\(uId)", "imageId": imageId, "countryId": CountryId, "countryName": cname, "imageOwn": ownersId ]
            //type=self,globaltype
            var postDict = NSDictionary()
            
            postDict = dat
            
            
            
            print("Post parameters to select the images for story--- \(postDict)")
            
            //add image to story
            
            
            DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async(execute: {
                apiClass.sharedInstance().postRequestWithMultipleImage(parameterString: "", parameters: postDict, viewController: self)
            })
            
            self.proceedBtnAction(tableIndex, collectionViewIndex: collectionIndex)
            
            self.detailSelectBtnAction(true)
            
        }
        
        
        
        
        /*
        if  addToPlanBtn.titleLabel?.text=="Add To Plan"
        {
            
        //let dat: NSDictionary = ["userId": "\(uId)", "imageId": imageId, "placeId": globalPlaceid, "placeType": self.globalType, "ownerId": ownersId ]
            var dat = NSDictionary()
            
            
            if placeIds.contains(CountryId)
            {
                print("Contains story")
                let indx = placeIds .index(of: CountryId)
                print(indx)
                
                let bookingid = ((countArray.object(at: indx)) as AnyObject).value(forKey: "_id") as? String ?? ""
                
                dat = ["userId": "\(uId)", "imageId": imageId, "countryId": CountryId, "countryName": cname, "imageOwn": ownersId, "bookingId": bookingid ]
                
            }
            else
            {
                dat = ["userId": "\(uId)", "imageId": imageId, "countryId": CountryId, "countryName": cname, "imageOwn": ownersId ]
            }
            
            
            
            
            
            //type=self,globaltype
            var postDict = NSDictionary()
            
            postDict = dat
            
        
            
           print("Post parameters to select the images for story--- \(postDict)")
            
            //add image to story
            
           
            DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async(execute: {
            apiClass.sharedInstance().postRequestWithMultipleImage(parameterString: "", parameters: postDict, viewController: self)
                })

            self.proceedBtnAction(tableIndex, collectionViewIndex: collectionIndex)
            
                        self.detailSelectBtnAction(true)
            
           // storyListCount.text=String(self.addTheLikes(countst))
            
        }
            
        else
        {
            
           // let dataStr: NSDictionary = ["userId": uId, "imageId": imageId]
            //print(dataStr)
         
            let indx = placeIds .index(of: CountryId)
            let bookingid = ((countArray.object(at: indx)) as AnyObject).value(forKey: "_id") as? String ?? ""
            let pId = ((countArray.object(at: indx)) as AnyObject).value(forKey: "_id") as? String ?? ""
            apiClass.sharedInstance().deleteLocationFromPlan(placeId: imageId, bookingIdFinal: bookingid as NSString)
            
        }
        */
       
        
        self.tempFunc()
        
        if Udefaults.integer(forKey: "indexToolTips") == 5 {
             self.manageToolsTipsShow()
        }
       
        
        
    }
    

    
    
    
    
    
    
    
    
    //MARK:bucket image tapped
    //MARK:
    
    func bucketButtonTapped(_ sender: UIButton)
    {
        // Your action
        
        //print("bucket image tapped")
        
        storyBucketBool = false //make false when add to bucket
        
        
        var imageId = NSString()
        var otherUserId = NSString()
        
        
        
        
        var arrId = NSArray()
        arrId = (self.arrayOfimages1[tableIndex] as AnyObject).value(forKey: "id") as! NSArray
        otherUserId = ""
        //(self.userDetailArray[tableIndex] as AnyObject).value(forKey: "id") as? String ?? ""
        
        imageId = arrId.object(at: collectionIndex) as? String as NSString? ?? ""
        
        
        
        //
        //        if  addToBucketLblInPopup.text=="Add To Bucket List"
        //        {
        //
        //            let parameterDic: NSDictionary = ["userId": uId,"imageOwn": otherUserId, "imageId": imageId ]
        //           //print("parameter of add t0 bucket=\(parameterString)")
        //
        //
        //
        //
        //
        //
        //            DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async(execute: {
        //               // bucketListApiClass.sharedInstance().postRequestForAddBucket(parameterDic, viewController: self)
        //
        //
        //
        //
        //
        //            })
        //
        //
        //            self.proceedBtnAction(tableIndex, collectionViewIndex: collectionIndex)
        //
        //
        //
        //
        //        }
        //        else
        //        {
        //
        //            let parameter: NSDictionary = ["userId": uId, "imageId": imageId]
        //
        //           // bucketListApiClass.sharedInstance().postRequestForDeletBucketListFromFeed(parameter, viewController: self)
        //
        //
        //
        //        }
        
        
        
        
        
        
        
        
        
        self.detailSelectBtnAction(true)
        
        
        
        
        self.tempFunc()
        
        if Udefaults.integer(forKey: "indexToolTips") == 6 {
            self.manageToolsTipsShow()
        }
        
        
        
    }
    
    
    
    //MARK: Edit Image Tapped
    
    func editButtonTapped(_ sender: UIButton)
    {
        self.tempFunc()
        
        
        
        
         let nxtObj2 = self.storyboard?.instantiateViewController(withIdentifier: "EditPostViewController") as! EditPostViewController
        
         nxtObj2.screenName = "Feed"
        
        
        //print(self.arrayOfimages1[self.tableIndex])
        
        
        var arrImg2 = NSArray()
        arrImg2 = (self.arrayOfimages1[self.tableIndex] as AnyObject).value(forKey: "largeImage") as! NSArray
        
        var ThumbArray = NSArray()
        ThumbArray = (self.arrayOfimages1[self.tableIndex] as AnyObject).value(forKey: "thumbnails") as! NSArray
        
        var geoTagArr = NSArray()
        geoTagArr = (self.arrayOfimages1[self.tableIndex] as AnyObject).value(forKey: "geoTag") as! NSArray
        
        var descriptionArr = NSArray()
        descriptionArr = (self.arrayOfimages1[self.tableIndex] as AnyObject).value(forKey: "description") as! NSArray
        
        var categoryArr = NSArray()
        categoryArr = (self.arrayOfimages1[self.tableIndex] as AnyObject).value(forKey: "category") as! NSArray
        
        var arrId = NSArray()
        arrId = (self.arrayOfimages1[self.tableIndex] as AnyObject).value(forKey: "id") as! NSArray
        
        
        let imageUrl = arrImg2[self.collectionIndex] as! String
        let imageId = arrId[self.collectionIndex] as! String
        let geoTagStr = geoTagArr[self.collectionIndex] as? String ?? ""
        let thumbnailStr = ThumbArray[self.collectionIndex] as? String ?? ""
        let descriptionStr = descriptionArr[self.collectionIndex] as? String ?? ""
        let cateArr = categoryArr[self.collectionIndex] as! NSMutableArray
        
        
        
        
        let dictionaryToEditdata = NSMutableDictionary()
        dictionaryToEditdata.setValue(geoTagStr, forKey: "geoTag")
        dictionaryToEditdata.setValue(thumbnailStr, forKey: "thumbnail")
        dictionaryToEditdata.setValue(imageUrl, forKey: "large")
        dictionaryToEditdata.setValue(descriptionStr, forKey: "description")
        dictionaryToEditdata.setValue(cateArr, forKey: "category")
        dictionaryToEditdata.setValue("public", forKey: "privacy")
        dictionaryToEditdata.setValue(imageId, forKey: "imgId")
        
        
        print(dictionaryToEditdata)
          nxtObj2.dataDictionary = dictionaryToEditdata
       self.navigationController! .pushViewController(nxtObj2, animated: true)
        
        
        
        
        //        SweetAlert().showAlert("PYT", subTitle: "Are you sure to delete this image?", style: AlertStyle.Warning, buttonTitle:"Cancel", buttonColor: UIColor .redColor() , otherButtonTitle:  "Ok", otherButtonColor: UIColor .greenColor()) { (isOtherButton) -> Void in
        //            if isOtherButton == true {
        //
        //                NSLog("Cancel Pressed")
        //
        //
        //            }
        //            else {
        //
        //                //Retry function
        //               //print("delete image tapped")
        //
        //
        //                var arrImg2 = NSArray()
        //                arrImg2 = self.arrayOfimages1[self.tableIndex] .valueForKey("largeImage") as! NSArray
        //
        //                var ThumbArray = NSArray()
        //                ThumbArray = self.arrayOfimages1[self.tableIndex].valueForKey("thumbnails") as! NSArray
        //
        //                var arrId = NSArray()
        //                arrId = self.arrayOfimages1[self.tableIndex] .valueForKey("id") as! NSArray
        //
        //
        //                let imageUrl = arrImg2[self.collectionIndex] as! String
        //                let imageId = arrId[self.collectionIndex] as! String
        //
        //
        //
        //
        //
        //
        //                let parameterString = "userId=\(self.uId)&photoId=\(imageId)&imageUrl=\(imageUrl)"
        //               //print(parameterString)
        //
        //                MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        //                apiClass.sharedInstance().postRequestDeleteImagePyt(parameterString, viewController: self)
        //
        //            }
        //}
        
        
        
        
        
        //
        //        // Create the alert controller
        //        let alertController = UIAlertController(title: "Pyt", message: "Are you sure to delete this image?", preferredStyle: .Alert)
        //
        //        // Create the actions
        //        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
        //            UIAlertAction in
        //
        //           //print("delete image tapped")
        //
        //
        //            var arrImg2 = NSArray()
        //            arrImg2 = self.arrayOfimages1[self.tableIndex] .valueForKey("largeImage") as! NSArray
        //
        //            var ThumbArray = NSArray()
        //            ThumbArray = self.arrayOfimages1[self.tableIndex].valueForKey("thumbnails") as! NSArray
        //
        //            var arrId = NSArray()
        //            arrId = self.arrayOfimages1[self.tableIndex] .valueForKey("id") as! NSArray
        //
        //
        //            let imageUrl = arrImg2[self.collectionIndex] as! String
        //            let imageId = arrId[self.collectionIndex] as! String
        //
        //
        //
        //
        //
        //
        //            let parameterString = "userId=\(self.uId)&photoId=\(imageId)&imageUrl=\(imageUrl)"
        //           //print(parameterString)
        //
        //            MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        //            apiClass.sharedInstance().postRequestDeleteImagePyt(parameterString, viewController: self)
        //
        //
        //            
        //            
        ////            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) {
        ////                UIAlertAction in
        ////                NSLog("Cancel Pressed")
        ////                
        //            
        //            }
        
        
        //                    let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) {
        //                        UIAlertAction in
        //                        NSLog("Cancel Pressed")
        //        
        //        
        //            }
        //        
        //        
        //            // Add the actions
        //            alertController.addAction(okAction)
        //            alertController.addAction(cancelAction)
        //        
        //        self.presentViewController(alertController, animated: true, completion: nil)
        
        
        
        
    }
    
    
    
    
    
    
    
    
    //MARK:- Action to add the image to story & Bucket
    
    func proceedBtnAction(_ tableViewIndex: Int, collectionViewIndex: Int)
    {
      
        let indexPathTable = IndexPath(row: tableViewIndex, section: 0)
        let indexPathCollection = IndexPath(row: collectionViewIndex, section: 0)
        
        
        let cell : cellClassTableViewCell =  imagesTableView.cellForRow(at: indexPathTable)! as! cellClassTableViewCell
        // grab the imageview using cell
        
        let imgV = cell.imagesCollectionView.cellForItem(at: indexPathCollection)?.viewWithTag(7459) as! UIImageView
        
        
        
        
        // get the exact location of image
        var rect : CGRect =  imgV.superview!.convert(imgV.frame, from: nil)
        rect = CGRect(x: self.view.frame.size.width/2, y: (rect.origin.y * -1)-10, width: imgV.frame.size.width, height: imgV.frame.size.height)
       //print(String.localizedStringWithFormat("rect is %f %f %f %f", rect.origin.x,rect.origin.y,rect.size.width,rect.size.height ))
        
        // create new duplicate image
        let starView : UIImageView = UIImageView(image: imgV.image)
        starView.frame = rect //CGRectMake(imgV.frame.origin.x, imgV.frame.origin.y, 70, 70)
        starView.frame.size.height=50
        starView.frame.size.width=50
        starView.layer.cornerRadius=5;
        starView.layer.borderWidth=1;
        
        self.view.addSubview(starView)
        
        
        var rect2 : CGRect =  starView.superview!.convert(starView.frame, from: nil)
         var endPoint=CGPoint()
        
        if storyBucketBool == true { //Add to story
            rect2 = CGRect(x: 5, y: (rect2.origin.y * -1)-10, width: starView.frame.size.width, height: starView.frame.size.height)
            endPoint = CGPoint(x: 30, y: 30)
        }
        else
        { //Add to bucket
             let fltV: CGFloat = self.view.frame.size.width-30
             rect2 = CGRect(x: self.view.frame.size.width - 6, y: (rect2.origin.y * -1)-10, width: starView.frame.size.width, height: starView.frame.size.height)
           endPoint = CGPoint(x: fltV, y: 30)
        }
        
       ////print( rect2)
        
        
        //rect2.size.height/2)
        
        
        // create a new CAKeyframeAnimation that animates the objects position
        
        let pathAnimation = CAKeyframeAnimation(keyPath: "position")
        pathAnimation.calculationMode = kCAAnimationPaced
        pathAnimation.fillMode = kCAFillModeForwards
        pathAnimation.isRemovedOnCompletion = false
        pathAnimation.duration = 1.0
        //pathAnimation.delegate=self
        
        let curvedPath:CGMutablePath = CGMutablePath()
    
        
        
       // pathAnimation.addQuadCurveToPoint(CGPoint(x: endPoint.x, y: endPoint.y), controlPoint: CGPoint(x: starView.frame.origin.y, y: endPoint.y))

    
        
//        CGPathMoveToPoint(curvedPath, nil, CGFloat(1.0), CGFloat(1.0))
//        CGPathMoveToPoint(curvedPath, nil, starView.frame.origin.x, starView.frame.origin.y)
//        CGPathAddCurveToPoint(curvedPath, nil, endPoint.x, starView.frame.origin.y, endPoint.x, starView.frame.origin.y, endPoint.x, endPoint.y)
        
        
        pathAnimation.path = curvedPath
        
        // apply transform animation
        let basic : CABasicAnimation = CABasicAnimation(keyPath: "transform");
        let transform : CATransform3D = CATransform3DMakeScale(2,2,1 ) //0.25, 0.25, 0.25);
        basic.setValue(NSValue(caTransform3D: transform), forKey: "scaleText");
        basic.duration = 1.0
        
        starView.layer.add(pathAnimation, forKey: "curveAnimation")
        starView.layer.add(basic, forKey: "transform");
        
        let control: UIControl = UIControl()
        
        let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(1.15 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
            
            // imgV .removeFromSuperview()
            
            control.sendAction(#selector(UIView.removeFromSuperview), to: starView, for: nil)
            control.sendAction(#selector(mainHomeViewController.reloadBadgeNumber), to: self, for: nil)
        })
    }
    
    
    
    // update the Badge number
    func reloadBadgeNumber(){
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    

    func deletePhotoTemporary()
    {
        
        //let tempArray = self.arrayOfimages1[tableIndex] as! NSArray
        let tempDict = self.arrayOfimages1[tableIndex] as! NSMutableDictionary
        
        
        let newMutableDict = NSMutableDictionary()
        
        for (key,values) in tempDict {
            
           //print("key=\(key), value=\(values)")
            
            if key as! String == "showMore" {
                newMutableDict .setObject(values, forKey: key as! String as NSCopying)
            }
                
            else
            {
                var value = values as! NSArray
                
                var value2 = NSMutableArray()
                
                value2 = NSMutableArray(array: value )
                
                value2.removeObject(at: collectionIndex)
                
                value = NSArray(array: value2)
                //print("new value=\(value)")
                
                
                if value.count<1 {
                    
                }else
                {
                    newMutableDict .setObject(value, forKey: key as! String as NSCopying)
                }
            }
            
            
           
            //print(newMutableDict)
            
        }
        
        if newMutableDict.count<1
        {
            DispatchQueue.main.async(execute: {
           //print(self.dataArray.count)
            self.dataArray .removeObject(at: self.tableIndex)
           //print(self.dataArray.count)
           self.reuseData[self.globalLocation]=nil
            
            self.imagesTableView .reloadData()
            })
            
        }
        else
        {
            self.arrayOfimages1.replaceObject(at: tableIndex, with: newMutableDict)
            
            let indexPath = IndexPath(row: tableIndex, section: 0)
            imagesTableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.left)
         reuseData[globalLocation]=nil

        }
        
        reuseData[globalLocation]=nil
        
    }
    
    
   
    
    
    
    
    
    
    
    
    
    
    
    
    //MARK: To show the popup view and hide that popup view
    
    func detailSelectBtnAction(_ showView:Bool) -> Void
    {
        
        
        //// hide the view
        if showView==false {
            self.detailView.isHidden = true

            /*
            
            if Udefaults.integer(forKey: "indexToolTips") < 5 {
                 self.manageToolsTipsShow()
            }
           
            
            self.tabBarController?.tabBar.isHidden = false
            self.detailView.isHidden = true
            let popUpView = detailView
            //let centre : CGPoint = CGPoint(x: self.view.center.x, y: self.view.center.y)
            let centre : CGPoint = CGPoint(x: (self.tabBarController?.view.center.x)!, y: (self.tabBarController?.view.center.y)!)
            
            popUpView?.center = centre
            popUpView?.layer.cornerRadius = 0.0
            let trans = popUpView?.transform.scaledBy(x: 1.0, y: 1.0)
            popUpView?.transform = trans!
            self.view .addSubview(popUpView!)
            UIView .animate(withDuration: 0.3, delay: 0.0, options:     UIViewAnimationOptions(), animations: {
                
                popUpView?.transform = (popUpView?.transform.scaledBy(x: 0.1, y: 0.1))!
                
                
                }, completion: {
                    (value: Bool) in
                    //popUpView .removeFromSuperview()
                    
                    
                    
                    popUpView?.transform = CGAffineTransform.identity
            })
            */
            
        }
            
            ////Show the View
        else
        {
            
           // toolTimer.invalidate()
            
            self.detailView.isHidden=false
            self.view.bringSubview(toFront: self.detailView)
            self.detailView.bringSubview(toFront: dynamicDetailSubview)
            //self.tabBarController?.tabBar.isHidden = true
           
            
            
            /*
            let popUpView = detailView
            let centre : CGPoint = CGPoint(x: self.view.center.x, y: self.view.center.y)
            //let centre : CGPoint = CGPoint(x: (self.tabBarController?.view.center.x)!, y: (self.tabBarController?.view.center.y)!)
            
            
            popUpView?.center = centre
            popUpView?.layer.cornerRadius = 0.0
            let trans = popUpView?.transform.scaledBy(x: 0.01, y: 0.01)
            popUpView?.transform = trans!
            self.view .addSubview(popUpView!)
            UIView .animate(withDuration: 0.3, delay: 0.0, options:     UIViewAnimationOptions(), animations: {
                
                popUpView?.transform = (popUpView?.transform.scaledBy(x: 100.0, y: 100.0))!//CGAffineTransformIdentity
                
                }, completion: {
                    (value: Bool) in
                    
                    
            })
            
            */
            
            
            
            
            
            
            let tapGestureRecognizer = UITapGestureRecognizer()
            tapGestureRecognizer.addTarget(self, action: #selector(mainHomeViewController.tempFunc))
            
            detailView.addGestureRecognizer(tapGestureRecognizer)
            
        
            
        }
        
    }
    
    
    
    
    
    
    
    
    
    ////////////////////////////////////////////////////////////////////////
    //MARK:-
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        URLCache.shared.removeAllCachedResponses()
        
       //print("MEMORYWARNING AND CLEARING CACHE ")
        
        let imageCache = SDImageCache.shared()
        imageCache?.clearMemory()
       // imageCache.clearDisk()
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    ////////////////////////////////////////////////////////////////////////
    
   //MARK:-///////////////call the Search api from here to get the photos of the locations////////////////////////
    //MARK:-
    
  
        func callApi(_ placeId:NSString, type:NSString ) -> Void
        {
            
        
        UserDefaults.standard.set(self.globalLocation, forKey: "selectedLocation")
        UserDefaults.standard.set(self.globalType, forKey: "selectedLocationType")
        UserDefaults.standard.set(self.globalPlaceid, forKey: "selectedLocationId")
        //NSUserDefaults.standardUserDefaults().setObject(self.globalCountry, forKey: "selectedLocationCountry")
        
        
        
        storyBool=false
         MBProgressHUD.hide(for: self.view, animated: true)
        
        //hit api here
        
     
            
            let parameterString:NSDictionary = ["userId": self.uId, "type": type, "placeId": placeId, "fullName": globalFullName, "skip": 0]
            
            print(parameterString)
        
            
            
        self.dataArray = NSMutableArray()
        self.arrayOfimages1 .removeAllObjects()
        self.userDetailArray .removeAllObjects()
        self.imagesTableView .reloadData()
            
        
         // OperationQueue.main.cancelAllOperations() //clear all the queues
            
        
        Udefaults.set(true, forKey: "refreshInterest")
        Udefaults.synchronize()
        
        let arrayOfKeys:NSArray = self.reuseData.allKeys as NSArray
        if (arrayOfKeys.contains(self.globalLocation)) {
            self.dataArray = self.reuseData .value(forKey: self.globalLocation as String) as! NSMutableArray
            // reuseData.setObject(1, forKey: "ShowMore\(globalLocation)")
            pageNumber = reuseData.value(forKey: "ShowMore\(globalLocation)") as! Int
            
           
            let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
           // DispatchQueue.main.async(execute: {
            
                
           // })
            
        OperationQueue.main.cancelAllOperations() //clear all the queues
            DispatchQueue.main.async(execute: {
                self.emptyView.isHidden=true
                self.imagesTableView.backgroundColor = UIColor (colorLiteralRed: 240/255, green: 240/255, blue: 240/255, alpha: 1)
                self.shortData()
            })
        }
            
        else
        {
            if refreshControl.isRefreshing {
                print("it is refreshing")
            }
            else
            {
                let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
                loadingNotification.mode = MBProgressHUDMode.indeterminate
                loadingNotification.label.text = "Loading Friend's Pictures"
                DispatchQueue.main.async(execute: {
                    self.imagesTableView .reloadData()
                })
            }
            
            
            // dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), {
            
            logOut = false
            let urlstringFeed = "\(appUrl)search_feed_screen_v2" //search_feed_screen"
            pageNumber = 1
             reuseData.setObject(pageNumber, forKey: "ShowMore\(globalLocation)" as NSCopying)
            apiClass.sharedInstance().getRequest(parameterString: parameterString, urlStringMultiple: urlstringFeed as NSString, viewController: self)
            
           
        }
        
        
        
        
        //})
        // })

        
       refreshControl.endRefreshing()
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //MARK:-//////////////////////// get response from server into its delegate/////////////////////
    //MARK:-
    
    func serverResponseArrived(Response:AnyObject)
    {
    
        
        //////////---------- REsponse for the add and delete image in story-----------////////
        if storyBool==true {
            
            jsonResult = NSDictionary()
            jsonResult = Response as! NSDictionary
            
            let success = jsonResult.object(forKey: "status") as! NSNumber
            
            if success != 1
            {
               CommonFunctionsClass.sharedInstance().showAlert(title: "Opps!", text: "Sorry image is not added to story, Please try again", imageName: "exclamationAlert") // CommonFunctionsClass.sharedInstance().alertViewOpen("Sorry image is not added to story, Please try again", viewController: self)
            }
            
            
        //get response here
            
        }
        
        
            
            
            
        
            
            
            
            
        
    ///////////--------------Response for the Locations-----------//////////////////
        else
        {
            
                        
            jsonResult = NSDictionary()
            jsonResult = Response as! NSDictionary
            
           
            imagesTableView.isUserInteractionEnabled = true
            
            let success = jsonResult.object(forKey: "status") as! NSNumber
            if success == 1
            {
                 logOut = true
                
               
             
                
                let arrayOfKeys:NSArray = self.reuseData.allKeys as NSArray
                if (arrayOfKeys.contains(self.globalLocation)) {
                   
                    self.dataArray = self.reuseData .value(forKey: self.globalLocation as String) as! NSMutableArray
                    
                   // print(dataArray.count)
                    
                
                }
                
                
                
                
                
                showApiHitted = false
                 dataArray.addObjects(from: jsonResult.value(forKey: "data")! as! NSMutableArray as [AnyObject])
             
                
                reuseData .setObject(dataArray, forKey: globalLocation)
               ///here get the bool value of the pagination
                let showMore = jsonResult.object(forKey: "showMore") as! NSNumber
                if showMore == 0 {
                    pageNumber = 0
                }

                reuseData.setObject(pageNumber, forKey: "ShowMore\(globalLocation)" as NSCopying)
                
                if dataArray.count<1
                {
                    
                    self.emptyView.isHidden=false
                    self.imagesTableView.backgroundColor = UIColor.clear
                    self.view .bringSubview(toFront: self.imagesTableView)
                    MBProgressHUD.hide(for: self.view, animated: true)
                   self.refreshControl .endRefreshing()
                }
                else
                {
                    if showTooltips == true
                    {
                        let indxtoolTip = Udefaults .integer(forKey: "indexToolTips")
                        
                        //toolTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.addToolTip), userInfo: nil, repeats: false)
                        
                    }
                    
                    
                    
                    self.emptyView.isHidden=true
                    self.imagesTableView.backgroundColor = UIColor (colorLiteralRed: 240/255, green: 240/255, blue: 240/255, alpha: 1)
                 
                    //self.viewWillAppear(true)
                    
                    self.shortData()
                }
                
                
               
                
            }
            else if(success == 5) //5
            {
                
                //logout the user from the app
                
                 //let nxtObj2 = self.storyboard?.instantiateViewController(withIdentifier: "settingsViewController") as! settingsViewController
                
                self.tabBarController?.tabBar.isHidden = true
                
                let nxtObj = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                
                
                logOut = true
                
                
                let uId = Udefaults .string(forKey: "userLoginId")!
                let token = Udefaults.string(forKey: "deviceToken")!
                
                let deviceTokenDict = NSMutableDictionary()
                
                deviceTokenDict.setValue(token, forKey: "token")
                deviceTokenDict.setValue("iphone", forKey: "device")
                
                let parameter:NSMutableDictionary = ["deviceToken":deviceTokenDict ,"userId":uId]
                
                
                
                //nxtObj2.logoutApi(parameter)
                
                Udefaults.set("", forKey: "userLoginId")
                Udefaults.set("", forKey: "userLoginName")
                Udefaults.set("", forKey: "userProfilePic")
                
                
                
                
                
                let arr = NSMutableArray()
                UserDefaults.standard.set(nil, forKey: "arrayOfIntrest")
                
                
                DispatchQueue.main.async(execute: {
                    self.dismiss(animated: true, completion: {})
                    
                    self.navigationController! .pushViewController(nxtObj, animated: true)
                    
                    
                    
                    OperationQueue.main.cancelAllOperations()
                    
                    
                                  })
                
                
              
                
                
            }
                
                
                
            else
            {
                MBProgressHUD.hide(for: self.view, animated: true)
                
                self.emptyView.isHidden=false
                self.imagesTableView.backgroundColor = UIColor.clear
                self.view .bringSubview(toFront: self.imagesTableView)
                MBProgressHUD.hide(for: self.view, animated: true)
                
                //CommonFunctionsClass.sharedInstance().alertViewOpen("Sorry no content found", viewController: self)
                
            }
            
            
            MBProgressHUD.hide(for: self.view, animated: true)
            //CommonFunctionsClass.sharedInstance().alertViewOpen("Testing here", viewController: self)
            
        }
        
        
        
      
        
        
    }

    
  
    
    
    
    
    
    
    func shortData() -> Void
    {
        
        //  DispatchQueue.main.async(execute: {
        
         self.refreshControl .endRefreshing() // it will showing then will remove
        
         let intrestArray = NSMutableArray()
        
        self.arrayOfimages1 .removeAllObjects()
        self.userDetailArray .removeAllObjects()
        
        for i in 0 ..< self.dataArray.count
        {
          
            //here get the count of the photos or status of the photos to show more or not
            
            
            self.photos = [(self.dataArray .object(at: i) as AnyObject).value(forKey: "photos")! ]
        let showMorePhotos = (self.dataArray .object(at: i) as AnyObject).value(forKey: "showMore") as! Int
            
          // print(self.photos[0])
            
            var imagesArray = NSArray()
            imagesArray = (self.photos[0] as AnyObject).value(forKey: "imageThumb")! as! NSArray//total small images array
            
            
            
            let latArray = (self.photos[0] as AnyObject).value(forKey: "latitude")! as! NSArray//total latitude array
            let longArray = (self.photos[0] as AnyObject).value(forKey: "longitude")! as! NSArray//total longitude array
            
            
            
            var imagesLargeArray = NSArray()
            imagesLargeArray = (self.photos[0] as AnyObject).value(forKey: "imageLarge")! as! NSArray//total images array
            
            
            var locationArray = NSArray()
            locationArray = (self.photos[0] as AnyObject).value(forKey: "city")! as! NSArray//total city name array
            
            var idArray = NSArray()
            idArray = (self.photos[0] as AnyObject).value(forKey: "photoId")! as! NSArray//total image id array
            
            
            var categoryArray = NSArray()
            categoryArray = (self.photos[0] as AnyObject).value(forKey: "category")! as! NSArray//total catigory array
            
            var albumArray = NSArray()
            albumArray = (self.photos[0] as AnyObject).value(forKey: "albumName")! as! NSArray//total albums name array
            
            
            var descriptionArray = NSArray()
            descriptionArray = (self.photos[0] as AnyObject).value(forKey: "description")! as! NSArray//total description array
           
            
            var geoTagArray = NSArray()
            geoTagArray = (self.photos[0] as AnyObject).value(forKey: "location")! as! NSArray//total geotag array
            
            
            var sourceArray = NSArray()
            sourceArray = (self.photos[0] as AnyObject).value(forKey: "source")! as! NSArray//total source(fb, pyt, checkin) name array
            
            var sourcetype = NSArray()
            sourcetype = (self.photos[0] as AnyObject).value(forKey: "dataType")! as! NSArray
            
            
            
            var countryArray = NSArray()
            countryArray = (self.photos[0] as AnyObject).value(forKey: "country")! as! NSArray//total country name array
            
            
            var likeCountArray = NSArray()
            likeCountArray = (self.photos[0] as AnyObject).value(forKey: "likeCount")! as! NSArray//total likecount array
            
            // //print(likeCountArray)
            
            
            var idLikedUsers = NSArray()
            idLikedUsers = (self.photos[0] as AnyObject).value(forKey: "userLiked")! as! NSArray
            
            var countrId = (self.photos[0] as AnyObject).value(forKey: "countryId")! as! NSArray
            
            var placeId = (self.photos[0] as AnyObject).value(forKey: "countryId")! as! NSArray
            
            
            let mutableDict: NSMutableDictionary = ["location":locationArray, "id":idArray, "category":categoryArray, "albums": albumArray, "description": descriptionArray, "country": countryArray, "largeImage": imagesLargeArray, "geoTag":geoTagArray, "latitude":latArray, "longitude": longArray, "source": sourceArray, "likeCount":likeCountArray, "likedUserId":idLikedUsers,"thumbnails":imagesArray, "sourceType":sourcetype, "showMore": showMorePhotos, "countId": countrId ]
            
            [self.arrayOfimages1 .add(mutableDict)]
            
            
            
            //////////// user detail get here ////////////
            
            var id = NSString()
            id = (self.dataArray .object(at: i) as AnyObject).value(forKey: "_id")! as? NSString ?? ""
            
            //Name of user
            var name = NSString()
            //Email
            var email = NSString()
            //Profile picture
             var profile = NSString()
            
            
            if ((self.dataArray.object(at: i) as AnyObject).value(forKey: "userId")! as AnyObject).count < 1{
                
                name = "Undefined User"
                email = ""
                profile = ""
                
                 self.userDetailArray.add(["id":id, "email":email, "name":name, "profile":"" ])
            }
            else
            {
            
            let nameSt = (((self.dataArray.object(at: i) as AnyObject).value(forKey: "userId")! as AnyObject).object(at: 0) as AnyObject).value(forKey: "name") as? String ?? ""
            
                name = nameSt as NSString
           
               let emailst = (((self.dataArray.object(at: i) as AnyObject).value(forKey: "userId")! as AnyObject).object(at: 0) as AnyObject).value(forKey: "email") as? String ?? ""
                
                email = emailst as NSString
                
        
            // if profile picture is avaliable in the code
            if ((((self.dataArray.object(at: i) as AnyObject).value(forKey: "userId")! as AnyObject).object(at: 0) as AnyObject).value(forKey: "picture") != nil)
            {
                
           let profilest = (((self.dataArray.object(at: i) as AnyObject).value(forKey: "userId")! as AnyObject).object(at: 0) as AnyObject).value(forKey: "picture") as? String ?? ""
               
                profile = profilest as NSString
                
                
                self.userDetailArray.add(["id":id, "email":email, "name":name, "profile":profile ])
            }
            else
            {
                self.userDetailArray.add(["id":id, "email":email, "name":name, "profile":"" ])
                //print("no profile picture")
            }
            
            }
            /////
            
            
            
        }
        
        intrestArray .add(["userDetail":self.userDetailArray, "images": self.arrayOfimages1])
        
        print(self.arrayOfimages1)
        
      //  DispatchQueue.main.async(execute: {
        self.imagesTableView .reloadData()
            
            
          //  })
        
        
        if countsDictionary.object(forKey: "bookings") != nil {
            if let stCount = countsDictionary.value(forKey: "bookings"){
                
              //  self.storyListCount.text=String(describing: stCount)
            }
            
        }
        
        
        
        
        if countsDictionary.object(forKey: "bucketCount") != nil {
            if let bktCount = countsDictionary.value(forKey: "bucketCount"){
                
                bucketListTotalCount=String(describing: bktCount)
            }
            
        }
        
        
        
        
        if self.dataArray.count<1
        {
            
            self.emptyView.isHidden=false
            self.imagesTableView.backgroundColor = UIColor.clear
            self.view .bringSubview(toFront: self.imagesTableView)
        }
        else
        {
            self.emptyView.isHidden=true
            self.imagesTableView.backgroundColor = UIColor (colorLiteralRed: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        }
        
        
        MBProgressHUD.hide(for: self.view, animated: true)
        
       // })
        
    }
    
    
    
    
    
    
    func changeArray(_ photoDetail: NSArray, index: Int, parm: NSString) -> NSMutableArray {
        
        var singleMutableArray = NSMutableArray()
        
         singleMutableArray = photoDetail.mutableCopy() as! NSMutableArray
        
        singleMutableArray .addObjects(from: (self.photos[index] as AnyObject).value(forKey: parm as String)! as! NSArray as [AnyObject])
        
        
        return singleMutableArray
    }
    
    
    
    
    
    
    
    
    //MARK:
    //MARK: Get the images in show more
    
    func getImages(_ parmdict: NSDictionary, indx: Int) {
        
        print(indx)
        
        
            let isConnectedInternet = CommonFunctionsClass.sharedInstance().isConnectedToNetwork()
         
            if isConnectedInternet
            {
         
         
         
                let urlString = NSString(string:"\(appUrl)search_More_Images_feed_screen")
                
                let needsLove = urlString
                let safeURL = needsLove.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
                
                let url:URL = URL(string: safeURL as String)!
                print("Final Url-----> " + (safeURL as String))
                
               
              //  let session = NSURLSession.sharedSession()
                let request = NSMutableURLRequest(url: url)
                request.httpMethod = "POST"
                
                
                do {
                    let jsonData = try!  JSONSerialization.data(withJSONObject: parmdict, options: [])
                    request.httpBody = jsonData
                    
                   
                } catch let error as NSError {
                    print(error)
                }
                
                
                
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.addValue("application/json", forHTTPHeaderField: "Accept")
                
              
                NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: OperationQueue.main) {(response, data, error) in
                    
                    OperationQueue.main.addOperation
                        {
                            
                            
                            if data == nil
                            {
                                
                                CommonFunctionsClass.sharedInstance().showAlert(title: "Server Alert", text: "Something doesn't seem right, Please try again!", imageName: "alertServer")
                               
                               
                            }
                            else
                            {
                                
                                do {
                                    
                                    
                                    let result = NSString(data: data!, encoding:String.Encoding.ascii.rawValue)!
                                 //   print("Body: \(result)")
                                    
                   let anyObj: Any = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                                    
                                    jsonResult = NSDictionary()
                                    jsonResult = anyObj as! NSDictionary
                                    
                                    let success = jsonResult.object(forKey: "status") as! NSNumber
                                    if success == 1
                                    {
                                       
                                        
                                        var dataArray2 = NSMutableArray()
                                       var phot = NSMutableArray()
                                        var olderDataDict = NSMutableDictionary()
                                        var oldArray = NSMutableArray()
                                        
                                        let arrayOfKeys:NSArray = self.reuseData.allKeys as NSArray
                                        if (arrayOfKeys.contains(self.globalLocation)) {
                                            
                                             oldArray = self.reuseData .value(forKey: self.globalLocation as String) as! NSMutableArray
                                        
                                            
                                            olderDataDict = oldArray.object(at: indx) as! NSMutableDictionary
                                          //  print(olderDataDict)
                                            
                                             phot = olderDataDict .value(forKey: "photos")! as! NSMutableArray
                                            
                                           // print(phot.count)
                                           
                                            
                                        }
                                        
                                        
                                        dataArray2 = jsonResult.value(forKey: "data")! as! NSMutableArray
                                        
                                        self.photos = []
                                        
                                        
                                        
                                        
                                        
                                        
                                        self.photos = [(dataArray2 .object(at: 0) as AnyObject).value(forKey: "photos")! ]
                                        
                                        let usrDataNew = (dataArray2 .object(at: 0) as AnyObject).value(forKey: "userId")! as! NSMutableArray
                                        
                                        
                                        
                                   // print(phot.count)
                                        phot.addObjects(from: (dataArray2 .object(at: 0) as AnyObject).value(forKey: "photos")! as! NSMutableArray as [AnyObject])
                                        print(phot.count)
                                        
                                        
                                        let showMorePhotos = (dataArray2 .object(at: 0) as AnyObject).value(forKey: "showMore") as! Int
                                        
                                        
                                        olderDataDict .setObject(phot, forKey: "photos" as NSCopying)
                                        olderDataDict .setObject(usrDataNew, forKey: "userId" as NSCopying)
                                        olderDataDict .setObject(showMorePhotos, forKey: "showMore" as NSCopying)
                                       // print(olderDataDict)
                                        
                                        
                                        oldArray.removeObject(at: indx) //.objectAtIndex(indx) as! NSMutableDictionary
                                        oldArray .insert(olderDataDict, at: indx)
                                        
                                        self.reuseData .setObject(oldArray, forKey: self.globalLocation)
                                       
                                        
                                
                                        
                                        var imagesArray = NSArray()
                                        imagesArray = (self.arrayOfimages1.object(at: indx) as AnyObject).value(forKey: "thumbnails") as! NSArray
                                        imagesArray = self.changeArray(imagesArray, index: 0, parm: "imageThumb").copy() as! NSArray
                                        print(imagesArray.count)
                                        
                                        var latArray = (self.arrayOfimages1.object(at: indx) as AnyObject).value(forKey: "latitude") as! NSArray
                                        latArray = self.changeArray(latArray, index: 0, parm: "latitude")
                                        
                                        var longArray = (self.arrayOfimages1.object(at: indx) as AnyObject).value(forKey: "longitude") as! NSArray
                                        longArray = self.changeArray(longArray, index: 0, parm: "longitude")
                                
                                        var countryIdArray = (self.arrayOfimages1[indx] as AnyObject).value(forKey: "countId") as! NSArray
                                        countryIdArray = self.changeArray(countryIdArray, index: 0, parm: "countryId")
                                        
                                        
                                        var imagesLargeArray = NSArray()
                                        imagesLargeArray = (self.arrayOfimages1.object(at: indx) as AnyObject).value(forKey: "largeImage") as! NSArray
                                        imagesLargeArray = self.changeArray(imagesLargeArray, index: 0, parm: "imageLarge")
                                        
                                        var locationArray = NSArray()
                                        locationArray = (self.arrayOfimages1.object(at: indx) as AnyObject).value(forKey: "location") as! NSArray
                                        locationArray = self.changeArray(locationArray, index: 0, parm: "city")
                                        
                                        var idArray = NSArray()
                                        idArray = (self.arrayOfimages1.object(at: indx) as AnyObject).value(forKey: "id") as! NSArray
                                        idArray = self.changeArray(idArray, index: 0, parm: "photoId")
                                        
                                        var categoryArray = NSArray()
                                        categoryArray = (self.arrayOfimages1.object(at: indx) as AnyObject).value(forKey: "category") as! NSArray
                                        categoryArray = self.changeArray(categoryArray, index: 0, parm: "category")
                                        
                                        var albumArray = NSArray() //
                                        albumArray = (self.arrayOfimages1.object(at: indx) as AnyObject).value(forKey: "albums") as! NSArray
                                        albumArray = self.changeArray(albumArray, index: 0, parm: "albumName")
                                        
                                        
                                        var descriptionArray = NSArray()
                                        descriptionArray = (self.arrayOfimages1.object(at: indx) as AnyObject).value(forKey: "description") as! NSArray
                                        descriptionArray = self.changeArray(descriptionArray, index: 0, parm: "description")
                                        
                                        
                                        var geoTagArray = NSArray()
                                        geoTagArray = (self.arrayOfimages1.object(at: indx) as AnyObject).value(forKey: "geoTag") as! NSArray
                                        geoTagArray = self.changeArray(geoTagArray, index: 0, parm: "location")
                                        
                                        
                                        var sourceArray = NSArray()
                                        sourceArray = (self.arrayOfimages1.object(at: indx) as AnyObject).value(forKey: "source") as! NSArray
                                        sourceArray = self.changeArray(sourceArray, index: 0, parm: "source")
                                        
                                        
                                        var sourcetype = NSArray()
                                        sourcetype = (self.arrayOfimages1.object(at: indx) as AnyObject).value(forKey: "sourceType") as! NSArray
                                        sourcetype = self.changeArray(sourcetype, index: 0, parm: "dataType")
                                        
                                        
                                        var countryArray = NSArray()
                                        countryArray = (self.arrayOfimages1.object(at: indx) as AnyObject).value(forKey: "country") as! NSArray
                                        countryArray = self.changeArray(countryArray, index: 0, parm: "country")
                                        
                                        
                                        
                                        var likeCountArray = NSArray()
                                        likeCountArray = (self.arrayOfimages1.object(at: indx) as AnyObject).value(forKey: "likeCount") as! NSArray
                                        likeCountArray = self.changeArray(likeCountArray, index: 0, parm: "likeCount")
                                        
                                        
                                        
                                        var idLikedUsers = NSArray()
                                        idLikedUsers = (self.arrayOfimages1.object(at: indx) as AnyObject).value(forKey: "likedUserId") as! NSArray
                                        idLikedUsers = self.changeArray(idLikedUsers, index: 0, parm: "userLiked")
                                        
                                        
                                        let mutableDict: NSMutableDictionary = ["location":locationArray, "id":idArray, "category":categoryArray, "albums": albumArray, "description": descriptionArray, "country": countryArray, "largeImage": imagesLargeArray, "geoTag":geoTagArray, "latitude":latArray, "longitude": longArray, "source": sourceArray, "likeCount":likeCountArray, "likedUserId":idLikedUsers,"thumbnails":imagesArray, "sourceType":sourcetype, "showMore": showMorePhotos, "countId": countryIdArray ]
                                        
                                        
                                        
                                        
                                        
                                       
                                        self.arrayOfimages1 .removeObject(at: indx)
                                        self.arrayOfimages1 .insert(mutableDict, at: indx)
                                        let indexPath2 = IndexPath( row: indx, section: 0)
                                        
                                        
                                        
                                         let cell:cellClassTableViewCell = self.imagesTableView.cellForRow(at: indexPath2) as! cellClassTableViewCell

                                     //   let cell = self.imagesTableView.cellForRowAtIndexPath(indexPath2) as! cellClassTableViewCell
                                        
                                        cell.imagesCollectionView .reloadData()
                                        
                                        
                                       //self.imagesTableView .reloadRowsAtIndexPaths([indexPath2], withRowAnimation: .None)
                                        
                                    }
                                    
                                    
                                    
                                    
                              
                                    
                                    
                                    
                                } catch {
                                    print("json error: \(error)")
                                     CommonFunctionsClass.sharedInstance().showAlert(title: "Server Alert", text: "Something doesn't seem right, Please try again!", imageName: "alertServer")
                                    
                                   
                                  
                                }
                                
                                
                                
                                
                                
                                
                            }
                           
                    }
                    
                }
                
               
                
                
            }
            else
            {
                CommonFunctionsClass.sharedInstance().showAlert(title: "No Internet Connection", text: "You are currently offline.", imageName: "alertInternet")
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








////////////MARK:- Extension of collection View ///////////////////////////

/*
extension mainHomeViewController : UITableViewDelegate, UITableViewDataSource {
 
    func tableView(tableView: UITableView,willDisplayCell cell: UITableViewCell,forRowAtIndexPath indexPath: NSIndexPath) {
 
        guard let tableViewCell = cell as? cellClassTableViewCell else { return }
        //here setting the uitableview cell contains collectionview delgate conform to viewcontroller
 
        tableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row, andForSection: indexPath.section)
 
 
 
    }
 
 
 
    func tableView(tableView: UITableView,
                   didEndDisplayingCell cell: UITableViewCell,
                                        forRowAtIndexPath indexPath: NSIndexPath) {
        
        guard let tableViewCell = cell as? cellClassTableViewCell else { return }
        

 //       tableViewCell.imagesCollectionView.reloadData()
       tableViewCell.contentView.clearsContextBeforeDrawing=true
        
//        tableViewCell.imagesCollectionView.reloadData()
//        tableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row, andForSection: indexPath.section)
        
        storedOffsets[indexPath.row] = tableViewCell.collectionViewOffset
    }
    
    
    
}

 */

 
//MARK:-


//MARK:- ///////////////////// Data source and delegates of the collection view in extension/////////////////
//MARK:-

extension mainHomeViewController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int   {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView,numberOfItemsInSection section: Int) -> Int
    {
        
        if collectionView.tag == 1221//storyCollectionView 
        {
            if planAllLocation == false//false to show the plans of that place
            {
                
                if countArray.count>0
                {
                    
//                    let countIdArr = (self.arrayOfimages1[tableIndex] as AnyObject).value(forKey: "countId") as! NSArray
//                    let CountryId = countIdArr[collectionIndex] as! String as NSString
                let placeIds = (countArray.value(forKey: "countryId")) as! NSArray
                print(placeIds)
                    print(globalPlaceid)
                    if placeIds.contains(globalPlaceid){//("58c3c09336f8b6180feea0c6"){//(globalPlaceid) {
                    print("Contains story")
                    let indx = placeIds .index(of: self.globalPlaceid)
                    print(indx)
                    
                let imageUrlArray = ((countArray.object(at: indx)) as AnyObject).value(forKey: "places") as! NSMutableArray
                    if imageUrlArray.count>0
                    {
                        planCountLbl.text = String(imageUrlArray.count)
                        return imageUrlArray.count
                        
                    }
                    
                    }
                    planCountLbl.text = "0"
                    return 0
                }
                planCountLbl.text = "0"
                return 0 // returen the plans of selected location
            }
            
            print(countArray.count)
            planCountLbl.text = String(countArray.count)
            return countArray.count //return the whole plans
        }
            
        else
        {
            print(collectionView.tag)
          //  print(arrayOfimages1)
            if(arrayOfimages1.count == 0)
            {
                return 0
            }
            let show = (arrayOfimages1[collectionView.tag] as AnyObject).value(forKey: "showMore") as! Int
            let countData = (arrayOfimages1[collectionView.tag] as AnyObject).value(forKey: "id")! as! NSArray
            
            if show == 0
            {
                return countData.count
            }
            else
            {
                return countData.count + 1
            }
        }
    
    }
    
    
    func collectionView(_ collectionView: UICollectionView,cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        if collectionView.tag == 1221//storyCollectionView 
        {
            
            
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "planCell",for: indexPath) as! planCollectionViewCell

            cell.contentView.frame = cell.bounds
            cell.contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            print(cell.frame)
                if planAllLocation == false//false to show the plans of that place
                {
                    
                     if countArray.count>0
                     {
                        let placeIds = (countArray.value(forKey: "countryId")) as! NSArray
                        
                        if placeIds.contains(globalPlaceid) {
                            print("Contains story")
                            let indx = placeIds .index(of: globalPlaceid )//"58c3c09336f8b6180feea0c6")
                            print(indx)
                            
                            
                            let imageUrlArray = ((countArray.object(at: indx)) as AnyObject).value(forKey: "places") as! NSMutableArray
                            if imageUrlArray.count > 0
                            {
                                print(imageUrlArray.count - 1 - (indexPath.row))
                                let imgUrl = (((imageUrlArray.object(at: imageUrlArray.count-1 - (indexPath.row ))) as! AnyObject).value(forKey: "place")as! AnyObject) .value(forKey: "imageThumb") as? String ?? ""
                                
                                print(imgUrl)
                               
                                UIView.animate(withDuration: 0.75, animations: {
                                    cell.planImage.transform = CGAffineTransform(scaleX: 0.02, y: 0.02)
                                }) { (finished) in
                                    UIView.animate(withDuration: 0.75, animations: {
                                        
                                        let block: SDWebImageCompletionBlock = {(image, error, cacheType, imageURL) -> Void in
                                            
                                        }
                                        
                                        cell.planImage.sd_setImage(with: URL(string: imgUrl), placeholderImage: UIImage (named: "dummyBackground1"), options: SDWebImageOptions(rawValue: 0), completed: block)
                                        
                                        
                                        //cell.planImage.sd_setImage(with: URL(string: imgUrl), placeholderImage: UIImage (named: "dummyBackground1"))
                                        cell.planImage.transform = CGAffineTransform.identity
                                    })
                                }

                                
                                let placetag = (((imageUrlArray.object(at:  imageUrlArray.count-1 - (indexPath.row))) as! AnyObject).value(forKey: "place")as! AnyObject) .value(forKey: "placeTag") as? String ?? ""
                                cell.planName.text = placetag
                                
                            }
                            
                            cell.deletplanButton.isHidden = false
                          //  if PlanDeleteBool == true
                          //  {
                                cell.deletplanButton.isHidden = false
                           // }
                          //  else
                          //  {
                               // cell.deletplanButton.isHidden = true
                                let longTapGest = LongPressGesture(target: self, action: #selector(mainHomeViewController.longTap(_:)))
                                
                               // cell.addGestureRecognizer(longTapGest)
                                cell.deletplanButton.tag = 1000+imageUrlArray.count-1 - (indexPath.row)//indexPath.row
                                cell.deletplanButton.addTarget(self, action: #selector(self.deletePlanApiHit(_:)), for: .touchUpInside)
                                
                                
                           // }
                            
                            
                            
                            
                            
                            
                        }
                        
                        cell.planImage.contentMode = .scaleAspectFill
                        
                       
                        
                    }
                    
                    
                   

                    
                    
                    return cell
                }
                    
                    //return cell for all locations or all plans
                else
                {
                    
                    let countriesName = ((countArray.object(at: indexPath.row )) as AnyObject).value(forKey: "name") as? String ?? "" //as! NSArray
                    var countryname = "NA"
                   // if countriesName.count > 0
                    //{
                        countryname = countriesName//.object(at: 0) as! String
                   // }
                    
                    let imgUrl = (((((countArray.object(at: indexPath.row )) as AnyObject).value(forKey: "places") as AnyObject).object(at: 0) as AnyObject).value(forKey: "place")as AnyObject).value(forKey: "imageThumb") as? String ?? ""

                    UIView.animate(withDuration: 0.75, animations: {
                        cell.planImage.transform = CGAffineTransform(scaleX: 0.02, y: 0.02)
                    }) { (finished) in
                        UIView.animate(withDuration: 0.75, animations: {
                            cell.planImage.sd_setImage(with: URL(string: imgUrl), placeholderImage: UIImage (named: "dummyBackground1"))

                            cell.planImage.transform = CGAffineTransform.identity
                        })
                    }

                    
                    
                     print(imgUrl)
                    
                    
                    cell.planName.text = countryname
                    
                   // cell.deletplanButton.isHidden = true
                    cell.deletplanButton.tag = 5000+indexPath.row //5000 for whole plan delete
                    cell.deletplanButton.addTarget(self, action: #selector(self.deletePlanApiHit(_:)), for: .touchUpInside)
                    //if PlanDeleteBool == true
                    //{
                   //     cell.deletplanButton.isHidden = false
                   // }
                   // else
                   /// {
                        cell.deletplanButton.isHidden = false
                        let longTapGest = LongPressGesture(target: self, action: #selector(mainHomeViewController.longTap(_:)))
                        
                        cell.addGestureRecognizer(longTapGest)
                        
                       
                        
                        
                   // }
                    return cell
                }

            }
            
 
            
           //images array
        else
        {
        if arrayOfimages1.count<1
        {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellCollectionView",for: indexPath) as! collectionViewCellClassFeed
            
            return cell
            
        }
        else
        {
            print("Index path i \(indexPath.row) \n Array count \(((arrayOfimages1[collectionView.tag] as AnyObject).value(forKey: "id")! as AnyObject).count)")
            let countData = (arrayOfimages1[collectionView.tag] as AnyObject).value(forKey: "id")! as! NSArray
            
        if indexPath.row < countData.count
        {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellCollectionView",for: indexPath) as! collectionViewCellClassFeed
                
                cell.layer.shouldRasterize = true
                cell.layer.rasterizationScale = UIScreen.main.scale
                
                
                if self.arrayOfimages1.count<1
                {
                    
                }
                else
                {
                    
                    
                    var imageName = NSString()
                    var imageName2 = NSString()
                    var imageId2 = NSString()
                    var imgDesc = NSString()
                    
                    
                    var arrId2 = NSArray()
                    arrId2 = (self.arrayOfimages1[collectionView.tag] as AnyObject).value(forKey: "id") as! NSArray
                    
                    var arrDesc = NSArray()
                    arrDesc = (self.arrayOfimages1[collectionView.tag] as AnyObject).value(forKey: "description") as! NSArray
                    
                    
                    imageId2 = arrId2[indexPath.row] as? String as NSString? ?? " "//get id of images
                    
                    imgDesc = arrDesc[indexPath.row] as? String as NSString? ?? " "//get description of image
                    
                    let likeView = cell.viewWithTag(7455)! as UIView
                    likeView.alpha = 0
                    
                    
                    
                    var countryArr = NSArray()
                    countryArr = (self.arrayOfimages1[collectionView.tag] as AnyObject).value(forKey: "country") as! NSArray
                    
                    let countryTxt = countryArr[indexPath.row] as? String ?? ""
                    
                    
                    let geoTag = (self.arrayOfimages1[collectionView.tag] as AnyObject).value(forKey: "geoTag") as! NSArray
                    
                    
                    var location = "\(geoTag[indexPath.row] as? String ?? "")"
                    if location == "Not found"{
                        location = ""
                    }
                    
                    if location == "" {
                        
                        location=countryTxt
                        
                    }
                    
                    
                    //let geoTagLbl = cell.viewWithTag(7456)! as! UILabel
                    cell.geoTagLbl.text=(location as String).capitalized
                    cell.geoTagLbl.lineBreakMode = .byTruncatingTail
                    cell.geoTagLbl.minimumScaleFactor=0.6
                    //geoTagLbl.adjustsFontSizeToFitWidth=true
                    
                    
                    
                    
                 
                    
                    
                    var cityArr = NSArray()
                    cityArr = (self.arrayOfimages1[collectionView.tag] as AnyObject).value(forKey: "location") as! NSArray
                    
                    var cityName = cityArr[indexPath.row] as? String ?? " "
                    
                    
                    if cityName == "" || cityName == " "{
                        cityName=countryTxt
                        
                    }
                    
                    
                    
                    
                    
                    //MARK:- MANAGE LIKE AND ITS COUNT
                    
                    // dispatch_async(dispatch_get_main_queue(), {
                    
                    var countLik = NSNumber()
                    //MANAGE from the crash
                    ////print(self.arrayOfimages1[collectionView.tag])
                    let likeCountValue = (self.arrayOfimages1[collectionView.tag] as AnyObject).value(forKey: "likeCount") as! NSArray
                    if likeCountValue[indexPath.row] as? NSNull != NSNull()  {
                        
                        countLik = likeCountValue[indexPath.row] as! NSNumber  //as? String ?? "0.0"
                        
                    }
                    else
                    {
                        countLik=0
                    }
                    
                    
                    
                    
                    let likedByMe = (self.arrayOfimages1[collectionView.tag] as AnyObject).value(forKey: "likedUserId") as! NSArray
                    let likedByMe2 = likedByMe .object(at: indexPath.row) as! NSArray
                    
                    //SHOW THE COUNT OF LIKED
                    cell.likecountlbl.text=String(describing: countLik)
                    cell.likeimg.image=UIImage (named: "Like")
                    
                    
                    ///////-  Show liked by me-/////
                    if likedByMe2.count>0
                    {
                        if likedByMe2.contains(self.uId)
                        {
                            //contains photo liked by me
                            let arrLk = self.likeCount.value(forKey: "imageId") as! NSArray
                            
                            if arrLk.contains(imageId2)
                            {
                                let indexOfImageId = (self.likeCount.value(forKey: "imageId") as AnyObject).index(of: imageId2)
                                
                                if (self.likeCount.object(at: indexOfImageId) as AnyObject).value(forKey: "like") as! Bool == true {
                                    cell.likeimg.image=UIImage (named: "likefill")
                                    let staticCount = (self.likeCount.object(at: indexOfImageId) as AnyObject).value(forKey: "count") as? NSNumber
                                    cell.likecountlbl.text=String(describing: staticCount!)// String(self.addTheLikes(staticCount!))
                                    
                                    
                                    
                                }
                                else{
                                    cell.likeimg.image=UIImage (named: "Like")
                                    let staticCount = (self.likeCount.object(at: indexOfImageId) as AnyObject).value(forKey: "count") as? NSNumber
                                    cell.likecountlbl.text=String(describing: staticCount!) //(self.addTheLikes(staticCount!))
                                }
                            }
                                
                                //if not contains the imageId
                            else
                            {
                                self.likeCount .add(["imageId":imageId2,"userId":self.uId, "like": true, "count": countLik])
                                //print(self.likeCount)
                                cell.likecountlbl.text=String(describing: countLik)
                                cell.likeimg.image=UIImage (named: "likefill")
                            }
                            
                            
                            
                        }
                            
                        else
                        {
                            let arrLk = self.likeCount.value(forKey: "imageId") as! NSArray
                            if arrLk.contains(imageId2)
                            {
                                let indexOfImageId = (self.likeCount.value(forKey: "imageId") as AnyObject).index(of: imageId2)
                                
                                if (self.likeCount.object(at: indexOfImageId) as AnyObject).value(forKey: "like") as! Bool == true {
                                    cell.likeimg.image=UIImage (named: "likefill")
                                    let staticCount = (self.likeCount.object(at: indexOfImageId) as AnyObject).value(forKey: "count") as? NSNumber
                                    cell.likecountlbl.text=String(describing: staticCount!)
                                    
                                }
                                else
                                {
                                    let staticCount = (self.likeCount.object(at: indexOfImageId) as AnyObject).value(forKey: "count") as? NSNumber
                                    cell.likecountlbl.text=String(describing: staticCount!)
                                    cell.likeimg.image=UIImage (named: "Like")
                                }
                            }
                            
                            
                            
                        }
                        
                        
                        
                    }
                        //not liked by me
                    else
                    {
                        let arrLk = self.likeCount.value(forKey: "imageId") as! NSArray
                        if arrLk.contains(imageId2)
                        {
                            let indexOfImageId = (self.likeCount.value(forKey: "imageId") as AnyObject).index(of: imageId2)
                            
                            if (self.likeCount.object(at: indexOfImageId) as AnyObject).value(forKey: "like") as! Bool == true {
                                cell.likeimg.image=UIImage (named: "likefill")
                                let staticCount = (self.likeCount.object(at: indexOfImageId) as AnyObject).value(forKey: "count") as? NSNumber
                                cell.likecountlbl.text=String(describing: staticCount!)
                                
                            }
                            else{
                                let staticCount = (self.likeCount.object(at: indexOfImageId) as AnyObject).value(forKey: "count") as? NSNumber
                                cell.likecountlbl.text=String(describing: staticCount!)
                                cell.likeimg.image=UIImage (named: "Like")
                            }
                        }
                        
                        
                        
                    }
                    
                    
                    
                    ////Add gesture in collection view
                    
                    var text = String()
                    text = "\(collectionView.tag) \(indexPath.row)"
                    
                    /////////Single Tap
                    let singleTapGesture = GestureViewClass(target: self, action: #selector(mainHomeViewController.SingleTap(_:)))
                    singleTapGesture.numberOfTapsRequired = 1 // Optional for single tap
                    singleTapGesture.gestureData=text
                    cell.addGestureRecognizer(singleTapGesture)
                    
                    
                    
                    //////Double tap gesture
                    let gestureDoubleTap = GestureViewClass(target: self, action: #selector(mainHomeViewController.doubleTap(_:)))
                    gestureDoubleTap.numberOfTapsRequired=2
                    gestureDoubleTap.gestureData=text
                    cell.addGestureRecognizer(gestureDoubleTap)
                    
                    singleTapGesture.require(toFail: gestureDoubleTap)
                    
                    
                    
                    /////Long Tap Gesture
                    cell.tag=1000*collectionView.tag+indexPath.row
                    
                    ////print(cell.tag)
                    
                    let longView = UIView()
                    longView.frame=cell.frame
                    longView.tag=1000*collectionView.tag+indexPath.row
                    //cell .addSubview(longView)
                    
                    
                    cell.likeButton.tag = 1000*collectionView.tag+indexPath.row
                    cell.likeButton.addTarget(self, action: #selector(self.imageTapped(_:)), for: UIControlEvents .touchUpInside)
                     cell.planButton.tag = 2000*collectionView.tag+indexPath.row
                    cell.menuButton.tag = 1000*collectionView.tag+indexPath.row
                    cell.menuButton.addTarget(self, action: #selector(self.openLongTap(_:event:)), for: UIControlEvents .touchUpInside)
                    cell.menuButton.setImage(UIImage (named: "More"), for: .normal)
                    
                   
                    
                    cell.planButton .addTarget(self, action: #selector(self.planBtnTapCollectionView(_:)), for: .touchUpInside)
                    
                    addToPlanBtn .setTitle("Add To Plan", for: .normal)
                    
                    if countsDictionary.object(forKey: "bookings") != nil  {
                        
                        //let countst = countArray.valueForKey("storyCount") as! NSNumber
                        let countst = countsDictionary.value(forKey: "bookings") as! NSArray
                        cell.planButton.setImage(UIImage (named: "travelplanbutton"), for: .normal)
                        
                        
                        
                        if countst.count>0
                        {
                            
                            //print(countst)
                            if countst.contains(imageId2) {
                                cell.planButton.setImage(UIImage (named: "travelplanbuttonactive"), for: .normal)
                               addToPlanBtn .setTitle("Remove From Plan", for: .normal)
                                // cell.planButton.removeTarget(nil, action: nil, for: .allEvents)
                            }
                            
                            
                        }
                        
                        
                    }
                    
                    
                    
                    
                }
                
                
                
                return cell
                
            
            }
        else{
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "showMoreCell",for: indexPath)
            // cell.frame = CGRectMake(0, 0, self.view.frame.size.width - 9, 50)
            
            cell.contentView.backgroundColor = UIColor .init(colorLiteralRed: 240/255, green: 240/255, blue: 240/255, alpha: 1)
            let spinner = UIActivityIndicatorView()
            
            // if !self.noMoreResultsAvail {
            spinner.isHidden = false
            
            spinner.activityIndicatorViewStyle = .gray
            spinner.frame = CGRect(x: cell.frame.size.width/2 - 20 , y: cell.frame.size.height/2 - 17, width: 40, height: 40)
            cell.addSubview(spinner)
            
            
            
            spinner.startAnimating()
            
            
            
            
            
            let userId = (self.userDetailArray .object(at: collectionView.tag) as AnyObject).value(forKey: "id") as? String ?? ""
            
            let skip = ((arrayOfimages1[collectionView.tag] as AnyObject).value(forKey: "id")! as AnyObject) .count
            
            let parameterString:NSDictionary = ["imageOwn": userId, "type": globalType, "placeId": globalPlaceid, "fullName": globalFullName, "skip": skip, "userId": self.uId ]
            
            
            print("More images parameters-\(parameterString)")
            self .getImages(parameterString, indx: collectionView.tag)
            
            
            
            ///////////////////////-------------
            
            
            return cell
            }
            
        }
        }
    }
    
    
    
    
   
    
    
    
    //MARK:-
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
        if collectionView.tag == 1221
        {
            //go to location onfo page
            if planAllLocation == false //false to show the plans of that place
            {
             
                let placeIds = (countArray.value(forKey: "countryId")) as! NSArray
                
                if placeIds.contains(globalPlaceid){//("58c3c09336f8b6180feea0c6"){//(globalPlaceid) {
                    print("Contains story")
                    let indx = placeIds .index(of: self.globalPlaceid)
                    print(indx)
                    
                    let storyArr = ((countArray.object(at: indx)) as AnyObject).value(forKey: "places") as! NSMutableArray //contains all story locations
                    
                    let userPicture = "" //((storyArr.object(at: storyArr.count-1 - (indexPath.row)) as AnyObject).value(forKey: "imageOwn") as AnyObject).value(forKey: "picture") as? String ?? "" //userProfilePicture
                    
                    let userName = ((storyArr.object(at: storyArr.count-1 - (indexPath.row)) as AnyObject).value(forKey: "imageOwn") as AnyObject).value(forKey: "name") as? String ?? "" //userName
                    
                    let desc = ((storyArr.object(at: storyArr.count-1 - (indexPath.row)) as AnyObject).value(forKey: "place") as AnyObject).value(forKey: "description") as? String ?? "" //description
                    
                    let countryname = ((storyArr.object(at: storyArr.count-1 - (indexPath.row)) as AnyObject).value(forKey: "place") as AnyObject).value(forKey: "country") as? String ?? ""
                    let cityName = ((storyArr.object(at: indexPath.row) as AnyObject).value(forKey: "place") as AnyObject).value(forKey: "city") as? String ?? ""
                    
                    let location = "\(((storyArr.object(at: storyArr.count-1 - (indexPath.row)) as AnyObject).value(forKey: "place") as AnyObject).value(forKey: "placeTag") as? String ?? ""),\(cityName),\(countryname) " //location(placeTag+city+country)
                    
                    var vanu = ((storyArr.object(at: storyArr.count-1 - (indexPath.row)) as AnyObject).value(forKey: "place") as AnyObject).value(forKey: "placeTag") as? String ?? "EM"
                    if vanu == "" || vanu == "EM" {
                        vanu = cityName
                        if vanu == "" {
                            vanu = countryname
                        }
                    }
                    
                    
                    
                    let largeImage = ((storyArr.object(at: storyArr.count-1 - (indexPath.row)) as AnyObject).value(forKey: "place") as AnyObject).value(forKey: "imageLarge") as? String ?? "" //Large image url
                    let thumbImage = ((storyArr.object(at: storyArr.count-1 - (indexPath.row)) as AnyObject).value(forKey: "place") as AnyObject).value(forKey: "imageThumb") as? String ?? "" //Large image url
                    
                    var sendgeoTag = ((storyArr.object(at: storyArr.count-1 - (indexPath.row)) as AnyObject).value(forKey: "place") as AnyObject).value(forKey: "placeTag") as? String ?? ""
                    let fullName22 = sendgeoTag
                    let fullNameArr22 = fullName22.characters.split{$0 == ","}.map(String.init)
                    if fullNameArr22.count>0{
                        sendgeoTag = fullNameArr22[0]
                    }
                    //Split the place tag to get the results in foursquare
                    
                    
                     let imageId = ((storyArr.object(at: storyArr.count-1 - (indexPath.row)) as AnyObject).value(forKey: "place") as AnyObject).value(forKey: "_id") as? String ?? "" //Image Id and place id
                    
                    
                    var lat = NSNumber()
                    var long = NSNumber()
                    if let vlu = ((storyArr.object(at: storyArr.count-1 - (indexPath.row)) as AnyObject).value(forKey: "place") as AnyObject).value(forKey: "latitude") //as? NSNull != NSNull()
                    {
                        lat = ((storyArr.object(at: storyArr.count-1 - (indexPath.row)) as AnyObject).value(forKey: "place") as AnyObject).value(forKey: "latitude") as! NSNumber  //as? String ?? "0.0"
                        long = ((storyArr.object(at: storyArr.count-1 - (indexPath.row)) as AnyObject).value(forKey: "place") as AnyObject).value(forKey: "longitude") as! NSNumber //as? String ?? "0.0"
                    }
                    else
                    {
                        lat=0
                        long=0
                    }
                    
                    var multipleImgs = NSMutableArray()//will empty not to show the multiple images
                    multipleImgs.add(largeImage)
                    
                    let catArrSt = ((storyArr.object(at: storyArr.count-1 - (indexPath.row)) as AnyObject).value(forKey: "place") as AnyObject).value(forKey: "category") as! NSMutableArray
                    let strcat = (catArrSt.value(forKey: "displayName") as AnyObject).componentsJoined(by: ",")
                    
                   
                    var countLik = NSNumber()
                    let likeCountValue = ((storyArr.object(at: storyArr.count-1 - (indexPath.row)) as AnyObject).value(forKey: "place") as AnyObject).value(forKey: "userLiked") as! NSMutableArray

                    countLik = NSNumber(value:likeCountValue.count)
                    
//                    if likeCountValue[b!] as? NSNull != NSNull()
//                    {
//                        countLik = likeCountValue[b!] as! NSNumber  //as? String ?? "0.0"
//                        
//                    }else
//                    {
//                        countLik=0
//                        
//                    }
                    
                    
                    
                    
               
                    
                    var mutableDic = NSMutableDictionary()
                        
//                      mutableDic = ["Description":desc, "profileImage": userPicture, "location": location, "locationImage": largeImage, "Venue": vanu, "cityName":cityName , "CountryName": countryname, "geoTag": sendgeoTag,"imageId":imageId,"latitude":lat, "longitude":long, "userName":userName, "Type": "Other", "multipleImagesLarge": multipleImgs, "Category": strcat, "likeBool":false, "standardImage":largeImage, "multipleImagesStandard": multipleImgs ,"categoryMainArray": catArrSt, "likeBool":true]
                    
                    
                    
                    if self.likeCount.count>0 {
                        let arrLk = self.likeCount.value(forKey: "imageId") as! NSArray
                        if arrLk.contains(imageId)
                        {
                            let index = (self.likeCount.value(forKey: "imageId") as AnyObject).index(of: imageId)
                            
                            if (self.likeCount.object(at: index) as AnyObject).value(forKey: "like") as! Bool == true {
                                
                                 mutableDic = ["Description":desc, "profileImage": userPicture, "location": location, "locationImage": largeImage, "Venue": vanu, "cityName":cityName , "CountryName": countryname, "geoTag": sendgeoTag,"imageId":imageId,"latitude":lat, "longitude":long, "userName":userName, "Type": "Other", "multipleImagesLarge": multipleImgs, "Category": strcat, "likeBool":true, "standardImage":largeImage, "multipleImagesStandard": multipleImgs ,"categoryMainArray": catArrSt, "likeCount": countLik]
                                
                            }
                                
                            else
                            {
                                mutableDic = ["Description":desc, "profileImage": userPicture, "location": location, "locationImage": largeImage, "Venue": vanu, "cityName":cityName , "CountryName": countryname, "geoTag": sendgeoTag,"imageId":imageId,"latitude":lat, "longitude":long, "userName":userName, "Type": "Other", "multipleImagesLarge": multipleImgs, "Category": strcat, "likeBool":false, "standardImage":largeImage, "multipleImagesStandard": multipleImgs ,"categoryMainArray": catArrSt, "likeCount": countLik]
                                
                              
                                
                            }
                            
                        }
                        else
                        {
                        mutableDic = ["Description":desc, "profileImage": userPicture, "location": location, "locationImage": largeImage, "Venue": vanu, "cityName":cityName , "CountryName": countryname, "geoTag": sendgeoTag,"imageId":imageId,"latitude":lat, "longitude":long, "userName":userName, "Type": "Other", "multipleImagesLarge": multipleImgs, "Category": strcat, "likeBool":false, "standardImage":largeImage, "multipleImagesStandard": multipleImgs ,"categoryMainArray": catArrSt, "likeCount": countLik]
                            
                        }
                        
                    }
                    else
                    {
                        
                        mutableDic = ["Description":desc, "profileImage": userPicture, "location": location, "locationImage": largeImage, "Venue": vanu, "cityName":cityName , "CountryName": countryname, "geoTag": sendgeoTag,"imageId":imageId,"latitude":lat, "longitude":long, "userName":userName, "Type": "Other", "multipleImagesLarge": multipleImgs, "Category": strcat, "likeBool":false, "standardImage":largeImage, "multipleImagesStandard": multipleImgs ,"categoryMainArray": catArrSt, "likeCount": countLik]
                        
                    }
                    
                    /////
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    let arrData = NSMutableArray()
                    arrData .add(mutableDic)
                    print(mutableDic)
                    let nxtObj2 = self.storyboard?.instantiateViewController(withIdentifier: "detailViewController") as! detailViewController
                    nxtObj2.arrayWithData=arrData
                    nxtObj2.fromStory=false//true
                    self.navigationController! .pushViewController(nxtObj2, animated: true)
                    
                }
                
                
            }
            //go to plans page
            else
            { //use _id for get booking id instead of countryId
                planAllLocation = false
                let countriesId = ((countArray.object(at: indexPath.row )) as AnyObject).value(forKey: "countryId") as? String ?? ""
                
               
                let nxtObj2 = self.storyboard?.instantiateViewController(withIdentifier: "TravelPlanVC") as! TravelPlanVC
                nxtObj2.countryId = countriesId
                nxtObj2.bookingIdFinal = (((countArray.object(at: indexPath.row )) as AnyObject).value(forKey: "_id") as? String)!
                self.navigationController! .pushViewController(nxtObj2, animated: true)
                
            }
            
        }
        
        
        
        //print("collectionviewtag:\(collectionView.tag) +  indexpathrow:\(indexPath.row)")
       
        
        
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
    {
        if collectionView.tag == 1221//storyCollectionView 
        {
            
        }
        else
        {
        for recognizer in cell.gestureRecognizers ?? [] {
            cell.removeGestureRecognizer(recognizer)
        }
        }
        
    }
    
    
   
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath){
        
        if collectionView.tag == 1221 {
 
        }
        else
        {
            
            if self.arrayOfimages1.count<1
            {
                
            }
            else
            {
                
                if indexPath.row < ((arrayOfimages1[collectionView.tag] as AnyObject).value(forKey: "id")! as AnyObject) .count
                {
                    var arrImg2 = NSArray()
                    arrImg2 = (self.arrayOfimages1[collectionView.tag] as AnyObject).value(forKey: "thumbnails") as! NSArray
                    
                    
                    let imageName2 = arrImg2[indexPath.row] as! String
                    
                    ///image of that place
                    
                    let locationimage = cell.viewWithTag(7459) as! UIImageView
                    locationimage.layer.cornerRadius = 0
                    locationimage.clipsToBounds = true
                    locationimage.contentMode = .scaleAspectFill
                    
                    let url2 = URL(string: imageName2 as String)
                    
                    let block: SDWebImageCompletionBlock = {(image, error, cacheType, imageURL) -> Void in
                        
                    }
                    locationimage.sd_setImage(with: url2!, placeholderImage: UIImage (named: "dummyBackground1"), options: SDWebImageOptions(rawValue: 0), completed: block)
                    
                    locationimage.focusOnFaces = true
                    
                    let gradient = cell.viewWithTag(7499) as! GradientView
                    
                    gradient.gradientLayer.colors = [UIColor.black.withAlphaComponent(0.75).cgColor, UIColor.clear.cgColor]
                    gradient.gradientLayer.gradient = GradientPoint.bottomTop.draw()
                    
                    
                    
                    if indexPath.row > 0 && indexPath.row < arrImg2.count - 1
                    {
                        
                        
                        let imageNameBack = arrImg2[indexPath.row - 1] as! String
                        let urlBack = URL(string: imageNameBack as String)
                        let tempImgView = UIImageView()
                        tempImgView.isHidden=true
                        
                        tempImgView .sd_setImage(with: urlBack)
                        
                        
                        let imageNameNext = arrImg2[indexPath.row + 1] as! String
                        let urlNext = URL(string: imageNameNext as String)
                        tempImgView .sd_setImage(with: urlNext)
                        
                    }
                    
                    
                }
                else
                {
                    
                    
                }
                
            }
        }
        
    }
    
    
    
    
    
    
    
    
    // MARK: UICollectionViewDelegateFlowLayout
    //MARK:
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView.tag != 1221 {
            
        //}
       // else
       // {
        
        var width1 = collectionView.frame.size.width/1.25   //1.8
        
        let height3 : CGFloat = self.imagesTableView.rowHeight - 70
        
        
        if indexPath.row == ((arrayOfimages1[collectionView.tag] as AnyObject).value(forKey: "id")! as AnyObject) .count  {
            width1 = 50.0
        }
        
        return CGSize(width: width1 , height: height3) // The size of one cell
            
        }
        
        else{
            return CGSize(width: 70 , height: 61)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        //top, left, bottom, right
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
   
    
    
    
///Plan header cell
    
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        //var reusableview: UICollectionReusableView? = nil
//       // if kind == UICollectionElementKindSectionHeader{
//            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "planHeader", for: indexPath) as! planCollectionViewHeaderCell
//           
//         headerView.changePlanButton.addTarget(self, action: #selector(mainHomeViewController.changePlans(sender:)), for: .touchUpInside)
//        
//            headerView.bringSubview(toFront: headerView.changePlanButton)
//           // headerView.changePlanButton.addTarget(self, action: #selector(mainHomeViewController.changePlans(_:)), for: .touchUpInside)
//        
//          //  reusableview = headerView
//       // }
//        
//        return headerView
//    }
//    
    
    
//    func changePlans(sender: UIButton) {
//        
//        if planAllLocation == false {
//            planAllLocation = true
//          
//            OperationQueue.main.addOperation({ () -> Void in
//                self.imagesTableView.beginUpdates()
//                self.imagesTableView.reloadSections(IndexSet(integer: 0), with: .automatic)
//                self.imagesTableView.endUpdates()
//
//            })
//            
//        }
//        else
//        {
//            
//            planAllLocation = false
//
//            OperationQueue.main.addOperation({ () -> Void in
//                self.imagesTableView.beginUpdates()
//                self.imagesTableView.reloadSections(IndexSet(integer: 0), with: .automatic)
//                self.imagesTableView.endUpdates()
//                
//            })
//            
//          
//        }
//        
//        
//    }
    
   
    
    
    
    
    //MARK:-
   //MARK: ////////////////// Function To Manage the count add and subtract of the likes////////////////
    //ADD Count of likes
    func addTheLikes(_ likeCount:NSNumber) -> Int {
        
        var returnCount = Int()
        
        returnCount = Int(likeCount) + 1
        
        
        return returnCount
        
    }
    
    ////Subtract Count of likes
    func subtractTheLikes(_ likeCount:NSNumber) -> Int {
        
        var returnCount = Int()
        
        returnCount = Int(likeCount) - 1
        
        return returnCount
        
    }
    
    
    
    
    
    
    
   ////////////////////////////////////////////////////////////////////////////
    
    //MARK:-///////////////Manage Gesture in collectionview Long tap , double tap and single tap////////////
    //MARK:-
   
    //MARK: Long Tap
    func longTap(_ sender: LongPressGesture)
    {
       
        if sender.state == .began
        {
            //PlanDeleteBool = true
            //storiesCollectionView.reloadData() future use
        }
        
        

        
    }
    
    //MARK: delet the plan from the list 
    func deletePlanApiHit(_ sender: UIButton) {
        let stTag = String(sender.tag)
        let cH = stTag[stTag.startIndex]
        print(cH)
        if cH == "5" {
            print("Delete the whole plan ")
            
            SweetAlert().showAlert("Confirm Delete?", subTitle: "Once deleted, you will no longer be able to see this whole plan.", style: AlertStyle.customImag(imageFile: "alertDelete"), buttonTitle:"Okay", buttonColor: UIColor.red , otherButtonTitle:  "Cancel", otherButtonColor: UIColor.green) { (isOtherButton) -> Void in
                if isOtherButton == true
                {
                    
                    //Retry function
                    print("delete image tapped")
                    let placeIds = (countArray.value(forKey: "countryId")) as! NSArray
                    
                  //  if placeIds.contains(self.globalPlaceid) {
                        print("Contains story")
                      //  let indx = placeIds .index(of: self.globalPlaceid )
                      //  print(indx)
                       // print(sender.tag)
                        let indexPath2 = sender.tag%5000
                        let imageUrlArray = ((countArray.object(at: indexPath2)) as AnyObject).value(forKey: "places") as! NSMutableArray
                        if imageUrlArray.count > 0
                        {
                            //   print(imageUrlArray)
                          
                            
                            let bookingid = ((countArray.object(at: indexPath2)) as AnyObject).value(forKey: "_id") as? String ?? ""
                            
                            apiClass.sharedInstance().deleteWholePlan(bookingIdFinal: bookingid as NSString)//deleteLocationFromPlan(placeId: imageId as NSString, bookingIdFinal: bookingid as NSString)
                        }
                   // }
                    
                }
                else
                {
                    
                    print("Cancel Pressed")
                }
            }
            
            
        }
           
            //delete images from plan
        else
        {
            SweetAlert().showAlert("Confirm Delete?", subTitle: "Once deleted, you will no longer be able to see this location in your plan.", style: AlertStyle.customImag(imageFile: "alertDelete"), buttonTitle:"Okay", buttonColor: UIColor.red , otherButtonTitle:  "Cancel", otherButtonColor: UIColor.green) { (isOtherButton) -> Void in
                if isOtherButton == true
                {
                    
                    
                    let placeIds = (countArray.value(forKey: "countryId")) as! NSArray
                    
                    if placeIds.contains(self.globalPlaceid) {
                        print("Contains story")
                        let indx = placeIds .index(of: self.globalPlaceid )//"58c3c09336f8b6180feea0c6")
                        print(indx)
                        
                        
                        let imageUrlArray = ((countArray.object(at: indx)) as AnyObject).value(forKey: "places") as! NSMutableArray
                        if imageUrlArray.count > 0
                        {
                         //   print(imageUrlArray)
                            let indexPath = sender.tag%1000
                          
                           // print(imageUrlArray.count - 1 - (indexPath))
                             // print(imageUrlArray.object(at: indexPath))
                            
                            let imageId = (((imageUrlArray.object(at: imageUrlArray.count-1 - (indexPath))) as! AnyObject).value(forKey: "place")as AnyObject) .value(forKey: "_id") as? String ?? ""

                         
                            
                            
                            let bookingid = ((countArray.object(at: indx)) as AnyObject).value(forKey: "_id") as? String ?? ""
                           // let pId = ((countArray.object(at: indx)) as AnyObject).value(forKey: "_id") as? String ?? ""
                            apiClass.sharedInstance().deleteLocationFromPlan(placeId: imageId as NSString, bookingIdFinal: bookingid as NSString)
                        }
                    
                    
                    
                    
                    
                  
                    print("delete image tapped")
                    
                    
                }
                else
                {
                    
                    print("Cancel Pressed")
                }
            }
            
            print("Delete image from plan")
        }
        print("comes here")
        PlanDeleteBool = true //false
      //  storiesCollectionView.reloadData()
        
    }
    }
    
    
    
    
    
    
   
 
    //MARK:- Double Tap
 
   func doubleTap(_ sender: GestureViewClass) {
 
 let userNameMy = Udefaults.string(forKey: "userLoginName")
 
    let fullName = sender.gestureData as String
    let fullNameArr = fullName.characters.split{$0 == " "}.map(String.init)
    //separate the string and change into integer
    
    let colViewTag = fullNameArr[0] as String
     let a:Int? = Int(colViewTag)
    
    let indexPath = fullNameArr[1]
    let b:Int? = Int(indexPath)
    
    
    //print(a)
    //print(b)
    
    let viewTaped = sender.view
    let likedView = viewTaped?.viewWithTag(7455)
    
        likedView?.alpha = 0
    
    let likecountlbl = viewTaped?.viewWithTag(7478) as! UILabel
    
   // hide and show the view of like
    
   
    let likeimg = viewTaped?.viewWithTag(7477) as! UIImageView
    
   // let likeimglbl = viewTaped?.viewWithTag(7488) as! UILabel
    
    
    
    
    var arrId = NSArray()
    arrId = (self.arrayOfimages1[a!] as AnyObject).value(forKey: "id") as! NSArray
    let imageId = arrId[b!] as? String ?? ""
    
    
    
    //MANAGE from the crash and get the like count from database
   
    var countLik = NSNumber()
    let likeCountValue = (self.arrayOfimages1[a!] as AnyObject).value(forKey: "likeCount") as! NSArray
    if likeCountValue[b!] as? NSNull != NSNull()  {
        
        countLik = likeCountValue[b!] as! NSNumber  //as? String ?? "0.0"
        
        
    }
    else
    {
        countLik=0
        
    }
    
    
    
    
    
    //MARK: LIKE COUNT MANAGE
    
    
    
    let otherUserId = (userDetailArray.object(at: a!) as AnyObject).value(forKey: "id") as? String ?? ""
    
    
   //print("like image tapped")
    
   // likeimglbl.text="You Liked This!!!"
    
    if self.likeCount.count>0 {
        let arrLikecount = self.likeCount.value(forKey: "imageId") as! NSArray
        //if (self.likeCount.value(forKey: "imageId") as AnyObject).contains(imageId) {
        
        if arrLikecount.contains(imageId) {
        
        
            let index = (self.likeCount.value(forKey: "imageId") as AnyObject).index(of: imageId)
            
            if (self.likeCount.object(at: index) as AnyObject).value(forKey: "like") as! Bool == true {
                
                let staticCount = (self.likeCount.object(at: index) as AnyObject).value(forKey: "count") as? NSNumber
                likecountlbl.text=String(self.subtractTheLikes(staticCount!))
                
                
                self.likeCount .removeObject(at: index)
                 // likeimglbl.text="You Unliked This!!!"
                self.likeCount .add(["userId":uId, "imageId":imageId, "like":false, "count": self.subtractTheLikes(staticCount!)])
               //print(self.likeCount.lastObject)
                
                 likedView?.alpha = 1
                
                UIView.animate(withDuration: 1.0, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                    likedView?.alpha = 0
                    }, completion: nil)
                
                
                likeimg.image=UIImage (named: "Like")
                
                let dat: NSDictionary = ["userId": "\(uId)", "photoId":"\(imageId)", "userLiked":"\(uId)", "status":"0", "imageOwn": "\(otherUserId)", "userName": "\(userNameMy!)"]
               //print("Post to like picture---- \(dat)")
                 DispatchQueue.main.async(execute: {
                apiClass.sharedInstance().postRequestLikeUnlikeImage(parameters: dat, viewController: self)
                })
                
            }
            else
            {
                let staticCount = (self.likeCount.object(at: index) as AnyObject).value(forKey: "count") as? NSNumber
                likecountlbl.text=String(self.addTheLikes(staticCount!))
                
                self.likeCount .removeObject(at: index)
                self.likeCount .add(["userId":uId, "imageId":imageId, "like":true, "count": self.addTheLikes(staticCount!)])
                
                
               //print(self.likeCount.lastObject)
                
                likeimg.image=UIImage (named: "likefill")
                likedView?.alpha = 1
                let dat: NSDictionary = ["userId": "\(uId)", "photoId":"\(imageId)", "userLiked":"\(uId)", "status":"1", "imageOwn": "\(otherUserId)", "userName": "\(userNameMy!)"]
                
                
                UIView.animate(withDuration: 1.0, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                    likedView?.alpha = 0
                    }, completion: nil)
                
               //print("Post to like picture---- \(dat)")
                 DispatchQueue.main.async(execute: {
                apiClass.sharedInstance().postRequestLikeUnlikeImage(parameters: dat, viewController: self)
                })
                
            }
        }
            // if not liked already
        else{
            self.likeCount .add(["userId":uId, "imageId":imageId, "like":true, "count": self.addTheLikes(countLik)])
            likedView?.alpha = 1
            likeimg.image=UIImage (named: "likefill")
             likecountlbl.text=String(self.addTheLikes(countLik))
            let dat: NSDictionary = ["userId": "\(uId)", "photoId":"\(imageId)", "userLiked":"\(uId)", "status":"1", "imageOwn": "\(otherUserId)", "userName": "\(userNameMy!)"]
          
            UIView.animate(withDuration: 1.0, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                likedView?.alpha = 0
                }, completion: nil)
            
            
           //print("Post to like picture---- \(dat)")
             DispatchQueue.main.async(execute: {
            apiClass.sharedInstance().postRequestLikeUnlikeImage(parameters: dat, viewController: self)
            })
        }

    }
    
    else
    
    {
        
        self.likeCount .add(["userId":uId, "count":self.addTheLikes(countLik), "like": true, "imageId": imageId])
        likecountlbl.text=String(self.addTheLikes(countLik))
        likeimg.image=UIImage (named: "likefill")
        likedView?.alpha = 1
        let dat: NSDictionary = ["userId": "\(uId)", "photoId":"\(imageId)", "userLiked":"\(uId)", "status":"1", "imageOwn": "\(otherUserId)", "userName": "\(userNameMy!)"]
        
        UIView.animate(withDuration: 1.0, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            likedView?.alpha = 0
            }, completion: nil)
        
       //print("Post to like picture---- \(dat)")
         DispatchQueue.main.async(execute: {
        apiClass.sharedInstance().postRequestLikeUnlikeImage(parameters: dat, viewController: self)
         })

    }
    
    
            
    
    
    
    
    
    
    
    }

    
    
    //MARK:- Single tap action
    //MARK:-
    
    func SingleTap(_ sender: GestureViewClass) {
        
        URLCache.shared.removeAllCachedResponses()
        
        DispatchQueue.main.async(execute: {
        
        let fullName = sender.gestureData as String
        let fullNameArr = fullName.characters.split{$0 == " "}.map(String.init)
        //separate the string and change into integer
        
        let colViewTag = fullNameArr[0] as String
        let a:Int? = Int(colViewTag)
        
        let indexPath = fullNameArr[1]
        let b:Int? = Int(indexPath)
        
        
            
            /////  Manage the single tap data
        var arrImg = NSArray()//Large image
        var imageName = NSString()//large image string
        
        var arrImg2 = NSArray()
        var imageStandard = NSString()
            
         arrImg = (self.arrayOfimages1[a!] as AnyObject).value(forKey: "largeImage") as! NSArray
         arrImg2 = (self.arrayOfimages1[a!] as AnyObject).value(forKey: "thumbnails") as! NSArray
            
            imageStandard = arrImg2[b!] as! String as NSString
            imageName = arrImg[b!] as! String as NSString
       
       
        
        
        var location = NSString()
        var arrayLocation = NSArray()
        var arrayCountry = NSArray()
        var arrayImageId = NSArray()
        var cityName = NSString()
            
        arrayLocation = (self.arrayOfimages1[a!] as AnyObject).value(forKey: "location") as! NSArray
        arrayCountry = (self.arrayOfimages1[a!] as AnyObject).value(forKey: "country") as! NSArray
          var arrayCountryId = (self.arrayOfimages1[a!] as AnyObject).value(forKey: "countId") as? NSArray
           
         arrayImageId = (self.arrayOfimages1[a!] as AnyObject).value(forKey: "id") as! NSArray
            
            cityName = arrayLocation[b!] as? String as NSString? ?? ""
            if cityName == ""{
                
             cityName = self.globalLocation
            }
            
            
            
           //print("City Name= \(cityName)")
            
            
        let countryName = arrayCountry[b!] as? String ?? "\(self.globalLocation)"
         let countryId = arrayCountryId?[b!] as? String ?? "\(self.globalPlaceid)"
            
        let geoTag = (self.arrayOfimages1[a!] as AnyObject).value(forKey: "geoTag") as! NSArray

            
            var sendgeoTag = geoTag[b!] as? String ?? ""
         
            let fullName22 = sendgeoTag
            let fullNameArr22 = fullName22.characters.split{$0 == ","}.map(String.init)
           
            if fullNameArr22.count>0
            {
                sendgeoTag = fullNameArr22[0]
            }
            
           
            // remove the another part of string
            let changeStr:NSString = sendgeoTag as NSString
            let ddd = changeStr.replacingOccurrences(of: "&", with: " and ") //replace & with and
            sendgeoTag = ddd
            
            
            
         location = "\(self.captitalString(geoTag[b!] as? String as NSString? ?? "")), \(self.captitalString(arrayLocation[b!] as? String as NSString? ?? "")), \(self.captitalString(arrayCountry[b!] as? String as NSString? ?? ""))" as NSString
            
           
            
            let multipleImgs = NSMutableArray()
            let multipleImgStandard = NSMutableArray()
            
            for i in 0..<geoTag.count{
                
                if( (geoTag[b!] as AnyObject)  .isEqual(geoTag[i]) ) {
                    
                    if imageName as String == arrImg[i] as! String{
                        
                    }
                    else
                    {
                    multipleImgs .add(arrImg[i] as! String)
                    multipleImgStandard .add(arrImg2[i] as! String)
                        }
                }
                
            }
            
            
            
            
            
      
            
        let profileImage = (self.userDetailArray .object(at: a!) as AnyObject).value(forKey: "profile")! as! NSString
            
            
            
        
        let arrDes = (self.arrayOfimages1[a!] as AnyObject).value(forKey: "description") as! NSArray
        let str = arrDes[b!] as? NSString ?? ""
       
        
            
            //imageId
             let imageId = arrayImageId[b!] as! String
            
        
       
        ///open new view
        
            var arrCategory = NSArray()
            arrCategory = (self.arrayOfimages1[a!] as AnyObject).value(forKey: "category") as! NSArray
            
           
          // //print(arrCategory)
            var catType = "Other"
            let source = (self.arrayOfimages1[a!] as AnyObject).value(forKey: "source") as! NSArray
            
            
            if source[b!] as? NSNull != NSNull()
            {
                
                let sourceStr = source.object(at: b!) as? String ?? ""
                if sourceStr == "PYT" {
                    catType = "PYT"
                    
                    }
                    
                    
                    
                    
                    
                    ///can delete
                    
                }
            
            
            
           
            
            
            multipleImgs .insert(imageName, at: 0)
            multipleImgStandard .insert(imageStandard, at: 0)
            
            
           let name = (self.userDetailArray .object(at: a!) as AnyObject).value(forKey: "name") as? String ?? " "
           let arrayData = NSMutableArray()
            
            
            
            //MANAGE from the crash in caseof latitude and longitude
            var lat = NSNumber()
            var long = NSNumber()
            let latArr = (self.arrayOfimages1[a!] as AnyObject).value(forKey: "latitude") as! NSArray
            if latArr[b!] as? NSNull != NSNull()  {
                
                lat = latArr[b!] as! NSNumber  //as? String ?? "0.0"
                
                let longArr = (self.arrayOfimages1[a!] as AnyObject).value(forKey: "longitude") as! NSArray
                long = longArr[b!] as! NSNumber //as? String ?? "0.0"
            }
            else
            {
                lat=0
                long=0
            }
            
            
            let catArrSt = arrCategory.object(at: b!) as! NSMutableArray
            
            let strcat = (catArrSt.value(forKey: "displayName") as AnyObject).componentsJoined(by: ",")
        
            
            
            
            
            
            
            
            
            
            
            //Likes count
            
            var countLik = NSNumber()
            let likeCountValue = (self.arrayOfimages1[a!] as AnyObject).value(forKey: "likeCount") as! NSArray
            if likeCountValue[b!] as? NSNull != NSNull()  {
                
                countLik = likeCountValue[b!] as! NSNumber  //as? String ?? "0.0"
                
                
            }else
            {
                countLik=0
                
            }
            
            
            
            
            
            
            
             let otherUserId = (self.userDetailArray.object(at: a!) as AnyObject).value(forKey: "id") as? String ?? ""
            
            
            
            
            var mutableDic = NSMutableDictionary()
            
            if self.likeCount.count>0 {
                let arrLk = self.likeCount.value(forKey: "imageId") as! NSArray
                if arrLk.contains(imageId)
                {
                    let index = (self.likeCount.value(forKey: "imageId") as AnyObject).index(of: imageId)
                    
                    if (self.likeCount.object(at: index) as AnyObject).value(forKey: "like") as! Bool == true {
                        
                        mutableDic = ["Description":str, "profileImage": profileImage, "location": location, "locationImage": imageName,"CountryName": countryName, "Venue": cityName, "geoTag": sendgeoTag, "userName":name, "Type": catType,"imageId":imageId,"latitude": lat, "longitude":long, "multipleImagesLarge": multipleImgs, "Category": strcat, "likeBool":true, "otherUserId":otherUserId, "cityName":cityName, "likeCount": countLik, "standardImage":imageStandard, "multipleImagesStandard": multipleImgStandard, "categoryMainArray": catArrSt, "placeType": self.globalType, "placeId": self.globalPlaceid, "countryId": countryId  ]
                        
                        arrayData .add(mutableDic)
                    }
                        
                    else
                    {
                        mutableDic = ["Description":str, "profileImage": profileImage, "location": location, "locationImage": imageName,"CountryName": countryName, "Venue": cityName, "geoTag": sendgeoTag, "userName":name, "Type": catType,"imageId":imageId,"latitude": lat, "longitude":long, "multipleImagesLarge": multipleImgs, "Category": strcat, "likeBool":false, "otherUserId":otherUserId, "cityName":cityName, "likeCount": countLik, "standardImage":imageStandard, "multipleImagesStandard": multipleImgStandard ,"categoryMainArray": catArrSt, "placeType": self.globalType, "placeId": self.globalPlaceid, "countryId": countryId]
                        
                        arrayData .add(mutableDic)
                    }
                    
                }
                else{
                    mutableDic = ["Description":str, "profileImage": profileImage, "location": location, "locationImage": imageName,"CountryName": countryName, "Venue": cityName, "geoTag": sendgeoTag, "userName":name, "Type": catType,"imageId":imageId,"latitude": lat, "longitude":long, "multipleImagesLarge": multipleImgs, "Category": strcat, "likeBool":false, "otherUserId":otherUserId, "cityName":cityName, "likeCount": countLik, "standardImage":imageStandard, "multipleImagesStandard": multipleImgStandard, "categoryMainArray": catArrSt, "placeType": self.globalType, "placeId": self.globalPlaceid, "countryId": countryId]
                    
                    arrayData .add(mutableDic)
                }
                
            }
            else
            {
                mutableDic = ["Description":str, "profileImage": profileImage, "location": location, "locationImage": imageName,"CountryName": countryName, "Venue": cityName, "geoTag": sendgeoTag, "userName":name, "Type": catType,"imageId":imageId,"latitude": lat, "longitude":long, "multipleImagesLarge": multipleImgs, "Category": strcat, "likeBool":false, "otherUserId":otherUserId, "cityName":cityName, "likeCount": countLik, "standardImage":imageStandard, "multipleImagesStandard": multipleImgStandard, "categoryMainArray": catArrSt, "placeType": self.globalType, "placeId": self.globalPlaceid, "countryId": countryId]
                
                arrayData .add(mutableDic)
            }
            
            
            
            
            
            
            
            
           print(mutableDic)
            
            
            
            let nxtObj2 = self.storyboard?.instantiateViewController(withIdentifier: "detailViewController") as! detailViewController
            nxtObj2.arrayWithData=arrayData
             nxtObj2.fromStory=false
            nxtObj2.countLikes=self.likeCount
          nxtObj2.fromInterest = false
            
       
            
            self.navigationController! .pushViewController(nxtObj2, animated: true)
            
        

        })
        
        
    }
    
    
    
    
    
    
    //MARK:
    //MARK: Press left like button
    func imageTapped(_ sender: UIButton)
    {
        let userNameMy = Udefaults.string(forKey: "userLoginName")
        
        print(sender.tag)
        let a:Int? = (sender.tag) / 1000
        let b:Int? = (sender.tag) % 1000
        
        ////print("table=\(a!), Collect\(b!)")
        
        collectionIndex = b!
        tableIndex = a!
        
        
        
        let viewTaped = sender.superview
        let likedView = viewTaped?.viewWithTag(7455)
        
        likedView?.alpha = 0
        
        let likecountlbl = viewTaped?.viewWithTag(7478) as! UILabel
        
        // hide and show the view of like
        
        
        let likeimg = viewTaped?.viewWithTag(7477) as! UIImageView
        
       // let likeimglbl = viewTaped?.viewWithTag(7488) as! UILabel
        
        
        
        
        var arrId = NSArray()
        arrId = (self.arrayOfimages1[a!] as AnyObject).value(forKey: "id") as! NSArray
        let imageId = arrId[b!] as? String ?? ""
        
        
        
        //MANAGE from the crash and get the like count from database
        
        var countLik = NSNumber()
        let likeCountValue = (self.arrayOfimages1[a!] as AnyObject).value(forKey: "likeCount") as! NSArray
        if likeCountValue[b!] as? NSNull != NSNull()  {
            
            countLik = likeCountValue[b!] as! NSNumber  //as? String ?? "0.0"
            
            
        }
        else
        {
            countLik=0
            
        }
        
        
        
        
        
        //MARK: LIKE COUNT MANAGE
        
        
        
        let otherUserId = (userDetailArray.object(at: a!) as AnyObject).value(forKey: "id") as? String ?? ""
        
        
        //print("like image tapped")
        
       // likeimglbl.text="You Liked This!!!"
        
        if self.likeCount.count>0 {
            let arrLikecount = self.likeCount.value(forKey: "imageId") as! NSArray
            //if (self.likeCount.value(forKey: "imageId") as AnyObject).contains(imageId) {
            
            if arrLikecount.contains(imageId) {
                
                let index = (self.likeCount.value(forKey: "imageId") as AnyObject).index(of: imageId)
                
                if (self.likeCount.object(at: index) as AnyObject).value(forKey: "like") as! Bool == true {
                    
                    let staticCount = (self.likeCount.object(at: index) as AnyObject).value(forKey: "count") as? NSNumber
                    likecountlbl.text=String(self.subtractTheLikes(staticCount!))
                    
                    
                    self.likeCount .removeObject(at: index)
                    //likeimglbl.text="You Unliked This!!!"
                    self.likeCount .add(["userId":uId, "imageId":imageId, "like":false, "count": self.subtractTheLikes(staticCount!)])
                    //print(self.likeCount.lastObject)
                    
                    likedView?.alpha = 1
                    
                    UIView.animate(withDuration: 1.2, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                        likedView?.alpha = 0
                        }, completion: nil)
                    
                    
                    
                    likeimg.image=UIImage (named: "Like")
                    
                    let dat: NSDictionary = ["userId": "\(uId)", "photoId":"\(imageId)", "userLiked":"\(uId)", "status":"0", "imageOwn": "\(otherUserId)", "userName": "\(userNameMy!)"]
                    print("Post to like picture---- \(dat)")
                    DispatchQueue.main.async(execute: {
                        apiClass.sharedInstance().postRequestLikeUnlikeImage(parameters: dat, viewController: self)
                    })
                    
                }
                else
                {
                    let staticCount = (self.likeCount.object(at: index) as AnyObject).value(forKey: "count") as? NSNumber
                    likecountlbl.text=String(self.addTheLikes(staticCount!))
                    
                    self.likeCount .removeObject(at: index)
                    self.likeCount .add(["userId":uId, "imageId":imageId, "like":true, "count": self.addTheLikes(staticCount!)])
                    
                    
                    //print(self.likeCount.lastObject)
                    
                    likeimg.image=UIImage (named: "likefill")
                    likedView?.alpha = 1
                    let dat: NSDictionary = ["userId": "\(uId)", "photoId":"\(imageId)", "userLiked":"\(uId)", "status":"1", "imageOwn": "\(otherUserId)", "userName": "\(userNameMy!)"]
                    
                    
                    UIView.animate(withDuration: 1.2, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                        likedView?.alpha = 0
                        }, completion: nil)
                    
                    print("Post to like picture---- \(dat)")
                    DispatchQueue.main.async(execute: {
                        apiClass.sharedInstance().postRequestLikeUnlikeImage(parameters: dat, viewController: self)
                    })
                    
                }
            }
                
                // if not liked already
            else
            {
                self.likeCount .add(["userId":uId, "imageId":imageId, "like":true, "count": self.addTheLikes(countLik)])
                likedView?.alpha = 1
                likeimg.image=UIImage (named: "likefill")
                likecountlbl.text=String(self.addTheLikes(countLik))
                let dat: NSDictionary = ["userId": "\(uId)", "photoId":"\(imageId)", "userLiked":"\(uId)", "status":"1", "imageOwn": "\(otherUserId)", "userName": "\(userNameMy!)"]
                
                UIView.animate(withDuration: 1.2, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                    likedView?.alpha = 0
                    }, completion: nil)
                
                
                print("Post to like picture---- \(dat)")
                DispatchQueue.main.async(execute: {
                    apiClass.sharedInstance().postRequestLikeUnlikeImage(parameters: dat, viewController: self)
                })
            }
            
        }
            
        else
            
        {
            
            self.likeCount .add(["userId":uId, "count":self.addTheLikes(countLik), "like": true, "imageId": imageId])
            likecountlbl.text=String(self.addTheLikes(countLik))
            likeimg.image=UIImage (named: "likefill")
            likedView?.alpha = 1
            let dat: NSDictionary = ["userId": "\(uId)", "photoId":"\(imageId)", "userLiked":"\(uId)", "status":"1", "imageOwn": "\(otherUserId)", "userName": "\(userNameMy!)"]
            
            UIView.animate(withDuration: 1.2, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                likedView?.alpha = 0
                }, completion: nil)
            
            print("Post to like picture---- \(dat)")
            DispatchQueue.main.async(execute: {
                apiClass.sharedInstance().postRequestLikeUnlikeImage(parameters: dat, viewController: self)
            })
            
        }
        
        
        
        
        
        
        
        
    }
    
    
    func planBtnTapCollectionView(_ sender: UIButton) {
        
       let a:Int? = (sender.tag) / 2000
        let b:Int? = (sender.tag) % 2000
        
        collectionIndex = b!
        tableIndex = a!
        longTapedView = sender.viewWithTag(2000*tableIndex+collectionIndex)! //.superview!
        
        self.storyButtonTapped(self)
    }
    
    
    //MARK:
    
    func openLongTap(_ sender: UIButton, event: UIEvent)
    {
        let touches: Set<AnyHashable>? = event.allTouches
        let touch: UITouch? = touches?.first as! UITouch?
        var currentTouchPosition: CGPoint? = touch?.location(in: self.view)

        print(currentTouchPosition)
        print("width: \(dynamicDetailSubview.frame.size.width), height: \(dynamicDetailSubview.frame.size.height),tableView.y + 160:\(dynamicDetailSubview.frame.size.height + 100)")
        
        var xframe = CGFloat()
        var yframe = CGFloat()
        if (currentTouchPosition?.x)! < dynamicDetailSubview.frame.size.width + 5
        {
            xframe = (currentTouchPosition?.x)! + 5 //+ dynamicDetailSubview.frame.size.width + 3
        }
        else
        {
            xframe = (currentTouchPosition?.x)! - dynamicDetailSubview.frame.size.width + 5
        }
        
        if (currentTouchPosition?.y)! < dynamicDetailSubview.frame.size.height + 130
        {
            yframe = (currentTouchPosition?.y)! - 5 //+ dynamicDetailSubview.frame.size.height + 3
        }
        else
        {
            yframe = (currentTouchPosition?.y)! - dynamicDetailSubview.frame.size.height
        }
        
        print("x:\(xframe), y:\(yframe)")
        
        
        dynamicDetailSubview.frame = CGRect(x: xframe, y: yframe, width: dynamicDetailSubview.frame.size.width, height: dynamicDetailSubview.frame.size.height)
        print(dynamicDetailSubview.frame)
        detailView .layoutIfNeeded()
        detailView.layoutSubviews()
        
        
        
        print(sender.tag)
        let a:Int? = (sender.tag) / 1000
        let b:Int? = (sender.tag) % 1000
        
        ////print("table=\(a!), Collect\(b!)")
        
        collectionIndex = b!
        tableIndex = a!
        longTapedView = sender.superview!
        
       self.manageViewLongTap()
        
        toolTimer.invalidate()

        
    }
    
    
    
    
    //MARK: Manage view of long Tap
    func manageViewLongTap() {
        
        planTap = false
        let b: Int = collectionIndex
        let a: Int = tableIndex
        
        
        
        var arrId = NSArray()
        arrId = (self.arrayOfimages1[a] as AnyObject).value(forKey: "id") as! NSArray
        let imageId = arrId[b] as! String
        
        
        //print(countsDictionary)
        if countsDictionary.object(forKey: "bookings") != nil  {
            
            //let countst = countArray.valueForKey("storyCount") as! NSNumber
            let countst = countsDictionary.value(forKey: "bookings") as! NSArray
            addToPlanBtn .setTitle("Add To Plan", for: .normal)
            
           
            
            if countst.count>0 {
                
                //print(countst)
                if countst.contains(imageId) {
                    addToPlanBtn .setTitle("Remove From Plan", for: .normal)
            
                }
                
                
            }
            
            
            
        }

        
        addToBucketBtn.setTitle("Add To Bucket", for: UIControlState .normal)
        addToBucketBtn.isUserInteractionEnabled=true
        if countsDictionary.object(forKey: "bucketImages") != nil  {
            
            //let countst = countArray.valueForKey("storyCount") as! NSNumber
            let countBkt = countsDictionary.value(forKey: "bucketImages") as! NSArray
            
            if countBkt.count>0 {
                
                //print(countBkt)
                if countBkt.contains(imageId) {
                    addToBucketBtn.setTitle("Remove From Bucket", for: UIControlState .normal)
                    addToBucketBtn.isUserInteractionEnabled = false
                }
                
                
            }
            
            
            
        }
        
        
        
        
        
        
        
        
        
        
        
        
        
        /////-Delete the uploaded photos from facebook
        
        let source = (self.arrayOfimages1[a] as AnyObject).value(forKey: "source") as! NSArray
        
        detailView.isHidden=true
        
        if source[b] as? NSNull != NSNull()  {
            
            self.editBottomSpace.constant = -(self.editButtonDetailview.frame.size.height)
            self.editButtonDetailview.isHidden = true
            let sourceStr = source.object(at: b) as? String ?? ""
            if sourceStr == "PYT" {
                
                //print(userDetailArray.objectAtIndex(a!).valueForKey("id"))
                
                if (userDetailArray.object(at: a) as AnyObject).value(forKey: "id") as? String == uId {
                    
                    //print("Enter if match the user id")
                    
                    self.editBottomSpace.constant = 1
                    self.editButtonDetailview.isHidden = false
                    
                }
            
                ///can delete
                
            }
            
            
        }
        
        
        
        ////////
        
        
        
        
        
        ////For like unlike
        
        likeButtonDetailView.setTitle("Like", for: UIControlState .normal)
        
        let likeCountArr = likeCount.value(forKey: "imageId") as! NSArray
       // if (likeCount.value(forKey: "imageId") as AnyObject).contains(imageId) {
        if likeCountArr.contains(imageId)
        {
            let index = (self.likeCount.value(forKey: "imageId") as AnyObject).index(of: imageId)
            
            if (self.likeCount.object(at: index) as AnyObject).value(forKey: "like") as! Bool == true {
                likeButtonDetailView.setTitle("Unlike", for: UIControlState .normal)
            }
            
        }
        
        
        
        
        
        self.detailSelectBtnAction(true)
        
        
    }
    
    
    
    
    
    
    
    
     //MARK:-
    ///// MARK:- create the capital string
    
    func captitalString(_ nameString:NSString) -> String {
        
        var nameString2 = nameString
        nameString2 = nameString.capitalized as NSString
        return nameString2 as String
        
    }
    
    
    
    
    
    
}







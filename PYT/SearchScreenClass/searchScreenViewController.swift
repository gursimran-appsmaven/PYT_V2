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

class searchScreenViewController: UIViewController, UINavigationControllerDelegate, UISearchBarDelegate {
    
    
    @IBOutlet var heightOfcontentView: NSLayoutConstraint!
    @IBOutlet weak var headerView: UIView!
    
    //SEARCH BAR VIEW
    @IBOutlet weak var search_Bar: UISearchBar!
    
    //search cancelButton
    @IBOutlet weak var cancelButtonSearch: UIButton!
    @IBOutlet weak var cancelWidth: NSLayoutConstraint!
    
    
    
    //BannerSearch
    @IBOutlet weak var searchBanner: UIImageView!
    
    @IBOutlet weak var txtLbl: UILabel!
    
    
    @IBOutlet weak var emptyView: UIView!
    
    
    @IBOutlet var menuButton: UIButton!
    
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
    @IBOutlet weak var scrollTopView: NSLayoutConstraint!
    @IBOutlet weak var scrollFirstView: UIView!
    
    
    
    @IBOutlet weak var searchedLocationsCollectionView: UICollectionView!
    
    @IBOutlet weak var trendingPlacesCollectionView: UICollectionView!
    
    @IBOutlet weak var bloggersCollectionView: UICollectionView!
    
    
    
    
    //Autoprompt view
    
    @IBOutlet weak var autoPromptTable: UITableView!
    @IBOutlet weak var autoPromptView: UIView!
    
    @IBOutlet weak var heightofPromptTableview: NSLayoutConstraint!
    
    
    
    
    
    
    @IBOutlet weak var promptIndicator: UIActivityIndicatorView!
    var task = URLSessionDataTask()
    var promptArray = NSMutableArray()
    var locationAutoPrompt = NSString()
    var locationType = NSString()
    var locationId = NSString()
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        
        IQKeyboardManager.shared().isEnableAutoToolbar=false
        IQKeyboardManager.shared().shouldResignOnTouchOutside=true
        
        
        
        
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        
        //  UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        
    }
    
    
    
    //MARK:- ViewDidLoad method
    //MARK:-
    
    
    override func viewDidLoad()
    {
        
        
        super.viewDidLoad()
        
        
        locationAutoPrompt = "Empty"
        autoPromptTable.rowHeight = 50
        
        headerView.alpha = 0
        
        
        
        searchBanner.layer.cornerRadius = 2.0
        searchBanner.clipsToBounds = true
        search_Bar.layer.cornerRadius = 5.0
        search_Bar.clipsToBounds = true
        search_Bar.barTintColor = UIColor .white
        //[self.searchBar setReturnKeyType:UIReturnKeyDone];
        search_Bar.returnKeyType = UIReturnKeyType .done
        search_Bar.showsCancelButton = false
        cancelWidth.constant = 0
        
        
        
        
        
        
        
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        blurEffectView.alpha = 0.8
        blurEffectView.frame = autoPromptView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        autoPromptView.addSubview(blurEffectView)
        self.autoPromptView .bringSubview(toFront: autoPromptTable)
        
        
        
        
        
        
        
        
        
        // bloggerslabel.attributedText=attributedTextClass().setAttributeRobotLight("  Travel Gurus\n", text1Size: 16, text2: "  Inspiration from the best travel bloggers", text2Size: 15)
        
        
        
        
        self.automaticallyAdjustsScrollViewInsets = false //adjust navigation bar
        
        //disable pop of navigation
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        
        
        DispatchQueue.main.async {
            
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
                    //srrObj = ((tabledata[0] as AnyObject) .object(i) as! NSMutableDictionary).mutableCopy() as! NSMutableDictionary
                    
                    
                    self.arrayOfIntrest .add(srrObj)
                    
                }
                
            }
            
            
            
            
            
            
            
            
            
            let uId = defaults .string(forKey: "userLoginId")
            
            
            
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
                self.postApiForTrendingLocationsSearch(userid: uId! as NSString) //api to get the trending and popular places
                
            }
            
            
            
            
            self.adjustHeightOftableView()
            
            URLCache.shared.removeAllCachedResponses()//clear cache
            
            
            
            
            
            
            
            
            
            
            self.navigationController?.isNavigationBarHidden = true
            
            self.tabBarController?.tabBar.isHidden = true
            
            
            
            
            selectedindxSearch=0
            
            
            
        }
        
        
        
        
        
        
        //NotificationCenter.defaultCenter.addObserver(self, selector: #selector(firstMainScreenViewController.keyboardDidHide(_:)), name: UIKeyboardDidHideNotification, object: nil) //uncomment this
        
        
        
        //MANAGE DEVICETOKEN
        
        let tokendevice = defaults.string(forKey: "deviceToken")!
        print(tokendevice)
        let uId = defaults .string(forKey: "userLoginId")
        if defaults.bool(forKey: "savedDeviceToken") == true {
            
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
    
    /*
     func hideTheView() {
     
     UIView.animate(withDuration: 0.4, animations: {() -> Void in
     
     self.headerView.alpha = 0
     self.autoPromptView.isHidden=true
     self.search_Bar.showsCancelButton = false
     self.cancelWidth.constant = 0
     self.searchBanner.image = UIImage (named: "bannerSearch")
     self.searchBanner.backgroundColor = UIColor .white
     self.scrollTopView.constant = 0
     self.singleSelectionButton.alpha = 1
     self.multipleSelectionButton.alpha = 1
     self.txtLbl.alpha = 1
     self.singlecityLabel.alpha = 1
     self.multipleCityLabel.alpha = 1
     self.view.layoutIfNeeded()
     })
     
     
     
     
     }
     
     
     func showTheView() {
     
     UIView.animateWithDuration(0.6, animations: {() -> Void in
     
     self.headerView.alpha = 1
     self.search_Bar.showsCancelButton = false
     self.search_Bar.layer.borderWidth = 1.0
     self.search_Bar.layer.borderColor = UIColor .lightGray.CGColor
     self.cancelWidth.constant = 43
     self.singlecityLabel.alpha = 0
     self.multipleCityLabel.alpha = 0
     self.promptIndicator.isHidden=true
     self.autoPromptTable.contentInset = UIEdgeInsetsMake(0, 0, 10, 0)
     self.scrollTopView.constant = -105
     self.singleSelectionButton.alpha = 0
     self.multipleSelectionButton.alpha = 0
     self.txtLbl.alpha = 0
     
     self.heightofPromptTableview.constant = self.autoPromptTable.rowHeight * CGFloat(self.promptArray.count) //+ 50
     print(self.heightofPromptTableview.constant)
     self.view.layoutIfNeeded()
     })
     
     
     }
     
     */
    
    
    
    //MARK:
    //MARK:- Update the height of TableView Rows with increase of intrests
    
    func adjustHeightOftableView() -> Void
    {
        
        
        if arrayOfIntrest.count<1
        {
            
            
            self.navigationItem.leftBarButtonItem=nil
            
            //heightOfTrendingView.constant=self.view.frame.size.width * 0.66
            
            self.heightOfcontentView.constant = 1150 //self.heightOfTableView.constant + 355 + heightOfTrendingView.constant
            
            UserDefaults.standard.set(arrayOfIntrest, forKey: "arrayOfIntrest")
            
            
            searchedLocationsCollectionView .reloadData()
            
        }
        else
        {
            
            searchedLocationsCollectionView .reloadData()
            
            self.heightOfcontentView.constant=1150//self.heightOfTableView.constant + 355 + self.heightOfLocationTable.constant + heightOfTrendingView.constant
            
            print("heightOfcontentView   ________   \(heightOfcontentView.constant)")
            
            
            UserDefaults.standard.set(arrayOfIntrest, forKey: "arrayOfIntrest")
            
        }
        
        
        
        
        
        
    }
    
    
    
    //MANAGE the add button from the list of added locationsk
    
    func addMoreDestinations(sender: UIButton) {
        
        search_Bar.becomeFirstResponder()
        
        
    }
    
    
    
    
    
    //MARK:
    //MARK: Collection View Delegates And Datasource
    //MARK:
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int   {
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView,numberOfItemsInSection section: Int) -> Int
    {
        if collectionView == trendingPlacesCollectionView{
            return trendingArray.count
        }
        else{
            return 3
        }
        
    }
    
    
    
    
    func collectionView(collectionView: UICollectionView,cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        
        
        
        if collectionView == trendingPlacesCollectionView {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "trendingCell",for: indexPath as IndexPath) as! locationsCell
            
            
            var nameSt = ""// trendingArray.objectAtIndex(indexPath.row).valueForKey("fullName") as? String ?? " "
            
            
            let ArrToSeperate = nameSt .components(separatedBy: ",")
            if ArrToSeperate.count>0
            {
                nameSt=ArrToSeperate[0] as String
            }
            
            
            
            let pImage : UIImage = UIImage(named:"backgroundImage")! //placeholder image
            let imageLoc = "" //trendingArray.objectAtIndex(indexPath.row).valueForKey("imageLarge") as? String ?? ""
            
            let url = NSURL(string: imageLoc as String)
            
            
            
            cell.locationLabel.text=nameSt
            
            
            // cell.locationImage.sd_setImage(with: url, placeholderImage: pImage)
            
            
            cell.locationImage.contentMode = .scaleAspectFill
            cell.locationImage.layer.cornerRadius=3
            cell.locationImage.clipsToBounds=true
            
            
            
            
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
            cell.locationImage.clipsToBounds = true
            cell.userImageProfile.clipsToBounds = true
            cell.userImageProfile.image = UIImage (named: "profileDummy")
            cell.userImageProfile.backgroundColor = UIColor .yellow
            
            return cell
        }
        
        
        
        
        
    }
    
    
    
    
    
    // MARK: UICollectionViewDelegateFlowLayout
    //MARK:
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        
        if collectionView == trendingPlacesCollectionView{
            
            let width1 = collectionView.frame.size.width/1.16
            let height3: CGFloat = trendingPlacesCollectionView.frame.height - 20
            
            return CGSize(width: width1 , height: height3)
            
        }
        else
        {
            
            let width1 = collectionView.frame.size.width/2.2
            let height3: CGFloat = bloggersCollectionView.frame.size.height
            
            return CGSize(width: width1 , height: height3)
        }
        
        
        
        
        
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        // return UIEdgeInsetsMake(0,8,0,8);  // top, left, bottom, right
        return UIEdgeInsetsMake(0, 4, 0, 4)
        // top, left, bottom, right
    }
    
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
        if collectionView == trendingPlacesCollectionView{
            
            var locationSt = "" //trendingArray.objectAtIndex(indexPath.row).valueForKey("fullName") as? String ?? ""
            
            let ArrToSeperate = locationSt .components(separatedBy: ",")
            if ArrToSeperate.count>0 {
                locationSt=ArrToSeperate[0] as String
            }
            
            let fullName = ""//trendingArray.objectAtIndex(indexPath.row).valueForKey("fullName") as? String ?? ""
            
            
            
            let typelo = ""//trendingArray.objectAtIndex(indexPath.row).valueForKey("type") as? String ?? ""
            
            let locId = ""//trendingArray.objectAtIndex(indexPath.row).valueForKey("_id") as? String ?? ""
            
            
            if (arrayOfIntrest .value(forKey: "placeId") as AnyObject).contains(locId) {
                
                // CommonFunctionsClass.sharedInstance().alertViewOpen("Already selected", viewController: self)
                var indexTre = Int()
                
                indexTre = 0//(arrayOfIntrest.value(forKey: "placeId") as AnyObject).index(locId)
                print(indexTre)
                print(arrayOfIntrest)
                selectedindxSearch=indexTre
                
                self.nextPageAction(sender: self)
                
            }
                
            else
            {
                let imageLoc = ""// trendingArray.objectAtIndex(indexPath.row).valueForKey("imageLarge") as? String ?? ""
                
                if arrayOfIntrest.count<5 {
                    
                    
                    
                    var dic = NSMutableDictionary()
                    // dic = ["location":locationSt,"lat": "0.0", "long": "0.0", "type": "country", "country": locationSt, "delete":false]
                    
                    dic = ["location":locationSt, "type": typelo, "placeId":"\(locId)",  "delete":false, "fullName": fullName, "imgLink": imageLoc ]
                    print(dic)
                    
                    self.arrayOfIntrest .insert(dic, at: 0)
                    
                    print(self.arrayOfIntrest)
                    
                    
                    
                    
                    
                    
                    self.nextPageAction(sender: self)
                    //self .adjustHeightOftableView()
                }
                    //More than 5
                else
                {
                    
                    for i in 0..<trendingArray.count {
                        
                        let locId2 = ""//trendingArray.objectAtIndex(i).valueForKey("_id") as? String ?? ""
                        
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
                        
                        
                        
                        
                    }
                    
                    
                    
                    
                    
                    
                    
                    
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
    
    
    
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        
        print("Enter")
        
        
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        
        
        
        print("Search bar did begin editing method called")
        
        if  arrayOfIntrest.count == 5 {
            
            
            // search_Bar.resignFirstResponder()
            //autoPromptView.isHidden = true
            
            search_Bar.performSelector(onMainThread: #selector(self.resignFirstResponder), with: nil, waitUntilDone: false)
            
            
            
            // [searchBar performSelectorOnMainThread:@selector(resignFirstResponder) withObject:nil waitUntilDone:NO];
            
            CommonFunctionsClass.sharedInstance().showAlert(title: "Too many locations!", text: "You can search for up to 5 locations at once if you'd like to search and explore more, please delete one or moreof the previous locations you've searched.", imageName: "alertLimit")
            
            
            
            // IQKeyboardManager.sharedManager().enable=false
            
            
        }
        else
        {
            scrollMainView.contentOffset.y = 0
            
            locationAutoPrompt="Empty"
            
            promptArray .removeAllObjects()
            
            
            self.showPopular()
            
            self.autoPromptTable.contentInset = UIEdgeInsetsMake(0, 0, 10, 0)
            
            
            scrollMainView.isScrollEnabled=false//disable the scrollView
            if autoPromptView.isHidden==true
            {
                // self.showTheView()
                self.autoPromptView.isHidden=false
            }
            
            let SearchString: NSString = search_Bar.text! as NSString
            
            if SearchString.length >= 3 {
                
                // promptIndicator.isHidden=false
                // promptIndicator.startAnimating()
                
                let uId = defaults .string(forKey: "userLoginId")
                
                
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
    
    
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        //customDelegate.didChangeSearchText(searchText)
        
        print("While entering the characters this method gets called")
        self.checkTextField(searchBar: search_Bar)
        
        
    }
    
    
    
    
    @IBAction func cancelSearchAction(sender: AnyObject) {
        
        self.cancelSearchFunction()
        
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        self.cancelSearchFunction()
        
    }
    
    
    func cancelSearchFunction() {
        
        
        
        // UIView.animate(withDuration: 0.4, animations: {() -> Void in
        self.autoPromptView.isHidden=true
        self.search_Bar.showsCancelButton = false
        self.cancelWidth.constant = 0
        self.scrollTopView.constant = 0
        self.txtLbl.alpha = 1
        self.headerView.alpha = 0
        self.scrollMainView.isScrollEnabled=true
        self.view.layoutIfNeeded()
        //  })
        
        
        search_Bar .resignFirstResponder()
        search_Bar .showsCancelButton = false
        
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
                self.searchBanner.image = UIImage (named: "bannerSearch")
                self.searchBanner.backgroundColor = UIColor .white
                self.scrollTopView.constant = 0
                self.txtLbl.alpha = 1
                self.view.layoutIfNeeded()
                // })
                
                
                
                
            }
            
            
            
            
            
            if SearchString.length >= 3 {
                self.scrollMainView.isScrollEnabled=false
                promptIndicator.isHidden=false
                promptIndicator.startAnimating()
                
                let uId = defaults .string(forKey: "userLoginId")
                
                
                if task != nil {
                    
                    if task.state == URLSessionTask.State.running {
                        task.cancel()
                        print("\n\n Task 1 cancel\n\n")
                    }
                }
                
                let parameterString = NSString(string:"query=\(SearchString)&userId=\(uId!)") as String
                print(parameterString)
                
                
                
                self .postApiForAutoPromptLocations(searchString: parameterString)
                
                
            }
            
            
            
            
        }
        
        
        
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
                                    // print("prompt array\n \n \(self.promptArray)")
                                    
                                    self.autoPromptTable .reloadData()
                                    self.emptyView.isHidden=true
                                    
                                    
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
                                    
                                    
                                    
                                    self.emptyView.isHidden=false
                                    
                                    
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
    
    
    
    //MARK:- //////////Buttons Action Here//////
    //MARK:-
    
    
    
    //MARK:- Goto Story Screen
    
    @IBAction func storyButtonAction(sender: AnyObject) {
        
        //let nxtObj = self.storyboard?.instantiateViewControllerWithIdentifier("storyViewcontrollerViewController") as! storyViewcontrollerViewController
        
        DispatchQueue.main.async {
            //self.navigationController! .pushViewController(nxtObj, animated: true)
            // nxtObj.hidesBottomBarWhenPushed = true
        }
        
    }
    
    
    
    //MARK:- Goto Bucket List
    
    @IBAction func bucketListAction(sender: AnyObject) {
        
        // let nxtObj = self.storyboard?.instantiateViewControllerWithIdentifier("BucketListViewController") as! BucketListViewController
        
        
        // self.navigationController! .pushViewController(nxtObj, animated: true)
        
    }
    
    
    
    
    
    
    
    //// action of proceed button to move next third
    
    @IBAction func nextPageAction(sender: AnyObject)
    {
        if arrayOfIntrest.count<1
        {
            CommonFunctionsClass.sharedInstance().showAlert(title: "Opps!", text: "Please add minimum one location.", imageName: "alertFill")
            
            //CommonFunctionsClass.sharedInstance().alertViewOpen("Please add minimum one interest", viewController: self)
        }
        else
        {
            //hit api
            let uId = defaults .string(forKey: "userLoginId")
            
            
            
            let typeArr = NSMutableArray()
            
            
            for i in 0..<arrayOfIntrest.count {
                
                //    print((arrayOfIntrest.objectAtIndex(i) as AnyObject).valueForKey("location"))
                
                
                let locName = ""// arrayOfIntrest.objectAtIndex(i).valueForKey("fullName") as? String ?? ""
                
                let locType = ""//arrayOfIntrest.objectAtIndex(i).valueForKey("type") as? String ?? ""
                
                let locId = ""//arrayOfIntrest.objectAtIndex(i).valueForKey("placeId") as? String ?? ""
                
                
                typeArr .add(["type": locType, "placeId": locId, "fullName": locName])
                
            }
            
            
            // { userId: "userIdofuser", location: [{type: "city", placeId: "idofplace"}, {type: "state", placeId: "idofplace"}]}
            
            
            
            let dic: NSDictionary = ["userId":uId!,"location": typeArr ]
            
            
            print(dic)
            
            
            
            
            
            // dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), {
            
            apiClass.sharedInstance().postRequestSearchedLocations(parameterString: "userId=\(uId!)", totalLocations: dic , viewController: self)
            
            //})
            
            UserDefaults.standard.set(arrayOfIntrest, forKey: "arrayOfIntrest")
            
            // let nxtObj = self.storyboard?.instantiateViewControllerWithIdentifier("MainTabBarViewController") as! MainTabBarViewController
            
            
            
            
            
            //self.navigationController! .pushViewController(nxtObj, animated: true)
            // self.dismissViewControllerAnimated(true, completion: {})
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
        
        
        print(arrayOfIntrest.count)
        
        arrayOfIntrest .removeObject(at: sender.tag)
        
        
        self .adjustHeightOftableView()
        
    }
    
    
    
    
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        
        return 1
        
        
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        if tableView == autoPromptTable{
            return promptArray.count
        }
        else{
            return 3//trendingArray.count
        }
        
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        
        
        if tableView == autoPromptTable{
            
            
            let cellPrompt:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "promptCell")!
            
            
            
            let searchLabel = cellPrompt.viewWithTag(5555) as! UILabel
            
            if promptArray.count - 1 < indexPath.row {
                
            }
            else
            {
                
                searchLabel.text = ""//promptArray.objectAtIndex(indexPath.row).valueForKey("fullName") as? String ?? ""
            }
            
            return cellPrompt
            
        }
            
            
            
            
            
            
            
            
            
            
            //Bloggers location table
        else
        {
            let cell:searchTableCell = tableView.dequeueReusableCell(withIdentifier: "searchCell")! as! searchTableCell
            
            
            var profileUrl = NSString()
            
            if indexPath.row==0 {
                profileUrl = "https://scontent.xx.fbcdn.net/v/t1.0-1/c3.0.50.50/p50x50/11659245_858591540881778_3443521200972300309_n.jpg?oh=2684f2e2132c48d119e0c3cbf65bfe40&oe=58ED6DFB"
                //Nitin Sir
                
                cell.bloggerName.text="Nitin Trehan"
                cell.locationImage.image=UIImage (named: "img2")
                
                cell.blogsBtnLbl .setTitle("96 Blogs", for: UIControlState .normal)
                cell.likesBtnLbl .setTitle("176 Likes", for: UIControlState .normal)
                
            }
            else if indexPath.row==1{
                
                profileUrl = "https://scontent.xx.fbcdn.net/v/t1.0-1/p50x50/15349790_10154566396396609_4262469596483300295_n.jpg?oh=af3eec7939958de237acaee1ab7886fd&oe=58DBFF64"
                cell.bloggerName.text="Tanvi Trehan"
                cell.locationImage.image=UIImage (named: "img3")
                
                cell.blogsBtnLbl .setTitle("84 Blogs", for: UIControlState .normal)
                cell.likesBtnLbl .setTitle("463 Likes", for: UIControlState .normal)
                
            }
                
                
            else
            {
                
                profileUrl = "https://scontent.xx.fbcdn.net/v/t1.0-1/p50x50/15726441_10154581083519193_8947036995706174825_n.jpg?oh=de675214c09b0dc901deca70d3bd6276&oe=58F1ACC3"
                cell.bloggerName.text="Dimple Duggal"
                cell.locationImage.image=UIImage (named: "img4")
                
                cell.blogsBtnLbl .setTitle("62 Blogs", for: UIControlState .normal)
                cell.likesBtnLbl .setTitle("233 Likes", for: UIControlState .normal)
                //Tanvi mam
            }
            
            
            let url = NSURL(string: profileUrl as String)
            
            // cell.locationImage.sd_setImageWithURL(url)
            
            cell.profileImage.sd_setImage(with: url as URL!)
            
            
            
            //Layout and constraints
            
            cell.profileImage!.layer.cornerRadius=cell.profileImage.frame.size.width/2
            cell.profileImage!.clipsToBounds=true
            
            cell.profileBorder.layer.cornerRadius=cell.profileBorder.frame.size.width/2
            cell.profileBorder!.clipsToBounds=true
            
            
            
            cell.locationImage.contentMode = .scaleAspectFill
            cell.backView.layer.cornerRadius = 3.0
            cell.backView.layer.masksToBounds = true
            
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
            return cell
        }
        
        
        
        
    }
    
    func tableView(tableView: (UITableView!), commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: (NSIndexPath!)) {
        
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        //         if tableView==locationtableView {
        //            return true
        //        }
        if tableView == autoPromptTable{
            
            return false
        }
        else{
            return false
        }
        
    }
    
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") {action in
            
            
        }
        
        
        return [deleteAction]
    }
    
    
    
    func tableView(tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: NSIndexPath) {
        
        
        
        
    }
    
    
    
    
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        
        if tableView == autoPromptTable
        {
            
            
            
            let selectedString = ""//promptArray.objectAtIndex(indexPath.row).valueForKey("fullName") as? String ?? ""
            print(selectedString)
            
            locationAutoPrompt = selectedString as NSString
            
            
            
            
            
            let str = ""//promptArray.objectAtIndex(indexPath.row).valueForKey("type") as? String ?? ""
            
            locationId = ""//promptArray.objectAtIndex(indexPath.row).valueForKey("_id") as? String ?? ""
            
            
            
            locationType = str as NSString
            
            
            print(locationType)
            print(locationId)
            
            
            
            
            self.autoPromptView.isHidden=true
            self.search_Bar.showsCancelButton = false
            self.cancelWidth.constant = 0
            self.searchBanner.image = UIImage (named: "bannerSearch")
            self.searchBanner.backgroundColor = UIColor .white
            self.scrollTopView.constant = 0
            self.scrollFirstView.backgroundColor = UIColor.init(colorLiteralRed: 246/255, green: 246/255, blue: 246/255, alpha: 0.78)
            self.txtLbl.alpha = 1
            self.headerView.alpha = 0
            self.view.layoutIfNeeded()
            
            
            
            
            
            
            
            self.scrollMainView.isScrollEnabled=true
            promptArray.removeAllObjects()
            autoPromptTable .reloadData()
            
            
            
            
            
            
            
            
            
            
            
            /////////////  Automatic add locations ////////
            
            if (arrayOfIntrest .value(forKey: "placeId") as AnyObject).contains(locationId) {
                
                CommonFunctionsClass.sharedInstance().showAlert(title: "Opps!", text: "Please enter different name.", imageName: "alertFill")
                //CommonFunctionsClass.sharedInstance().alertViewOpen("Please Enter Different Name", viewController: self)
                self.messageFrame.removeFromSuperview()
                
                
            }
            else
            {
                
                var dict = NSMutableDictionary()
                //            dict = ["location":locationAutoPrompt,"lat": "0.0", "long": "0.0", "type": locationType, "country":"\(locationAutoPrompt)",  "delete":false ]
                
                let fullName = locationAutoPrompt
                let ArrToSeperate = locationAutoPrompt .components(separatedBy: ",")
                if ArrToSeperate.count>0 {
                    locationAutoPrompt=ArrToSeperate[0] as String as NSString
                }
                
                
                
                dict = ["location":locationAutoPrompt, "type": locationType, "placeId":"\(locationId)",  "delete":false, "fullName": fullName as String , "imgLink": "" ]
                
                
                
                
                if self.arrayOfIntrest.count<5{
                    DispatchQueue.global(qos: .background).async {
                        self .apiToGetTheLocationPhoto(parameters: fullName)
                    }
                    
                    self.arrayOfIntrest .insert(dict, at: 0)
                    selectedindxSearch=0
                    //self .nextPageAction(self)
                    
                    
                    
                }
                
                
                //hide if there are 5 locations in the array
                
                
                self.adjustHeightOftableView()
                
                search_Bar.text = nil
                
            }
            
            
            
            
            
        }
            
        else
        {
            
            
        }
        
        
        
        
    }
    
    
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        
        
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
                            
                            
                            defaults.set(true, forKey: "savedDeviceToken")
                            
                            
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





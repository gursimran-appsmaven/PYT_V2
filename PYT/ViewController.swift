//
//  ViewController.swift
//  PYT
//
//  Created by osx on 14/06/17.
//  Copyright © 2017 osx. All rights reserved.
//

import UIKit
import UIKit
import Crashlytics
import MBProgressHUD
import IQKeyboardManager

class ViewController: UIViewController, apiClassDelegate , UIScrollViewDelegate, UIWebViewDelegate {

    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
   
    @IBOutlet weak var fbBtn: UIButton!
    @IBOutlet weak var signInBtn: CustomButton!
    @IBOutlet weak var signInHeight: NSLayoutConstraint!
    
    var loginType = String()
    var accessToken = ""
    var myActivityIndicator = UIActivityIndicatorView()
    var frontVC = UIViewController()
    
    /////Instagram crediantials///
    
    let KAUTHURL = "https://api.instagram.com/oauth/authorize/"
    let kAPIURl = "https://api.instagram.com/v1/users/"
    let KCLIENTID = "af98fa34169649e081995ab149e14bda" //"a8565a67537e480ea2982f51ef8ee44f"
    let KCLIENTSERCRET = "b374c64eb1974df28958e47b481bb762" //"b73b046cac894fdc8ecf321d0de001d1"
    let kREDIRECTURI = "http://pictureyourtravel.com" //"http://www.appsmaventech.com"
    var fullURL = NSString()
    var tabledata = UserDefaults.standard.array(forKey: "arrayOfIntrest")
    var instagramWebView = UIWebView()
    var forgetBool = Bool()
    
    
    
    //tutorials
    let whiteView = UIView()
    let scrollView2 = UIScrollView() //(frame: CGRect(x:0, y:0, width:320,height: 300))
    var images = ["img1", "img2", "img3"]
    var frame: CGRect = CGRect(x:0, y:0, width:0, height:0)
    var pageControl = UIPageControl()
    var skipBtn = UIButton()
    var doneToturials = UIButton()
    
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        
        tabledata = UserDefaults.standard.array(forKey: "arrayOfIntrest")
        apiClass.sharedInstance().delegate=self //delegate of api class
        
       // NotificationCenter.defaultCenter.addObserver(self, selector: #selector(ViewController.moveInside(_:)),name:"MoveInside", object: nil)
        
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
      self.navigationController?.isNavigationBarHidden = true
    }
    

    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: if First time
        //MARK:
        
       
        Udefaults.set(true, forKey: "tutorialLaunch")
        
        
        let n: Int! = self.navigationController?.viewControllers.count //check the count of controllers for show the tutorials
        if n == 1 {
            Udefaults.set(false, forKey: "tutorialLaunch")
        }
        
        let firstLaunch = Udefaults.bool(forKey: "tutorialLaunch")
        whiteView.isHidden = true
        
        if firstLaunch == false
        {
            whiteView.isHidden = false
            
            whiteView.frame = CGRect(x:0, y:0, width:self.view.frame.size.width,height: self.view.frame.size.height)
            whiteView.backgroundColor = UIColor .white
            self.view.addSubview(whiteView)
            
            scrollView2.frame = CGRect(x:0, y:0, width:self.view.frame.width,height: self.view.frame.size.height-20)
            scrollView2.showsHorizontalScrollIndicator = false
            pageControl.frame = CGRect(x:self.view.frame.width/2 - 50,y: self.view.frame.height - 50, width:100, height:50)
            
            configurePageControl()
            
            scrollView2.delegate = self
            self.whiteView.addSubview(scrollView2)
            
            
            doneToturials.backgroundColor = UIColor.init(colorLiteralRed: 0/255, green: 44/255, blue: 63/255, alpha: 1)
            doneToturials.setTitle("Get Started", for: .normal)
            doneToturials.titleLabel?.font = UIFont(name:"Roboto-Medium", size: 14)
            doneToturials.setTitleColor(UIColor .white, for: .normal)
            
            
            
            for index in 0..<3
            {
                frame.origin.x = self.scrollView2.frame.size.width * CGFloat(index)
                frame.size = self.scrollView2.frame.size
                scrollView2.isPagingEnabled = true
                
                
                let imageView2 = UIImageView(frame: frame)
                imageView2.contentMode = .scaleAspectFit
                imageView2.image = UIImage(named: String(images[index]))
                
                let labeltxt = UILabel()
                labeltxt.backgroundColor = UIColor .clear
                
                let Y_Co = (self.view.frame.size.height/2 + 40)
                
               labeltxt.frame = CGRect(x: frame.origin.x + (frame.size.width/2 - (frame.size.width/2 - 25)), y: Y_Co, width: frame.size.width - 50, height: 180)
                labeltxt.textAlignment = .center
                labeltxt.font = UIFont(name:"Roboto-Regular", size: 12)
                labeltxt.numberOfLines = 0
                labeltxt.textColor = UIColor .darkGray
                labeltxt.alpha = 0.8
                if index == 0{
                    labeltxt.text = "Be a part of community where you can see, like, share, and comment on the travel pictures of your friends and family."
                }
                else if(index == 1)
                {
                    labeltxt.text = "Discover a place in depth with reviews and nearby places. Add them to your bucketlist to carry them in your pocket as part of your travel plan. Book flights, hotels, tours, and more from one place."
                }
                else{
                    labeltxt.text = "Upload and share your travel memories with your friends and family. Geo-tag your photos and become a travel guide."
                }
                
                self.scrollView2 .addSubview(imageView2)
                self.scrollView2 .addSubview(labeltxt)
                
                
                
                
                if index == 2
                {
                    
                    // imageView2 .addSubview(doneToturials)
                    self.scrollView2 .addSubview(doneToturials)
                    
                    doneToturials.frame = CGRect(x:imageView2.frame.width/2 - 125 + imageView2.frame.origin.x ,y: self.view.frame.height - 90, width:250, height:42)
                    print(doneToturials.frame)
                    
                    
                    
                }
                
                
                
                
            }
            
            self.scrollView2.contentSize = CGSize(width:self.scrollView2.frame.size.width * 3,height: self.scrollView2.frame.size.height)
            pageControl.addTarget(self, action: #selector(changePage(_sender:)), for: .valueChanged)
            
            pageControl.currentPageIndicatorTintColor = UIColor.init(colorLiteralRed: 104/255, green: 173/255, blue: 120/255, alpha: 1)
            pageControl.pageIndicatorTintColor = UIColor.init(colorLiteralRed: 104/255, green: 173/255, blue: 120/255, alpha: 0.6)
            self.whiteView .bringSubview(toFront: pageControl)
            
            skipBtn.frame = CGRect(x:self.view.frame.size.width - 150 ,y: self.view.frame.height - 80, width:150, height:30)
            skipBtn.setTitle("SKIP TIPS", for: .normal)
            skipBtn.titleLabel?.font = UIFont(name:"Roboto-Medium", size: 14)
            skipBtn.setTitleColor(UIColor.init(colorLiteralRed: 104/255, green: 173/255, blue: 120/255, alpha: 1), for: .normal)
            self.whiteView .addSubview(skipBtn)
            skipBtn .addTarget(self, action: #selector(self.skipBtnAction), for: .touchUpInside )
            
            doneToturials.layer.cornerRadius = doneToturials.frame.size.height/2
            doneToturials.layer.borderColor=UIColor (colorLiteralRed: 157.0/255.0, green: 194.0/255.0, blue: 134.0/255.0, alpha: 1).cgColor
            doneToturials.layer.borderWidth=1.2
            doneToturials .addTarget(self, action: #selector(self.skipBtnAction), for: .touchUpInside)
            doneToturials.clipsToBounds = true
            
        }
            
            
        else
        {
            IQKeyboardManager.shared().isEnableAutoToolbar=true
            apiClass.sharedInstance().delegate=self
            
            //check the access tokens for auto login into the app
            if let name = Udefaults.string(forKey: "userLoginId") // check fb access token
            {
                print(name)
                
                if name == ""  //if fbaccesstoken is empty check instagram token
                {
                    if let name2 = Udefaults.string(forKey: "instagramAccessToken")
                    {
                        self.accessToken = name2
                    }
                }
                else
                {
                    self.accessToken = name
                }
            }
            
        }
        
        
        emailTextField.text = "test@gmail.com"
        passwordTextField.text = "1234"
        
        
    }
    
    
    
    //MARK: 
    //MARK: Manage the tutorials
    
    
    
    func configurePageControl() {
        // The total number of pages that are available is based on how many available colors we have.
        self.pageControl.numberOfPages = images.count
        self.pageControl.currentPage = 0
        self.pageControl.tintColor = UIColor.red
        self.pageControl.pageIndicatorTintColor = UIColor.black
        self.pageControl.currentPageIndicatorTintColor = UIColor.green
        self.whiteView.addSubview(pageControl)
        
    }
    
    func changePage(_sender:Any) -> ()
    
    //func changePage(sender: AnyObject) -> ()
    {
        let x = CGFloat(pageControl.currentPage) * scrollView2.frame.size.width
        scrollView2.setContentOffset(CGPoint(x:x, y:0), animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
        if pageNumber == 2
        {
            skipBtn.isHidden = true
        }
        else
        {
            skipBtn.isHidden = false
        }
    }
    
    func skipBtnAction()
    {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {() -> Void in
            
            self.whiteView.frame = CGRect(x: -(self.whiteView.frame.size.width), y: 0, width: self.whiteView.bounds.width, height: self.whiteView.frame.size.height)
            
            /////////////////---------- Start function -------////////
            
            let tabledata = Udefaults.array(forKey: "arrayOfIntrest")
            if let name = Udefaults.string(forKey: "userLoginId") // check user login id
            {
                print(name)
                if name == ""  //if fbaccesstoken is empty check instagram token
                {
                    // self.viewDidLoad()
                }
                else
                {
                    SocketIOManager.sharedInstance.establishConnection()
                    
                    if (tabledata?.count)! < 1
                    {
                        let nxtObj = self.storyboard?.instantiateViewController(withIdentifier: "searchScreenViewController") as! searchScreenViewController
                        
                        self.navigationController?.pushViewController(nxtObj, animated: true)
                    }
                    else
                    {
                        let nxtObj = self.storyboard?.instantiateViewController(withIdentifier: "MainTabBarViewController") as! MainTabBarViewController
                        
                        self.navigationController?.pushViewController(nxtObj, animated: true)
                    }
                    
                }
            }
            
            ///////////////////-------------- End funct---------////////
            
            
        }, completion: {(finished: Bool) -> Void in
            self.whiteView.removeFromSuperview()
            
             Udefaults.set(true, forKey: "tutorialLaunch")//uncomment this
            
            // self.viewDidLoad() //uncomment this
        })
        
    }
    
    
    
    
    
    
    //MARK:- facebook Action to get the detail and accessToken
    //MARK:-
    
    
    /*
     function for get the access token from the facebook and get into the app
     also will be able to hit the graph api
     */
    
    @IBAction func facebookAction(_ sender: Any)
    {
        forgetBool = false
        loginType = ""
        
        let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = "Logging in"
        
        
        
        // apiClass.sharedInstance().postRequestCategories("", viewController: self)//hit the api to get the categories from the web
        
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        
        //-- set permissions to facebook----/////
        fbLoginManager.logIn(withReadPermissions: ["email","user_photos"," user_about_me", "public_profile", "user_location", "user_birthday", "user_tagged_places", "user_friends"], from: self) { (result, error) -> Void in
            
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                if(fbloginresult.isCancelled)
                {
                    
                    CommonFunctionsClass.sharedInstance().showAlert(title: "Anything wrong?", text: "You just cancelled the sign-in process.", imageName: "alertDelete")
                    
                    MBProgressHUD.hide(for: self.view, animated: true)
                }
                    
                else if(fbloginresult.grantedPermissions.contains("email"))
                {
                    let token =   FBSDKAccessToken.current().tokenString // access token
                    let token2 = FBSDKAccessToken.current().userID
                    print(token2!)
                    print(token!)
                    
                    self.accessToken = token! // set access token to global for use
                    print(self.accessToken)
                    
                Udefaults.set(self.accessToken, forKey: "faceBookAccessToken")
                    Udefaults.set("", forKey: "instagramAccessToken")
                    
                    self.getFBUserData(id: token2! as NSString, token: token! as NSString) // call  api for testing
                    
                    
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1 * NSEC_PER_SEC)) / Double(NSEC_PER_SEC), execute: {() -> Void in
                        
                        //self.graphApi()
                        fbLoginManager.logOut() // logout the facebook
                        MBProgressHUD.hide(for: self.view, animated: true)
                    })
                    
                }
            }
                
            else
            {
                print(error)
                MBProgressHUD.hide(for: self.view, animated: true)
            }
        }
        
      
    }
   
    
    
    
    ////////////--------- function to get the user data from facebook /or graph api  call the api -------------//////
    /// hit the api to backend for save the access token and get user data from facebook
    func getFBUserData(id:NSString,token:NSString)
    {
        
        let tokendevice = Udefaults.string(forKey: "deviceToken")!
        print(tokendevice)
        
        if((FBSDKAccessToken.current()) != nil)
        {
            
            Udefaults.set(true, forKey: "social")
            Udefaults.synchronize()
            
            if (self.accessToken == "")
            {
                
                //Unable to get the access token
                
            }
            else
            {
                let parameterDict: NSDictionary = ["fbId": id, "accessToken": token, "deviceToken": ["token": "", "device": "iphone"]]
                print(parameterDict)
                
                apiClass.sharedInstance().postRequestFacebook(parameterString: parameterDict, viewController: self)
                logOut = true
            }
        }
        
    }
    
        /////////////////////------------- Facebook login ends Here------------////////////////////
    
    
    
    
    
    
    
    
    
    
    
    ////////////////////////////////////////////////////////////////////////////////
    
    //MARK:- get data from instagram Login of user
    //MARK:-
    
    
    @IBAction func instaGramActionBtn(sender: AnyObject) {
        
        forgetBool = false
        
        loginType = ""
        
        
        
        fullURL = NSString .localizedStringWithFormat("%@?client_id=%@&redirect_uri=%@&response_type=token", KAUTHURL, KCLIENTID, kREDIRECTURI)
        print(fullURL)
        instagramWebView = UIWebView(frame: CGRect(x: 0, y: 20, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        instagramWebView.loadRequest(NSURLRequest(url: NSURL(string: fullURL as String)! as URL) as URLRequest)
        
        instagramWebView.delegate=self
        self.view.addSubview(instagramWebView) //open webview
        myActivityIndicator.startAnimating()
        
        myActivityIndicator.activityIndicatorViewStyle = .gray
        self.instagramWebView .addSubview(myActivityIndicator)
        
        
        let cancelBtn = UIButton()
        cancelBtn.frame = CGRect(x: 8, y: 8, width: 36, height: 36)
        cancelBtn.setImage(UIImage (named: "close"), for: .normal)
        cancelBtn.layer.cornerRadius=cancelBtn.frame.size.width/2
        cancelBtn.clipsToBounds=true
        self.instagramWebView .addSubview(cancelBtn)
        //cancelBtn.addTarget(self, action: #selector(ViewController.cancleInstagram(_:)), for: .touchUpInside)
        cancelBtn.backgroundColor=UIColor .black
        cancelBtn.titleLabel?.textColor=UIColor .white
        
        myActivityIndicator.frame = CGRect(x: self.instagramWebView.frame.width/2-15, y: cancelBtn.frame.origin.y, width: 30, height: 30)
    }
    
    
    /////---- Manage the webView
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        var urlString: String = request.url!.absoluteString
        
        print(urlString)
        var UrlParts = urlString .components(separatedBy: NSString .localizedStringWithFormat("%@/", kREDIRECTURI) as String)
        //urlString .componentsSeparatedByString(NSString .localizedStringWithFormat("%@/", kREDIRECTURI) as String )
        
        
        print(UrlParts[0])
        print(UrlParts)
        
        if UrlParts.count > 1 {
            
            urlString = UrlParts[1]
            
            let accessToken = NSRange()
            
            if accessToken.location != NSNotFound {
                let strAccessToken: String = "" //urlString.substringFromIndex(urlString.startIndex.advancedBy(NSMaxRange(accessToken)))
                // Save access token to user Udefaults for later use.
                
                // Add constant key #define KACCESS_TOKEN @”access_token” in constant class
                
                print(strAccessToken)
                
                var myStringArr = strAccessToken.components(separatedBy: "=") //.componentsSeparatedByString("=")
                let accessInsta: String = myStringArr [1]
                print(accessInsta)
                
                //////- separate access token and userId
                
                
                var instaUserId = NSString()
                
                
                
                let totalAraay = accessInsta.components(separatedBy: ".")
                if totalAraay.count>1 {
                    //print("UserId=\(totalAraay[0])")
                    instaUserId=totalAraay[0] as? String as NSString? ?? ""
                }
                print(accessInsta)
                
                instagramWebView .removeFromSuperview()
               
                
                // let parameterString = NSString(string:"user_login_instagram/\(instaUserId)/\(accessInsta)") as String
                
                // apiClass.sharedInstance().getRequest(parameterString, viewController: self) // call api with parameters
                
                
                
                ///////------ temp to make video
                
                let tokendevice = Udefaults.string(forKey: "deviceToken")!
                print(tokendevice)
                
                let parameterDict: NSDictionary = ["igId":instaUserId , "accessToken": accessInsta, "deviceToken": ["token": "", "device": "iphone"]]
                
                print(parameterDict)
                
                apiClass.sharedInstance().postRequestInstagram(parameterString: parameterDict, viewController: self)
                logOut=true
                
                
                
                ///Clear the instagram coookies for next time login
                
                URLCache.shared.removeAllCachedResponses()
                if let cookies = HTTPCookieStorage.shared.cookies {
                    for cookie in cookies {
                        HTTPCookieStorage.shared.deleteCookie(cookie)
                    }
                }
                
                
                
                
                
                
                
                ////temp to make video
                
                
                
                
            }
            return false
        }
        return true
    }
    
    
    func cancleInstagram(sender:UIButton) -> Void {
        
        self.instagramWebView .removeFromSuperview()
        
        CommonFunctionsClass.sharedInstance().showAlert(title: "What Happen?", text: "You just cancelled the sign-in process.", imageName: "alertDelete")
        myActivityIndicator.removeFromSuperview()
        
    }
    
    
    
    func webViewDidFinishLoad(webView: UIWebView){
        
        myActivityIndicator.stopAnimating()
        
    }// here hide it
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?){
        
        
    }// here hide it
    
    
    
    /////////////////--------- Instagram handel end --------///////////////
    
    

    
    
    
    
    
    
    //MARK:- Server Communication Delagte
    //MARK:-
    /*
     it will get the result of the api from server
     if access token is valid then go to next screen else show alert for login again
     
     */
    
    func serverResponseArrived(Response:AnyObject){
        
        ///// if not login from facebook or instagram
        
        if(loginType == "normal")
        {
            jsonResult = NSDictionary()
            jsonResult = Response as! NSDictionary
            let success = jsonResult.object(forKey: "status") as! NSNumber
            if success == 1
            {
                var userDetail = NSDictionary()
                userDetail = jsonResult.object(forKey: "data") as! NSDictionary
                print(userDetail)
                
                let uEmail = userDetail.value(forKey: "email") as? String ?? ""
                Udefaults.set(uEmail, forKey: "loginEmail")
                let uname = userDetail.value(forKey: "name") as? String ?? ""
                Udefaults.set(uname, forKey: "userLoginName")
                let uid = userDetail.value(forKey: "_id") as? String ?? ""
                Udefaults.set(uid, forKey: "userLoginId")
                let profilePic = userDetail.value(forKey: "picture") as? String ?? ""
                Udefaults.set(profilePic, forKey: "userProfilePic")
                Udefaults.synchronize()
                
                
                let runtimeLocations = userDetail.value(forKey: "runTimeLocation") as! NSMutableArray
                
                let arrRu = NSMutableArray()
                UserDefaults.standard.set(arrRu, forKey: "arrayOfIntrest")
                tabledata = UserDefaults.standard.array(forKey: "arrayOfIntrest")
                
                if runtimeLocations.count > 0
                {
                    let arrayOfLoc = NSMutableArray()
                    for i in 0..<runtimeLocations.count
                    {
                let fullName1 = (runtimeLocations[i] as! NSDictionary)  //(runtimeLocations.objectAtIndex(l) as AnyObject).value("fullName") as? String ?? ""
                      let fullName = fullName1["fullName"] as? String ?? ""
                        let placeId = fullName1["placeId"] as? String ?? ""
                        let placeType = fullName1["type"] as? String ?? ""
                        
                        var loc = ""
                        
                        let ArrToSeperate = fullName .components(separatedBy: ",")
                        if ArrToSeperate.count>0 {
                            loc=ArrToSeperate[0] as String
                        }
                        
                        
                        var dic = NSMutableDictionary()
//                        dic = ["location":loc, "type": runtimeLocations.objectAtIndex(l).valueForKey("type") as? String ?? "", "placeId": runtimeLocations.objectAtIndex(l).valueForKey("placeId") as? String ?? "",  "delete":false, "fullName": fullName ]

                         dic = ["location":loc, "type": placeType, "placeId": placeId,  "delete":false, "fullName": fullName ]
                        
                        
                         print(dic)
                        
                        arrayOfLoc .add(dic)
                        
                    }
                    
                    UserDefaults.standard.set(arrayOfLoc, forKey: "arrayOfIntrest")
                    tabledata = UserDefaults.standard.array(forKey: "arrayOfIntrest")
                    
                }
                
                
                
                
                let nxtObj3 = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                
                
               
                
                if (tabledata?.count)!<1 {
                    
                    let nxtObj = self.storyboard?.instantiateViewController(withIdentifier: "searchScreenViewController") as! searchScreenViewController
                    
                   // dispatch_after(DispatchTime.now(dispatch_time_t(DispatchTime.now()), Int64(1 * NSEC_PER_SEC)), DispatchQueue.main, {() -> Void in
                        
                        
                        self.navigationController! .pushViewController(nxtObj, animated: true)
                        self.dismiss(animated: true, completion: {})
                   // })
                    
                    
                    
                }
                else
                {
                    let nxtObj = self.storyboard?.instantiateViewController(withIdentifier: "searchScreenViewController") as! searchScreenViewController
                    
                    //let nxtObj = self.storyboard?.instantiateViewControllerWithIdentifier("MainTabBarViewController") as? MainTabBarViewController
                     self.navigationController! .pushViewController(nxtObj, animated: true)
                     self.dismiss(animated: true, completion: {})
                    
                    DispatchQueue.global(qos: .background).async {
                       
                       
                    }
                    
                }
                
                
                
                //dispatch_get_global_queue(Int(QOS_CLASS_BACKGROUND.rawValue), 0).asynchronously(execute: {
                  DispatchQueue.global(qos: .background).async {
                    
                    let uId2 = Udefaults .string(forKey: "userLoginId")
                    let objt = storyCountClass()
                    let dic:NSDictionary = ["userId": uId2!]
                    objt.postRequestForcountStory(parameterString: dic)
                    //objt.postRequestForcountStory("userId=\(uId2!)")
                    
                    
                    //            dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), {
                    //                let objt2 = UserProfileDetailClass()
                    //                objt2.postRequestForGetTheUserProfileData("userId=\(uId2!)")
                    //            })
                    
                }
                
                
                
                // Socket
                SocketIOManager.sharedInstance.establishConnection()
                
                
                
                
            }
                
                
            else
            {
                //print(jsonResult)
                
                CommonFunctionsClass.sharedInstance().showAlert(title: "Incorrect Info", text: "The username or password do not match", imageName: "alertWrong")
                
                
            }
            
            
            MBProgressHUD.hide(for: self.view, animated: true)
            return
            
            
            
            
        }
            
            
        else
        {
            print("value of logout = \(logOut)")
            if logOut == true {
                
                ////////if login from facebook or instagram
                
                
                jsonResult = NSDictionary()
                jsonResult = Response as! NSDictionary
                let success = jsonResult.object(forKey: "status") as! NSNumber
                
                if success == 1
                {
                    print(jsonResult)
                    
                    let pytUserId = jsonResult.value(forKey: "userId") as? String ?? ""
                    print(pytUserId)
                    let pytUserName = jsonResult.value(forKey: "name") as? String ?? ""
                    let pytUserProfilePic = jsonResult.value(forKey: "profilePic") as? String ?? ""
                    Udefaults.set(pytUserId, forKey: "userLoginId")
                    Udefaults.set(pytUserName, forKey: "userLoginName")
                    Udefaults.set(pytUserProfilePic, forKey: "userProfilePic")
                    
                    
                    
                    
                    
                    let runtimeLocations = jsonResult.value(forKey: "runtimeLocation") as! NSMutableArray
                    
                    if runtimeLocations.count > 0 {
                        
                        let arrayOfLoc = NSMutableArray()
                        for l in 0..<runtimeLocations.count {
                            
                            
                            
                            
                            let fullName1 = runtimeLocations.object(at: l) as? NSDictionary
                            
                            let fullName = fullName1?["fullName"] as? String ?? ""
                            let placeId = fullName1?["placeId"] as? String ?? ""
                            let placeType = fullName1?["type"] as? String ?? ""
                            
                            
                            
                            
                            var loc = ""
                            
                            let ArrToSeperate = fullName .components(separatedBy: ",")
                            if ArrToSeperate.count>0 {
                                loc=ArrToSeperate[0] as String
                            }
                            
                            
                            
                            var dic = NSMutableDictionary()
                            dic = ["location":loc, "type": placeType, "placeId": placeId,  "delete":false, "fullName": fullName ]
                            print(dic)
                            
                            arrayOfLoc .add(dic)
                            
                            
                            
                        }
                        
                        UserDefaults.standard.set(arrayOfLoc, forKey: "arrayOfIntrest")
                        tabledata = UserDefaults.standard.array(forKey: "arrayOfIntrest")
                        
                    }
                    
                    
                    DispatchQueue.main.async {
                                    
                                    self .moveinsideApp()
                    }
                    
                                     // Socket
                    SocketIOManager.sharedInstance.establishConnection()
                    
                    
                    
                }
                    
                else
                {
            
                    Udefaults.set("", forKey: "userLoginId")
                    
                    CommonFunctionsClass.sharedInstance().showAlert(title: "Session Expire", text: "Your session is expired, Please login again", imageName: "alertDelete")
                    
                    
                    
                }
                
            }
            else
            {
                logOut = true
            }
            
        }
        
        
        
    }
    
    
    
    
    
    
    
    
    
    func moveInside(notification: NSNotification) {
        
        tabledata = UserDefaults.standard.array(forKey: "arrayOfIntrest")
        // self .moveinsideApp()
        
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    ///////////////////////////////////////////////////////////////////////////////////
    
    //MARK:- Login to app SIGNIN
    //MARK:-
    
    //MARK: Sign in Button action
    
   
    @IBAction func loginButtonAction(_ sender: Any)
    {
        forgetBool = false
        self.loginInDatabase()
    }
    
    
    func loginInDatabase() -> Void {
        
        
        
        
        if emailTextField.text == ""
        {
            CommonFunctionsClass.sharedInstance().showAlert(title: "Opps!", text: "Please enter a valid email address.", imageName: "alertWrong")
            
            
        }
        else
        {
            if isValidEmail(candidate: emailTextField.text!)
            {
                emailTextField.textColor=UIColor .black
                
                if passwordTextField.text=="" {
                    
                    CommonFunctionsClass.sharedInstance().showAlert(title: "Opps!", text: "The password you have entered is not correct. Please try again.", imageName: "alertWrong")
                    
                    
                    
                }
                else
                {
                    
                    
                    
                    let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
                    loadingNotification.mode = MBProgressHUDMode.indeterminate
                    loadingNotification.label.text = "Logging in"
                    
                    loginType = "normal"
                    
                    self .loginApi(email: emailTextField.text! as String as NSString, password: passwordTextField.text! as String as NSString)
                    
                }
                
                
                
            }
            else
            {
                
                CommonFunctionsClass.sharedInstance().showAlert(title: "Invalid Info", text: "The email id you have entered is not correct. Please try again.", imageName: "alertWrong")
            }
            
        }
        
        self.emailTextField .resignFirstResponder()
        self.passwordTextField.resignFirstResponder()
        
        
    }
    
    
    //MARK:- Valid Email or not
    func isValidEmail(candidate: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: candidate)
    }
    
    
    func loginApi(email:NSString, password:NSString) -> Void
    {
      
        let token = Udefaults.string(forKey: "deviceToken")!
        print(token)
        
        
        
        let parameterString: NSDictionary = ["email":emailTextField.text!, "password": passwordTextField.text!, "deviceToken":["token": "", "device": "iphone"]]
        
        // let parameterString = NSString(string:"email=\(emailTextField.text!)&password=\(passwordTextField.text!)&deviceToken=\(token)&device=iphone") as String
        print(parameterString)
        
        
        
        
        apiClass.sharedInstance().postRequestForLogin(parameterString: parameterString, viewController: self)
        
        Udefaults.set(false, forKey: "social")
        Udefaults.synchronize()
        //apiClass.sharedInstance().postRequestSearch(parameterString, viewController: self)// call api
        
        
    }
    
    //Don't have account signup button action
    @IBAction func newSignupButtonAction(_ sender: Any) {
        // if not select any location show search screen
        
        let nxtObj = self.storyboard?.instantiateViewController(withIdentifier: "SignUpScreenViewController") as! SignUpScreenViewController
        self.navigationController! .pushViewController(nxtObj, animated: true)
    }
    
    
    
    //MARK:
    //MARK: Forget password
    
    @IBAction func forgetPasswordAction(_ sender: Any)
    {
        let nxtObj = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordViewController") as! ForgotPasswordViewController
        
        self.navigationController! .pushViewController(nxtObj, animated: true)
    }
    
  
    /*
     forgetBool = true
     loginType = "normal"
     
     alertController = UIAlertController(title: "Forgot Password", message: "Please enter your email id to proceed", preferredStyle: .Alert)
     
     let backView = alertController.view.subviews.last?.subviews.last
     backView?.layer.cornerRadius = 10.0
     backView?.backgroundColor = UIColor.whiteColor()
     
     
     
     
     let confirmAction = UIAlertAction(title: "Confirm", style: .Default) { (_) in
     
     //confirmAction.setValue(UIColor.orangeColor(), forKey: "titleTextColor")
     
     MBProgressHUD.showHUDAddedTo(self.view, animated: true)
     
     if let field = self.alertController.textFields![0] as? UITextField {
     // store your data
     
     
     
     if self.isValidEmail(field.text!)
     {
     
     let prm: NSDictionary = ["email": field.text!]
     
     apiClass.sharedInstance().postRequestForForgotPassword(prm, viewController: self)
     
     
     }
     else
     {
     CommonFunctionsClass.sharedInstance().showAlert("Invalid Info", text: "The email id you have entered is not correct. Please try again.", imageName: "alertWrong")
     
     MBProgressHUD.hideHUDForView(self.view, animated: true)
     self.presentViewController(self.alertController, animated: true, completion: nil)
     }
     
     
     
     
     
     
     } else {
     // user did not fill field
     }
     }
     
     let cancelAction = UIAlertAction(title: "Cancel", style: .Default) { (_) in }
     
     alertController.addTextFieldWithConfigurationHandler { (textField) in
     textField.placeholder = "Enter Your Email"
     }
     
     
     
     
     confirmAction.setValue(UIColor (colorLiteralRed: 0/255, green: 42/255, blue: 60/255, alpha: 1.0), forKey: "titleTextColor")
     //  confirmAction.setValue(UIFont(name: "Roboto-Medium", size:16), forKey: "titleTextFont")
     
     cancelAction.setValue(UIColor .redColor(), forKey: "titleTextColor")
     
     
     
     alertController.addAction(confirmAction)
     alertController.addAction(cancelAction)
     
     
     self.presentViewController(alertController, animated: true, completion: nil)
     
     }
     
     
     */
    
    
    
    
    
    
    
    
    /////////////////////////////////////////////////////////////
    
    //MARK:- Function to move to next Screen After Login from facebook/ instagram/ signin/ or go througn app
    //MARK:-
    
    func moveinsideApp() -> Void
    {
        let uId = Udefaults .string(forKey: "userLoginId")
        
        
      
        let nxtObj = self.storyboard?.instantiateViewController(withIdentifier: "searchScreenViewController") as! searchScreenViewController
        
        self.navigationController! .pushViewController(nxtObj, animated: true)
        self.dismiss(animated: true, completion: {})
        
        
        
        DispatchQueue.global(qos: .background).async {
       
            
            let objt = storyCountClass()
            let dic:NSDictionary = ["userId": uId!]
            objt.postRequestForcountStory(parameterString: dic)
            
            DispatchQueue.global(qos: .background).async {
           // dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), {
                //let objt2 = UserProfileDetailClass()
               // objt2.postRequestForGetTheUserProfileData(uId!)
                
                
            }
            
            
            
        }
        
        
        
        
        
    }
    

    
    
    
    
    
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


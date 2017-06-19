//
//  signupProfilePictureViewController.swift
//  PYT
//
//  Created by osx on 16/06/17.
//  Copyright © 2017 osx. All rights reserved.
//

import UIKit
import IQKeyboardManager
import MBProgressHUD

class signupProfilePictureViewController: UIViewController, apiClassDelegate {

    @IBOutlet var nameTf: UITextField!
    var loginFromFb = Bool()
    var email = NSString()
    var password = NSString()

    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        print("email:\(email), Password:\(password)")
        IQKeyboardManager.shared().shouldResignOnTouchOutside=true
        IQKeyboardManager.shared().isEnableAutoToolbar=true
        
         apiClass.sharedInstance().delegate=self //delegate of api class
        
        // Do any additional setup after loading the view.
    }

    
    
    
    func startRegisterUser() {
        
        
        nameTf.resignFirstResponder()
        
        
        
    }
    
    
    
    
    
    
    
    
    
    //MARK:- facebook Action to get the detail and accessToken
    //MARK:-
    
    
    /*
     function for get the access token from the facebook and get into the app
     also will be able to hit the graph api
     */
    
    @IBAction func facebookAction(_ sender: Any) {
   
       loginFromFb = true
        
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
                    
                    let accessToken = token! // set access token to global for use
                    
                    
                    let defaults = UserDefaults.standard
                    defaults.set(accessToken, forKey: "faceBookAccessToken")
                    defaults.set("", forKey: "instagramAccessToken")
                    
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
        
        let tokendevice = defaults.string(forKey: "deviceToken")!
        print(tokendevice)
        
        if((FBSDKAccessToken.current()) != nil)
        {
            
            defaults.set(true, forKey: "social")
            defaults.synchronize()
            
        
                let parameterDict: NSDictionary = ["fbId": id, "accessToken": token, "deviceToken": ["token": "", "device": "iphone"]]
                print(parameterDict)
                
                apiClass.sharedInstance().postRequestFacebook(parameterString: parameterDict, viewController: self)
                logOut = true
    
        }
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    //MARK:- Server response arrived here
    //MARK:-
    func serverResponseArrived(Response:AnyObject){
        
        if loginFromFb == true {
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
                defaults.set(pytUserId, forKey: "userLoginId")
                defaults.set(pytUserName, forKey: "userLoginName")
                defaults.set(pytUserProfilePic, forKey: "userProfilePic")
                
                
                
                
                
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
                    
                    
                }
                
                
                // DispatchQueue.main.async {
                
                self .moveinsideApp()
                //}
                
                // Socket
                //  SocketIOManager.sharedInstance.establishConnection()
                
                
                
            }
                
            else
            {
                
                defaults.set("", forKey: "userLoginId")
                
                CommonFunctionsClass.sharedInstance().showAlert(title: "Session Expire", text: "Your session is expired, Please login again", imageName: "alertDelete")
                
                
                
            }
            
            

        }
        else{
            
        
        jsonResult = NSDictionary()
        jsonResult = Response as! NSDictionary
        
        
        
        let success = jsonResult.object(forKey: "status") as! NSNumber
        
        if success == 1
        {
            
          
            let uname = nameTf.text!
            defaults.set(uname, forKey: "userLoginName")
            
            
            defaults.set("", forKey: "userProfilePic")
            
            
            
            //save The credentail and login to the app
            
            let pytUserId = ""//(jsonResult.value(forKey: "data")! as AnyObject) .value("userId") as? String ?? ""
            
            
            
            defaults.set(pytUserId, forKey: "userLoginId")
            defaults.set(false, forKey: "social")
            
            let nxtObj3 = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            
            if (nxtObj3.tabledata?.count)!<1 {
                
                
                
                let nxtObj = self.storyboard?.instantiateViewController(withIdentifier: "searchScreenViewController") as! searchScreenViewController
                
                 self.navigationController! .pushViewController(nxtObj, animated: true)
                
                self.dismiss(animated: true, completion: {})
               
                
                
                
            }
            else
            {
                //let nxtObj = self.storyboard?.instantiateViewControllerWithIdentifier("MainTabBarViewController") as? MainTabBarViewController
                
                DispatchQueue.main.async {
                    // self.navigationController! .pushViewController(nxtObj!, animated: true)
                    //self.dismiss(animated: true, completion: {})
                }
                
            }
            
            
            DispatchQueue.global(qos: .background).async {
                
                ////for get the count of stories added by user
                
                let uId = defaults .string(forKey: "userLoginId")
                let objt = storyCountClass()
                //objt.postRequestForcountStory("userId=\(uId!)")
                let dic:NSDictionary = ["userId": uId!]
                objt.postRequestForcountStory(parameterString: dic)
                
                
                
                
                ///For get the user's all data
                
                DispatchQueue.global(qos: .background).async {
                    //let objt2 = UserProfileDetailClass()
                    // objt2.postRequestForGetTheUserProfileData(uId!)
                }
                
                
            }
            
            
            
            
            
            // Socket
            // SocketIOManager.sharedInstance.establishConnection()
            
            
            
            
            
        }
        else{
            
            print(jsonResult)
            
            
            CommonFunctionsClass.sharedInstance().showAlert(title: "User already exists!", text: "Email id already registered.", imageName: "alertWrong")
            
            
            
        }
        
        
        
        MBProgressHUD.hide(for: self.view, animated: true)
        
        
        
        }
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func moveinsideApp() -> Void
    {
        let uId = defaults .string(forKey: "userLoginId")
        
        
        
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

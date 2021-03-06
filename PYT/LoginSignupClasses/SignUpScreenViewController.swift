//
//  SignUpScreenViewController.swift
//  PYT
//
//  Created by Niteesh on 25/10/16.
//  Copyright © 2016 appsMaven. All rights reserved.
//

import UIKit
import IQKeyboardManager
import MBProgressHUD

class SignUpScreenViewController: UIViewController, apiClassDelegate {

    //Outlets of textFields
    
    
    @IBOutlet var emailTf: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        IQKeyboardManager.shared().shouldResignOnTouchOutside=true
        IQKeyboardManager.shared().isEnableAutoToolbar=true
    apiClass.sharedInstance().delegate = self
        self.tabBarController?.tabBar.isHidden = true
        //self.tabBarController?.setTabBarVisible(visible: false, animated: true)

    }
    
    

    override func viewDidAppear(_ animated: Bool) {
   
        //apiClass.sharedInstance().delegate=self //delegate of api class

        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.view .setNeedsLayout()
        self.view.layoutIfNeeded()
        
    }
    
    override func viewWillLayoutSubviews() {
        

    }
    
    
    
    
    //MARK:- TextField Delegates
    //MARK:-
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
         if textField == emailTf
        {
            textField .addTarget(self, action: #selector(SignUpScreenViewController.emailTextField(textField:)), for: .editingChanged)
            
           
        }
        
        
        return true
        
    }
   
    func emailTextField(textField: UITextField)
    {
    
        if isValidEmail(candidate: emailTf.text!)
        {
            
            emailTf.textColor=UIColor .black
            
        }
        else
        {
            
            emailTf.textColor=UIColor .red
            
        }
        
        
    }
    

    
    
    
    
    
    
    ////////////////////////////////////////////////////////////////////////////////////
    
    //MARK:- Sign UP  Button Actions
    //MARK:-
    
    @IBAction func NextButtonAction(_ sender: Any) {
    

        // check all txtFields are not empty
        
        
        if emailTf.text == ""
        {
            
            CommonFunctionsClass.sharedInstance().showAlert(title: "Fill required fields", text: "Please fill required fields to continue.", imageName: "oopsAlert")

        }
            
        else
        {
            
            
            if let email:Bool = self.checkIngTextField(txtF: emailTf) {
                if email == false {
                    // self.emailTf.becomeFirstResponder()
                    CommonFunctionsClass.sharedInstance().showAlert(title: "Incorrect Info", text: "The email id you have entered is not correct. \n Please try again.", imageName: "exclamationAlert")
                }
                else
                {
                     emailTf.resignFirstResponder()
                    
                    let nxtObj = self.storyboard?.instantiateViewController(withIdentifier: "signupSetPasswordViewController") as? signupSetPasswordViewController
                    
                    nxtObj?.userEmail = emailTf.text! as NSString
                    
                    
                    self.navigationController! .pushViewController(nxtObj!, animated: true)
                        //self.dismiss(animated: true, completion: {})
                    

                }
            }
            
            
            
            
            
            
        }
        
        
        
               
        
    }
    
    
    
    
    
    
    
    
    
    //MARK:- Function to check the textFields
    
    func checkIngTextField(txtF:UITextField) -> Bool! {
        let emtf = txtF
        
        
        if txtF.text=="" || txtF.text == " " || txtF.text == "\n" {
            return false
        }
            
        else{
            if emtf == emailTf {
                
                if isValidEmail(candidate: emailTf.text!)
                {
                    
                    return true
                }
                else
                {
                    
                    return false
                    
                }
                
            }
            else{
                return true
            }
            
        }
        
    }
    
    
    
    //MARK:- Valid Email or not
    func isValidEmail(candidate: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: candidate)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    ////////////////////////////////////////////////////////////////////////////////////
    
    //MARK:- SignIn Button to Login Back
    //MARK:-
    //Login Button to move back if alredy Signed Up
    
    @IBAction func SignInBtnAction(_ sender: Any) {
  
        
            self.navigationController?.popViewController(animated: true)

    }
    

    
    //MARK:- facebook Action to get the detail and accessToken
    //MARK:-
    
    
    /*
     function for get the access token from the facebook and get into the app
     also will be able to hit the graph api
     */
    
    @IBAction func facebookAction(_ sender: Any) {
   
       
        
        let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = "Logging in"
        
        
        
        // apiClass.sharedInstance().postRequestCategories("", viewController: self)//hit the api to get the categories from the web
        
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        
        //-- set permissions to facebook----/////
        fbLoginManager.logIn(withReadPermissions: ["email","user_photos"," user_about_me", "public_profile", "user_location", "user_birthday", "user_tagged_places", "user_friends", "user_videos"], from: self) { (result, error) -> Void in
            
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                if(fbloginresult.isCancelled)
                {
                    
                   CommonFunctionsClass.sharedInstance().showAlert(title: "Anything wrong?", text: "You just cancelled the sign-in process.", imageName: "exclamationAlert")
                    
                    MBProgressHUD.hide(for: self.view, animated: true)
                }
                    
                else if(fbloginresult.grantedPermissions.contains("email"))
                {
                    let token =   FBSDKAccessToken.current().tokenString // access token
                    let token2 = FBSDKAccessToken.current().userID
                    print(token2!)
                    print(token!)
                    
                    let accessToken = token! // set access token to global for use
                    
                    
                   
                    Udefaults.set(accessToken, forKey: "faceBookAccessToken")
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
            
            
            let parameterDict: NSDictionary = ["fbId": id, "accessToken": token, "deviceToken": ["token": "", "device": "iphone"]]
            print(parameterDict)
            
            apiClass.sharedInstance().postRequestFacebook(parameterString: parameterDict, viewController: self)
            logOut = true
            
        }
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    //MARK:- Server response arrived here
    //MARK:-
    func serverResponseArrived(Response:AnyObject){
        
     Udefaults.set(false, forKey: "savedDeviceToken")
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
                let arrayOfLoc = NSMutableArray()
                UserDefaults.standard.set(arrayOfLoc, forKey: "arrayOfIntrest")
                if runtimeLocations.count > 0
                {
                        for l in 0..<runtimeLocations.count {
                        
                        
                        let fullName1 = runtimeLocations.object(at: l) as? NSDictionary
                        
                        let fullName = fullName1?["fullName"] as? String ?? ""
                        let placeId = fullName1?["placeId"] as? String ?? ""
                        let placeType = fullName1?["type"] as? String ?? ""
                        let placeImage = fullName1?["imageUrl"] as? String ?? ""

                        
                        
                        
                        var loc = ""
                        
                        let ArrToSeperate = fullName .components(separatedBy: ",")
                        if ArrToSeperate.count>0 {
                            loc=ArrToSeperate[0] as String
                        }
                        
                        
                        
                        var dic = NSMutableDictionary()
                        dic = ["location":loc, "type": placeType, "placeId": placeId,  "delete":false, "fullName": fullName, "imageUrl": placeImage ]
                        print(dic)
                        
                        arrayOfLoc .add(dic)
                        
                        
                        
                    }
                    
                    UserDefaults.standard.set(arrayOfLoc, forKey: "arrayOfIntrest")
                    
                    
                }
                
                
                // DispatchQueue.main.async {
                
                self .moveinsideApp()
                //}
                
                // Socket
                  SocketIOManager.sharedInstance.establishConnection()
                
                
                
            }
                
            else
            {
                
                Udefaults.set("", forKey: "userLoginId")
                
                CommonFunctionsClass.sharedInstance().showAlert(title: "Session Expire", text: "Your session is expired, Please login again", imageName: "exclamationAlert")
                
                
                
            }
            
            
            
        
    
    
    }
    
    
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

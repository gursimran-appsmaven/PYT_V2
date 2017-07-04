//
//  signupSetPasswordViewController.swift
//  PYT
//
//  Created by osx on 16/06/17.
//  Copyright © 2017 osx. All rights reserved.
//

import UIKit
import IQKeyboardManager
import MBProgressHUD
class signupSetPasswordViewController: UIViewController, apiClassDelegate
{

    @IBOutlet var passwordTf: UITextField!
    @IBOutlet var confirmPasswordTf: UITextField!

    
    var userEmail = NSString()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        IQKeyboardManager.shared().shouldResignOnTouchOutside=true
        IQKeyboardManager.shared().isEnableAutoToolbar=true
        apiClass.sharedInstance().delegate = self
        
//&& passwordTf.text == "" && confirmPasswordTf.text == ""
        // Do any additional setup after loading the view.
    }

    
    
    
    
    
    
    //MARK:- TextField Delegates
    //MARK:-
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        if textField==confirmPasswordTf
        {
            textField .addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
            
            
        }
            
       
        
        
        return true
        
    }

    
    
    
    func textFieldDidChange(textField: UITextField) {
        
        if passwordTf.text! .range(of: confirmPasswordTf.text!) != nil {
            print("exists")
        }
        else{
            if confirmPasswordTf.text == "" {
            }
            else{
                
                
            }
            
        }
        
    }
    
    
    
    func checkIngTextField(txtF:UITextField) -> Bool {
        let emtf = txtF
        
        
        if txtF.text=="" || txtF.text == " " || txtF.text == "\n" {
          
            return false
        }
            
        else{
     return true
        }
    }
    
    
    
    

    @IBAction func netBtnAction(_ sender: Any)
    {

        if (passwordTf.text?.characters.count)!<1 && (confirmPasswordTf.text?.characters.count)!<1
        {
        CommonFunctionsClass.sharedInstance().showAlert(title: "Oops!", text: "Please fill both fields.", imageName: "alertFill")
            
        }
        else
        {
            
            if let pass:Bool = self.checkIngTextField(txtF: passwordTf!)
            {
                if pass == false
                {
                    //self.passwordTf.becomeFirstResponder()
                    CommonFunctionsClass.sharedInstance().showAlert(title: "Oops!", text: "Please fill password.", imageName: "alertFill")
                }
                else
                {
                    if let cPass:Bool = self.checkIngTextField(txtF: confirmPasswordTf!)
                    {
                        if cPass == false
                        {
                            //self.confirmPasswordTf.becomeFirstResponder()
                            
                            CommonFunctionsClass.sharedInstance().showAlert(title: "Oops!", text: "The passwords you entered do not match.", imageName: "alertFill")
                        }
                        else
                        {
                            if confirmPasswordTf.text==passwordTf.text {
                                
                                print("Go to nxt screen")
                                passwordTf.resignFirstResponder()
                                confirmPasswordTf.resignFirstResponder()
                                
                                
                                
                                
                                
                                let nxtObj = self.storyboard?.instantiateViewController(withIdentifier: "signupProfilePictureViewController") as? signupProfilePictureViewController
                                
                                nxtObj?.email = userEmail
                                nxtObj?.password = passwordTf.text! as NSString
                                
                                
                                self.navigationController! .pushViewController(nxtObj!, animated: true)
                                self.dismiss(animated: true, completion: {})
                                
                                
                                
                                
                                
                            }
                            else
                            {
                                // self.confirmPasswordTf.becomeFirstResponder()
                                
                                CommonFunctionsClass.sharedInstance().showAlert(title: "Oops!", text: "Please fill same password", imageName: "alertFill")
                                
                            }
                        }
                    }
                    
                }
            }
        }
        
        
            
            
            /*
             
             
             let token = Udefaults.string(forKey: "deviceToken")!
             print(token)
             
             
             
             let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
             loadingNotification.mode = MBProgressHUDMode.indeterminate
             loadingNotification.label.text = "Signing Up..."
             
             let parameterString: NSDictionary = ["name":nameTf.text!, "email": emailTf.text!, "password": passwordTf.text!, "deviceToken":["token": "", "device": "iphone"]]
             
             //NSString(string:"username=\(nameTf.text!)&email=\(emailTf.text!)&password=\(passwordTf.text!)&deviceToken=\(token)&device=iphone") as String
             print(parameterString)
             
             
             nameTf.resignFirstResponder()
             
             
             apiClass.sharedInstance().postRequestSearch(parameterString: parameterString, viewController: self)// call api
             
             
             */
            
            
            
            
        }
    
    
    
    
    
    
    //MARK:- facebook Action to get the detail and accessToken
    //MARK:-
    
    
    /*
     function for get the access token from the facebook and get into the app
     also will be able to hit the graph api
     */
    
    @IBAction func facebookAction(_ sender: Any)
    {
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
            if runtimeLocations.count > 0 {
                
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
              SocketIOManager.sharedInstance.establishConnection()
            
            
            
        }
            
        else
        {
            
            Udefaults.set("", forKey: "userLoginId")
            
            CommonFunctionsClass.sharedInstance().showAlert(title: "Session Expire", text: "Your session is expired, Please login again", imageName: "alertDelete")
            
            
            
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

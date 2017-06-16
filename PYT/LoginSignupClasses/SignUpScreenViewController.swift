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

class SignUpScreenViewController: UIViewController {

    //Outlets of textFields
    
    
    @IBOutlet var emailTf: UITextField!
    
    var allDone = Bool()
   
    
    @IBOutlet var confrmlbl: UILabel!
    @IBOutlet var signUpBtn: UIButton!
    @IBOutlet var gradientView: UIView!
    
    
    @IBOutlet var heightOfContantScrollView: NSLayoutConstraint!
    @IBOutlet var viewHeight: NSLayoutConstraint!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        IQKeyboardManager.shared().shouldResignOnTouchOutside=true
        IQKeyboardManager.shared().isEnableAutoToolbar=true
    
        
    }
    
    

    override func viewDidAppear(_ animated: Bool) {
   
        //apiClass.sharedInstance().delegate=self //delegate of api class

        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.view .setNeedsLayout()
        self.view.layoutIfNeeded()
        
    }
    
    override func viewWillLayoutSubviews() {
        if self.view.frame.size.height<=667 {
            
            self.viewHeight.constant = 600
            
        }
        else
        {
            self.viewHeight.constant=self.view.frame.size.height - 64
        }

    }
    
    
    
    
    
    @IBAction func backButtonAction(_ sender: Any) {
    
        for controller in self.navigationController!.viewControllers as Array
        {
            if controller .isKind(of: ViewController.self)
            {
                self.navigationController?.popViewController(animated: true)
                break
            }
        }
        
    
    //self.navigationController?.popViewControllerAnimated(true)
    
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
    
    @IBAction func SignUpBtnAction(sender: AnyObject) {

        // check all txtFields are not empty
        
        
        if emailTf.text == ""  {
            
            CommonFunctionsClass.sharedInstance().showAlert(title: "Opps!", text: "Please fill all the required fields to continue.", imageName: "alertFill")
            
            
        }
            
        else
        {
            
            
            if let email:Bool = self.checkIngTextField(txtF: emailTf) {
                if email == false {
                    // self.emailTf.becomeFirstResponder()
                    allDone=false
                    CommonFunctionsClass.sharedInstance().showAlert(title: "Opps!", text: "Please enter a valid email address.", imageName: "alertFill")
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
            
            
            
            
            
            
            
            
            //////////////////////
        }
        
        
        
               
        
    }
    
    
    
    
    
    
    
    
    
    //MARK:- Function to check the textFields
    
    func checkIngTextField(txtF:UITextField) -> Bool! {
        let emtf = txtF
        
        
        if txtF.text=="" || txtF.text == " " || txtF.text == "\n" {
            allDone=false
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
    
    @IBAction func SignInBtnAction(sender: AnyObject) {
        //Move To LOgin screen

        
        
        
//        let n: Int! = self.navigationController?.viewControllers.count
//        let oldUIViewController: UIViewController = (self.navigationController?.viewControllers[n-2])!
//        
//        
//        
//        if oldUIViewController.isKindOfClass(ViewController) {
//            
//           // print("This is first View controller")
//          
//            let nxtObj = self.storyboard?.instantiateViewControllerWithIdentifier("loginViewController") as! loginViewController
//            
//            self.dismissViewControllerAnimated(true, completion: {})
//            self.navigationController! .pushViewController(nxtObj, animated: true)
//            
//            //apiClass.sharedInstance().postRequestCategories("", viewController: self)//hit the api to get the categories from the web
//            
//        }
//        else{
        
            //print("This is new view controller")
            self.navigationController?.popViewController(animated: true)
//        }
        
        
        
       
    }
    
    
    
    
   
    
    
    
    //MARK:- facebook Action to get the detail and accessToken
    //MARK:-
    
    
    /*
     function for get the access token from the facebook and get into the app
     also will be able to hit the graph api
     
    
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
                    let token =   FBSDKAccessToken.current().tokenString as NSString // access token
                    let token2 = FBSDKAccessToken.current().userID as NSString
                    print(token2)
                    print(token)
                    
                    self.accessToken = token as String // set access token to global for use
                    print(self.accessToken)
                    
                    
                    defaults.set(self.accessToken, forKey: "faceBookAccessToken")
                    defaults.set("", forKey: "instagramAccessToken")
                    
                    
                    self.getFBUserData(id: token2, token: token)
                    
                    
                    DispatchQueue.global(qos: .background).async {
                        
                        //self.graphApi()
                        fbLoginManager.logOut() // logout the facebook
                        MBProgressHUD.hide(for: self.view, animated: true)
                    }
                    
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
    
    

    */
    
    
    
    
    
    
    
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

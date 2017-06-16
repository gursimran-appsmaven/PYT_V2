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
    
    @IBOutlet var nameTf: UITextField!
    @IBOutlet var emailTf: UITextField!
    @IBOutlet var passwordTf: UITextField!
    @IBOutlet var confirmPasswordTf: UITextField!
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
    
        let CenterView = self.view.viewWithTag(111)
        CenterView?.layer.cornerRadius=15
        CenterView?.clipsToBounds=true
        CenterView?.backgroundColor=UIColor .clear
        
        
        let signUpButton = self.view.viewWithTag(112)
        signUpButton!.layer.cornerRadius=(signUpButton?.frame.size.height)!/2
        
        signUpButton!.layer.borderColor=UIColor (colorLiteralRed: 157.0/255.0, green: 194.0/255.0, blue: 134.0/255.0, alpha: 1).cgColor
        signUpButton!.layer.borderWidth=1.0
        signUpButton!.clipsToBounds=true
       
        

     
    
    }
    
    

    override func viewDidAppear(_ animated: Bool) {
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.view .setNeedsLayout()
         self.view.layoutIfNeeded()
        
        //////////-------  Add Gradient color to background  --------///////////
        
        gradientView.backgroundColor=UIColor .white
        
//        
//        let layer = CAGradientLayer()
//        layer.frame = CGRect(x: 0, y: 0, width: self.gradientView.frame.size.width, height: self.gradientView.frame.size.height)
//        
//        //        layer.frame = gradientView.bounds
//        
//        let blueColor = UIColor(red: 0/255, green: 146/255, blue: 198/255, alpha: 1.0).CGColor as CGColorRef
//        let purpleColor = UIColor(red: 117/255, green: 42/255, blue: 211/255, alpha: 1.0).CGColor as CGColorRef
//        layer.colors = [purpleColor, blueColor]
//        layer.startPoint = CGPoint(x: 0.0, y: 0.4)
//        layer.endPoint = CGPoint(x: 0.0, y: 0.8)
//        layer.locations = [0.30,1.0]
//        self.gradientView.layer.addSublayer(layer)
        
        
        
        /////////------ End of gradient color -------/////////

        
        apiClass.sharedInstance().delegate=self //delegate of api class
        
        
       
        
        
        
//        if self.view.frame.size.height<=667 {
//            
//            self.heightOfContantScrollView.constant=600
//            
//        }
//        else
//        {
//            self.heightOfContantScrollView.constant=self.view.frame.size.height - 64
//        }
//        
//        print("height of MainView---\(self.view.frame.size.height)")
//        print("height of content---\(self.heightOfContantScrollView.constant)")
        
        
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
        
        if textField==confirmPasswordTf
        {
            textField .addTarget(self, action: #selector(SignUpScreenViewController.textFieldDidChange(textField:)), for: .editingChanged)
            
           
        }
        
        else if textField == emailTf
        {
            textField .addTarget(self, action: #selector(SignUpScreenViewController.textFieldDidChange(textField:)), for: .editingChanged)
            
           
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
    
    
    
    
    
    
    
    
    ////////////////////////////////////////////////////////////////////////////////////
    
    //MARK:- Sign UP  Button Actions
    //MARK:-
    
    @IBAction func SignUpBtnAction(sender: AnyObject) {

        // check all txtFields are not empty
        
        
        if nameTf.text == "" && emailTf.text == "" && passwordTf.text == "" && confirmPasswordTf.text == "" {
            
            CommonFunctionsClass.sharedInstance().showAlert(title: "Opps!", text: "Please fill all the required fields to continue.", imageName: "alertFill")
            
            
        }
            
        else
        {
            if let name:Bool = self.checkIngTextField(txtF: nameTf) { //check name field
                if name == false {
                   // self.nameTf.becomeFirstResponder()
                    allDone=false
                    
                    CommonFunctionsClass.sharedInstance().showAlert(title: "Oops!", text: "Please fill Username", imageName: "alertFill")
                   
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
                            if let pass:Bool = self.checkIngTextField(txtF: passwordTf) {
                                if pass == false {
                                    //self.passwordTf.becomeFirstResponder()
                                    allDone=false
                                     CommonFunctionsClass.sharedInstance().showAlert(title: "Oops!", text: "Please fill password.", imageName: "alertFill")
                                }
                                else{
                                    if let cPass:Bool = self.checkIngTextField(txtF: confirmPasswordTf) {
                                        if cPass == false {
                                            //self.confirmPasswordTf.becomeFirstResponder()
                                            allDone=false
                                             CommonFunctionsClass.sharedInstance().showAlert(title: "Oops!", text: "The passwords you entered do not match.", imageName: "alertFill")
                                        }
                                        else{
                                            if confirmPasswordTf.text==passwordTf.text {
                                                allDone=true
                                            }
                                            else{
                                               // self.confirmPasswordTf.becomeFirstResponder()
                                                allDone=false
                                                 CommonFunctionsClass.sharedInstance().showAlert(title: "Oops!", text: "Please fill same password", imageName: "alertFill")
                                                
                                            }
                                        }
                                        
                                    }
                                    
                                }
                            }
                        }
                    }
                    
                    
                    
                }
                
                
                
            }
        }
        
        
        
        
        if allDone==true {
            
            //device token
           
           let token = defaults.string(forKey: "deviceToken")!
            print(token)
            
            
            
            let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
            loadingNotification.mode = MBProgressHUDMode.indeterminate
            loadingNotification.label.text = "Signing Up..."

            let parameterString: NSDictionary = ["name":nameTf.text!, "email": emailTf.text!, "password": passwordTf.text!, "deviceToken":["token": "", "device": "iphone"]]
            
            //NSString(string:"username=\(nameTf.text!)&email=\(emailTf.text!)&password=\(passwordTf.text!)&deviceToken=\(token)&device=iphone") as String
            print(parameterString)
          
            passwordTf.resignFirstResponder()
            emailTf.resignFirstResponder()
            nameTf.resignFirstResponder()
            confirmPasswordTf.resignFirstResponder()
           
            apiClass.sharedInstance().postRequestSearch(parameterString: parameterString, viewController: self)// call api
            
           
        }
        
        
        
    }
    
    
    
    
    
    
    
    
    
    //MARK:- Function to check the textFields
    
    func checkIngTextField(txtF:UITextField) -> Bool {
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
    
    
    
    
   
    
    
    
    
    //MARK:- Server response arrived here
    //MARK:-
    func serverResponseArrived(Response:AnyObject){
        
     
       
            jsonResult = NSDictionary()
            jsonResult = Response as! NSDictionary
        
        
       
        let success = jsonResult.object(forKey: "status") as! NSNumber
            
            if success == 1
            {
              
                
                let uname = nameTf.text
                
                
                defaults.set(uname, forKey: "userLoginName")
                
                
                defaults.set("", forKey: "userProfilePic")
                
                
                
                //save The credentail and login to the app
                
                let pytUserId = ""//(jsonResult.value(forKey: "data")! as AnyObject) .value("userId") as? String ?? ""
                
                
               
                defaults.set(pytUserId, forKey: "userLoginId")
                defaults.set(false, forKey: "social")
                
                let nxtObj3 = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                
                if (nxtObj3.tabledata?.count)!<1 {
                   
                    
                    
                    //let nxtObj = self.storyboard?.instantiateViewControllerWithIdentifier("firstMainScreenViewController") as! firstMainScreenViewController
                    
                   // dispatch_after(DispatchTime.now(dispatch_time_t(DISPATCH_TIME_NOW), Int64(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), {() -> Void in
                        
                       // self.navigationController! .pushViewController(nxtObj, animated: true)
                        self.dismiss(animated: true, completion: {})
                   // })
                    
                    
                    
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
        
        
            
        
        
        //apiClass.sharedInstance().postRequestCategories("", viewController: self)//hit the api to get the categories from the web
        
 
 
        
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

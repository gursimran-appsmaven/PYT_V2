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
    
    
    
    
    
    //MARK:- Server response arrived here
    //MARK:-
    func serverResponseArrived(Response:AnyObject){
        
        
        
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

//
//  changePasswordViewController.swift
//  PYT
//
//  Created by Niteesh on 21/12/16.
//  Copyright © 2016 appsMaven. All rights reserved.
//

import UIKit
import MBProgressHUD
import IQKeyboardManager

class changePasswordViewController: UIViewController, settingClassDelegate {

    
    @IBOutlet weak var oldPassword: UITextField!//old Password textField
    
    @IBOutlet weak var newPassword: UITextField! //New Password textField
    
    @IBOutlet weak var backView: UIView!
    
    
    var oldPasswdId = NSString()
    @IBOutlet weak var submitButtonOutlet: UIButton!
    
    
    override func viewWillAppear(_ animated: Bool)
    {
            SettingApiClass.sharedInstance().delegate=self //delegate of api class
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

         self.tabBarController?.setTabBarVisible(visible: false, animated: true)
         IQKeyboardManager.shared().shouldResignOnTouchOutside = true
        
        backView.dropShadow(scale: true,right: true,bottom: true)
       // submitButtonOutlet.isHidden = false
       // submitButtonOutlet.layer.cornerRadius=submitButtonOutlet.frame.size.height/2
       // submitButtonOutlet.layer.borderColor = UIColor (colorLiteralRed: 162/255, green: 200/255, blue: 138/255, alpha: 1).cgColor
        //submitButtonOutlet.layer.borderWidth = 1.5
        //submitButtonOutlet.clipsToBounds=true
       // submitButtonOutlet.layer.masksToBounds=true
        
        
        
        
      
        
        
        
        // Do any additional setup after loading the view.
    }

    
    
    @IBAction func backButtonAction(_ sender: AnyObject) {
    
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: {})
        URLCache.shared.removeAllCachedResponses()
    
    }
    
    

    
    
    //Forgot Password Action
    
    @IBAction func submitButtonAction(_ sender: AnyObject) {


                let uId = Udefaults .string(forKey: "userLoginId")
        
                let oldPString:NSString = oldPassword.text! as NSString
                let newPString:NSString = newPassword.text! as NSString
                //let confirmPString:NSString = confirmPassword.text! as NSString
        
        
                oldPassword.resignFirstResponder()
                newPassword.resignFirstResponder()
               // confirmPassword.resignFirstResponder()
        
        
        
                if newPString.length > 1 //oldPString.length > 1 && newPString.length
                {
        
            
                       MBProgressHUD.showAdded(to: self.view, animated: true)
                        let parameter:NSDictionary = ["userId": uId!, "newPwd":newPString, "oldPwd": oldPString]
        
            SettingApiClass.sharedInstance().changePasswordApi(parameter, urlToSend: "edit_user_password", viewController: self)
                    
                }
                else
                {
                    self.showAlert("Oops!", text: "Please fill all the required fields", imageName: "alertFill")
                }
                
        


    
            /*
            let newPString:NSString = newPassword.text! as NSString
          //  let confirmPString:NSString = confirmPassword.text! as NSString
            
            
            if newPString.length > 1 {
                
                
                //if newPString == confirmPString {
                    
                    let parameter:NSDictionary = ["userId": oldPasswdId, "newPwd":newPString]
                    print(parameter)
                    MBProgressHUD.showAdded(to: self.view, animated: true)
                    SettingApiClass.sharedInstance().changePasswordApi(parameter, urlToSend: "change_password_without_session", viewController: self)
                    
                    
                    
                    
                //}
                //else{
                  //  self.showAlert("Oops!", text: "The passwords you entered do not match.", imageName: "alertFill")
               // }
                
                
            }
            else{
                self.showAlert("Oops!", text: "Please fill all the required fields", imageName: "alertFill")
            }
        */
        
    }
    
    
    
     func serverResponseArrivedSetting(_ Response:AnyObject){
        
        jsonResult = NSDictionary()
        jsonResult = Response as! NSDictionary
        
        let status = jsonResult .value(forKey: "status") as! NSNumber
        var message = ""
        
        if status == 1 {
            
            message = jsonResult.value(forKey: "msg") as? String ?? ""
            newPassword.text=""
            oldPassword.text=""
         //   confirmPassword.text=""
            
            
            
            self.showAlert("Success!", text: "Your password has been changed successfully.", imageName: "alertPassword")
            
            self.backButtonAction(self)
            
            
            
        }
        else if status == 0{
            message = jsonResult.value(forKey: "msg") as? String ?? ""
            self.showAlert("Server Alert", text: "Something doesn't seem right, Please try again!", imageName: "alertServer")
        }
        else
        {
        
             message = jsonResult.value(forKey: "msg") as? String ?? ""
            self.backButtonAction(self)
            self.showAlert("Server Alert", text: "Something doesn't seem right, Please try again!", imageName: "alertServer")
        }
        
        
        
        
        MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
        
    }
    
    
    
    
    
    
    
    func showAlert(_ title: NSString, text: NSString, imageName: NSString) {
        
        
        SweetAlert().removeFromParentViewController()
        SweetAlert().showAlert(title as String, subTitle: text as String, style: AlertStyle.customImag(imageFile: imageName as String))
        
        
    }
    
    
    
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
      
        URLCache.shared.removeAllCachedResponses()
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
extension UIView {
    
    func dropShadow(scale: Bool = true,right: Bool = false,bottom: Bool = false) {
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.25
        if(right && bottom)
        {
            self.layer.shadowOffset = CGSize(width: 1, height: 1)
        }
        else if(right && !bottom)
        {
            self.layer.shadowOffset = CGSize(width: 1, height: 0)
        }
        else if(!right && bottom)
        {
            self.layer.shadowOffset = CGSize(width: 0, height: 1)
        }
        self.layer.shadowRadius = 1
        
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}

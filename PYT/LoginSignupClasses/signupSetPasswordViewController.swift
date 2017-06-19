//
//  signupSetPasswordViewController.swift
//  PYT
//
//  Created by osx on 16/06/17.
//  Copyright © 2017 osx. All rights reserved.
//

import UIKit
import IQKeyboardManager
class signupSetPasswordViewController: UIViewController
{

    @IBOutlet var passwordTf: UITextField!
    @IBOutlet var confirmPasswordTf: UITextField!

    
    var userEmail = NSString()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        IQKeyboardManager.shared().shouldResignOnTouchOutside=true
        IQKeyboardManager.shared().isEnableAutoToolbar=true
        
        
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
             
             
             let token = defaults.string(forKey: "deviceToken")!
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

//
//  ForgotPasswordViewController.swift
//  PYT
//
//  Created by osx on 30/05/17.
//  Copyright © 2017 appsMaven. All rights reserved.
//

import UIKit
import MBProgressHUD


class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var emailTxtField: UITextField!
    
    @IBOutlet weak var doneButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        doneButton.layer.cornerRadius=doneButton.frame.size.height/2
        doneButton.layer.borderColor = UIColor (colorLiteralRed: 162/255, green: 200/255, blue: 138/255, alpha: 1).cgColor
        doneButton.layer.borderWidth = 1.5
        doneButton.clipsToBounds=true
        doneButton.layer.masksToBounds=true
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func doneAction(_ sender: Any) {
        
        emailTxtField .resignFirstResponder()
        
        
        if ViewController().isValidEmail(candidate: emailTxtField.text!)
        {
            
            let prm: NSDictionary = ["email": emailTxtField.text!]
            
           MBProgressHUD.showAdded(to: self.view, animated: true)
            self .ChangePasswordifForgot(forgetString: prm)
            
        }
        else
        {
            CommonFunctionsClass.sharedInstance().showAlert(title: "Invalid Info", text: "The email id you have entered is not correct. Please try again.", imageName: "alertWrong")
            
            MBProgressHUD.hide(for: self.view, animated: true)
           
        }

        
        
    }
    
    @IBAction func actionback(sender: AnyObject) {
        
        self.navigationController! .popViewController(animated: true)
        
    }
   
    
    
    func ChangePasswordifForgot(forgetString: NSDictionary) {
        
        
        
        let isConnectedInternet = CommonFunctionsClass.sharedInstance().isConnectedToNetwork()
        
        if isConnectedInternet
        {
            //CommonFunctionsClass.sharedInstance().startIndicator(viewController.view)
            
            var urlString = NSString(string:"\(appUrl)validate_email")
            print("WS URL----->>" + (urlString as String))
            
            urlString = urlString .replacingOccurrences(of: " ", with: "%20") as NSString
            
            let url:NSURL = NSURL(string: urlString as String)!
            let session = URLSession.shared
            
            let request = NSMutableURLRequest(url: url as URL)
            request.httpMethod = "POST"
            request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData //NSURLRequest.CachePolicy.ReloadIgnoringCacheData
            
            
            do {
                let jsonData = try!  JSONSerialization.data(withJSONObject: forgetString, options: [])
                request.httpBody = jsonData
                
                
                // here "jsonData" is the dictionary encoded in JSON data
            } catch let error as NSError {
                print(error)
            }
            
            
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            //request.HTTPBody = parameterString.dataUsingEncoding(NSUTF8StringEncoding)
            
            let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
                
                OperationQueue.main.addOperation
                    {
                        
                        
                        if data == nil
                        {
                            CommonFunctionsClass.sharedInstance().showAlert(title: "Server Alert", text: "Something doesn't seem right, Please try again!", imageName: "alertServer")
                            
                            MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                        }
                        else
                        {
                            
                        
                            do {
                                
                                let result = NSString(data: data!, encoding:String.Encoding.ascii.rawValue)!
                                print("Body: Result from forget password \(result)")
                                
                                let anyObj: Any = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                                jsonResult = NSDictionary()
                                jsonResult = anyObj as! NSDictionary
                                let success = jsonResult.object(forKey: "status") as! NSNumber
                                if success == 1 {
                                    
                                   // let nxtObj = self.storyboard?.instantiateViewControllerWithIdentifier("changePasswordViewController") as! changePasswordViewController
                                   // nxtObj.forgotPasswordScreen = true
                                   // nxtObj.oldPasswdId = jsonResult.valueForKey("user")!.valueForKey("_id") as? String ?? "Id"
                                    
                                    
                                   // self.navigationController?.pushViewController(nxtObj, animated: true)
                                    
                                    
                                }
                                else
                                {
                                    CommonFunctionsClass.sharedInstance().showAlert(title: "Invalid Info", text: "The email id you have entered is not correct. Please try again.", imageName: "alertWrong")
                                    
                                    
                                }
                                
                                MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                                
                            }
                            catch {
                                print("json error: \(error)")
                                CommonFunctionsClass.sharedInstance().showAlert(title: "Server Alert", text: "Something doesn't seem right, Please try again!", imageName: "alertServer")
                                
                                MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                            }
                            
                            
                            
                            
                            
                        }
                }
            })
            
            task.resume()
        }
        else
        {
            CommonFunctionsClass.sharedInstance().showAlert(title: "No Internet Connection", text: "You are currently offline.", imageName: "alertInternet")
            
            MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
            
        }
        
        
        
        
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

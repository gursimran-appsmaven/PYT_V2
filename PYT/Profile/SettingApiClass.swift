//
//  SettingApiClass.swift
//  PYT
//
//  Created by Niteesh on 21/12/16.
//  Copyright © 2016 appsMaven. All rights reserved.
//

import UIKit
import MBProgressHUD




///create a delegate for intract with server
protocol settingClassDelegate
{
    func serverResponseArrivedSetting(_ Response:AnyObject)
}


class SettingApiClass: NSObject
{

    
  
    
    var delegate:settingClassDelegate! = nil
    
    static var instance: SettingApiClass!
    
    // SHARED INSTANCE
    class func sharedInstance() -> SettingApiClass
    {
        self.instance = (self.instance ?? SettingApiClass())
        return self.instance
    }
    
    
    
    ////////////////----MARK: Get api to connect facebook and instagram
    
    
    func Connectfacebook_Instagram(_ parameterString : NSDictionary , urlHit: NSString, viewController : UIViewController)
    {
        
        let isConnectedInternet = CommonFunctionsClass.sharedInstance().isConnectedToNetwork()
        
        if isConnectedInternet
        {
            
            
            
            let urlString = NSString(string:"\(appUrl)\(urlHit)")
            
            let needsLove = urlString
            let safeURL = needsLove.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            
            let url:URL = URL(string: safeURL as String)!
            print("Final Url-----> " + (safeURL as String))
            
           
            let session = URLSession.shared
            session.configuration.timeoutIntervalForRequest=20
            
            //session.configuration.timeoutIntervalForResource=60
            
            let request = NSMutableURLRequest(url: url)
            request.httpMethod = "POST"
            request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
            
            do {
                let jsonData = try!  JSONSerialization.data(withJSONObject: parameterString, options: [])
                request.httpBody = jsonData
                
                
                // here "jsonData" is the dictionary encoded in JSON data
            } catch let error as NSError {
                print(error)
            }
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            

            
           
            
              let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
                
                
                
                OperationQueue.main.addOperation
                    {
                        
                        
                        if data == nil
                        {
                              self.showAlert("Server Alert", text: "Something doesn't seem right, Please try again!", imageName: "alertServer")
                            
                            
                           
                            MBProgressHUD.hideAllHUDs(for: viewController.view, animated: true)
                            
                            
                            
                        }
                        else
                        {
                            
                            
                            DispatchQueue.main.async(execute: {
                                
                                do {
                                    
                                    
                                    //    let anyObj = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as! [String:AnyObject]
                                    
                                     let result = NSString(data: data!, encoding:String.Encoding.ascii.rawValue)!
                                     print("Body: \(result)")
                                   
                                     let anyObj: Any = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                                    
                                    
                                    self.delegate.serverResponseArrivedSetting(anyObj as AnyObject)
                                    
                                    
                                    
                                } catch {
                                    print("json error: \(error)")
                                  
                                    self.showAlert("Server Alert", text: "Something doesn't seem right, Please try again!", imageName: "alertServer")
                                    
                                    MBProgressHUD.hideAllHUDs(for: viewController.view, animated: true)
                                }
                                
                                
                                
                                
                            })
                            
                            
                            
                            
                        }
                        
                        //indicatorClass.sharedInstance().hideIndicator()
                }
                
            }
            
            task.resume()
        }
        else
        {
            self.showAlert("No Internet Connection", text: "You are currently offline.", imageName: "alertInternet")
            
            MBProgressHUD.hide(for: viewController.view, animated: true)
        }
    }
    
    
    
    
    
    //MARK: API to get the user profile
    
    
    func getUSerProfile(_ parameterString:NSString, viewController: UIViewController) {
            
            let isConnectedInternet = CommonFunctionsClass.sharedInstance().isConnectedToNetwork()
            
            if isConnectedInternet
            {
                //CommonFunctionsClass.sharedInstance().startIndicator(viewController.view)
                
                var urlString = NSString(string:"\(appUrl)get_user_profile") //Live Url
                
                let prmDict: NSDictionary = ["userId": parameterString]
                
                print("WS URL----->>" + (urlString as String))
                
                urlString = urlString .replacingOccurrences(of: " ", with: "%20") as NSString
                
                let url:URL = URL(string: urlString as String)!
                let session = URLSession.shared
                
                let request = NSMutableURLRequest(url: url)
                request.httpMethod = "POST"
                request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
                
                
                
                do {
                    let jsonData = try!  JSONSerialization.data(withJSONObject: prmDict, options: [])
                    request.httpBody = jsonData
                    
                    // here "jsonData" is the dictionary encoded in JSON data
                } catch let error as NSError {
                    print(error)
                }
                
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.addValue("application/json", forHTTPHeaderField: "Accept")
                
                
                
                
            let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
                    
                    OperationQueue.main.addOperation
                        {
                            
                            if data == nil
                            {
                                print("server not responding")
                                //CommonFunctionsClass.sharedInstance().alertViewOpen("Server is not responding", viewController: viewController)
                                MBProgressHUD.hideAllHUDs(for: viewController.view, animated: true)
                            }
                            else
                            {
                                
                                do {
                                    
                                    let result = NSString(data: data!, encoding:String.Encoding.ascii.rawValue)!
                                    print("Body: user Profile in setting screen \(result)")
                                    
                                    let anyObj: Any = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                                    
                                    print(anyObj)
                                    
                                    basicInfo=NSMutableDictionary()
                                    basicInfo=anyObj as! NSMutableDictionary
                                    
                                    
                                    profileUserData = basicInfo

                                    print(profileUserData)
                                    self.delegate.serverResponseArrivedSetting(anyObj as AnyObject)
                                    
                                    
                                } catch
                                {
                                    print("json error: \(error)")
                                   
                                    MBProgressHUD.hideAllHUDs(for: viewController.view, animated: true)
                                }
                                
                                
                                
                                
                                
                                
                                
                            }
                    }
                }
                
                task.resume()
            }
            else
            {
               self.showAlert("No Internet Connection", text: "You are currently offline.", imageName: "alertInternet")
                
                MBProgressHUD.hideAllHUDs(for: viewController.view, animated: true)
            }
        
        
        
    }
    
    
    
    
    //MARK:
    //MARK: Change the password of the user
    
    func changePasswordApi(_ parameterString:NSDictionary, urlToSend: NSString, viewController: UIViewController) {
        
        //userId
        let isConnectedInternet = CommonFunctionsClass.sharedInstance().isConnectedToNetwork()
        
        if isConnectedInternet
        {
            
            
            
let urlString = NSString(string:"\(appUrl)\(urlToSend)") //edit_user_password")
//            let urlString = NSString(string:"\(appUrl)changePassword")
            
            
            let isConnectedInternet = CommonFunctionsClass.sharedInstance().isConnectedToNetwork()
            
            if isConnectedInternet
            {
                // CommonFunctionsClass.sharedInstance().startIndicator(viewController.view)
                
                var urlString = NSString(string:"\(urlString)")
                print("WS URL----->>" + (urlString as String))
                
                urlString = urlString .replacingOccurrences(of: " ", with: "%20") as NSString
                
                let url:URL = URL(string: urlString as String)!
                let session = URLSession.shared
                session.configuration.timeoutIntervalForRequest=20
                // session.configuration.timeoutIntervalForResource=40
                
                
                let request = NSMutableURLRequest(url: url)
                request.httpMethod = "POST"
                request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
                
                
                do {
                    let jsonData = try!  JSONSerialization.data(withJSONObject: parameterString, options: [])
                    request.httpBody = jsonData
                    
                    
                    // here "jsonData" is the dictionary encoded in JSON data
                } catch let error as NSError {
                    print(error)
                }
                
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.addValue("application/json", forHTTPHeaderField: "Accept")
                
                

                
                
                
                
                
                let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in

                    
                    OperationQueue.main.addOperation
                        {
                            
                            if data == nil
                            {
                                print("server not responding")
                                //CommonFunctionsClass.sharedInstance().alertViewOpen("Server is not responding", viewController: viewController)
                                MBProgressHUD.hideAllHUDs(for: viewController.view, animated: true)
                            }
                            else
                            {
                                
                                
                                do {
                                    
                                    let result = NSString(data: data!, encoding:String.Encoding.ascii.rawValue)!
                                    print("Body: \(result)")
                                    
                                     let anyObj: Any = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                                    
                                    print(anyObj)
                                    
                                    basicInfo=NSMutableDictionary()
                                    basicInfo=anyObj as! NSMutableDictionary
                                    
                                    
                                    profileUserData = basicInfo
                                    
                                    print(profileUserData)
                                    self.delegate.serverResponseArrivedSetting(anyObj as AnyObject)
                                    
                                    
                                } catch
                                {
                                    print("json error: \(error)")
                                    CommonFunctionsClass.sharedInstance().showAlert(title: "Server Alert", text: "Something doesn't seem right, Please try again!", imageName: "alertServer")
                                    MBProgressHUD.hideAllHUDs(for: viewController.view, animated: true)
                                }
                                
                                
                                
                                
                                
                                
                                
                            }
                    }
                }
                
                task.resume()
            }
            else
            {
                
              
                self.showAlert("No Internet Connection", text: "You are currently offline.", imageName: "alertInternet")
                
                
                MBProgressHUD.hideAllHUDs(for: viewController.view, animated: true)
            }
            
            
        }
    }
    
    
    
    
    
    
    //MARK: Show the alert
    
    
    func showAlert(_ title: NSString, text: NSString, imageName: NSString) {
        
        
        SweetAlert().removeFromParentViewController()
        SweetAlert().showAlert(title as String, subTitle: text as String, style: AlertStyle.customImag(imageFile: imageName as String))
        
        
    }
    
    
    
    
    
    
    
    
   
    
    
    
}

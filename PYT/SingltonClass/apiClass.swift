
//
//  apiClass.swift
//  PYT
//
//  Created by Niteesh on 07/07/16.
//  Copyright © 2016 appsMaven. All rights reserved.
//




import UIKit
import SwiftyJSON
import SystemConfiguration
import MBProgressHUD


///create a delegate for intract with server
protocol apiClassDelegate
{
    func serverResponseArrived(Response:AnyObject)
}






class apiClass: NSObject {

    
    ////Live Ulr
    
     let baseUrlfb = appUrl
    let baseUrlLogin = "\(appUrl)login_email"
 
    let baseUrladdImage = "\(appUrl)save_story"
    
    let searchStory = "\(appUrl)set_runTimeLocation" //new version
   
     let likeUnlike = "\(appUrl)like_unlike_image_V2"//like_unlike_image"
    let deletePytImage = "\(appUrl)delete_image" // latest version
    let addAccessToken = "\(appUrl)token" // latest version
 let forgetString = "\(appUrl)validate_email"
    
  
    
    
    
    
    var delegate:apiClassDelegate! = nil
    
    static var instance: apiClass!
    
    // SHARED INSTANCE
    class func sharedInstance() -> apiClass
    {
        self.instance = (self.instance ?? apiClass())
        return self.instance
    }
    
    
    
    
    
    
    
    
    
    
    /////////////////////////////////////////////////////////////////////////////////

    //MARK:- api for get feed screen results
    //MARK:-
    
    func getRequest(parameterString : NSDictionary, urlStringMultiple: NSString , viewController : UIViewController)
    {
        
        
        let isConnectedInternet = CommonFunctionsClass.sharedInstance().isConnectedToNetwork()
        
        if isConnectedInternet
        {
            let urlString = NSString(string:"\(urlStringMultiple)")
            let needsLove = urlString
            let safeURL = needsLove.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
            
            let url:NSURL = NSURL(string: safeURL as String)!
            print("Final Url-----> " + (safeURL as String))
            
            let request = NSMutableURLRequest(url: url as URL)
            request.httpMethod = "POST"
           
            let postString = parameterString
        
            
            do {
                let jsonData = try!  JSONSerialization.data(withJSONObject: postString, options: [])
                request.httpBody = jsonData
                
        
            } catch let error as NSError {
                print(error)
            }
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")

            NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: OperationQueue.main) {(response, data, error) in
                
                
                
                OperationQueue.main.addOperation
                    {
                        if data == nil
                        {
                          CommonFunctionsClass.sharedInstance().showAlert(title: "Server Alert", text: "Something doesn't seem right, Please try again!", imageName: "alertServer")
                            
                            MBProgressHUD.hideAllHUDs(for: viewController.view, animated: true)
                            
                            
                            
                        }
                        else
                        {
                          
                            
                           //  DispatchQueue.main.async {
                            
                                do {
                                    
                                    
                                   // let anyObj: Any = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
                                    
                                    
                                    let anyObj: Any = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                                    
                                    
                                    
                                    
                                            self.delegate.serverResponseArrived(Response: anyObj as AnyObject)
                                    
                                    
                                    
                                        } catch {
                                                print("json error: \(error)")
                                           
                                            CommonFunctionsClass.sharedInstance().showAlert(title: "Server Alert", text: "Something doesn't seem right, Please try again!", imageName: "alertServer")
                                            
                                            
                                            MBProgressHUD.hideAllHUDs(for: viewController.view, animated: true)
                                        }
                                
                                
                            
                        }
                        
                       
                }
                
            }
       
           
        }
        else
        {
            print(viewController)
            
            
            
            CommonFunctionsClass.sharedInstance().showAlert(title: "No Internet Connection", text: "You are currently offline.", imageName: "alertInternet")

           
                    MBProgressHUD.hideAllHUDs(for: viewController.view, animated: true)
        }
 
 
 
 
        
       
        
        
        
    }
    
    
    
    
    func postRequestFacebook(parameterString : NSDictionary , viewController : UIViewController)
    {
        
        let isConnectedInternet = CommonFunctionsClass.sharedInstance().isConnectedToNetwork()
        
        if isConnectedInternet
        {
            let request = NSMutableURLRequest(url: NSURL(string: "\(appUrl)login_with_facebook")! as URL)//live url
            
            
            request.httpMethod = "POST"
            let postString = parameterString
            
            
            do {
                let jsonData = try!  JSONSerialization.data(withJSONObject: postString, options: [])
                request.httpBody = jsonData
                
                
                // here "jsonData" is the dictionary encoded in JSON data
            } catch let error as NSError {
                print(error)
            }
            
            
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            
            
            let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
                guard error == nil && data != nil else {                                                          // check for fundamental networking error
                    print("error=\(error)")
                    return
                }
                
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(response)")
                }
                
                let responseString = String(data: data!, encoding: String.Encoding.utf8)
                print("responseString = \(responseString)")
                
                
                DispatchQueue.main.async {
                    
                    do {
                        
                        
                        let anyObj: Any = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                        
                          self.delegate.serverResponseArrived(Response: anyObj as AnyObject)
                        
                        
                        
                    } catch
                    {
                        print("json error: \(error)")
                        CommonFunctionsClass.sharedInstance().showAlert(title: "Server Alert", text: "Something doesn't seem right, Please try again!", imageName: "alertServer")
                        
                       
                        MBProgressHUD.hideAllHUDs(for: viewController.view, animated: true)
                    }
                    
                    
                    
                    
                }
                
                
                
                
                
                
                
            }
            task.resume()
            
        }
        else
        {
            
            CommonFunctionsClass.sharedInstance().showAlert(title: "No Internet Connection", text: "You are currently offline.", imageName: "alertInternet")

        }
        
        
        
        
        
    }

    

    
    
    
    
    
    //MARK: post request to instagram login
    func postRequestInstagram(parameterString : NSDictionary , viewController : UIViewController)
    {
        
        let isConnectedInternet = CommonFunctionsClass.sharedInstance().isConnectedToNetwork()
        
        if isConnectedInternet
        {
            let request = NSMutableURLRequest(url: NSURL(string: "\(appUrl)login_with_instagram")! as URL)//live url
            
            
            request.httpMethod = "POST"
            let postString = parameterString
            //request.httpBody = postString.dataUsingEncoding(String.Encoding.utf8)
            
            do {
                let jsonData = try!  JSONSerialization.data(withJSONObject: postString, options: [])
                request.httpBody = jsonData
                
                
                // here "jsonData" is the dictionary encoded in JSON data
            } catch let error as NSError {
                print(error)
            }
            
            
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            
            
            let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
                guard error == nil && data != nil else {                                                          // check for fundamental networking error
                    print("error=\(error)")
                    return
                }
                
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(response)")
                }
                
                let responseString = String(data: data!, encoding: String.Encoding.utf8)
                print("responseString = \(responseString)")
                
                
                DispatchQueue.main.async {
                    
                    do
                    {
                        let anyObj: Any = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                        
                        self.delegate.serverResponseArrived(Response: anyObj as AnyObject)
                        
                        
                        
                    } catch
                    {
                        print("json error: \(error)")
                        CommonFunctionsClass.sharedInstance().showAlert(title: "Server Alert", text: "Something doesn't seem right, Please try again!", imageName: "alertServer")
                        
                    MBProgressHUD.hideAllHUDs(for: viewController.view, animated: true)
                    }
                
                }
                
                
            }
            task.resume()
            
        }
        else
        {
             CommonFunctionsClass.sharedInstance().showAlert(title:"No Internet Connection", text: "You are currently offline.", imageName: "alertInternet")

        }
        
        
        
        
        
    }

    
    
    
    
    
    
    
    
    
    
    
    
    
    /////////////////////////////////////////////////////////////////////////////////

    
    //MARK:- api for Signup in the app
    //MARK
    
    func postRequestSearch(parameterString : NSDictionary , viewController : UIViewController)
    {
        
        let isConnectedInternet = CommonFunctionsClass.sharedInstance().isConnectedToNetwork()
        
        if isConnectedInternet
        {
            let request = NSMutableURLRequest(url: NSURL(string: "\(appUrl)signup_email")! as URL)//live url
            
          
            request.httpMethod = "POST"
            let postString = parameterString
            
            do {
                let jsonData = try!  JSONSerialization.data(withJSONObject: postString, options: [])
                request.httpBody = jsonData
                
                // here "jsonData" is the dictionary encoded in JSON data
            } catch let error as NSError {
                print(error)
            }
           
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            
            let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
                guard error == nil && data != nil else {                                                          // check for fundamental networking error
                    print("error=\(error)")
                    return
                }
                
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(response)")
                }
                
                let responseString = String(data: data!, encoding: String.Encoding.utf8)
                print("responseString = \(responseString)")
                
                
                        DispatchQueue.main.async {
                
                            do {
                
                               
                
                               
                                
                                
                                let anyObj: Any = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                
                                self.delegate.serverResponseArrived(Response:anyObj as AnyObject)
                
                            } catch
                            {
                                print("json error: \(error)")
                                 CommonFunctionsClass.sharedInstance().showAlert(title:"Server Alert", text: "Something doesn't seem right, Please try again!", imageName: "alertServer")
                                
                                
                                MBProgressHUD.hideAllHUDs(for: viewController.view, animated: true)
                            }
                         
                            
                        }
                
                
                
            }
            task.resume()
            
        }
        else
        {
             CommonFunctionsClass.sharedInstance().showAlert(title:"No Internet Connection", text: "You are currently offline.", imageName: "alertInternet")

             MBProgressHUD.hideAllHUDs(for: viewController.view, animated: true)
        }
        
     
        
    }
    
    
    
    
    
    
    
    /////////////////////////////////////////////////////////////////////////////////
    
    //MARK:- Post request for login into screen
    //MARK:-
    
    func postRequestForLogin(parameterString : NSDictionary, viewController : UIViewController)
    {
        let isConnectedInternet = CommonFunctionsClass.sharedInstance().isConnectedToNetwork()
        
        if isConnectedInternet
        {
            //CommonFunctionsClass.sharedInstance().startIndicator(viewController.view)
            
            var urlString = NSString(string:"\(baseUrlLogin)")
            print("WS URL----->>" + (urlString as String))
            
            urlString = urlString .replacingOccurrences(of: " ", with: "%20") as NSString
            let url:NSURL = NSURL(string: urlString as String)!
            let request = NSMutableURLRequest(url: url as URL)
            request.httpMethod = "POST"
            request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
            
             let session = URLSession.shared// NSURLSession.sharedSession()
            
            do {
                let jsonData = try!  JSONSerialization.data(withJSONObject:parameterString, options: [])
                request.httpBody = jsonData
                
                
                // here "jsonData" is the dictionary encoded in JSON data
            } catch let error as NSError {
                print(error)
            }
            
            
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            //request.httpBody = parameterString.dataUsingEncoding(String.Encoding.utf8)
            
            let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
                
                OperationQueue.main.addOperation
                    {
                       
                        
                        if data == nil
                        {
                             CommonFunctionsClass.sharedInstance().showAlert(title:"Server Alert", text: "Something doesn't seem right, Please try again!", imageName: "alertServer")
                            
                            MBProgressHUD.hideAllHUDs(for: viewController.view, animated: true)
                        }
                        else
                        {


                            
                            
                            do {
                                
                                
                
                                
                                let anyObj: Any = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                                
                                self.delegate.serverResponseArrived(Response: anyObj as AnyObject)
                                
                                
                                
                            } catch {
                                print("json error: \(error)")
                                 CommonFunctionsClass.sharedInstance().showAlert(title:"Server Alert", text: "Something doesn't seem right, Please try again!", imageName: "alertServer")
                                
                                MBProgressHUD.hideAllHUDs(for: viewController.view, animated: true)
                            }
                            
                            
                        }
                }
            })
            
            task.resume()
        }
        else
        {
             CommonFunctionsClass.sharedInstance().showAlert(title:"No Internet Connection", text: "You are currently offline.", imageName: "alertInternet")

             MBProgressHUD.hideAllHUDs(for: viewController.view, animated: true)
           
        }
        
    }
    
    
    
 
    
    
    //MARK: 
    //MARK: Forgot password api
    /*
    func postRequestForForgotPassword(parameterString : NSDictionary, viewController : UIViewController)
    {
        let isConnectedInternet = CommonFunctionsClass.sharedInstance().isConnectedToNetwork()
        
        if isConnectedInternet
        {
            //CommonFunctionsClass.sharedInstance().startIndicator(viewController.view)
            
            var urlString = NSString(string:"\(forgetString)")
            print("WS URL----->>" + (urlString as String))
            
            urlString = urlString .stringByReplacingOccurrencesOfString(" ", withString: "%20")
            
            let url:NSURL = NSURL(string: urlString as String)!
            let session = NSURLSession.sharedSession()
            
            let request = NSMutableURLRequest(url: url)
            request.httpMethod = "POST"
            request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
            
            
            do {
                let jsonData = try!  JSONSerialization.data(withJSONObject:(parameterString, options: [])
                request.httpBody = jsonData
                
                
                // here "jsonData" is the dictionary encoded in JSON data
            } catch let error as NSError {
                print(error)
            }
            
            
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            //request.httpBody = parameterString.dataUsingEncoding(String.Encoding.utf8)
            
            let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
                
                OperationQueue.main.addOperation
                    {
                        
                        
                        if data == nil
                        {
                            CommonFunctionsClass.sharedInstance().showAlert(title:"Server Alert", text: "Something doesn't seem right, Please try again!", imageName: "alertServer")
                            
                            MBProgressHUD.hideAllHUDsForView(viewController.view, animated: true)
                        }
                        else
                        {
                            
                            
                            
                            
                            do {
                                
                                let result = NSString(data: data!, encoding:NSASCIIStringEncoding)!
                                print("Body: Result from forget password \(result)")
                                
                                let anyObj: Any = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
                                
                                self.delegate.serverResponseArrived(anyObj)
                                
                                
                                
                            } catch {
                                print("json error: \(error)")
                                CommonFunctionsClass.sharedInstance().showAlert(title:"Server Alert", text: "Something doesn't seem right, Please try again!", imageName: "alertServer")
                                
                                indicatorClass.sharedInstance().hideIndicator()
                                MBProgressHUD.hideAllHUDsForView(viewController.view, animated: true)
                            }
                            
                            
                            
                            
                            
                        }
                }
            })
            
            task.resume()
        }
        else
        {
             CommonFunctionsClass.sharedInstance().showAlert(title:"No Internet Connection", text: "You are currently offline.", imageName: "alertInternet")

            MBProgressHUD.hideAllHUDsForView(viewController.view, animated: true)
            
        }
        
    }

    */

    
    
    
    
    
    
    
    /////////////////////////////////////////////////////////////////////////////////

    //MARK:- Post request for get the categories from the database
    //MARK:-
    
    func postRequestCategories(parameterString : String)
    {
        
        let isConnectedInternet = CommonFunctionsClass.sharedInstance().isConnectedToNetwork()
        
        if isConnectedInternet
        {
            let request = NSMutableURLRequest(url: NSURL(string: "\(appUrl)get_categories")! as URL) //Live url
            
            request.httpMethod = "POST"
            let postString: NSDictionary = ["userId": parameterString]
            
            
            
            do {
                let jsonData = try!  JSONSerialization.data(withJSONObject: postString, options: [])
                request.httpBody = jsonData
                
                
                // here "jsonData" is the dictionary encoded in JSON data
            } catch let error as NSError {
                print(error)
            }
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            
            
            //request.httpBody = postString.dataUsingEncoding(String.Encoding.utf8)
            let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
                guard error == nil && data != nil else {                                                          // check for fundamental networking error
                    print("error=\(error)")
                    return
                }
                
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(response)")
                }
                
                let responseString = String(data: data!, encoding: String.Encoding.utf8)
                
                DispatchQueue.main.async {
                    
                    do
                    {
                        let anyObj: Any = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                     
                        
                        let rslt = anyObj as! NSMutableDictionary
                        
                        let status = rslt.value(forKey: "status") as! NSNumber
                        
                        if status == 1
                        {
                            
                            print("category list is updated")
                            
                            
                            let tagsArr = rslt.value(forKey: "data") as! NSMutableArray
                            
                           
                            let tagsArrOld = Udefaults.mutableArrayValue(forKey: "categoriesFromWeb")
                            
                            
                            
                            if tagsArrOld .isEqual(to: tagsArr as [AnyObject]) {
                                  print("No new category is added")
                               
                            }
                            else
                            {
                                  print("New categories are added")
                                Udefaults .setValue(nil , forKey: "Interests")
                                Udefaults .setValue(nil , forKey: "IntrestsId")
                                Udefaults .setValue(tagsArr, forKey: "categoriesFromWeb")//
                            }
                            
                        }
                        else{
                            
                            print("Not a valid user")
                            
                            
                        }
                        
                        
                    } catch
                    {
                        print("json error: \(error)")
                
                        
                    }
                    
                }
                
              
                
                
                
            }
            task.resume()
            
        }
        else
        {
            CommonFunctionsClass.sharedInstance().showAlert(title: "No Internet Connection", text: "You are currently offline.", imageName: "alertInternet")

           
        }
    }
    
    
    
    
    
    
    
    
    
    
    /////////////////////////////////////////////////////////////////////////////////
    
    //MARK:- Post api for add image in story from detail screen
    //MARK:-
    
    func postRequestWithMultipleImage(parameterString : String , parameters: NSDictionary , viewController : UIViewController)
    {
        let isConnectedInternet = CommonFunctionsClass.sharedInstance().isConnectedToNetwork()
        
        if isConnectedInternet
        {
           // CommonFunctionsClass.sharedInstance().startIndicator(viewController.view)
            
            var urlString = NSString(string:"\(baseUrladdImage)")
            print("WS URL----->>" + (urlString as String))
            
            urlString = urlString .replacingOccurrences(of: " ", with: "%20") as NSString
            
            let url:NSURL = NSURL(string: urlString as String)!
            let session = URLSession.shared
            

         let request = NSMutableURLRequest(url: url as URL)
            request.httpMethod = "POST"
            request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
            
            
            do {
                let jsonData = try!  JSONSerialization.data(withJSONObject: parameters, options: [])
                request.httpBody = jsonData
                
                // here "jsonData" is the dictionary encoded in JSON data
            } catch let error as NSError {
                print(error)
            }   
            
            
          
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")

            
            
            let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
                
                OperationQueue.main.addOperation
                    {
                        
                        if data == nil
                        {
                            CommonFunctionsClass.sharedInstance().showAlert(title: "Server Alert", text: "Something doesn't seem right, Please try again!", imageName: "alertServer")
                            
                            MBProgressHUD.hideAllHUDs(for: viewController.view, animated: true)
                        }
                        else
                        {
                            
                            
                            do {
                                
                               
                                
                               // let anyObj: Any = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                                
                                
                               DispatchQueue.global(qos: .background).async {
                              
                                    let uId = Udefaults .string(forKey: "userLoginId")
                                    let objt = storyCountClass()
                                
                                let dic:NSDictionary = ["userId": uId!]
                                objt.postRequestForcountStory(parameterString: dic)
                                objt.postRequestForcountStoryandBucket(dic)
                                
                                }
                                
                                
                                MBProgressHUD.hideAllHUDs(for: viewController.view, animated: true)
                                
                            } catch
                            {
                                print("json error: \(error)")
                               CommonFunctionsClass.sharedInstance().showAlert(title: "Server Alert", text: "Something doesn't seem right, Please try again!", imageName: "alertServer")
                                
                            MBProgressHUD.hideAllHUDs(for: viewController.view, animated: true)
                            }
                            
                            
                            
          
                            
                        }
                }
            })
            
            task.resume()
        }
        else
        {
            CommonFunctionsClass.sharedInstance().showAlert(title: "No Internet Connection", text: "You are currently offline.", imageName: "alertInternet")

            MBProgressHUD.hideAllHUDs(for: viewController.view, animated: true)
        }
        
    }
    
    
    
    
   
    
    
    
    
    
    
    
    
    
    //////////////////////////////////////////////////////////////
    //MARK:- Post api to send the user selected locations
    //MARK:-
    
    func postRequestSearchedLocations(parameterString : String, totalLocations: NSDictionary , viewController : UIViewController)
    {
        
        let isConnectedInternet = CommonFunctionsClass.sharedInstance().isConnectedToNetwork()
        
        if isConnectedInternet
        {
            print(parameterString)
            print(totalLocations)
            
            var urlString = NSString(string:"\(searchStory)")
            print("WS URL----->>" + (urlString as String))
            
            urlString = urlString .replacingOccurrences(of: " ", with: "%20") as NSString
            
            let url:NSURL = NSURL(string: urlString as String)!
            let session = URLSession.shared
            let request = NSMutableURLRequest(url: url as URL)
            request.httpMethod = "POST"
            request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
            
            do {
                let jsonData = try!  JSONSerialization.data(withJSONObject: totalLocations, options: [])
                request.httpBody = jsonData
                
            } catch let error as NSError {
                print(error)
            }
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            
            
            let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
                
                OperationQueue.main.addOperation
                    {
                        
                        if data == nil
                        {
                            
                            MBProgressHUD.hideAllHUDs(for: viewController.view, animated: true)
                        }
                        else
                        {
                            
                            
                            do {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
                                
                            } catch
                            {
                                print("json error: \(error)")
                               
                            }
                            
                       
                            
                        }
                }
            })
            
            task.resume()
        }
        else
        {
            
        }
        
    }

    
    
    
   // MARK:- //////////////------- POST REQUEST TO LIKE UNLIKE-----///////
    //MARK:-
    
    func postRequestLikeUnlikeImage(parameters: NSDictionary , viewController : UIViewController)
    {
        let isConnectedInternet = CommonFunctionsClass.sharedInstance().isConnectedToNetwork()
        
        if isConnectedInternet
        {
            // CommonFunctionsClass.sharedInstance().startIndicator(viewController.view)
            
            var urlString = NSString(string:"\(likeUnlike)")
            print("WS URL----->>" + (urlString as String))
            
            urlString = urlString .replacingOccurrences(of: " ", with: "%20") as NSString
            
            let url:NSURL = NSURL(string: urlString as String)!
            let session = URLSession.shared
            session.configuration.timeoutIntervalForRequest=20
           
            let request = NSMutableURLRequest(url: url as URL)
            request.httpMethod = "POST"
            request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
            
            do
            {
                let jsonData = try!  JSONSerialization.data(withJSONObject: parameters, options: [])
                request.httpBody = jsonData
                
                // here "jsonData" is the dictionary encoded in JSON data
            } catch let error as NSError
            {
                print(error)
            }
            
            
          
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            
            let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
                
                OperationQueue.main.addOperation
                    {
                        
                        if data == nil
                        {
                             CommonFunctionsClass.sharedInstance().showAlert(title: "Server Alert", text: "Something doesn't seem right, Please try again!", imageName: "alertServer")
                            
                            MBProgressHUD.hideAllHUDs(for: viewController.view, animated: true)
                        }
                        else
                        {
                            
                            
                            do {
                                
                                
                            } catch
                            {
                                print("json error: \(error)")
                               CommonFunctionsClass.sharedInstance().showAlert(title: "Server Alert", text: "Something doesn't seem right, Please try again!", imageName: "alertServer")
                            }
                            
                       
                            
                            
                        }
                }
            })
            
            task.resume()
        }
        else
        {
            CommonFunctionsClass.sharedInstance().showAlert(title: "No Internet Connection", text: "You are currently offline.", imageName: "alertInternet")

            MBProgressHUD.hideAllHUDs(for: viewController.view, animated: true)
        }
        
    }

    
   
    
    
    
    
    
  
    
    //MARK: Post api to delete uploaded images from the pyt app
    //MARK:-
    
    func postRequestDeleteImagePyt(parameters: NSString , viewController : UIViewController)
    {
        let isConnectedInternet = CommonFunctionsClass.sharedInstance().isConnectedToNetwork()
        
        if isConnectedInternet
        {
            // CommonFunctionsClass.sharedInstance().startIndicator(viewController.view)
            
            var urlString = NSString(string:"\(deletePytImage)")
            print("WS URL----->>" + (urlString as String))
            
            urlString = urlString .replacingOccurrences(of: " ", with: "%20") as NSString
            
            let url:NSURL = NSURL(string: urlString as String)!
            let session = URLSession.shared
            
            let request = NSMutableURLRequest(url: url as URL)
            request.httpMethod = "POST"
            request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
            let postString = parameters
            request.httpBody = postString.data(using: String.Encoding.utf8.rawValue)
            
            
            let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
                
                OperationQueue.main.addOperation
                    {
                        
                        MBProgressHUD.hideAllHUDs(for: viewController.view, animated: true)
                        
                        if data == nil
                        {
                            CommonFunctionsClass.sharedInstance().showAlert(title: "Server Alert", text: "Something doesn't seem right, Please try again!", imageName: "alertServer")
                        }
                        else
                        {
                            
                            do
                            {
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadDelete"), object: nil)
                               
                                
                            } catch
                            {
                                print("json error: \(error)")
                              
                                
                            }
                            
                            
                        }
                }
            })
            
            task.resume()
        }
        else
        {
            CommonFunctionsClass.sharedInstance().showAlert(title: "No Internet Connection", text: "You are currently offline.", imageName: "alertInternet")

            MBProgressHUD.hideAllHUDs(for: viewController.view, animated: true)
        }
        
    }
    

    
    
    
    
    //MARK: Post api to delete uploaded images from the pyt app in interest screen
    //MARK:-
    
    func postRequestDeleteImagePytFromInterest(parameters: NSString , viewController : UIViewController)
    {
        let isConnectedInternet = CommonFunctionsClass.sharedInstance().isConnectedToNetwork()
        
        if isConnectedInternet
        {
            // CommonFunctionsClass.sharedInstance().startIndicator(viewController.view)
            
            var urlString = NSString(string:"\(deletePytImage)")
            print("WS URL----->>" + (urlString as String))
            
            urlString = urlString .replacingOccurrences(of: " ", with: "%20") as NSString
            
            let url:NSURL = NSURL(string: urlString as String)!
            let session = URLSession.shared
            
            
            let request = NSMutableURLRequest(url: url as URL)
            request.httpMethod = "POST"
            
            request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
            let postString = parameters
            request.httpBody = postString.data(using: String.Encoding.utf8.rawValue)
            
            
            let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
                
                OperationQueue.main.addOperation
                    {
                        
                        if data == nil
                        {
                            CommonFunctionsClass.sharedInstance().showAlert(title: "Server Alert", text: "Something doesn't seem right, Please try again!", imageName: "alertServer")
                        }
                        else
                        {
                            
                            do
                            {
                               
                                let anyObj: Any = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                                
                                
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadDeleteInterest"), object: nil)
                                
                                
                            } catch
                            {
                                print("json error: \(error)")
                               CommonFunctionsClass.sharedInstance().showAlert(title: "Server Alert", text: "Something doesn't seem right, Please try again!", imageName: "alertServer")
                                
                            }
                    
                            
                        }
                }
            })
            
            task.resume()
        }
        else
        {
            CommonFunctionsClass.sharedInstance().showAlert(title: "No Internet Connection", text: "You are currently offline.", imageName: "alertInternet")

            MBProgressHUD.hideAllHUDs(for: viewController.view, animated: true)
        }
        
    }
    
    
    
    
    
    
    
    
    
    
    //MARK: Post api to delete uploaded images from the pyt app in Detail screen
    //MARK:-
    
    func postRequestDeleteImagePytFromDetail(parameters: NSString , viewController : UIViewController)
    {
        let isConnectedInternet = CommonFunctionsClass.sharedInstance().isConnectedToNetwork()
        
        if isConnectedInternet
        {
            // CommonFunctionsClass.sharedInstance().startIndicator(viewController.view)
            
            var urlString = NSString(string:"\(deletePytImage)")
            print("WS URL----->>" + (urlString as String))
            
            urlString = urlString .replacingOccurrences(of: " ", with: "%20") as NSString
            
            let url:NSURL = NSURL(string: urlString as String)!
            let session = URLSession.shared
            
            let request = NSMutableURLRequest(url: url as URL)
            request.httpMethod = "POST"
            
            request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
            let postString = parameters
            request.httpBody = postString.data(using: String.Encoding.utf8.rawValue)
            
            
            let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
                
                OperationQueue.main.addOperation
                    {
                        
                        MBProgressHUD.hideAllHUDs(for: viewController.view, animated: true)
                        
                        if data == nil
                        {
                            CommonFunctionsClass.sharedInstance().showAlert(title: "Server Alert", text: "Something doesn't seem right, Please try again!", imageName: "alertServer")
                        }
                        else
                        {
                            
                            
                            do {
                                
                               
                                
                                let anyObj: Any = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                                
                                
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadDeleteDetail"), object: nil)
                                
                                
                            } catch
                            {
                                print("json error: \(error)")
                                CommonFunctionsClass.sharedInstance().showAlert(title: "Server Alert", text: "Something doesn't seem right, Please try again!", imageName: "alertServer")
                                
                            }
                            
                       
                            
                        }
                }
            })
            
            task.resume()
        }
        else
        {
            CommonFunctionsClass.sharedInstance().showAlert(title: "No Internet Connection", text: "You are currently offline.", imageName: "alertInternet")

            MBProgressHUD.hideAllHUDs(for: viewController.view, animated: true)
        }
        
    }
    

    
    
    
    
    
    
    
      
    
    //TRY CATCH BLOCK
    
    
    //                            do {
    //
    //
    //                                let anyObj = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as! [String:AnyObject]
    //                                 self.delegate.serverResponseArrived(anyObj)
    //
    //
    //
    //                            } catch {
    //                                print("json error: \(error)")
    //                                CommonFunctionsClass.sharedInstance().alertViewOpen("Sorry there is some issue in backend, Please try again", viewController: viewController)
    //
    //                            }
    

    
    
    
    
}

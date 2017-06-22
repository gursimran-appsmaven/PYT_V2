//
//  apiClassInterest.swift
//  PYT
//
//  Created by Niteesh on 26/11/16.
//  Copyright © 2016 appsMaven. All rights reserved.
//

import UIKit
import SwiftyJSON
import SystemConfiguration
import MBProgressHUD


///create a delegate for intract with server
protocol apiClassInterestDelegate
{
    func serverResponseArrivedInterest(_ Response:AnyObject)
}



class apiClassInterest: NSObject {

    
    
    let baseUrlInterest = ""
    let baseUrlInterestData = "\(appUrl)" //LIVE URL
    
    //let baseUrlInterestData = "http://35.163.56.71/" //Test Url
   
    
    var delegate:apiClassInterestDelegate! = nil
    
    static var instance: apiClassInterest!
    
    // SHARED INSTANCE
    class func sharedInstance() -> apiClassInterest
    {
        self.instance = (self.instance ?? apiClassInterest())
        return self.instance
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    ////////////////////////////////////////////////////////////////////////////////
    //MARK:- Posr api to save the interests of the user in database
    //MARK:-
    
    func postRequestInterest(_ parameterString : NSDictionary , viewController : UIViewController)
    {
        
        let isConnectedInternet = CommonFunctionsClass.sharedInstance().isConnectedToNetwork()
        
        if isConnectedInternet
        {
        
//            let request = NSMutableURLRequest(URL: NSURL(string: "\(appUrl)setUserInterest")!) //Live Url

            let request = NSMutableURLRequest(url: URL(string: "\(appUrl)set_user_interests")!)
            
            
            request.httpMethod = "POST"
            
//            let postString = parameterString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
//            print(postString)
            
            let session = URLSession.shared
            session.configuration.timeoutIntervalForRequest=20
          //  session.configuration.timeoutIntervalForResource=30
            
            
            //request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
            
            do {
                let jsonData = try!  JSONSerialization.data(withJSONObject: parameterString, options: [])
                request.httpBody = jsonData
                
                
                // here "jsonData" is the dictionary encoded in JSON data
            } catch let error as NSError {
                print(error)
            }
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            
            
            
            let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
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
                
                
                DispatchQueue.main.async(execute: {
                    
                    do {
                        
                        let result = NSString(data: data!, encoding:String.Encoding.ascii)!
                        print("Body: \(result)")
                        
                        let anyObj: AnyObject = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                        
                        if (viewController .isKind(of: chooseInterestsViewController.self)){
                            
                           MBProgressHUD.hideAllHUDs(for: viewController.view, animated: true)
                            self.delegate.serverResponseArrivedInterest(anyObj)
                            
                        }
                        
                        
                        //  self.delegate.serverResponseArrived(anyObj)
                        
                        
                        
                        
                    } catch {
                        print("json error: \(error)")
                        CommonFunctionsClass.sharedInstance().showAlert("Server Alert", text: "Something doesn't seem right, Please try again!", imageName: "alertServer")
                        indicatorClass.sharedInstance().hideIndicator()
                        
                        
                        
                    }
                    
                    
                  
                    
                    
                    
                })
                
                
                
                
                
                
                
            }) 
            task.resume()
            
        }
        else
        {
            CommonFunctionsClass.sharedInstance().showAlert("No Internet Connection", text: "You are currently offline.", imageName: "alertInternet")
            MBProgressHUD.hideAllHUDs(for: viewController.view, animated: true)
        }
        
        
    }
    
    
    
    
    
    
    
    ///////// testing for interest wise data api
    
    
    func postRequestInterestWiseData(_ parameterString : NSMutableDictionary , viewController : UIViewController)
    {
        
        let isConnectedInternet = CommonFunctionsClass.sharedInstance().isConnectedToNetwork()
        
        if isConnectedInternet
        {
            //let request = NSMutableURLRequest(URL: NSURL(string: "\(appUrl)getPicturesInterest")!)//old version
           
            // let request = NSMutableURLRequest(URL: NSURL(string: "\(appUrl)arrange_category_vise")!)//new version
         
            let request = NSMutableURLRequest(url: URL(string: "\(appUrl)arrange_category_vise_V2")!)
            
            request.httpMethod = "POST"
            
           print(parameterString)
            
            
            do {
                let jsonData = try!  JSONSerialization.data(withJSONObject: parameterString, options: [])
                request.httpBody = jsonData
               
                
                // here "jsonData" is the dictionary encoded in JSON data
            } catch let error as NSError {
                print(error)
            }
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")

            
            
          
            
            
            
            //let session = NSURLSession.sharedSession()
           // session.configuration.timeoutIntervalForRequest=20
           
            let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
                guard error == nil && data != nil else {                                                          // check for fundamental networking error
                    print("error=\(error)")
                    return
                }
                
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    //print("response = \(response)")
                }
                
                  //let responseString = String(data: data!, encoding: NSUTF8StringEncoding)
                //print("responseString = \(responseString)")
                
                
                DispatchQueue.main.async(execute: {
                    
                    do {
                        
                        let result = NSString(data: data!, encoding:String.Encoding.ascii)!
                        print("Body: result in intrest screen interest wisedata \(result)")
                        
                        let anyObj: AnyObject = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                        
                        
//                        SweetAlert().showAlert("PYT", subTitle: result as String, style: AlertStyle.Error)
                        
                        self.delegate.serverResponseArrivedInterest(anyObj)
                        
                        
                    } catch
                    {
                        print("json error: \(error)")
                        CommonFunctionsClass.sharedInstance().showAlert("Server Alert", text: "Something doesn't seem right, Please try again!", imageName: "alertServer")
                        indicatorClass.sharedInstance().hideIndicator()
                        
                        
                        
                    }
                    MBProgressHUD.hideAllHUDs(for: viewController.view, animated: true)
                    
                    
                    
                })
                
                
                
                
                
                
                
            }) 
            task.resume()
            
        }
        else
        {
            CommonFunctionsClass.sharedInstance().showAlert("No Internet Connection", text: "You are currently offline.", imageName: "alertInternet")
            //MBProgressHUD.hideHUDForView(viewController.view, animated: true)
            MBProgressHUD.hideAllHUDs(for: viewController.view, animated: true)
        }
        
        
    }
    
    
    
    
    
    //////////////////////////////--------- Post api to Trending Places------------///////////////
    
    

    
    
    
    ////////////////////////////////////////////////////////////////////////
    //MARK:- Post api to get the trending locations
    //MARK:-
    
    func postApiForTrendingLocations(_ viewController: UIViewController, userid: NSString)
    {
        let isConnectedInternet = CommonFunctionsClass.sharedInstance().isConnectedToNetwork()
        
        if isConnectedInternet
        {
//            let request = NSMutableURLRequest(URL: NSURL(string: "\(appUrl)trending")!)//old version
            
            let request = NSMutableURLRequest(url: URL(string: "\(appUrl)get_trending_places")!)//New version
            
           
            
            request.httpMethod = "POST"
            
            
            let newDict:NSDictionary = ["userId": userid]
            
          

            do {
                let jsonData = try!  JSONSerialization.data(withJSONObject: newDict, options: [])
                request.httpBody = jsonData
                
                
                // here "jsonData" is the dictionary encoded in JSON data
            } catch let error as NSError {
                print(error)
            }
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            

            
//            request.HTTPBody = userid.dataUsingEncoding(NSUTF8StringEncoding)
            let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
                guard error == nil && data != nil else {                                                          // check for fundamental networking error
                    print("error=\(error)")
                    return
                }
                
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    
                }
                
                
                
                DispatchQueue.main.async(execute: {
                    
                    do {
                        
                        let result = NSString(data: data!, encoding:String.Encoding.ascii)!
                        print("Body: \(result)")
                        
                        let anyObj: AnyObject = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                        
                        self.delegate.serverResponseArrivedInterest(anyObj)
                        
                    } catch {
                        print("json error: \(error)")
                        CommonFunctionsClass.sharedInstance().showAlert("Server Alert", text: "Something doesn't seem right, Please try again!", imageName: "alertServer")
                        
                        
                        
                        
                    }
                    
                    
                    
                    
                })
                
                
                
                
                
                
                
            }) 
            task.resume()
            
        }
        else
        {
            CommonFunctionsClass.sharedInstance().showAlert("No Internet Connection", text: "You are currently offline.", imageName: "alertInternet")
        }
        
    }
    
    
    
    
    
    

    
    
    
    

    
    
    
    
}

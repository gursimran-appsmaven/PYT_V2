//
//  storyCountClass.swift
//  PYT
//
//  Created by Niteesh on 13/12/16.
//  Copyright © 2016 appsMaven. All rights reserved.
//

import UIKit
import SwiftyJSON
import SystemConfiguration





var countArray = NSDictionary()
var bucketImagesArrayGlobal = NSMutableArray()



class storyCountClass: NSObject
{
    
    ////////- post for get count
    
    func postRequestForcountStory(parameterString : NSDictionary)
    {
        
        
        
        let isConnectedInternet = CommonFunctionsClass.sharedInstance().isConnectedToNetwork()
        
        if isConnectedInternet
        {
           
            var urlString = NSString(string:"\(appUrl)get_story")
         
            
            
            print("WS URL----->>" + (urlString as String))
            
            urlString = urlString .replacingOccurrences(of: " ", with: "%20") as NSString
            
            let url:NSURL = NSURL(string: urlString as String)!
            let session = URLSession.shared
            
            let request = NSMutableURLRequest(url: url as URL)
            request.httpMethod = "POST"
            request.cachePolicy = NSURLRequest .CachePolicy.reloadIgnoringCacheData
            
            do {
                let jsonData = try!  JSONSerialization.data(withJSONObject: parameterString, options: [])
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

                        }
                        else
                        {
                                                        
                            
                            
                            do
                            {
                                let anyObj: Any = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                                
                                let result = NSString(data: data!, encoding:String.Encoding.ascii.rawValue)!
                                print("Body: Result from story count \(result)")

                                
                                
                                basicInfo = NSMutableDictionary()
                                basicInfo = anyObj as! NSMutableDictionary
                                
                                let status = basicInfo.value(forKey: "status") as! NSNumber
                                
                                if status == 1
                                {
                                   // if jsonArray.count>0{
                                        countArray=basicInfo
                                        print(basicInfo)
                                    
                                        
//                                        bucketListTotalCount = "0"
//                                        if countArray.object(forKey: "bucketCount") != nil
//                                        {
//                                            if let bktCount = countArray.value(forKey: "bucketCount"){
//                                                
//                                                bucketListTotalCount = "\(bktCount)"
//                                            }
                                    
                                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadCount"), object: nil)
                                    
                                    
                                    
                               // }
                                    //}
 
                                }
 
                                else if(status == 5){
                                    
                                }
                                
                               
                                
                                    
                                    
                                    
                                    
                                    
                    
                               
                                
                                
                            }
                            catch {
                                print("json error: in getting count of the storyyyyyy------------------------------------- \(error)")
//                                CommonFunctionsClass.sharedInstance().alertViewOpen("Sorry there is some issue in backend, Please try again", viewController: viewController)
                            }
                            
                            
                            
                            
                            
                        }
                        
                }
        
                
            })
                
            
            task.resume()
        }
        else
        {
//            CommonFunctionsClass.sharedInstance().alertViewOpen("Please Check Internet Connection", viewController: viewController)
        }
            
            
                        
        
    }
    
    
    
    
    
    
    
    
    
    
    

}

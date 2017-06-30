import UIKit
import Foundation
import SystemConfiguration
import SwiftyJSON

typealias ServiceResponse = (JSON, NSError?, Int) -> Void
typealias OnSuccess = (_ statusCode: Int) -> ()
typealias OnError = (_ error: NSError) -> ()
typealias OnFetchFailure = (_ errorMessage: String) -> ()

class ApiServices: NSObject
{
    //upload_image
    var BaseURL="\(appUrl)upload_image" //Live Url
    //var BaseURL="\(appUrl)api/photo"
    
   // var BaseURL="http://35.163.56.71/api/photo"//Test Url
    
    
    static let sharedInstance=ApiServices()
    var status=Int()
    
    
    //MARK: Post Image Api
    
    func postRequest(_ urlToAppend: String,params: NSDictionary,data:NSDictionary  ,onCompletion: @escaping (JSON, NSError?, Int) -> Void)
    {
        let connected: Bool = isConnectedToNetwork()
        if(connected==true)
        {
            makePostRequest(urlToAppend,param:params,data:data, onCompletion: {json, err, stat in
                
                onCompletion(json as JSON, err as NSError!, stat as Int)
            })
        }
        else
        {
            //onCompletion(nil, nil, 405)
            let jsn:JSON = ["status": 0]
            let er:NSError? = nil
            onCompletion(jsn, er, 405)
        }
    }
    
    
    
    func makePostRequest(_ urlToAppend: String,param: NSDictionary,data:NSDictionary, onCompletion: @escaping ServiceResponse)
    {
        var url="\(BaseURL)" as String
        url = url + urlToAppend
        print(url)
       // let BoundaryConstant: String = "----------V2ymHFg03ehbqgZCaKO6jy"
        
        // string constant for the post parameter 'file'. My server uses this name: `file`. Your's may differ
        
        // the server url to which the image (or the media) is uploaded. Use your server url here
        
        // create request
        
        print("Data to uplod in server: - \(data)")
        
        
        let request: NSMutableURLRequest = NSMutableURLRequest()
       
        request.httpMethod = "POST"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        
        print(data)
        
        
        do {
            let jsonData = try!  JSONSerialization.data(withJSONObject: data, options: [])
            request.httpBody = jsonData
            
            
            // here "jsonData" is the dictionary encoded in JSON data
        } catch let error as NSError {
            print(error)
        }
        
        
        
        // request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(prmt, options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        

        
      
        
        // set URL
        request.url =  URL(string: url)!
        let session = URLSession.shared
        
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            
            if let  resp = response as? HTTPURLResponse
                {
                    self.status = resp.statusCode
                    let json:JSON = ["data": data!] //JSON(data: data!)
                    let resstr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                    print(resstr)

                    
                    onCompletion(json, error as NSError?, self.status)
                }
                else{
                    print(response as? HTTPURLResponse)
                }
        })


        
        task.resume()
        
        
    }
    
    
    /*
    
     func postRequest(urlToAppend: String,params: NSDictionary,data:NSMutableDictionary  ,onCompletion: (JSON, NSError!, Int) -> Void)
     {
     let connected: Bool = isConnectedToNetwork()
     if(connected==true)
     {
     makePostRequest(urlToAppend,param:params,data:data, onCompletion: {json, err, stat in
     
     onCompletion(json as JSON, err as NSError!, stat as Int)
     })
     }
     else
     {
     onCompletion(nil, nil, 405)
     }
     }
     
     func makePostRequest(urlToAppend: String,param: NSDictionary,data:NSMutableDictionary, onCompletion: ServiceResponse)
     {
     var url="\(BaseURL)" as String
     url = url + urlToAppend
     print(url)
     let BoundaryConstant: String = "----------V2ymHFg03ehbqgZCaKO6jy"
     // string constant for the post parameter 'file'. My server uses this name: `file`. Your's may differ
     let FileParamConstant: String = "userPhoto"
     // the server url to which the image (or the media) is uploaded. Use your server url here
     
     // create request
     let request: NSMutableURLRequest = NSMutableURLRequest()
     request.HTTPShouldHandleCookies = false
     //  request.timeoutInterval = 30
     request.HTTPMethod = "POST"
     // set Content-Type in HTTP header
     let contentType: String = "multipart/form-data; boundary=\(BoundaryConstant)"
     request.addValue(contentType, forHTTPHeaderField: "Content-Type")
     // post body
     let body: NSMutableData = NSMutableData()
     // add params (all params are strings)
     
     var i = Int()
     
     for (key,value) in param {
     body.appendData("--\(BoundaryConstant)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
     body.appendData("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
     body.appendData("\(value as! String)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
     }
     
     
     
     for (key2, value2) in data
     {
     
     i += 1
     
     
     body.appendData("--\(BoundaryConstant)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
     body.appendData("Content-Disposition: form-data; name=\"\(key2)\"; filename=\"image\(i).png\"\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
     body.appendData(String("Content-Type: image/png\r\n\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
     body.appendData(value2 as! NSData)
     body.appendData(String(format: "\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
     
     
     print(BoundaryConstant)
     
     // setting the body of the post to the reqeust
     
     }
     
     
     //print(body.description)
     body.appendData("--\(BoundaryConstant)--\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
     request.HTTPBody = body
     
     // set URL
     request.URL =  NSURL(string: url)!
     let session = NSURLSession.sharedSession()
     
     let task = session.dataTaskWithRequest(request, completionHandler:
     {data, response, error -> Void in
     if let  resp = response as? NSHTTPURLResponse
     {
     self.status = resp.statusCode
     let json:JSON = JSON(data: data!)
     let resstr = NSString(data: data!, encoding: NSUTF8StringEncoding)
     print(resstr)
     
     
     onCompletion(json, error, self.status)
     }
     else{
     print(response as? NSHTTPURLResponse)
     }
     })
     
     
     
     task.resume()
     
     
     }
    */
    
    //MARK: Reachability
    fileprivate func isConnectedToNetwork() -> Bool {
 
        let reachability  = SCNetworkReachabilityCreateWithName(kCFAllocatorDefault, "localhost")
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(reachability!, &flags){
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        
        return (isReachable && !needsConnection)
        
    }
    
    
    
    
    
    
 }



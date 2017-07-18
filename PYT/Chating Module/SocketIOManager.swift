//
//  SocketIOManager.swift
//  PYT
//
//  Created by Niteesh on 02/02/17.
//  Copyright © 2017 appsMaven. All rights reserved.
//

import UIKit

class SocketIOManager: NSObject {

    
     static let sharedInstance = SocketIOManager()
    
    override init() {
        super.init()
    }
    
    
    
    ////and we’ll provide the IP address of our computer and the designated port.
    
    var socket: SocketIOClient = SocketIOClient(socketURL: NSURL (string: appUrl) as! URL) //SocketIOClient(socketURL: (URL(string: "\(appUrl)")! as NSURL) as URL)
    
    
    
    
    
    ///define two methods now that will make use of the above socket property. The first one connects the app to the server, and the second makes the disconnection.
    //MARK: create and disconnect connection
    
    func establishConnection()
    {
        socket.connect()
    }
    
    
    func reconnect()
    {

    }
    
    
    
    func closeConnection() {
        socket.disconnect()
    }
    
    
    
   
    
    
    
    
    
    
    //MARK: Function to send the messages
    
    
    func sendMessage(_ message: String, withNickname nickname: String, receiverId: NSMutableArray, locType: String, msgType: NSNumber, locName: String, receiverName: String, receiverProfile: String, senderName: String, senderDp: String, displayMsg: String, placeId: NSString, largeUrls: NSString, thumbUrls: NSString) {
        
       // print("senderid = \(nickname), receiver id=\(receiverId), msgType = \(msgType), message=\(message), senderId=\(nickname), receiverName=\(receiverName), receiverDP=\(receiverProfile), Sender Dp= \(senderDp) receiverId= \(receiverId)")
        
//        socket.emit("start_conversation",["msg": message, "senderId": nickname,"to": receiverId, "locationName": locName, "locationType": locType, "msgType": msgType, "toUserDP": receiverProfile, "toUserName": receiverName, "senderName": senderName, "senderDp": senderDp, "displayMsg": displayMsg  ])

        
        socket.emit("start_conversation",["msg": message, "userId": nickname, "between": receiverId,  "placeType": locType, "placeId": placeId, "userName": senderName, "userDp": senderDp, "placeName": locName, "msgType":msgType, "thumbUrl": thumbUrls, "largeUrl": largeUrls ])
        
        
        
        
    }
    
    
    
    //on the basis of conv Id
    
    func sendMessagewithConvId(_ message: String, withNickname nickname: String, receiverId: NSMutableArray, locType: String, msgType: NSNumber, locName: String, receiverName: String, receiverProfile: String, senderName: String, senderDp: String, displayMsg: String, placeId: NSString, largeUrls: NSString, thumbUrls: NSString, convId: NSString) {
        
        
        
        
        socket.emit("do_chat",["msg": message, "userId": nickname, "between": receiverId,   "userName": senderName, "userDp": senderDp, "msgType":msgType, "thumbUrl": thumbUrls, "largeUrl": largeUrls, "converId": convId, "placeId": placeId, "placeName":locName, "placeType":locType ])
        
    }
    
    
    
    
    
    //TEMP Image Function
    
    
//    func sendMessageImage(message: String, withNickname nickname: String, receiverId: String, locType: String, msgType: String, locName: String, receiverName: String, receiverProfile: String, senderName: String, senderDp: String) {
//        
//      //  print("senderid = \(nickname), receiver id=\(receiverId), msgType = \(msgType), message=\(message), senderId=\(nickname), receiverName=\(receiverName), receiverDP=\(receiverProfile), Sender Dp= \(senderDp) receiverId= \(receiverId)")
//        
//
//        
//        socket.emit("image",["msg": "Hello Kunal Testing is here for images" ])
//        
//        
//    }
    
    
    
    
    
    
    //MARK: Clear the chat messages older counter
    
    func sendCounter(_ userId: String) {
        
       
        
        socket.emit("clear_read_count",["userId": userId ])
        
        
    }
    
    
    
    
    
    //MARK: Get the messages from the server
    ///
    
    func getChatMessage(_ completionHandler: @escaping (_ messageInfo: [String: AnyObject]) -> Void) {
        socket.on("receive_message") { (dataArray, socketAck) -> Void in
            var messageDictionary = [String: AnyObject]()
           
             
            let dataArr = NSArray(array: dataArray)
            print(dataArr)
            
            
            messageDictionary["senderId"] = ((dataArr.object(at: 0) as! NSDictionary).value(forKey: "sender") as! NSDictionary).value(forKey: "_id") as AnyObject?   //((dataArr.object(at: 0) as AnyObject).value(forKey: "sender") as AnyObject).value(forKey: "_id") as? String ?? ""
            
            let incommsgDic = (dataArr.object(at: 0) as AnyObject).value(forKey: "msg") as! NSDictionary
            
            let jsonData = try! JSONSerialization.data(withJSONObject: incommsgDic, options: JSONSerialization.WritingOptions.prettyPrinted)
            
            let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
            
            
            
            
            messageDictionary["msg"] = jsonString as AnyObject? //dataArr.objectAtIndex(0).valueForKey("msg") as? String ?? ""
            messageDictionary["LocationName"] = (dataArr.object(at: 0) as AnyObject).value(forKey: "placeName") as AnyObject
                //(dataArr.object(at: 0) as AnyObject).value(forKey: "placeName") as? String ?? ""
             messageDictionary["LocationType"] = (dataArr.object(at: 0) as AnyObject).value(forKey: "placeId") as AnyObject // dataArr.object(at: 0).value(forKey: "placeId") as? String ?? ""
             print(messageDictionary)
            
            completionHandler(messageDictionary)
        }
    }
    
    
    
    
    
    func getChatMessageNotify(_ completionHandler: @escaping (_ messageInfo: [String: AnyObject]) -> Void) {
        socket.on("notify_count") { (dataArray, socketAck) -> Void in
            var messageDictionary = [String: AnyObject]()
            
            let dataArr = NSArray(array: dataArray)
        print(dataArr)
            
             messageDictionary["count"] = (dataArr.object(at: 0) as AnyObject).value(forKey: "count") as AnyObject //dataArr.object(at: 0).value(forKey: "count")
           //print(messageDictionary)
            completionHandler(messageDictionary)
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //The first action we have to take is to send a new user’s nickname to the server, using of course the Socket.IO library. Open the SocketIOManager.swift file, and define the following method:
    //Send the nice name here id will be send of the user
    func connectToServerWithNickname(_ senderId: String, completionHandler: (_ userList: [[String: AnyObject]]?) -> Void) {
        
        print(senderId)
        
         let defaults = UserDefaults.standard
        let userName = defaults .string(forKey: "userLoginName")!
      
        
        let userPic = defaults .string(forKey: "userProfilePic")!
        
        
        socket.emit("touch_server", ["userId":senderId, "name": userName, "picture": userPic])
        
        
        
      //  listenForOtherMessages()

        
        ///For future use
        /*
         socket.on("userList") { ( dataArray, ack) -> Void in
         completionHandler(userList: dataArray[0] as! [[String: AnyObject]])
         }
         
         
         //Leave chat 
         func exitChatWithNickname(nickname: String, completionHandler: () -> Void) {
         socket.emit("exitUser", nickname)
         completionHandler()
         }
         
         
        //Exit action
         @IBAction func exitChat(sender: AnyObject) {
         SocketIOManager.sharedInstance.exitChatWithNickname(nickname) { () -> Void in
         dispatch_async(dispatch_get_main_queue(), { () -> Void in
         self.nickname = nil
         self.users.removeAll()
         self.tblUserList.hidden = true
         self.askForNickname()
         })
         }
         }
         
         
         //MARK: Being Notified When Users Type Messages
         //
         func sendStartTypingMessage(nickname: String) {
         socket.emit("startType", nickname)
         }
         
         //// Notify when stop type
         
         func sendStopTypingMessage(nickname: String) {
         socket.emit("stopType", nickname)
         }
         
 */
        
        
        
        
        
    }
    
    
    
    fileprivate func listenForOtherMessages() {
        socket.on("userConnectUpdate") { (dataArray, socketAck) -> Void in
            NotificationCenter.default.post(name: Notification.Name(rawValue: "userWasConnectedNotification"), object: dataArray[0] as! [String: AnyObject])
            
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1.0 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { () -> Void in
                
                //dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), {
                let defaults = UserDefaults.standard
                let uId = defaults .string(forKey: "userLoginId")
                
                if uId == nil || uId == ""{
                    
                }
                else
                {
                    SocketIOManager.sharedInstance.connectToServerWithNickname(uId!, completionHandler: { (userList) -> Void in
                        DispatchQueue.main.async(execute: { () -> Void in
                            if userList != nil {
                                
                               // print(userList)
                                
                            }
                        })
                    })
                }
                
                
                
                //})
                
            }
            
            
        }
        
        socket.on("userExitUpdate") { (dataArray, socketAck) -> Void in
            NotificationCenter.default.post(name: Notification.Name(rawValue: "userWasDisconnectedNotification"), object: dataArray[0] as! String)
        }
        
//        socket.on("userTypingUpdate") { (dataArray, socketAck) -> Void in
//            NSNotificationCenter.defaultCenter().postNotificationName("userTypingNotification", object: dataArray[0] as? [String: AnyObject])
//        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
}

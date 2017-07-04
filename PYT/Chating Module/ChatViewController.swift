




//
//  ChatViewController.swift
//  PYT
//
//  Created by Niteesh on 23/01/17.
//  Copyright © 2017 appsMaven. All rights reserved.
//

import UIKit
import IQKeyboardManager
import JSQMessagesViewController
import SDWebImage

class ChatViewController: JSQMessagesViewController {
    
   
    private var photoMessageMap = [String: JSQPhotoMediaItem]()
    
    var userAvatarImage: JSQMessagesAvatarImage!
    var myAvataerImage: JSQMessagesAvatarImage!
    
    
    
    //Messages
    let incomingBubble = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImage(with: UIColor(red: 153/255, green: 189/255, blue: 131/255, alpha: 1.0))
    let outgoingBubble = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImage(with: UIColor.white)
    var messages = [JSQMessage]()
    
    
    var CountTableArray = NSMutableArray() 
    var selectedTag = Int()
    var largeUrl = NSString()
    var thumbUrl = NSString()
    var locationName = NSString()
    var locationType = NSString()
    var locationId = NSString()
    var receiver_Id = NSString()
    var receiverName = NSString()
    var receiverProfile = NSString()
    var myProfilePic = NSString()
    var myName = NSString()
    var convertationId = NSString()
    
    
    var avatars = [String: JSQMessagesAvatarImage]()
    
    var chatingIndicator = UIActivityIndicatorView()
     let uId = Udefaults .string(forKey: "userLoginId")
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.headerLabel.text = receiverName as String
        self.backBtn .setImage(UIImage (named:"back"), for: UIControlState .normal)
        
        self.backBtn .addTarget(self, action: #selector(ChatViewController.backButtonAction) , for: UIControlEvents .touchUpInside)
        self.deleteButton .addTarget(self, action: #selector(ChatViewController.backButtonAction), for: .touchUpInside)
        
        
        
    }
    
    //BACK Action
    
    func backButtonAction() -> Void {
        
        if zoomImageScrollView.isHidden==false {
            
            zoomImageScrollView.isHidden=true
        }
        else
        {
        self.navigationController?.popViewController(animated: true)
            
        //self.tabBarController?.setTabBarVisible(visible: true, animated: true)
        }
    }
    
    
    ////Add this method in view did appear to get the messages
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        SocketIOManager.sharedInstance.getChatMessage { (messageInfo) -> Void in
           DispatchQueue.main.async(execute: {
               
                print(messageInfo)
                let otherId = messageInfo["senderId"] as! String
                let msg = messageInfo["msg"] as! String
                let msgType = "1"
                
                
//                if messageInfo["LocationName"] as! String == self.locationName as String && messageInfo["LocationType"] as! String == self.locationType as String {

                if messageInfo["LocationType"] as! String == self.locationId as String {
                    
                    let message =  JSQMessage(senderId: otherId, senderDisplayName: msgType, date: NSDate() as Date!, text: msg) // JSQMessage(senderId: otherId, displayName: msgType, text: msg)
                    self.messages .append(message!)
                    //self.messages += [message]
                    
                    JSQSystemSoundPlayer .jsq_playMessageReceivedAlert()
                    
                    self.reloadMessagesView()
                    
                    
//                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(5.0 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
//                        
//                        self.reloadMessagesView()
//                        
//                    }
                    
                    
                    
                    
                }
                else{
                    print("different location message")
                    
                }
                
                
                
              
                
                
                
                
               
            })
        }
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        zoomImageScrollView.isHidden=true
        
        
        
        
       
       
        
        //SocketIOManager.sharedInstance.closeConnection()
       chatingIndicator.startAnimating()
        chatingIndicator.center=self.view.center
        self.view .addSubview(chatingIndicator)
        self.view.bringSubview(toFront: chatingIndicator)
        SocketIOManager.sharedInstance.establishConnection()
         self.getOlderMessages(userId: uId!)  ///older messages will be appears
        
       
        
        
        
        
        
        
        
        
        
        
        
        //self.tabBarController?.tabBar.isHidden = true
        // Do any additional setup after loading the view.
       
        selectedTag = 91190
       
       
        
       
        
        self.senderId=uId!

        
        
        IQKeyboardManager.shared().shouldResignOnTouchOutside=true
        IQKeyboardManager.shared().isEnableAutoToolbar=true
        
        
        
        self.setup()
      //  self.addDemoMessages()
        
        //var messages: [JSQMessage] = [JSQMessage]()
       // var avatarDict = [String: JSQMessagesAvatarImage]()
        
        
        
        
        
       // IQKeyboardManager.sharedManager().shouldResignOnTouchOutside=true
        
        self.imagesTableView? .reloadData()
        
        zoomImageScrollView.delegate=self
        zoomImageScrollView.showsVerticalScrollIndicator=false
        zoomImageScrollView.showsHorizontalScrollIndicator=false
        
     
        
         myName = Udefaults .string(forKey: "userLoginName")! as NSString
         myProfilePic = Udefaults .string(forKey: "userProfilePic")! as NSString
        
        
        
        self .createAvatar()
        
        if CountTableArray.count>0 {
            //print(CountTableArray.objectAtIndex(0).valueForKey("Thumbnail") as? String ?? "")
//            if (CountTableArray.objectAtIndex(0) as AnyObject).valueForKey("Thumbnail") as? String ?? "" == "NA" {
//                
//            }
        }
        else
        {
            //MARK: call the api to get photos
            
            self.getPhotosByLocation(my_UserId: uId!, other_UserId: receiver_Id as String, location_Name: locationName as String, location_Type: locationType as String)
        }
        
       
        
       
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.handleDisconnectedUserUpdateNotification(notification:)), name: NSNotification.Name(rawValue: "userWasDisconnectedNotification"), object: nil)
        
        //(self, selector: #selector(ChatViewController.handleDisconnectedUserUpdateNotification(_:)), name: "userWasDisconnectedNotification", object: nil)
        
        
    
        self.messagesViewBottomSpace.constant = 200
        self.openImages(sender: self)
        
        
       
}

    
    
    //MARK: Get notified when user is dicconnected 
    func handleDisconnectedUserUpdateNotification(notification: NSNotification) {
        let disconnectedUserNickname = notification.object as! String
        print("User \(disconnectedUserNickname.uppercased()) has left.")
        
        
        SocketIOManager.sharedInstance.establishConnection()
        
    }
    
    
    func handleConnectedUserUpdateNotification(notification: NSNotification) {
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            
            
//            let defaults = NSUserDefaults.standardUserDefaults()
//            let uId = defaults .stringForKey("userLoginId")
//            
//            if uId == nil || uId == ""{
//                
//            }
//            else
//            {
//                SocketIOManager.sharedInstance.connectToServerWithNickname(uId!, completionHandler: { (userList) -> Void in
//                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                        if userList != nil {
//                            
//                            //print(userList)
//                            
//                        }
//                    })
//                })
//                
//            }
//            
            
            
            
            
        }
        
        
        
        
    }

    
    
    
    
    
    
    
    //MARK: Get Photos By Location
    //MARK:
    
    
    func getPhotosByLocation(my_UserId: String, other_UserId: String, location_Name: String, location_Type:String) -> Void {
       
        //let parameterString = "senderId=\(other_UserId)&userId=\(my_UserId)&locationName=\(location_Name)&locationType=\(location_Type)"
        
        
        let prmDic: NSDictionary = ["userId":my_UserId, "senderId": other_UserId, "placeId": locationId, "placeType": location_Type]
        
        
        ////print("Parameter=\(parameterString)")
        
        let isConnectedInternet = CommonFunctionsClass.sharedInstance().isConnectedToNetwork()
        
        if isConnectedInternet
        {
//            let request = NSMutableURLRequest(URL: NSURL(string: "\(appUrl)get_images_for_chat")!)

            let request = NSMutableURLRequest(url: NSURL(string: "\(appUrl)get_images_for_chating")! as URL)
            
            
            request.httpMethod = "POST"
            let postString = prmDic
           // request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
            
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
                    //print("error=\(error)")
                    return
                }
                
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                    //print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    //print("response = \(response)")
                }
                
            
                
                DispatchQueue.main.async {

                    
                    do {
                        
                        //let result = NSString(data: data!, encoding:NSASCIIStringEncoding)!
                         //print("Body: \(result)")
                        
                       let anyObj: Any = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                        
                        basicInfo = NSMutableDictionary()
                        basicInfo = anyObj as! NSMutableDictionary
                        
                        let status = basicInfo .value(forKey: "status") as! NSNumber
                        
                        if status == 1
                        {
                            
                            let arrPhoto: NSMutableArray = basicInfo .value(forKey: "data")! as! NSMutableArray
                            
                           
                            if arrPhoto.count>0
                            {
                                for i in 0..<arrPhoto.count
                                {
                                    let thumb = (arrPhoto.object(at: i) as AnyObject).value(forKey: "imageThumb") as? String ?? ""
                                    // arrPhoto.objectAtIndex(i).valueForKey("imageThumb") as? String ?? ""
                                    
                                     let large = (arrPhoto.object(at: i) as AnyObject).value(forKey: "imageLarge") as? String ?? ""//arrPhoto.objectAtIndex(i).valueForKey("imageLarge") as? String ?? ""
                                    
                                    
                                    
                                    
                                    self.CountTableArray .add(["Thumbnail": thumb, "Large": large])
                                    
                                }
                                
                                
                            }
                            
                            
                            
                        }
                        else
                        {
                            
                           
                            
                            
                        }
                        
                        
                        self.imagesTableView.reloadData()
                        
                        
                        
                        
                    } catch {
                        //print("json error: \(error)")
                      CommonFunctionsClass.sharedInstance().showAlert(title: "Server Alert", text: "Something doesn't seem right, Please try again!", imageName: "alertServer")
                       
                        
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
    
    
    
    
    
    
    //MARK: Api to get the 10 older messages of this chat
    func getOlderMessages(userId: String ) -> Void {
        
//        let parameterString = "senderId=\(receiver_Id)&userId=\(userId)&locationName=\(locationName)&locationType=\(locationType)"

        
        let useridsArray: NSMutableArray = [userId, receiver_Id]
        
        let parameterString:NSDictionary = ["userId":userId, "placeId": locationId, "placeType": locationType, "converId":convertationId, "between": useridsArray]
        
        print("Parameter=\(parameterString)")
        
        let isConnectedInternet = CommonFunctionsClass.sharedInstance().isConnectedToNetwork()
        
        if isConnectedInternet
        {
//            let request = NSMutableURLRequest(URL: NSURL(string: "\(appUrl)chat_description")!)
            let request = NSMutableURLRequest(url: NSURL(string: "\(appUrl)get_older_messages")! as URL)
            
            
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
                    //print("error=\(error)")
                    return
                }
                
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                    //print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    //print("response = \(response)")
                }
                
                
                
                
                DispatchQueue.main.async{
                    do {
                        
                        //let result = NSString(data: data!, encoding:NSASCIIStringEncoding)!
                       //print("Body: \(result)")
                        
                        
                        let anyObj: Any = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                        
                        basicInfo = NSMutableDictionary()
                        basicInfo = anyObj as! NSMutableDictionary
                        
                        let status = basicInfo .value(forKey: "status") as! NSNumber
                        
                        if status == 1{
                            
                            let arr: NSMutableArray = basicInfo .value(forKey: "chat") as! NSMutableArray
                            
                          //  print(arr)
                            
                           
                            
                            
                            
                            for i in 0..<arr.count{
                            //print(arr.objectAtIndex(i).valueForKey("received"))
                                let msg = ((arr.object(at: i) as AnyObject).value(forKey: "sender") as AnyObject).value(forKey: "_id") as? String ?? ""// arr.objectAtIndex(i).valueForKey("sender")!.valueForKey("_id") as? String ?? ""
                           
                                var UsId = ""
                                
                                if userId == msg as! String{
                                    UsId = self.senderId
                                }
                                else{
                                    UsId = self.receiver_Id as String
                                }
                                
                                
                                
                                let incommsgDic = (arr.object(at: i) as AnyObject).value(forKey: "msg") as! NSDictionary
                                
                                let jsonData2 = try!  JSONSerialization.data(withJSONObject: incommsgDic, options: [])
                                
                                let jsonString2 = NSString(data: jsonData2, encoding: String.Encoding.utf8.rawValue)! as String
                                
                                
                                
                            let message = JSQMessage(senderId: UsId, senderDisplayName: "", date: NSDate() as Date!, text: jsonString2)
                               // print(message?.description)
                                self.messages .append(message!)
                                //self.messages += [message]
                                
                                
                                
                                
                            }
                            
                        }
                        else
                        {
                            
                          
                            
                            
                        }
                        
                        
                       self.reloadMessagesView()
                        
                        
                        
                        
                        
                    } catch {
                        //print("json error: \(error)")
                        
                        //SweetAlert().showAlert("PYT", subTitle: "Sorry there is some issue in backend, Please try again!", style: AlertStyle.Error)
                        
                       
                        
                      
                        
                    }
                    
                    
                    self.chatingIndicator.isHidden=true
                    self.chatingIndicator.stopAnimating()
                    self.chatingIndicator.removeFromSuperview()
                    
                }
                
                
                
                
                
                
                
            }
            task.resume()
            
        }
        else
        {
            CommonFunctionsClass.sharedInstance().showAlert(title: "No Internet Connection", text: "You are currently offline.", imageName: "alertInternet")
        }
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    func createAvatar()
    {
        
        
        
        
        let imgView1 = UIImageView()
        let imageView2 = UIImageView()
        
        
        
        
        
        //get my profile pic
//        let block: SDWebImageCompletionBlock! = {(image: UIImage!, error: NSError!, cacheType: SDImageCacheType!, imageURL: NSURL!) -> Void in
//            
//            if self.myProfilePic == ""
//            {
//                self.myAvataerImage = JSQMessagesAvatarImageFactory.avatarImageWithImage(UIImage (named: "user-1"), diameter: 30)
//            }
//            else{
//                if image == nil {
//                    let imageUser = UIImage (named: "user-1")
//                    self.myAvataerImage = JSQMessagesAvatarImageFactory.avatarImageWithImage(imageUser, diameter: 30)
//                }
//                else{
//                    self.myAvataerImage = JSQMessagesAvatarImageFactory.avatarImageWithImage(image, diameter: 30)
//                }
//                
//                
//            }
//            
//            
//        }
        
        //completion block of the sdwebimageview
        imgView1.image = UIImage (named: "dummyProfile2") //sd_setImageWithURL(NSURL(string: myProfilePic as String), placeholderImage: UIImage (named: "user-1"), completed: block)
        
        
        
        //
        //get user profile pic
//        let block2: SDWebImageCompletionBlock! = {(image: UIImage!, error: NSError!, cacheType: SDImageCacheType!, imageURL: NSURL!) -> Void in
//            
//            //self.finishReceivingMessage()
//            if self.receiverProfile == ""
//            {
//                self.userAvatarImage = JSQMessagesAvatarImageFactory.avatarImageWithImage(UIImage (named: "user-1"), diameter: 30)
//            }
//            else{
//                
//                if image == nil {
//                    let imageUser = UIImage (named: "user-1")
//                    self.userAvatarImage = JSQMessagesAvatarImageFactory.avatarImageWithImage(imageUser, diameter: 30)
//                }else{
//                    self.userAvatarImage = JSQMessagesAvatarImageFactory.avatarImageWithImage(image, diameter: 30)
//                }
//            }
//            
//            
//            
//            
//        }
        
        //completion block of the sdwebimageview
        imageView2.image = UIImage (named: "dummyProfile1") //sd_setImageWithURL(NSURL(string: receiverProfile as String), placeholderImage:UIImage (named: "user-1"), completed: block2)
        
        
        
        
        
        
        
        
        
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    @IBAction func openImages(sender: AnyObject) {
        
        
        
        selectedTag = 91190
        imagesTableView .reloadData()
        IQKeyboardManager.shared().resignFirstResponder()
        
        self.heightOfImagesView.constant = 200
        self .jsq_setToolbarBottomLayoutGuideConstant(0)
        
        self.view.layoutIfNeeded()
        
    }
    
    
    
 
    
    
    //MARK: Reload the messages view
    
    func reloadMessagesView() {
       
        self.collectionView?.reloadData()
        self.scrollToBottom(animated: true)
        
        
    }
    
    
    
    
    
    
    
    
    //MARK:
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        URLCache.shared.removeAllCachedResponses()
        
        //print("MEMORYWARNING AND CLEARING CACHE ")
        
        //let imageCache = SDImageCache.sharedImageCache()
        //imageCache.clearMemory()
        // imageCache.clearDisk()
        // Dispose of any resources that can be recreated.
    }
    
    }



//MARK - Setup

extension ChatViewController
{
    
    func addDemoMessages() {
        
        ////////get the messages from server
//        SocketIOManager.sharedInstance.getChatMessage { (messageInfo) -> Void in
//            dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                
//                //print(messageInfo)
//                
//                //self.chatMessages.append(messageInfo)
//                //self.tblChat.reloadData()
//                //                self.scrollToBottom()
//            })
//        }
        
        
        
        
        
        
        
        
        
        
        for i in 1...5 {
            let sender = (i%2 == 0) ? "Server" : self.senderId
            let messageContent = "Message nr. \(i)"
            let message = JSQMessage(senderId: sender, displayName: sender, text: messageContent)
           self.messages .append(message!)
            //self.messages += [message]
        }
        self.reloadMessagesView()
    }
    
    
    func setup() {
        //self.senderId = UIDevice.currentDevice().identifierForVendor?.UUIDString
        self.senderDisplayName = UIDevice.current.identifierForVendor?.uuidString
    }
}







//MARK - Data Source
extension ChatViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       // //print(collectionView)
        
       
           
            return self.messages.count
            
        
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData!
    {
    
    //override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        

        let message = self.messages[indexPath.item]
        let result = convertStringToDictionary(text: message.text)!
        
        //// get the string and convert it into json and get the values what you need
        
       
      //  print(result)
        if result["msgType"] as! NSNumber == 1 {
         
            
            let JSQTypeMessage = JSQMessage(senderId: message.senderId, senderDisplayName: "", date: NSDate() as Date!, text: result["msg"]as! String)
            print(JSQTypeMessage)
            
            return JSQTypeMessage
            
        }
        
        else
        {
            var stringUrl:NSURL?
           
            
            stringUrl = NSURL(string: result["thumbUrl"] as! String )
            
            let tempImageView = UIImageView(image: nil)
         
            
//            let block: SDWebImageCompletionBlock! = {(image: UIImage!, error: NSError!, cacheType: SDImageCacheType!, imageURL: NSURL!) -> Void in
//               
//               
//             
//                
//            }
            
            //completion block of the sdwebimageview
            tempImageView.sd_setImage(with: stringUrl as URL!, placeholderImage: nil) //sd_setImageWithURL(stringUrl, placeholderImage: nil, completed: block)
            
            
            let photoImage = JSQPhotoMediaItem(image: tempImageView.image)
            
            
            
            // This makes it so the bubble can be incoming rather than just all outgoing.
            if !(message.senderId == self.senderId) {
                photoImage?.appliesMediaViewMaskAsOutgoing = false
            }
            
            let message = JSQMessage(senderId: message.senderId, displayName: self.senderDisplayName, media: photoImage)
            
            
            return message
        }
        
        
//        let JSQTypeMessage = JSQMessage(senderId: message.senderId, senderDisplayName: "", date: message.date, text: message.text)
//        
//        return JSQTypeMessage
        
            
     
    
    
    }
    
    
    
//    override func collectionView(collectionView: JSQMessagesCollectionView!, didDeleteMessageAtIndexPath indexPath: NSIndexPath!) {
//        self.messages.removeAtIndex(indexPath.row)
//    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource!
    {
    
//    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        let data = messages[indexPath.row]
        switch(data.senderId) {
        case self.senderId:
            return self.outgoingBubble
        default:
            return self.incomingBubble
        }
    }
    
    
    
    
    
    
        
  //MARK: Users profile pictures
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource!
    {
        
    //override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource!

        let message = messages[indexPath.row]
        
        
        
        if (message.senderId == self.senderId) {
            //reurn my profile
         return myAvataerImage
            
                    
        }
        else
        {
            return userAvatarImage
        }
        
        
    }
    
    
    
    
    
    
    
    
    
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, didTapMessageBubbleAt indexPath: IndexPath!)
    {
    //override func collectionView(collectionView: JSQMessagesCollectionView, didTapMessageBubbleAtIndexPath indexPath: NSIndexPath) {
      
        IQKeyboardManager.shared().resignFirstResponder()
        
        self.bottomSpaceOfZoomView.constant = 0//self.view.frame.size.height
        //print("Bottdcfhsvhjacgc--\(bottomSpaceOfZoomView.constant)")
        self.view .layoutIfNeeded()
        
        let message = self.messages[indexPath.row] //self.messageModelData.messages[indexPath.row]
       
        
        
        
        let result = convertStringToDictionary(text: message.text)!
        // convertStringToDictionary(message.text)!
        
        print(result)
        
        //// get the string and convert it into json and get the values what you need
       
        if result["msgType"] as! NSNumber == 1 {
            //print("Text message   Dont do any thing")
            
        }
            
        else{
            var stringUrl = ""
             var largeUrl = ""
            
            
          
            
            stringUrl = result["thumbUrl"] as! String
            largeUrl = result["largeUrl"] as! String
            
            
             self .openImageZoom(thumbnail: stringUrl as NSString, large: largeUrl as NSString)
            
            
        }
        
        
        
    }

    
    
    
    
    
    
    
    
    
    
    
    
    
}




//MARK - Toolbar
extension ChatViewController
{
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        
    
    //override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
        
         zoomImageScrollView.isHidden=true //Hide the zoom view
        
       
        if thumbUrl == "" || largeUrl == "" {
           
        
        
        
        if  selectedTag == 91190 // if message is text message
        {
            
            var first20 = String(text.characters.prefix(40))
           
            
            
            let length: NSString = text as NSString
            if length.length > 40 {
                first20 = "\(first20)..."
            }
            
            print(first20)
            
            
            
            //// convert the message into json
            let tempDict = NSMutableDictionary()
            tempDict .setValue(text, forKey: "msg")
            tempDict .setValue(1, forKey: "msgType")// here 1 is for text
            tempDict .setValue(self.senderId, forKey: "sender")
            print(tempDict)
            
            let jsonData = try!  JSONSerialization.data(withJSONObject: tempDict, options: [])
            
            let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
            
            print(jsonString)
            
            
            
            //toUserDP
            //toUserName
            
             let message = JSQMessage(senderId: self.senderId, senderDisplayName: senderDisplayName, date: date, text: jsonString)
            
            self.messages .append(message!)
            //self.messages += [message]
            

                       
           //SocketIOManager.sharedInstance.sendMessage(text, withNickname: self.senderId, receiverId: receiver_Id as String) //senderId)
            
            
//            SocketIOManager.sharedInstance.sendMessage(jsonString, withNickname: self.senderId, receiverId: receiver_Id as String, locType: locationType as String, msgType: "1", locName: locationName as String, receiverName: receiverName as String, receiverProfile: receiverProfile as String, senderName: myName as String, senderDp: myProfilePic as String, displayMsg: first20 )

            //let defaults = NSUserDefaults.standardUserDefaults()
            //let uId = defaults .stringForKey("userLoginId")
            
            let useridsArray: NSMutableArray = [self.senderId, receiver_Id]
            
            
            if convertationId == "" {
               SocketIOManager.sharedInstance.sendMessage(text, withNickname: self.senderId, receiverId: useridsArray, locType: locationType as String, msgType: 1, locName: locationName as String, receiverName: receiverName as String, receiverProfile: receiverProfile as String, senderName: myName as String, senderDp: myProfilePic as String, displayMsg: first20, placeId: locationId,largeUrls: "", thumbUrls: "")
            }
            else
            {
               
                
                
                SocketIOManager.sharedInstance.sendMessagewithConvId(text, withNickname: self.senderId, receiverId: useridsArray, locType: locationType as String, msgType: 1, locName: locationName as String, receiverName: receiverName as String, receiverProfile: receiverProfile as String, senderName: myName as String, senderDp: myProfilePic as String, displayMsg: first20, placeId: locationId,largeUrls: "", thumbUrls: "", convId: convertationId)
                
                
            }
            
            
            
            
            
            
            
           //self.reloadMessagesView()
            self.finishSendingMessage()
            
        }
        else
        {
            self.addPhotoMediaMessage()
        }
            
        }
        
        
            
            // send the both messages
        else
        {
        
            
            
            
            self.addPhotoMediaMessage()
            

            
            
            
            if text == "" || text == " " || text == "\n" {
                
                
            }
            else
            {
            
                var first20 = String(text.characters.prefix(40))
                
                
                
                let length: NSString = text as NSString
                if length.length > 40 {
                    first20 = "\(first20)..."
                }
                
                print(first20)
                
                
                
                //// convert the message into json
                let tempDict = NSMutableDictionary()
                tempDict .setValue(text, forKey: "msg")
                tempDict .setValue(1, forKey: "msgType")// here 1 is for text
                tempDict .setValue(self.senderId, forKey: "sender")
                print(tempDict)
                
                let jsonData = try!  JSONSerialization.data(withJSONObject: tempDict, options: [])
                
                let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
                
                print(jsonString)
                
                
                
                //toUserDP
                //toUserName
                
                let message = JSQMessage(senderId: self.senderId, senderDisplayName: senderDisplayName, date: date, text: jsonString)
                
               self.messages .append(message!)
                //self.messages += [message]
                
                
                
                
                
                let useridsArray: NSMutableArray = [self.senderId, receiver_Id]
                
                
                if convertationId == "" {
                    SocketIOManager.sharedInstance.sendMessage(text, withNickname: self.senderId, receiverId: useridsArray, locType: locationType as String, msgType: 1, locName: locationName as String, receiverName: receiverName as String, receiverProfile: receiverProfile as String, senderName: myName as String, senderDp: myProfilePic as String, displayMsg: first20, placeId: locationId,largeUrls: "", thumbUrls: "")
                }
                else
                {
                    SocketIOManager.sharedInstance.sendMessagewithConvId(text, withNickname: self.senderId, receiverId: useridsArray, locType: locationType as String, msgType: 1, locName: locationName as String, receiverName: receiverName as String, receiverProfile: receiverProfile as String, senderName: myName as String, senderDp: myProfilePic as String, displayMsg: first20, placeId: locationId,largeUrls: "", thumbUrls: "", convId: convertationId)
                    
                    
                }
                
                
                
                
                
                
                
                //self.reloadMessagesView()
                self.finishSendingMessage()
                

                
                
            }
            
            
            
                
            
            
            
            
            
            
        }
        
        
            
    }
    
    override func textViewDidBeginEditing(_ textView: UITextView) {
        
    
    //override func textViewDidBeginEditing(textView: UITextView) {
       
        if thumbUrl == "" || largeUrl == "" {
            self.zoomImageScrollView.isHidden = true
           self.heightOfImagesView.constant=0
            
            if (textView != self.inputToolbar.contentView.textView) {
                return
            }

            textView .becomeFirstResponder()
            if (self.automaticallyScrollsToMostRecentMessage) {
                self.scrollToBottom(animated: false)
            }
            
        }
            
        else{
            
            
            
            
            self.bottomSpaceOfZoomView.constant = 200//self.view.frame.size.height - inputToolbar.frame.size.height
            
          
            
            
            self.zoomImageScrollView.isHidden = false
            self.heightOfImagesView.constant=0
           
            self.view .layoutIfNeeded()
        }
        
        
    }
    override func textViewDidEndEditing(_ textView: UITextView)
    {
    
    //override func textViewDidEndEditing(textView: UITextView) {
        
        if (textView != self.inputToolbar.contentView.textView) {
            return;
        }
        
        thumbUrl = ""
        largeUrl = ""
        inputToolbar.contentView.rightBarButtonItem.isEnabled = false
        inputToolbar.contentView.textView.text = nil
        
        self.heightOfImagesView.constant = 0
        textView .resignFirstResponder()
         zoomImageScrollView.isHidden = true
        
        self.jsq_setToolbarBottomLayoutGuideConstant(0)
        
    }
    
    
    

    override func didPressAccessoryButton(_ sender: UIButton!) {
        
        // SocketIOManager.sharedInstance.reconnect()
        
        thumbUrl = ""
        largeUrl = ""
        
        if self.heightOfImagesView.constant == 200 {
         self.heightOfImagesView.constant = 0
            self.messagesViewBottomSpace.constant = 0
            inputToolbar.contentView.textView.becomeFirstResponder()
             selectedTag = 91190
            zoomImageScrollView.isHidden=true
            inputToolbar.contentView.rightBarButtonItem.isEnabled = false
            inputToolbar.contentView.textView.text = nil
        }
        
        
        else
        {
            
        self.openImages(sender: self)
            self.scrollToBottom(animated: true)
            zoomImageScrollView.isHidden = true
            inputToolbar.contentView.rightBarButtonItem.isEnabled = false
            inputToolbar.contentView.textView.text = nil
        }

        
        
       }
    
    
    /////Send button action to send the messages to the server
    
   
    
    
    //MARK: Function to get the dictionary from the response
    //MARK:
    func convertStringToDictionary(text: String) -> [String:AnyObject]? {
        if let data = text.data(using: String.Encoding.utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject]
            } catch let error as NSError {
                //print(error)
            }
        }
        return nil
    }
    
    
    
    
    
    
    
    
    
    
    
}



extension ChatViewController {
   
    override func numberOfSections(in tableView: UITableView) -> Int
    {
    //override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
       // //print("Returning num sections")
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
    //override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ////print("Returning num rows")
        
        self.view .layoutIfNeeded()
        
        if CountTableArray.count % 3 == 0 {
            return CountTableArray.count/3
        }
        else
        {
            return CountTableArray.count/3 + 1
            
        }
        
        
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
    //override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //print("Trying to return cell")
     
        let CellIdentifier = "CellImagesMessages"
        
        var cell:UITableViewCell
        
        if let reuseCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier) {
            cell=reuseCell
        } else {
            cell=UITableViewCell()
            cell.frame=CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 110)
            //(style: .Default, reuseIdentifier: CellIdentifier)
        }
       
        let arr = NSMutableArray()
        
        let count = indexPath.row * 3
         ////print(count)// to show the 3 images at a time in row of tableview
        
        for i in count..<CountTableArray.count {
          // //print(i)
            arr .add(["Images":CountTableArray .object(at: i), "Tag":i])
            if arr.count==3 {
                break
            }
        }
       
        
        let newBtn1 = UIButton()
        let newBtn2 = UIButton()
        let newBtn3 = UIButton()
        
        let indicator1 = UIActivityIndicatorView()
        
        
        cell.clipsToBounds=true
        
        
        let buttonWidth = cell.frame.size.width/3 - 10
        var buttonSpace = (buttonWidth * 3 )
        
        buttonSpace = cell.frame.size.width - buttonSpace
       
        buttonSpace = buttonSpace / 3 - 2 //+ 10
        
       // //print("Button space = \(buttonSpace) \n button Width = \(buttonWidth)")
        
        
        for j in 0..<arr.count {
            
            
            
            let imageName2 = ((arr.object(at: j) as AnyObject).value(forKey: "Images") as AnyObject).value(forKey: "Thumbnail") as? String ?? ""
            //((arr.objectAtIndex(j) as AnyObject).valueForKey("Images")! as AnyObject).valueForKey("Thumbnail") as? String ?? ""
            ////print(imageName2)
            
            let url2 = NSURL(string: imageName2 )
            let pImage : UIImage = UIImage(named:"dummyBackground2")!
            
            
            
            if j == 0
            {
                newBtn1.frame = CGRect(x: buttonSpace, y:0, width: buttonWidth, height: 95)//CGRectMake(buttonSpace, 0, buttonWidth, 95)
                newBtn1 .addTarget(self, action: #selector(ChatViewController.buttonAction(sender:)), for: .touchUpInside)
                cell.contentView .addSubview(newBtn1)
                newBtn1.imageView!.contentMode = .scaleAspectFill
                newBtn1.clipsToBounds=true
                newBtn1.tag = (arr.object(at: j) as AnyObject).value(forKey: "Tag") as! Int
                
                indicator1.center = newBtn1.center
                newBtn1 .addSubview(indicator1)
                indicator1 .startAnimating()
                indicator1.activityIndicatorViewStyle = .gray
                indicator1 .removeFromSuperview()
                
//                let block: SDWebImageCompletionBlock! = {(image: UIImage!, error: NSError!, cacheType: SDImageCacheType!, imageURL: NSURL!) -> Void in
//                    
//                    indicator1 .removeFromSuperview()
//                }
                
                newBtn1.sd_setImage(with: url2 as URL!, for: .normal, placeholderImage: pImage)
                //newBtn1.imageView?.sd_setImage(with: url2 as URL!, placeholderImage: pImage) //sd_setImageWithURL(url2, forState: .Normal, placeholderImage: pImage, completed: block)
                
                if newBtn1.tag == selectedTag {
                    
                    newBtn1.layer.borderWidth=3.5
                    newBtn1.layer.borderColor = UIColor .green.cgColor
                    
                }
                
               
                    
                
            }
            else if (j == 1)
            {
                newBtn2.frame = CGRect(x: newBtn1.frame.origin.x + buttonWidth + buttonSpace, y: 0, width: buttonWidth, height: 95)//CGRectMake(newBtn1.frame.origin.x + buttonWidth + buttonSpace , 0, buttonWidth, 95)
               newBtn2 .addTarget(self, action: #selector(ChatViewController.buttonAction(sender:)), for: .touchUpInside)
                cell.contentView .addSubview(newBtn2)
                newBtn2.imageView!.contentMode = .scaleAspectFill
                newBtn2.clipsToBounds=true
                newBtn2.tag = (arr.object(at: j) as AnyObject).value(forKey: "Tag") as! Int
                
                indicator1.center = newBtn2.center
                newBtn2 .addSubview(indicator1)
                indicator1 .startAnimating()
                indicator1.activityIndicatorViewStyle = .gray
                indicator1 .removeFromSuperview()
                
//                let block: SDWebImageCompletionBlock! = {(image: UIImage!, error: NSError!, cacheType: SDImageCacheType!, imageURL: NSURL!) -> Void in
//                    indicator1 .removeFromSuperview()
//                }
                
                newBtn2.sd_setImage(with: url2 as URL!, for: .normal, placeholderImage: pImage)
                
                //newBtn2.imageView?.sd_setImage(with: url2 as URL!, placeholderImage: pImage) //sd_setImageWithURL(url2, forState: .Normal, placeholderImage: pImage, completed: block)
                
                
                if newBtn2.tag == selectedTag {
                    
                    newBtn2.layer.borderWidth=3.5
                    newBtn2.layer.borderColor = UIColor .green.cgColor
                    
                }
                
                
            }
                
            else
            {
                newBtn3.frame = CGRect(x: newBtn2.frame.origin.x + buttonWidth + buttonSpace, y: 0, width: buttonWidth, height: 95)
                //CGRectMake(newBtn2.frame.origin.x + buttonWidth + buttonSpace , 0, buttonWidth, 95)
                // newBtn.addTarget(self, action: #selector(self.urSelctor), forControlEvents: .TouchUpInside)
                newBtn3 .addTarget(self, action: #selector(ChatViewController.buttonAction(sender:)), for: .touchUpInside)
        
                cell.contentView .addSubview(newBtn3)
               
                newBtn3.tag = (arr.object(at: j) as AnyObject).value(forKey: "Tag") as! Int
                
                indicator1.center = newBtn3.center
                newBtn3.imageView!.contentMode = .scaleAspectFill
                newBtn3.clipsToBounds=true
                newBtn3 .addSubview(indicator1)
                indicator1 .startAnimating()
                indicator1.activityIndicatorViewStyle = .gray
                indicator1 .removeFromSuperview()
//                let block: SDWebImageCompletionBlock! = {(image: UIImage!, error: NSError!, cacheType: SDImageCacheType!, imageURL: NSURL!) -> Void in
//                    indicator1 .removeFromSuperview()
//                }
                
                newBtn3.sd_setImage(with: url2 as URL!, for: .normal, placeholderImage: pImage)
                //newBtn3.imageView?.sd_setImage(with: url2 as URL!, placeholderImage: pImage) //sd_setImageWithURL(url2, forState: .Normal, placeholderImage: pImage, completed: block)
                
                if newBtn3.tag == selectedTag {
                    
                    newBtn3.layer.borderWidth=3.5
                    newBtn3.layer.borderColor = UIColor .green.cgColor
                    
                }
            }
            
            
            
        }
        
        
        
        /*
 
         let imageName2 = hotelImagesArray.valueForKey("normal") .objectAtIndex(indexPath.row)
         let url2 = NSURL(string: imageName2 as! String)
         let pImage : UIImage = UIImage(named:"backgroundImage")!
         
         
         let block: SDWebImageCompletionBlock! = {(image: UIImage!, error: NSError!, cacheType: SDImageCacheType!, imageURL: NSURL!) -> Void in
         
         activityIndicatorView .removeFromSuperview()
         }
         
         //completion block of the sdwebimageview
         locationimage2.contentMode = .ScaleAspectFill
         locationimage2.sd_setImageWithURL(url2, placeholderImage: pImage, completed: block)
         
 */
        

        
        
        
        
      
       
      
        return cell
    }
    
    
    
    
    func buttonAction(sender: Any) {
        //print("Button tapped")
        //print(sender.tag)
        
        
        bottomSpaceOfZoomView.constant = self.view.frame.size.height - inputToolbar.frame.origin.y
        //print(bottomSpaceOfZoomView.constant)
        
        zoomImageScrollView.isHidden=false
        self.view .bringSubview(toFront: zoomImageScrollView)
        
        zoomIndicator.isHidden=false
        zoomIndicator.startAnimating()
        
        zoomImageScrollView.minimumZoomScale = 1.0
        zoomImageScrollView.maximumZoomScale = 5.0
        zoomImageScrollView.zoomScale = 1.0
        zoomImageScrollView .contentSize = zoomImageView.frame.size //CGSizeMake(zoomImageView.frame.size.width, zoomImageView.frame.size.height)
        
        
        
        //print(CountTableArray.objectAtIndex(sender.tag))
        
        
        let imageLarge = (CountTableArray.object(at: (sender as AnyObject).tag) as AnyObject).value(forKey: "Large") as? String ?? ""
        let imageThumbnail = (CountTableArray.object(at: (sender as AnyObject).tag) as AnyObject).value(forKey: "Thumbnail") as? String ?? ""
        
        largeUrl = imageLarge as NSString
        thumbUrl = imageThumbnail as NSString
        
        
        let urlLarge = NSURL(string: imageLarge )
         let urlThumb = NSURL(string: imageThumbnail )
        
        let pImage : UIImage = UIImage(named:"dummyBackground2")!
        zoomImageView.sd_setImage(with: urlThumb as! URL, placeholderImage: pImage)
        //d_setImageWithURL(urlThumb, placeholderImage: pImage)
        
        selectedTag = (sender as AnyObject).tag //assign the value into varibble so that sjhow the green border in tableview
        
        imagesTableView .reloadData()
        
        inputToolbar.contentView.rightBarButtonItem.isEnabled = true
        
        
        
        
        self.zoomIndicator.stopAnimating()
        self.zoomIndicator.isHidden=true
        
//        let block: SDWebImageCompletionBlock! = {(image: UIImage!, error: NSError!, cacheType: SDImageCacheType!, imageURL: NSURL!) -> Void in
//        
//        self.zoomIndicator.stopAnimating()
//            self.zoomIndicator.isHidden=true
//        
//        }
        
        zoomImageView.sd_setImage(with: urlLarge as! URL, placeholderImage: zoomImageView.image) //sd_setImageWithURL(urlLarge, placeholderImage: zoomImageView.image, completed: block)
        
       
        
        
        
        
      // self.addPhotoMediaMessage()
        
        
    }

    
    func addPhotoMediaMessage() {
        
        
        let tempDict = NSMutableDictionary()
        
        tempDict .setValue(2, forKey: "msgType")// here 2 is for image
        tempDict .setValue(self.senderId, forKey: "sender")
        tempDict .setValue("", forKey: "msg")
        print(tempDict)
        
        
        let tempDict2 = NSMutableDictionary()
        tempDict2 .setValue(thumbUrl, forKey: "thumbUrl")
        tempDict2.setValue(largeUrl, forKey: "largeUrl")
        tempDict2 .setValue(2, forKey: "msgType")// here 2 is for image
        
       
        print(tempDict)
       
        
        
        
        //let jsonData = try! NSJSONSerialization.dataWithJSONObject(tempDict, options: NSJSONWritingOptions.PrettyPrinted)
        //let jsonString = NSString(data: jsonData, encoding: NSUTF8StringEncoding)! as String
        
       
        ///display
        let jsonData2 = try!  JSONSerialization.data(withJSONObject: tempDict2, options: [])
        let jsonString2 = NSString(data: jsonData2, encoding: String.Encoding.utf8.rawValue)! as String
        
        
        
        
        //print(jsonString)
        
       
        
        let photoMessage = JSQMessage(senderId: self.senderId, senderDisplayName: "1", date: NSDate() as Date!, text: jsonString2 as String) //JSQMessage(senderId: self.senderId, displayName: thumbUrl as String, media: photoItem)
        
        self.messages.append(photoMessage!)
       
//        SocketIOManager.sharedInstance.sendMessage(jsonString as String, withNickname: self.senderId, receiverId: receiver_Id as String, locType: locationType as String, msgType: "2", locName: locationName as String, receiverName: receiverName as String, receiverProfile: receiverProfile as String, senderName: myName as String, senderDp: myProfilePic as String)
       

        //4-Apr        SocketIOManager.sharedInstance.sendMessage(jsonString, withNickname: self.senderId, receiverId: receiver_Id as String, locType: locationType as String, msgType: "1", locName: locationName as String, receiverName: receiverName as String, receiverProfile: receiverProfile as String, senderName: myName as String, senderDp: myProfilePic as String, displayMsg: "Image" )
        
        
        let useridsArray: NSMutableArray = [self.senderId, receiver_Id]
        
        
        
        if convertationId == "" {
            
        
        
        SocketIOManager.sharedInstance.sendMessage("Image", withNickname: self.senderId, receiverId: useridsArray, locType: locationType as String, msgType: 2, locName: locationName as String, receiverName: receiverName as String, receiverProfile: receiverProfile as String, senderName: myName as String, senderDp: myProfilePic as String, displayMsg: "Image", placeId: locationId, largeUrls: largeUrl , thumbUrls: thumbUrl)
        }
       else
        {
            
            
            
           SocketIOManager.sharedInstance.sendMessagewithConvId("Image", withNickname: self.senderId, receiverId: useridsArray, locType: locationType as String, msgType: 2, locName: locationName as String, receiverName: receiverName as String, receiverProfile: receiverProfile as String, senderName: myName as String, senderDp: myProfilePic as String, displayMsg: "Image", placeId: locationId, largeUrls: largeUrl , thumbUrls: thumbUrl, convId: convertationId)
            
            
       }
        
        
       
        self.reloadMessagesView()
         selectedTag = 91190
        imagesTableView .reloadData()
        inputToolbar.contentView.rightBarButtonItem.isEnabled = false
    }
    
 
    
   
    
    /*
    private func fetchImageDataAtURL(photoURL: String, forMediaItem mediaItem: JSQPhotoMediaItem, clearsPhotoMessageMapOnSuccessForKey key: String?) {
       
        let imgView = UIImageView()
        imgView.sd_setImageWithURL(NSURL(string: photoURL), placeholderImage: UIImage (named: "backgroundImage"))
        
           mediaItem.image = imgView.image
                self.collectionView.reloadData()
                
                guard key != nil else {
                    return
                }
        
        
        
    }
    
    */
    
    
    
    
    
    
    
    
    
     
     
     
    override func viewForZooming(in scrollView: UIScrollView) -> UIView?
    {
    // override func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView?
        
     if scrollView==zoomImageScrollView
     {
     return zoomImageView
     }
     
     else
     {
        return self.view
        }
        
    }
    
    
    //MARK: Show zoom image
    
    func openImageZoom(thumbnail: NSString, large: NSString) -> Void {
        
        //print(zoomImageScrollView)
         zoomImageScrollView.isHidden=false
        self.view .bringSubview(toFront: zoomImageScrollView)
        
         zoomIndicator.isHidden=false
         zoomIndicator.startAnimating()
        
          zoomImageScrollView.minimumZoomScale = 1.0
         zoomImageScrollView.maximumZoomScale = 5.0
         zoomImageScrollView.zoomScale = 1.0
         zoomImageScrollView .contentSize = zoomImageView.frame.size//CGSizeMake(zoomImageView.frame.size.width, zoomImageView.frame.size.height)
        
        
        
       
        
        
        let imageLarge = large
        let imageThumbnail = thumbnail
        
        
        let urlLarge = NSURL(string: imageLarge as String )
        let urlThumb = NSURL(string: imageThumbnail as String )
        
        let pImage : UIImage = UIImage(named:"dummyBackground2")!
       // zoomImageView.sd_setImageWithURL(urlThumb, placeholderImage: pImage)
        
        self.zoomIndicator.stopAnimating()
        self.zoomIndicator.isHidden=true
        
//         let block: SDWebImageCompletionBlock! = {(image: UIImage!, error: NSError!, cacheType: SDImageCacheType!, imageURL: NSURL!) -> Void in
//        
//         self.zoomIndicator.stopAnimating()
//            self.zoomIndicator.isHidden=true
//        
//           }
        
          zoomImageView.sd_setImage(with: urlLarge as! URL, placeholderImage: zoomImageView.image) //sd_setImageWithURL(urlLarge, placeholderImage: zoomImageView.image, completed: block)
        
        
        
        
    }
 
    
    
    
    
  
    
    
    
    
    
}











 
        

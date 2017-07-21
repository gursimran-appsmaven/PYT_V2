//
//  AppDelegate.swift
//  PYT
//
//  Created by osx on 14/06/17.
//  Copyright © 2017 osx. All rights reserved.
//

var bucketListTotalCount = "0"
var logOut: Bool = true
var profileUserData = NSMutableDictionary()
var appUrl = "http://pictureyourtravel.com/"  //Test
//var appUrl = "http://52.25.207.151/"// Live server
var Udefaults = UserDefaults.standard
var notificationBool = Bool()
var notificationSenderId = NSString()
var notificationPlaceId = NSString()
var notificationPlaceName = NSString()

import UIKit
//import Lock
//import CoreData
import IQKeyboardManager
import Fabric
import Crashlytics
import GoogleMaps
import GooglePlaces
import AWSS3
import UserNotifications


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
    
    var window: UIWindow?
    var window2: UIWindow?
    
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    var searchResult:NSMutableDictionary!
    
    
    func application(application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: () -> Void) {
        /*
         Store the completion handler.
         */
        
        // AWSS3TransferUtility.interceptApplication(application, handleEventsForBackgroundURLSession: identifier, completionHandler: completionHandler)
    }
    
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {

        
        //registerForPushNotifications(application)
        
        Udefaults.set("", forKey: "deviceToken")
        Udefaults.set(false, forKey: "multipleCity")
        Udefaults .setValue(nil, forKey: "PostInterest")
        //tool tips
        //  defaults .setInteger(0, forKey: "indexToolTips")
        //  defaults.setBool(false, forKey: "tooldetail")
        
        DispatchQueue.main.async
            {
                
//                UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil))
//                
//                UIApplication.shared.registerForRemoteNotifications()
                
                
                
                
                if #available(iOS 10, *)
                {
                    
                    //Notifications get posted to the function (delegate):  func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: () -> Void)"
                    
                    
                    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
                        
                        guard error == nil else {
                            //Display Error.. Handle Error.. etc..
                            return
                        }
                        
                        if granted {
                            
                            application.registerForRemoteNotifications()
                        }
                        else {
                            //Handle user denying permissions..
                        }
                    }
                    
                    //Register for remote notifications.. If permission above is NOT granted, all notifications are delivered silently to AppDelegate.
                    application.registerForRemoteNotifications()
                }
                else {
                    let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
                    application.registerUserNotificationSettings(settings)
                    application.registerForRemoteNotifications()
                }
                
                
                
                
                
                
                // Override point for customization after application launch.
                
                //hide status bar
                // application.statusBarHidden = true
                
                //PYTtechnologies for testing by client
                //GMSServices.provideAPIKey("AIzaSyA6938N3ppXprNoVQbTsb5c1yGUfYzS9So")
        //GMSPlacesClient.provideAPIKey("AIzaSyA6938N3ppXprNoVQbTsb5c1yGUfYzS9So")
                
                
                //niteesh.appsmaven for testing by Developer
            GMSPlacesClient.provideAPIKey("AIzaSyClITzB5uJq33QGoj2XMhlCbPssFSlePpI")
                GMSServices.provideAPIKey("AIzaSyClITzB5uJq33QGoj2XMhlCbPssFSlePpI")
                
                
                FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
                
                
                
                //iqkeyboard manager
                IQKeyboardManager.shared().isEnabled = true
                IQKeyboardManager.shared().keyboardDistanceFromTextField=90
                
                
                
                application.statusBarStyle = .lightContent //color of atatus bar
                
                
                
               /// fabric management
               
                Fabric.with([Crashlytics.self])
                Crashlytics.sharedInstance().debugMode = true

                
        }
        
        
        
        
        
        
         SocketIOManager.sharedInstance.establishConnection()
        
        
        //MARK: Auto loging into app
        
        
        /*
         let tabledata = defaults.arrayForKey("arrayOfIntrest")
         if let name = defaults.stringForKey("userLoginId") // check user login id
         {
         print(name)
         
         
         
         
         
         
         
         
         if name == ""  //if fbaccesstoken is empty check instagram token
         {
         
         
         //                let storyboard=UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
         //                let joinObj=storyboard.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
         //                let navigationController=self.window?.rootViewController as! UINavigationController
         //                navigationController.navigationBar.hidden=true
         //                navigationController.setViewControllers([joinObj], animated: true)
         
         
         
         
         }
         else
         {
         
         SocketIOManager.sharedInstance.establishConnection()
         
         if tabledata?.count<1 {
         
         
         
         
         
         // if not select any intrest show intrest screen
         
         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), {() -> Void in
         
         
         let storyboard=UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
         let joinObj=storyboard.instantiateViewControllerWithIdentifier("firstMainScreenViewController") as! firstMainScreenViewController
         let navigationController=self.window?.rootViewController as! UINavigationController
         navigationController.navigationBar.hidden=true
         navigationController.setViewControllers([joinObj], animated: true)
         
         
         
         })
         
         
         
         }
         else
         {
         
         
         
         if  let uId = defaults .stringForKey("userLoginId"){
         print(uId)
         if uId != "" {
         
         let userName = defaults .stringForKey("userLoginName")!
         
         
         Crashlytics.sharedInstance().setUserIdentifier(uId)
         Crashlytics.sharedInstance().setUserName(userName as String)
         
         
         let tagsArr: NSMutableArray = defaults.mutableArrayValueForKey("categoriesFromWeb")
         
         if tagsArr.count<1 {
         apiClass.sharedInstance().postRequestCategories(uId)
         }
         
         
         
         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), {() -> Void in
         
         apiClass.sharedInstance().postRequestCategories(uId)
         
         })
         
         
         
         
         
         
         
         
         
         
         let objt = storyCountClass()
         let objt2 = UserProfileDetailClass()
         ///story count
         // dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), {
         //dispatch_async(dispatch_get_main_queue(), {
         print("This is run on the background queue")
         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), {() -> Void in
         let dic:NSDictionary = ["userId": uId]
         objt.postRequestForcountStory(dic)
         
         // dispatch_async(dispatch_get_main_queue(), {
         
         // })
         
         
         
         ///User profile
         //dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), {
         objt2.postRequestForGetTheUserProfileData(uId)
         // })
         })
         
         
         
         
         
         }
         
         else
         {
         
         }
         
         
         
         
         }
         
         
         
         
         
         
         //MARK: Notification Section
         
         
         if let option = launchOptions {
         
         
         
         
         let info = launchOptions![UIApplicationLaunchOptionsRemoteNotificationKey]
         if (info != nil) {
         
         
         let initialViewController = storyboard.instantiateViewControllerWithIdentifier("MainTabBarViewController") as! MainTabBarViewController
         
         self.window?.rootViewController = initialViewController
         self.window?.makeKeyAndVisible()
         
         initialViewController.selectedIndex = 3
         
         //navController.pushViewController(myViewController, animated: true)
         
         
         application.applicationIconBadgeNumber = 0
         
         
         
         }
         //}
         
         
         
         
         
         
         }
         
         else
         {
         
         //                        let joinObj=storyboard.instantiateViewControllerWithIdentifier("firstMainScreenViewController") as! firstMainScreenViewController
         //                        let navigationController=self.window?.rootViewController as! UINavigationController
         //                        navigationController.navigationBar.hidden=true
         //                        navigationController.setViewControllers([joinObj], animated: true)
         //
         
         let initialViewController = storyboard.instantiateViewControllerWithIdentifier("MainTabBarViewController")
         
         
         self.window?.rootViewController = initialViewController
         self.window?.makeKeyAndVisible()
         
         
         
         
         
         }
         
         
         
         }
         
         }
         }
         
         */
        
        
        
        
        
        
        if  let uId = Udefaults .string(forKey: "userLoginId"){
            print(uId)
            if uId != "" {
                
                let userName = Udefaults .string(forKey: "userLoginName")!
                
                
                Crashlytics.sharedInstance().setUserIdentifier(uId)
                Crashlytics.sharedInstance().setUserName(userName as String)
                
                
                let tagsArr: NSMutableArray = Udefaults.mutableArrayValue(forKey: "categoriesFromWeb")
                
                if tagsArr.count<1 {
                    apiClass.sharedInstance().postRequestCategories(parameterString: uId)
                }
                
                
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                    
                    apiClass.sharedInstance().postRequestCategories(parameterString: uId)
                    
                }
                
                
                
                
                
                
                
                
                
                
                                let objt = storyCountClass()
                               // let objt2 = UserProfileDetailClass()
                                ///story count
                
                                print("This is run on the background queue")
                
                 DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                    let dic:NSDictionary = ["userId": uId]
                    
                      objt.postRequestForcountStoryandBucket(dic)
                    objt.postRequestForcountStory(parameterString: dic)
                    
                                    //objt2.postRequestForGetTheUserProfileData(uId)
                
                                }
                
                
                
                
                
            }}
        
        
        
        
        
        
        
        //MARK: Notification Section
        
        
        if let option = launchOptions
        {
            
            let info = launchOptions![UIApplicationLaunchOptionsKey.remoteNotification]
            
            
            if (info != nil)
            {
                
                  let tabledata2 = Udefaults.array(forKey: "arrayOfIntrest")
                if (tabledata2?.count)! > 0 {
                    let initialViewController = storyboard.instantiateViewController(withIdentifier: "MainTabBarViewController") as! MainTabBarViewController
                    
                    self.window?.rootViewController = initialViewController
                    self.window?.makeKeyAndVisible()
                    notificationBool = true
                    initialViewController.selectedIndex = 3
                }
                
                
                
                application.applicationIconBadgeNumber = 0
                
                
                
            }
            //}
            
            
            
            
            
            
        }
        
        
        
        
        
        
        
        
        
        /////////////////////----- Tab bar text color to white color always----------/////
        
        UITabBar.appearance().tintColor = UIColor .clear
        // Add this code to change StateNormal text Color,
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor .white], for: .normal)
        // then if StateSelected should be different, you should add this code
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor .white], for: .selected)
        
        
        
        
        
        application.applicationIconBadgeNumber = 0
        
        
        return true
        
    }
    
    
    
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool
    {
        
        print("URL : \(url)")
        if(url.scheme?.isEqual("fb1726736034214210"))! {
            print("Facebook url scheme")
            
            return FBSDKApplicationDelegate.sharedInstance().application(application, open: url as URL!, sourceApplication: sourceApplication, annotation: annotation)
            
        } else {
            
            print("another url scheme")
            return true
            
            
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    //MARK: Notification Start
    //MARK:
    
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error)
    {
        print(error)
        //CommonFunctionsClass.sharedInstance().showAlert(title: "err", text: "\(error.localizedDescription)" as NSString, imageName: "")
        ////custome alert
        
        
        
    }
    
    
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        
        print(deviceToken.description)
        
//        var myToken=deviceToken.description
//        myToken=myToken.replacingOccurrences(of: "<", with: "")
//        myToken=myToken.replacingOccurrences(of: ">", with: "")
//        myToken=myToken.replacingOccurrences(of: " ", with: "")
//        print("DEVICE TOKEN = \(myToken)")

        var myToken = ""
        for i in 0..<deviceToken.count {
            myToken = myToken + String(format: "%02.2hhx", arguments: [deviceToken[i]])
        }
        print(myToken)
        
        Udefaults.set(myToken, forKey: "deviceToken")
        Udefaults.synchronize()
        
        
        
        ////custome alert
        
        let alertController = UIAlertController(title: "Device token received", message: "Device token is: \n \(myToken)", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        
        
        let cancelAction = UIAlertAction(title: "Okay", style: UIAlertActionStyle.cancel, handler: {(alert: UIAlertAction!) in print("cancel")})
        alertController.addAction(cancelAction)
        
        // self.window?.rootViewController?.presentViewController(alertController, animated: true, completion:{})
        
        
        
        /////
        
        
        
        let tokendevice = Udefaults.string(forKey: "deviceToken")!
        print(tokendevice)
        let uId = Udefaults .string(forKey: "userLoginId")
        if Udefaults.bool(forKey: "savedDeviceToken") == true {
            
        }
            
        else
        {
            if uId != "" && uId != nil {
                
                let parameterDict: NSDictionary = ["userId": uId!, "deviceToken": ["token": tokendevice, "device": "iphone"]]
                
                  let sendTokenController = searchScreenViewController()
                
                 sendTokenController.postApiFordeviceToken(param: parameterDict)
                
            }
            else
            {
                
                print("unable to send the devicetoken")
            }
            
        }
        
        
        
        
        
    }
    
    
    
    
    
    
    
    
    func registerForPushNotifications(_ application: UIApplication) {
        
        
        //let notificationSettings = UIUserNotificationSettings(
        //  forTypes: [ .Badge, .Sound, .Alert ], categories: nil)
        
        
        // application.registerUserNotificationSettings(notificationSettings)
        application.registerForRemoteNotifications()
        
    }
    
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        
        if notificationSettings.types != UIUserNotificationType() {
            // application.registerUserNotificationSettings(notificationSettings)
            application.registerForRemoteNotifications()
        }
        
    }
    
    
      func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
     print(userInfo)
     
       // CommonFunctionsClass.sharedInstance().showAlert(title: "Notification", text: userInfo.description as NSString, imageName: "nil")
        
        let uInfo = userInfo as AnyObject
        let msg2 = (uInfo.value(forKey: "data") as AnyObject).value(forKey: "displayMsg") as? String ?? ""
         let senderName = (uInfo.value(forKey: "data") as AnyObject).value(forKey: "senderName") as? String ?? ""
        let placeId = (uInfo.value(forKey: "data") as AnyObject).value(forKey: "placeId") as? String ?? ""
        let senderId = (uInfo.value(forKey: "data") as AnyObject).value(forKey: "senderId") as? String ?? ""
      let placeName = (uInfo.value(forKey: "data") as AnyObject).value(forKey: "placeName") as? String ?? ""
        notificationSenderId = senderId as NSString
        notificationPlaceId = placeId as NSString
        notificationPlaceName = placeName as NSString
        
        //CommonFunctionsClass.sharedInstance().showAlert(title: "Notification", text: "\(userInfo.description)" as NSString, imageName: "nil")
        
            //let typeNoti = userInfo["data"]!["type"]!
        
        
        
     
     if application.applicationState == .active
     {
     
     
     let cont = window?.currentViewController
    
        if cont! is MainTabBarViewController {
            
        //cont!.isKindOfClass(MainTabBarViewController) {
     
     let cont2 = self.window?.currentViewController as! MainTabBarViewController
     
     if cont2.selectedIndex == 3
     {
     print("Chat View Controller or chating list view controller")
     application.applicationIconBadgeNumber = 0
     
     NotificationCenter.default.post(name: NSNotification.Name(rawValue: "pushReload"), object: nil)
     
     }
     else
     {
        
    HDNotificationView.show(with: UIImage(named: "Logo")!, title: senderName, message: msg2, isAutoHide: true, onTouch: {() -> Void in
     
     application.applicationIconBadgeNumber = 0
     })
     
     }
     
     
     }
     
     
     
        else if cont! is ChatingListViewController // .isKindOfClass(ChatingListViewController)
                 {
     
                     print("Chat View Controller or chating list view controller")
                     application.applicationIconBadgeNumber = 0
     
                     //NotificationCenter.defaultCenter.postNotificationName(NSNotification.Name(rawValue: "pushReload"), object: nil)
     
                 }
     else
     {
      HDNotificationView.show(with: UIImage(named: "Logo")!, title: senderName, message: msg2, isAutoHide: true, onTouch: {() -> Void in
     
     application.applicationIconBadgeNumber = 0
     
      })
     
     
     
     }
     }
     
     else
     {
       notificationBool = true
       let initialViewController = self.storyboard.instantiateViewController(withIdentifier: "MainTabBarViewController") as! MainTabBarViewController
     
       self.window?.rootViewController = initialViewController
      self.window?.makeKeyAndVisible()
      
        initialViewController.selectedIndex = 3
     
     }
     
     
     
    
    }

    
    
    
    private func application(_ application: UIApplication, didReceiveRemoteNotificationuserInfo: [NSObject : AnyObject])
    {
        print(didReceiveRemoteNotificationuserInfo)
        
    }
    
    
    
    
    
    
    
    //MARK: Notification End
    
    
    
    
    
    
    
    
    
    
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
       
        
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        FBSDKAppEvents.activateApp()
        
        let viewController = self.window?.currentViewController
        
        print(viewController)
        if viewController is mainHomeViewController || viewController is intrestViewController || viewController is ChatingListViewController || viewController is PostScreenViewController || viewController is ProfileVC || viewController is MainTabBarViewController {
            
          //  MainTabBarViewController().tabBar.isHidden = false
            //self.window?.currentViewController?.tabBarController?.tabBar.isHidden = false
            
        }
        else
        {
           //  MainTabBarViewController().tabBar.isHidden = true
            //self.window?.currentViewController?.tabBarController?.tabBar.isHidden = true
        }
        
        
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}


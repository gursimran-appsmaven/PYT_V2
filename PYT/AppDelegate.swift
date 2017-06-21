//
//  AppDelegate.swift
//  PYT
//
//  Created by osx on 14/06/17.
//  Copyright © 2017 osx. All rights reserved.
//

var bucketListTotalCount = "0"
var logOut: Bool = true
var appUrl = "http://pictureyourtravel.com/"  //Test
//var appUrl = "http://52.25.207.151/"// Live New server working
var Udefaults = UserDefaults.standard


import UIKit
//import Lock
import CoreData
import IQKeyboardManager
import Fabric
import Crashlytics
import GoogleMaps
import GooglePlaces
import AWSS3
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
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
    
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        
        //registerForPushNotifications(application)
        
        Udefaults.set("", forKey: "deviceToken")
        Udefaults.set(false, forKey: "multipleCity")
        
        //tool tips
        //  defaults .setInteger(0, forKey: "indexToolTips")
        //  defaults.setBool(false, forKey: "tooldetail")
        
        DispatchQueue.main.async
            {
                
                if #available(iOS 10, *)
                {
                    
                    //Notifications get posted to the function (delegate):  func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: () -> Void)"
                    
                    
                    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
                        
                        guard error == nil else {
                            //Display Error.. Handle Error.. etc..
                            return
                        }
                        
                        if granted {
                            //Do stuff here..
                            
                            //Register for RemoteNotifications. Your Remote Notifications can display alerts now :)
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
                //GMSServices.provideAPIKey("AIzaSyBDenikfv42wDKexBdljrjKNex8UHmT-bU")
                //GMSPlacesClient.provideAPIKey("AIzaSyBDenikfv42wDKexBdljrjKNex8UHmT-bU")
                
                
                //niteesh.appsmaven for testing by Developer
                GMSPlacesClient.provideAPIKey("AIzaSyB9TowwPbfXzVrkmKbKB5qBkc4luwc-qck")
                GMSServices.provideAPIKey("AIzaSyB9TowwPbfXzVrkmKbKB5qBkc4luwc-qck")
                
                
                FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
                
                
                
                
                
                
                //iqkeyboard manager
                IQKeyboardManager.shared().isEnabled = true
                IQKeyboardManager.shared().keyboardDistanceFromTextField=90
                
                
                
                application.statusBarStyle = .lightContent //color of atatus bar
                
                
                
                //fabric management
                // Fabric.with([Crashlytics.self])
                // Crashlytics.sharedInstance().debugMode = true
                
                
                
        }
        
        
        
        
        
        
        // SocketIOManager.sharedInstance.establishConnection()
        
        
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
                                    objt.postRequestForcountStory(parameterString: dic)
                                    objt.postRequestForcountStoryandBucket(dic)
                                    //objt2.postRequestForGetTheUserProfileData(uId)
                
                                }
                
                
                
                
                
            }}
        
        
        
        
        
        
        
        //MARK: Notification Section
        
        
        if let option = launchOptions
        {
            
            let info = launchOptions![UIApplicationLaunchOptionsKey.remoteNotification]
            if (info != nil) {
                
                
                // let initialViewController = storyboard.instantiateViewControllerWithIdentifier("MainTabBarViewController") as! MainTabBarViewController
                
                // self.window?.rootViewController = initialViewController
                // self.window?.makeKeyAndVisible()
                
                // initialViewController.selectedIndex = 3
                
                
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
    
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError)
    {
        print(error)
        
        ////custome alert
        
        
        
    }
    
    
    
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        
        
        print(deviceToken.description)
        
        var myToken=deviceToken.description
        myToken=myToken.replacingOccurrences(of: "<", with: "")
        myToken=myToken.replacingOccurrences(of: ">", with: "")
        myToken=myToken.replacingOccurrences(of: " ", with: "")
        print("DEVICE TOKEN = \(myToken)")
        
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
                
                //  let sendTokenController = firstMainScreenViewController()
                
                // sendTokenController.postApiFordeviceToken(parameterDict)
                
            }
            else
            {
                
                print("unable to send the devicetoken")
            }
            
        }
        
        
        
        
        
    }
    
    
    
    
    
    
    
    
    func registerForPushNotifications(application: UIApplication) {
        
        
        //let notificationSettings = UIUserNotificationSettings(
        //  forTypes: [ .Badge, .Sound, .Alert ], categories: nil)
        
        
        // application.registerUserNotificationSettings(notificationSettings)
        application.registerForRemoteNotifications()
        
    }
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        
        if notificationSettings.types != UIUserNotificationType() {
            // application.registerUserNotificationSettings(notificationSettings)
            application.registerForRemoteNotifications()
        }
        
    }
    
    /*
     func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
     print(userInfo)
     
     
     let msg2 = userInfo["data"]!["displayMsg"]!
     let senderName = userInfo["data"]!["senderName"]!
     let typeNoti = userInfo["data"]!["type"]!
     
     
     if application.applicationState == .Active {
     
     
     let cont = window?.currentViewController
     print(cont)
     if cont!.isKindOfClass(MainTabBarViewController) {
     
     let cont2 = window?.currentViewController as! MainTabBarViewController
     
     if cont2.selectedIndex == 3
     {
     print("Chat View Controller or chating list view controller")
     application.applicationIconBadgeNumber = 0
     
     NSNotificationCenter.defaultCenter().postNotificationName("pushReload", object: nil)
     
     }
     else
     {
     // HDNotificationView.showNotificationViewWithImage(UIImage(named: "logo")!, title: senderName, message: msg2, isAutoHide: true, onTouch: {() -> Void in
     
     application.applicationIconBadgeNumber = 0
     })
     
     }
     
     
     }
     
     
     
     //            else if cont! .isKindOfClass(ChatingListViewController)
     //            {
     //
     //                print("Chat View Controller or chating list view controller")
     //                application.applicationIconBadgeNumber = 0
     //
     //                NotificationCenter.defaultCenter().postNotificationName("pushReload", object: nil)
     //
     //            }
     else
     {
     // HDNotificationView.showNotificationViewWithImage(UIImage(named: "logo")!, title: senderName, message: msg2, isAutoHide: true, onTouch: {() -> Void in
     
     application.applicationIconBadgeNumber = 0
     
     // })
     
     
     
     }
     
     
     
     
     }
     
     else
     {
     
     //  let initialViewController = storyboard.instantiateViewControllerWithIdentifier("MainTabBarViewController") as! MainTabBarViewController
     
     //  self.window?.rootViewController = initialViewController
     // self.window?.makeKeyAndVisible()
     
     
     
     
     if typeNoti == "chat"
     {
     
     initialViewController.selectedIndex = 3
     
     //navController.pushViewController(myViewController, animated: true)
     
     
     application.applicationIconBadgeNumber = 0
     
     }
     
     else
     {
     
     }
     
     
     
     
     
     
     
     }
     
     
     
     
     
     }
     
     
     */
    
    
    
    private func application(application: UIApplication, didReceiveRemoteNotificationuserInfo: [NSObject : AnyObject])
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
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}


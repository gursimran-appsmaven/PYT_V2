//
//  signupProfilePictureViewController.swift
//  PYT
//
//  Created by osx on 16/06/17.
//  Copyright © 2017 osx. All rights reserved.
//

import UIKit
import IQKeyboardManager
import MBProgressHUD
import AWSS3


class signupProfilePictureViewController: UIViewController, apiClassDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var nameTf: UITextField!
    var loginFromFb = Bool()
    var email = NSString()
    var password = NSString()
    var boolProfile = Bool()
    
    @IBOutlet weak var profileIndicator: UIActivityIndicatorView!
    @IBOutlet weak var profileBtn: UIButton!
    //Image picker
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.tabBarController?.setTabBarVisible(visible: false, animated: true)

        print("email:\(email), Password:\(password)")
        IQKeyboardManager.shared().shouldResignOnTouchOutside=true
        IQKeyboardManager.shared().isEnableAutoToolbar=true
        
         apiClass.sharedInstance().delegate=self //delegate of api class
        profileIndicator.isHidden = true
        profileBtn.layer.cornerRadius = 20 //profileBtn.frame.size.width/2
        profileBtn.clipsToBounds = true
        // Do any additional setup after loading the view.
    }

    
    @IBAction func finishAction(_ sender: Any) {
    
      
            if profileBtn.imageView?.image == nil
            {
                self.loginFromFb = false
                let parameterString: NSDictionary = ["name":self.nameTf.text!, "email": self.email, "password": self.password, "deviceToken":["token": "", "device": "iphone"], "picture": ""]
                print(parameterString)
                apiClass.sharedInstance().postRequestSearch(parameterString: parameterString, viewController: self)
            }
            else
            {
            self.startUploadingImage((profileBtn.imageView?.image)!)
            }
        
        
    }
    
   
    
    
    
    //MARK: //////////////////////// profile picture change Module starts here///////////////
    
    
    
    //MARK: Photo image picker
    
    //MARK: Image Picker Delegates
    @IBAction func profileButtonAction(_ sender: Any) {
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        
        
        let alertController = UIAlertController(title: "Select Image", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let libAction = UIAlertAction(title: "Select from library", style: UIAlertActionStyle.default, handler: {(alert: UIAlertAction!) in self.gallary()
            
        })
        
        let captureAction = UIAlertAction(title: "Capture image", style: UIAlertActionStyle.default, handler: {(alert: UIAlertAction!) in self.capture()
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: {(alert: UIAlertAction!) in print("cancel")})
        
        alertController.addAction(libAction)
        alertController.addAction(captureAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion:{})
        
        
        
    }
    
    
    
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,didFinishPickingMediaWithInfo info: [String : Any])
    {
        
        let chosenImage = info[UIImagePickerControllerEditedImage] as! UIImage!
        
        // let urlImg = info[UIImagePickerControllerReferenceURL]
        
        print(chosenImage)
        
        var finalImage = UIImage()
        finalImage=chosenImage!
        
        profileBtn.imageView?.image = nil
        
        
        let testImgView = UIImageView()
        testImgView.image=self.scaleImage(chosenImage!, toSize: CGSize(width: 200, height: 200))// imagePostViewController().scaleImage(chosenImage, toSize: CGSize(width:200, height: 200))
        
        
       
        
      
        
        profileBtn.setImage(testImgView.image, for: .normal)
        boolProfile = true
        dismiss(animated: true, completion: nil)
        
        
        
    }
    
    
    func capture() {
        
        
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    func gallary(){
        
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
        
    }

    
    func startUploadingImage(_ profileImage:UIImage)
    {
        
        profileIndicator.isHidden=false
        profileIndicator.startAnimating()
        
        let amazoneUrl = "https://s3-us-west-2.amazonaws.com/"
        
        let myIdentityPoolId = "us-west-2:47968651-2cda-46d4-b851-aea8cbcd663f"//liveserver
        let S3BucketName = "pytphotobucket" //change bucketname only in test server
        
        
        
        
        //dispatch_group_enter(myGroup)
        
        
        print("Different format \(Date())")
        
        let formatter = DateFormatter()
        formatter.dateFormat = "ddMMyyHHmmss"
        let stringDate: String = formatter.string(from: Date())
        print(stringDate)
        
        
        
        
        
        var localFileName:String? = "profile-\(email)-\(stringDate).jpg"
        localFileName = localFileName!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        print(localFileName)
        
        
        // Configure AWS Cognito Credentials
        //
        
        
        
        
        let credentialsProvider:AWSCognitoCredentialsProvider = AWSCognitoCredentialsProvider(regionType:AWSRegionType.USWest2, identityPoolId: myIdentityPoolId)
        
        let configuration = AWSServiceConfiguration(region:AWSRegionType.USWest2, credentialsProvider:credentialsProvider)
        
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        
        // Set up AWS Transfer Manager Request
                    //let S3BucketName = "testpyt" // test sever
        
        print("Locatl file name= \(localFileName)")
        
        
        
        
        
        
        let fileURL = URL(fileURLWithPath: NSTemporaryDirectory() + "PytProfilePicture-\(localFileName)")
        let data = UIImageJPEGRepresentation(profileImage, 0.3)
        try? data!.write(to: fileURL, options: [.atomic])
        
        
        
        
        
        
        let remoteName = localFileName!
        let uploadRequest = AWSS3TransferManagerUploadRequest()
        uploadRequest?.body = fileURL
        uploadRequest?.acl=AWSS3ObjectCannedACL.publicRead
        uploadRequest?.key = remoteName
        uploadRequest?.bucket = S3BucketName
        uploadRequest?.contentType = "image/jpeg"
        
        
        let transferManager = AWSS3TransferManager.default()
        
        
        
        let s3URL = URL(string: "\(amazoneUrl)\(S3BucketName)/\(uploadRequest!.key!)")!
        print("Uploaded to:\n\(s3URL)")
        
        
        
        // Perform file upload
        
      transferManager.upload(uploadRequest!).continueWith { (task) -> AnyObject! in
        
        
            
            DispatchQueue.main.async {
                self.profileIndicator.isHidden=true
                self.profileIndicator.stopAnimating()
                
            }
            
            if let exception = task.error {
                print("Upload failed with exception (\(exception))")
                
                
                
            }
            
            if task.result != nil {
                DispatchQueue.main.async
                    {
                  
                    self.profileBtn.contentMode = .scaleAspectFill
                    
                  //  self.profileBtn.imageView?.image = profileImage
                    print("Uploaded to:\n\(s3URL)")
                    
                    Udefaults.set(String(describing: s3URL), forKey: "userProfilePic")
                    
                        
                        
                        
                        
                        self.loginFromFb = false
                        let parameterString: NSDictionary = ["name":self.nameTf.text!, "email": self.email, "password": self.password, "deviceToken":["token": "", "device": "iphone"], "picture": String(describing: s3URL)]
                        print(parameterString)
                        apiClass.sharedInstance().postRequestSearch(parameterString: parameterString, viewController: self)
                    
                    
                }
                
                
                
            }
            else {
                print("Unexpected empty result.")
                
                
                
                if let error = task.error {
                    print("Upload failed with error: (\(error.localizedDescription))")
                    if error.localizedDescription == "The Internet connection appears to be offline."
                    {
                        DispatchQueue.main.async {
                            MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                            
                            SweetAlert().showAlert("PYT", subTitle: "Please check internet!", style: AlertStyle.warning)
                        }
                    }
                        
                    else if(error.localizedDescription == "An SSL error has occurred and a secure connection to the server cannot be made.")
                    {
                        //MANAGE RETRY HERE
                    }
                    
                    
                    
                }
                    
                else{
                    
                    
                    //MANAGE RETRY HERE
                    
                    
                }
                
                
            }
            
            
            
            
            
            
            return nil
            
            
            
            
            
            
            
        }
        
        
        
        
        
        
        
        
        
        
        
        
    }
    
    
    
    
    
    
    func scaleImage(_ image: UIImage, toSize newSize: CGSize) -> UIImage {
        var scaledSize:CGSize = newSize
        var scaleFactor: Float = 1
        if image.size.width > image.size.height {
            scaleFactor = Float(image.size.width / image.size.height)
            scaledSize.width = newSize.width
            scaledSize.height =  newSize.height / CGFloat(scaleFactor)
        }
        else {
            scaleFactor = Float(image.size.height / image.size.width)
            scaledSize.height = newSize.height
            scaledSize.width = newSize.width / CGFloat(scaleFactor)
        }
        UIGraphicsBeginImageContextWithOptions(scaledSize, false, 0.0)
        let scaledImageRect = CGRect(x: 0.0, y: 0.0, width: scaledSize.width, height: scaledSize.height)
        image.draw(in: scaledImageRect)
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        
        
        
        
        return scaledImage!
    }
    
    
    
    
    
    
    
    
    
    //MARK:- facebook Action to get the detail and accessToken
    //MARK:-
    
    
    /*
     function for get the access token from the facebook and get into the app
     also will be able to hit the graph api
     */
    
    @IBAction func facebookAction(_ sender: Any) {
   
       loginFromFb = true
        
        let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = "Logging in"
        
        
        
         //apiClass.sharedInstance().postRequestCategories(parameterString: "")//hit the api to get the categories from the web
        
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        
        //-- set permissions to facebook----/////
        fbLoginManager.logIn(withReadPermissions: ["email","user_photos"," user_about_me", "public_profile", "user_location", "user_birthday", "user_tagged_places", "user_friends","user_videos"], from: self) { (result, error) -> Void in
            
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                if(fbloginresult.isCancelled)
                {
                    
                    CommonFunctionsClass.sharedInstance().showAlert(title: "Anything wrong?", text: "You just cancelled the sign-in process.", imageName: "exclamationAlert")
                    
                    MBProgressHUD.hide(for: self.view, animated: true)
                }
                    
                else if(fbloginresult.grantedPermissions.contains("email"))
                {
                    let token =   FBSDKAccessToken.current().tokenString // access token
                    let token2 = FBSDKAccessToken.current().userID
                    print(token2!)
                    print(token!)
                    
                    let accessToken = token! // set access token to global for use
                    
                    
                    Udefaults.set(accessToken, forKey: "faceBookAccessToken")
                    Udefaults.set("", forKey: "instagramAccessToken")
                    
                    self.getFBUserData(id: token2! as NSString, token: token! as NSString) // call  api for testing
                    
                    
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1 * NSEC_PER_SEC)) / Double(NSEC_PER_SEC), execute: {() -> Void in
                        
                        //self.graphApi()
                        fbLoginManager.logOut() // logout the facebook
                        MBProgressHUD.hide(for: self.view, animated: true)
                    })
                    
                }
            }
                
            else
            {
                print(error)
                MBProgressHUD.hide(for: self.view, animated: true)
            }
        }
        
        
    }
    
    
    
    
    ////////////--------- function to get the user data from facebook /or graph api  call the api -------------//////
    /// hit the api to backend for save the access token and get user data from facebook
    func getFBUserData(id:NSString,token:NSString)
    {
        
        let tokendevice = Udefaults.string(forKey: "deviceToken")!
        print(tokendevice)
        
        if((FBSDKAccessToken.current()) != nil)
        {
            
            Udefaults.set(true, forKey: "social")
            Udefaults.synchronize()
            
        
                let parameterDict: NSDictionary = ["fbId": id, "accessToken": token, "deviceToken": ["token": "", "device": "iphone"]]
                print(parameterDict)
                
                apiClass.sharedInstance().postRequestFacebook(parameterString: parameterDict, viewController: self)
                logOut = true
    
        }
        
    }
    
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    
    
    //MARK:- Server response arrived here
    //MARK:-
    func serverResponseArrived(Response:AnyObject){
        
        if loginFromFb == true {
            jsonResult = NSDictionary()
            jsonResult = Response as! NSDictionary
            let success = jsonResult.object(forKey: "status") as! NSNumber
            
            if success == 1
            {
                print(jsonResult)
                
                let pytUserId = jsonResult.value(forKey: "userId") as? String ?? ""
                print(pytUserId)
                let pytUserName = jsonResult.value(forKey: "name") as? String ?? ""
                let pytUserProfilePic = jsonResult.value(forKey: "profilePic") as? String ?? ""
                Udefaults.set(pytUserId, forKey: "userLoginId")
                Udefaults.set(pytUserName, forKey: "userLoginName")
                Udefaults.set(pytUserProfilePic, forKey: "userProfilePic")
                
                
                apiClass.sharedInstance().postRequestCategories(parameterString: pytUserId)
                
                
                let runtimeLocations = jsonResult.value(forKey: "runtimeLocation") as! NSMutableArray
                let arrayOfLoc = NSMutableArray()
                UserDefaults.standard.set(arrayOfLoc, forKey: "arrayOfIntrest")
                if runtimeLocations.count > 0 {
                    
                   
                    for l in 0..<runtimeLocations.count {
                        
                        
                        
                        
                        let fullName1 = runtimeLocations.object(at: l) as? NSDictionary
                        
                        let fullName = fullName1?["fullName"] as? String ?? ""
                        let placeId = fullName1?["placeId"] as? String ?? ""
                        let placeType = fullName1?["type"] as? String ?? ""
                        let placeImage = fullName1?["imageUrl"] as? String ?? ""
                        
                        
                        var loc = ""
                        
                        let ArrToSeperate = fullName .components(separatedBy: ",")
                        if ArrToSeperate.count>0 {
                            loc=ArrToSeperate[0] as String
                        }
                        
                        
                        
                        var dic = NSMutableDictionary()
                        dic = ["location":loc, "type": placeType, "placeId": placeId,  "delete":false, "fullName": fullName, "imageUrl": placeImage ]
                        print(dic)
                        
                        arrayOfLoc .add(dic)
                        
                        
                        
                    }
                    
                    UserDefaults.standard.set(arrayOfLoc, forKey: "arrayOfIntrest")
                    
                    
                }
                
                
                // DispatchQueue.main.async {
                
                self .moveinsideApp()
                //}
                
                // Socket
                  SocketIOManager.sharedInstance.establishConnection()
                
                
                
            }
                
            else
            {
                
                Udefaults.set("", forKey: "userLoginId")
                
                CommonFunctionsClass.sharedInstance().showAlert(title: "Session Expire", text: "Your session is expired, Please login again", imageName: "exclamationAlert")
                
                
                
            }
            
            

        }
        else
        {
            
        
        jsonResult = NSDictionary()
        jsonResult = Response as! NSDictionary
        
        
        
        let success = jsonResult.object(forKey: "status") as! NSNumber
        
        if success == 1
        {
            
          
            let uname = nameTf.text!
            Udefaults.set(uname, forKey: "userLoginName")
            Udefaults.set(email, forKey: "userLoginEmail")
            
            Udefaults.set("", forKey: "userProfilePic")
            
            let arrayOfLoc = NSMutableArray()
            UserDefaults.standard.set(arrayOfLoc, forKey: "arrayOfIntrest")
            
            //save The credentail and login to the app
            
            let pytUserId = ""//(jsonResult.value(forKey: "data")! as AnyObject) .value("userId") as? String ?? ""
            
            
            
            Udefaults.set(pytUserId, forKey: "userLoginId")
            Udefaults.set(false, forKey: "social")
            
            let nxtObj3 = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
   ////crashing
            if (nxtObj3.tabledata?.count)!<1 {
                
                
                
                let nxtObj = self.storyboard?.instantiateViewController(withIdentifier: "searchScreenViewController") as! searchScreenViewController
                
                 self.navigationController! .pushViewController(nxtObj, animated: true)
                
                self.dismiss(animated: true, completion: {})
               
                
                
                
            }
            else
            {
                //let nxtObj = self.storyboard?.instantiateViewControllerWithIdentifier("MainTabBarViewController") as? MainTabBarViewController
                
                DispatchQueue.main.async {
                    // self.navigationController! .pushViewController(nxtObj!, animated: true)
                    //self.dismiss(animated: true, completion: {})
                }
                
            }
            
            
            DispatchQueue.global(qos: .background).async {
                
                ////for get the count of stories added by user
                
                let uId = Udefaults .string(forKey: "userLoginId")
                let objt = storyCountClass()
                //objt.postRequestForcountStory("userId=\(uId!)")
                let dic:NSDictionary = ["userId": uId!]
                objt.postRequestForcountStory(parameterString: dic)
                
                
                
                
                ///For get the user's all data
                
                DispatchQueue.global(qos: .background).async {
                    //let objt2 = UserProfileDetailClass()
                    // objt2.postRequestForGetTheUserProfileData(uId!)
                }
                
                
            }
            
            
            
            
            
            // Socket
             SocketIOManager.sharedInstance.establishConnection()
            
            
            
            
            
        }
        else{
            
            print(jsonResult)
            
            
            CommonFunctionsClass.sharedInstance().showAlert(title: "User already exists!", text: "Email id already registered.", imageName: "exclamationAlert")
            
            
            
        }
        
        
        
        MBProgressHUD.hide(for: self.view, animated: true)
        
        
        
        }
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func moveinsideApp() -> Void
    {
        let uId = Udefaults .string(forKey: "userLoginId")
        
        
        
        let nxtObj = self.storyboard?.instantiateViewController(withIdentifier: "searchScreenViewController") as! searchScreenViewController
        
        self.navigationController! .pushViewController(nxtObj, animated: true)
        self.dismiss(animated: true, completion: {})
        
        
        
        DispatchQueue.global(qos: .background).async {
            
            
            let objt = storyCountClass()
            let dic:NSDictionary = ["userId": uId!]
            objt.postRequestForcountStory(parameterString: dic)
            
            DispatchQueue.global(qos: .background).async {
                // dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), {
                //let objt2 = UserProfileDetailClass()
                // objt2.postRequestForGetTheUserProfileData(uId!)
                
                
            }
            
            
            
        }
        
        
        
        
        
        
        
    }
    
    
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  ProfileVC.swift
//  PYT
//
//  Created by osx on 23/06/17.
//  Copyright © 2017 osx. All rights reserved.
//

import UIKit
import AWSS3
import MBProgressHUD
import IQKeyboardManager

class ProfileVC: UIViewController,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate, settingClassDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var contentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var view1Height: NSLayoutConstraint!
    @IBOutlet weak var view2Height: NSLayoutConstraint!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var outerImg: CustomImageView!
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var catCollectionView: UICollectionView!
    @IBOutlet weak var actionsTableView: UITableView!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var nameTxtWidth: NSLayoutConstraint!
    
    
    var boolProfile = Bool()
    var dataArray = NSMutableArray()
    let uId = Udefaults .string(forKey: "userLoginId")!
    var countCategory = Int()
    let imagePicker = UIImagePickerController()

    @IBOutlet weak var profileChangeIndicator: UIActivityIndicatorView!
    @IBOutlet weak var userNameIndicator: UIActivityIndicatorView!
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.tabBarController?.tabBar.isHidden = false
        // self.tabBarController?.setTabBarVisible(visible: true, animated: true)
        SettingApiClass.sharedInstance().delegate=self //delegate of api class
        if let userName = Udefaults .string(forKey: "userLoginName"){
            nameTF.text =  userName.capitalized
        }
        
      
      //  shareBtn.isUserInteractionEnabled = true
        let userPic = Udefaults .string(forKey: "userProfilePic")
        print(userPic)
        
        
        let urlProfile = URL(string: (userPic! as? String)! )
        userImg .sd_setImage(with: urlProfile, placeholderImage: UIImage (named: "dummyBackground2"))
      
        let prm:NSDictionary = ["userId":uId, "status": "1"]
       // profileIndicator.isHidden=false
        //profileIndicator.startAnimating()
        
        
        
        self.postApiToGetPYTUserPhotosDetail(prm, urlToSend: "get_images_for_profile_V3")
        
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countCategory = 0
        profileChangeIndicator.isHidden = true
        userNameIndicator.isHidden = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews()
    {
        outerImg.layer.cornerRadius = outerImg.frame.width/2
        userImg.layer.cornerRadius = userImg.frame.width/2
        outerImg.layer.masksToBounds = true
        userImg.layer.masksToBounds = true
        
        view1Height.constant = view.frame.width * 13/25
      
        if countCategory == 0 {
            view2Height.constant = 0
        }
        else if (countCategory == 1 || countCategory == 2){
            view2Height.constant = view.frame.width * 13/25
        }
        else
        {
         view2Height.constant = view.frame.width * 13/25 + catCollectionView.frame.width/2
        }
        
//        view2Height.constant = view.frame.width * 13/25 //+ catCollectionView.frame.width/2
        
        tableViewHeight.constant = CGFloat(11*55 + 20*4 + 10)/*sections*/
        contentViewHeight.constant = view1Height.constant + view2Height.constant + tableViewHeight.constant
    }
    //MARK: DataSource and delegate of tableView
    //MARK:-
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 4
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        switch section {
        case 0:
            return 2

        case 1:
            return 5
            
        case 2:
            return 3

        case 3:
            return 1

        default:
            return 0
            
        }

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 55
    }
    
    func tableView( _ tableView: UITableView, viewForFooterInSection section: Int) -> UIView?
    {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 20))
        footerView.backgroundColor = UIColor.clear
        return footerView

    }
    func tableView( _ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        if(section==3)
        {
            return 30
        }
        return 20

    }
    func tableView( _ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 0.1
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileActionsCell", for: indexPath) as! ProfileActionsCell
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                cell.actionName.text = "Saved Destinations"
                cell.actionImage.image = UIImage(named:"profilebucket")

            case 1:
                cell.actionName.text = "Travel Plan"
                cell.actionImage.image = UIImage(named:"travelplans")

            default:
                cell.actionName.text = ""
                cell.actionImage.image = UIImage(named:"")

            }
        case 1:
            switch indexPath.row {
            case 0:
                cell.actionName.text = "View Tutorial"
                cell.actionImage.image = UIImage(named:"tutorials")

            case 1:
                cell.actionName.text = "Share Application"
                cell.actionImage.image = UIImage(named:"Share")

            case 2:
                cell.actionName.text = "Add More Account"
                cell.actionImage.image = UIImage(named:"addaccount")

            case 3:
                cell.actionName.text = "Choose Interest"
                cell.actionImage.image = UIImage(named:"Report")

            case 4:
                cell.actionName.text = "Change Password"
                cell.actionImage.image = UIImage(named:"password")

            default:
                cell.actionName.text = ""
                cell.actionImage.image = UIImage(named:"")

            }
            

        case 2:
            switch indexPath.row {
            case 0:
                cell.actionName.text = "Report a problem"
                cell.actionImage.image = UIImage(named:"Report")

            case 1:
                cell.actionName.text = "Help"
                cell.actionImage.image = UIImage(named:"help")

            case 2:
                cell.actionName.text = "Privacy Policy"
                cell.actionImage.image = UIImage(named:"privacy")

            default:
                cell.actionName.text = ""
                cell.actionImage.image = UIImage(named:"")

            }
            

        case 3:
            switch indexPath.row {
            case 0:
                cell.actionName.text = "Logout"
                cell.actionImage.image = UIImage(named:"Logout")

            default:
                cell.actionName.text = ""
                cell.actionImage.image = UIImage(named:"")

            }
        default:
            return cell
            
        }
        
        return cell
    }
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                print("Saved Destinations")
                
            case 1:
                print("Travel Plan")
                let obj = self.storyboard?.instantiateViewController(withIdentifier: "TravelPlansListVC") as! TravelPlansListVC
                self.navigationController?.pushViewController(obj, animated: true)
            default:
                print(" ")

            }
        case 1:
            switch indexPath.row {
            case 0:
                print("View Tutorial")
                 let nxtObj = self.storyboard?.instantiateViewController(withIdentifier: "contentViewController") as! contentViewController
                nxtObj.comingFrom = "Tutorials"
                self.navigationController?.pushViewController(nxtObj, animated: true)
                
            case 1:
                print("Share Application")
                let textToShare = "Pyt is here, Check it now "
                
                if let myWebsite = URL(string: "http://pictureyourtravel.com/") {
                    let objectsToShare = [textToShare, myWebsite] as [Any]
                    let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                    
                    activityVC.popoverPresentationController?.sourceView = self.view
                    self.present(activityVC, animated: true, completion: nil)
                }
                break
                
            case 2:
                print("Add More Account")
                
            case 3:
                print("Choose Interest")
                
                let nxtObj = self.storyboard?.instantiateViewController(withIdentifier: "ChooseInterestVC") as! ChooseInterestVC
                nxtObj.comingFrom = "Profile"
                self.navigationController! .pushViewController(nxtObj, animated: true)
                
            case 4:
                print("Change Password")
                
                let nxtObj = self.storyboard?.instantiateViewController(withIdentifier: "changePasswordViewController") as! changePasswordViewController
              
                self.navigationController! .pushViewController(nxtObj, animated: true)
                self.tabBarController?.tabBar.isHidden = true
                //self.tabBarController?.setTabBarVisible(visible: false, animated: true)
                
            default:
                print(" ")
                
            }
            
            
        case 2:
            switch indexPath.row {
            case 0:
                print("Report a problem")
                
            case 1:
                print("Help")
                
            case 2:
                print("Privacy Policy")
                
            default:
                print(" ")
                
            }
            
            
        case 3:
            switch indexPath.row {
            case 0:
                print("Logout")

                self.ActionLogout()
                
                
            default:
                print(" ")

                
            }
        default:
            print("")

            
        }

        
    }
    
     // MARK: UICollectionView
    
    func numberOfSections(in collectionView: UICollectionView) -> Int   {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView,numberOfItemsInSection section: Int) -> Int
    {
        return dataArray.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize
    {
        let width1 = collectionView.frame.size.width/2  - 5
        return CGSize(width: width1 , height: width1) // The size of one cell
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView,cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCollectionCell", for: indexPath) as! ProfileCollectionCell
        
        let gradient = cell.viewWithTag(7499) as! GradientView
        
        gradient.gradientLayer.colors = [UIColor.black.withAlphaComponent(0.75).cgColor, UIColor.clear.cgColor]
        gradient.gradientLayer.gradient = GradientPoint.bottomTop.draw()
        cell.categoryName.text = (dataArray.object(at: indexPath.row) as AnyObject).value(forKey: "source") as? String ?? ""
        cell.countLbl.text = (dataArray.object(at: indexPath.row) as AnyObject).value(forKey: "count") as? String ?? ""
        
        let imgUrl = (dataArray.object(at: indexPath.row) as AnyObject).value(forKey: "standardimage") as? String ?? ""
        
        
        cell.categoryImage.sd_setImage(with: URL(string: imgUrl), placeholderImage: UIImage (named: "backgroundImage"))
        cell.categoryImage.contentMode = .scaleAspectFill
        
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
            
        var prmtr = ""
        let source = (dataArray.object(at: indexPath.row) as AnyObject).value(forKey: "source") as? String ?? ""
        
            if source == "FACEBOOK"
            {
                prmtr = "2"//"userId=\(uId)&status=2&skip=0" // Facebook
            }
            else if(source == "PYT" )
            {
                prmtr = "4"//"userId=\(uId)&status=4&skip=0" // Pyt
            }
            else
            {
                prmtr = "3"//"userId=\(uId)&status=3&skip=0" //Instagram
            }
        
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "UploadedImagesVC") as! UploadedImagesVC
        
        obj.parameters = prmtr as NSString
        
//        if boolProfileOther == true {
//            obj.urlload="get_images_of_friend"
//        }
//        else{
            obj.urlload="get_images_for_profile_V3"//"get_images_for_profile"
        //}
        
        obj.username = nameTF.text!
        
        obj.countStrText = (dataArray.object(at: indexPath.row) as AnyObject).value(forKey: "count")! as! NSString
        
        self.navigationController?.pushViewController(obj, animated: true)
        
    }

    
    
    
    //MARK: All Api and there responses 
    //MARK:
    //MARK: Api to get the images and count from server
    //MARK:
    func postApiToGetPYTUserPhotosDetail(_ parameterReview: NSDictionary, urlToSend: NSString) {
        
        self.catCollectionView.isUserInteractionEnabled=false
        
        print(parameterReview)
        dataArray.removeAllObjects()
        
        let isConnectedInternet = CommonFunctionsClass.sharedInstance().isConnectedToNetwork()
        
        if isConnectedInternet
        {
            //            let request = NSMutableURLRequest(URL: NSURL(string: "\(appUrl)albums")!)
            let request = NSMutableURLRequest(url: URL(string: "\(appUrl)\(urlToSend)")!)
            
            request.httpMethod = "POST"
            // let postString = parameterReview
            
            do {
                let jsonData = try!  JSONSerialization.data(withJSONObject: parameterReview, options: [])
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
                
                
                DispatchQueue.main.async(execute: {
                    
                    do {
                        
                        let result = NSString(data: data!, encoding:String.Encoding.ascii.rawValue)!
                        //print("Body: \(result)")
                       let anyObj: Any = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                        
                        basicInfo = NSMutableDictionary()
                        basicInfo = anyObj as! NSMutableDictionary
                        
                        let status = basicInfo .value(forKey: "status") as! NSNumber
                        
                        
                        
                        if status == 1
                        {
                            
                            let facebookCount = ((basicInfo .value(forKey: "data")! as AnyObject).object(at: 0) as AnyObject).value(forKey: "fb_count") as! NSNumber
                            
                            let InstagramCount = ((basicInfo .value(forKey: "data")! as AnyObject).object(at: 0) as AnyObject).value(forKey: "insta_count") as! NSNumber
                            let PytCount = ((basicInfo .value(forKey: "data")! as AnyObject).object(at: 0) as AnyObject).value(forKey: "pyt_count") as! NSNumber
                            
                            
                            
                            
                            if facebookCount != 0
                            {
                self.dataArray .add(["source": "FACEBOOK", "count": String(describing: facebookCount), "largeImage": ((((basicInfo .value(forKey: "data")! as AnyObject).object(at: 0) as AnyObject).value(forKey: "fb") as AnyObject).object(at: 0) as AnyObject).value(forKey: "imageLarge")  as? String ?? "", "standardimage": ((((basicInfo .value(forKey: "data")! as AnyObject).object(at: 0) as AnyObject).value(forKey: "fb") as AnyObject).object(at: 0) as AnyObject).value(forKey: "imageStandard")  as? String ?? ""])
                             print(self.dataArray)
                                
                            }
                            
                            if InstagramCount != 0
                            {
                            self.dataArray .add(["source": "INSTAGRAM", "count": String(describing: InstagramCount), "largeImage": ((((basicInfo .value(forKey: "data")! as AnyObject).object(at: 0) as AnyObject).value(forKey: "insta") as AnyObject).object(at: 0) as AnyObject).value(forKey: "imageLarge")  as? String ?? "", "standardimage": ((((basicInfo .value(forKey: "data")! as AnyObject).object(at: 0) as AnyObject).value(forKey: "insta") as AnyObject).object(at: 0) as AnyObject).value(forKey: "imageStandard")  as? String ?? ""])
                                
                                
                                
                            }
                            if PytCount != 0
                            {
                                self.dataArray .add(["source": "PYT", "count": String(describing: PytCount), "largeImage": ((((basicInfo .value(forKey: "data")! as AnyObject).object(at: 0) as AnyObject).value(forKey: "pyt") as AnyObject).object(at: 0) as AnyObject).value(forKey: "imageLarge")  as? String ?? "", "standardimage": ((((basicInfo .value(forKey: "data")! as AnyObject).object(at: 0) as AnyObject).value(forKey: "pyt") as AnyObject).object(at: 0) as AnyObject).value(forKey: "imageThumb")  as? String ?? ""])
                            
                            }
                            
                            
                            
                        }
                            
                        else if (status == 5){
                            
                            print("Status = 5 logout the user")
                            
                        }
                        
                        
                        
                        
                        
                        self.catCollectionView.reloadData()
                        self.catCollectionView.isUserInteractionEnabled=true
                        
                        self.countCategory = 0
                        if(self.dataArray.count == 1 || self.dataArray.count == 2)
                        {
                        self.countCategory = 1
                        }
                        self.viewWillLayoutSubviews()
                        
//                        DispatchQueue.main.async(execute: { () -> Void in
//                            if(self.dataArray.count == 1 || self.dataArray.count == 2)
//                            {
//                                UIView.animate(withDuration: 0.2, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
//                                    
//                                    self.profileHeight.constant = self.cellheight
//                                    
//                                    self.view.layoutIfNeeded()
//                                }, completion: nil)
//                            }
//                            else if(self.dataArray.count == 3)
//                            {
//                                UIView.animate(withDuration: 0.2, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
//                                    
//                                    self.profileHeight.constant = 0
//                                    self.view.layoutIfNeeded()
//                                }, completion: nil)
//                            }
//                            else
//                            {
//                                self.profileHeight.constant = 0
//                            }
//                            
//                        })
                        
                        
                        
                        
                        
                    } catch {
                        //print("json error: \(error)")
                        CommonFunctionsClass.sharedInstance().showAlert(title: "Server Alert", text: "Something doesn't seem right, Please try again!", imageName: "alertServer")
                        
                        //  self .postRequestCategories("", viewController: viewController) //recall
                        
                    }
                    
                    
                   // self.WhiteIndicator.isHidden = true
                    
                    
                })
                
                
                
                
                
                
            }
            task.resume()
            
        }
        else
        {
            CommonFunctionsClass.sharedInstance().showAlert(title: "No Internet Connection", text: "You are currently offline.", imageName: "alertInternet")
            //self.profileIndicator.isHidden=true
            //self.profileIndicator.stopAnimating()
        }
        
        
        
        
        
        
        
    }
    
    func shortUserProfile(_ result:NSMutableDictionary)
    {
        print(result)
        print(result.value(forKey: "status"))
        
        if result.value(forKey: "status") as! NSNumber == 1 {
            
            
            let userNameText = (result.value(forKey: "data") as AnyObject).value(forKey: "name") as? String ?? " "
            if userNameText != " " {
                nameTF.text=userNameText
            }
            
            
            let profileUrl = ((result.value(forKey: "user") as AnyObject).object(at: 0) as AnyObject).value(forKey: "profilePic") as? String ?? " "
            
            if profileUrl != " " {
                let imgurl = URL (string: profileUrl)
                print(imgurl)
                userImg.sd_setImage(with: imgurl! , placeholderImage: UIImage (named: ""))
                // .sd_setImage(with: imgurl, placeholderImage: UIImage (named: "profileDummy"))
            }
            
            let connection = (result.value(forKey: "data")! as AnyObject).value(forKey: "connection") as! NSMutableArray
            
            
            
            
            
            //facebookBtn.setImage(UIImage (named: "fbSetting"), for: UIControlState())
            //instaBtn.setImage(UIImage (named: "instaSetting"), for: UIControlState())
            
            //instaBtn.isUserInteractionEnabled=true
           // facebookBtn.isUserInteractionEnabled=true
            
            
            if connection.count < 1 {
                
               // facebookBtn.setImage(UIImage (named: "fbSetting"), for: UIControlState())
               // instaBtn.setImage(UIImage (named: "instaSetting"), for: UIControlState())
                
               // instaBtn.isUserInteractionEnabled=true
                //facebookBtn.isUserInteractionEnabled=true
                
            }
                
            else if connection.count == 1{
                if connection.contains("facebook") {
                    //disable facebook
                  //  facebookBtn.setImage(UIImage (named: "fillFbSetting"), for: UIControlState())
                    //facebookBtn.isUserInteractionEnabled=false
                    
                }
                else if(connection.contains("instagram")){
                    //disable the instagram
                    //instaBtn.setImage(UIImage (named: "fillInstaSetting"), for: UIControlState())
                   // instaBtn.isUserInteractionEnabled=false
                }
                
            }
                
            else{
                
                if connection .contains("facebook") {
                    //disable the facebook
                   // facebookBtn.setImage(UIImage (named: "fillFbSetting"), for: UIControlState())
                   // facebookBtn.isUserInteractionEnabled=false
                    
                }
                
                if  connection .contains("instagram") {
                    
                    //disable the instagram
                   // instaBtn.setImage(UIImage (named: "fillInstaSetting"), for: UIControlState())
                   // instaBtn.isUserInteractionEnabled=false
                }
                
                
            }
            
            
            
        }
        
     
    }
    
    //MARK:
    //MARK: Api to change user name
    
    
    func changeUserNameApi(_ parameterString:NSDictionary) {
        
        let isConnectedInternet = CommonFunctionsClass.sharedInstance().isConnectedToNetwork()
        if isConnectedInternet
        {
            let urlString = NSString(string:"\(appUrl)edit_user_name")
            let isConnectedInternet = CommonFunctionsClass.sharedInstance().isConnectedToNetwork()
            
            if isConnectedInternet
            {
                
                
                var urlString = NSString(string:"\(urlString)")
                print("WS URL----->>" + (urlString as String))
                
                urlString = urlString .replacingOccurrences(of: " ", with: "%20") as NSString
                
                let url:URL = URL(string: urlString as String)!
                let session = URLSession.shared
                session.configuration.timeoutIntervalForRequest=20
                
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
                            self.userNameIndicator.isHidden = true
                            self.userNameIndicator.stopAnimating()
                            if data == nil
                            {
                                print("server not responding")
                            }
                            else
                            {
                                do
                                {
                                    let result = NSString(data: data!, encoding:String.Encoding.ascii.rawValue)!
                                    print("Body: \(result)")
                                     let anyObj: Any = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                                    
                                    basicInfo=NSMutableDictionary()
                                    basicInfo=anyObj as! NSMutableDictionary
                                    let success = basicInfo.object(forKey: "status") as! NSNumber
                                    if success==1
                                    {
                                        print("Profile Picture is Updated")
                                        Udefaults.set(self.nameTF.text!, forKey: "userLoginName")
                                        self.changeNameBtn.setImage(UIImage(named:"crossprofile") , for: .normal)
                                        
                                    }
                                    else
                                    {
                                        CommonFunctionsClass.sharedInstance().showAlert(title: "Server Alert", text: "Unable to update username, please try again!", imageName: "alertServer")
                                    }
                                    
                                } catch
                                {
                                    print("json error: \(error)")
                                    CommonFunctionsClass.sharedInstance().showAlert(title: "Server Alert", text: "Something doesn't seem right, Please try again!", imageName: "alertServer")
                                    }
                                
                            }
                    }
                }
                
                task.resume()
            }
            else
            {
                CommonFunctionsClass.sharedInstance().showAlert(title: "No Internet Connection", text: "You are currently offline.", imageName: "alertInternet")
                userNameIndicator.isHidden = true
                userNameIndicator.stopAnimating()
            }
            
            
        }
    }
    
    
    
    
    
    
    
    //MARK: Server class delegate
    func serverResponseArrivedSetting(_ Response:AnyObject){
        
        ///// the user info will be comes here
        
        if boolProfile==true
        {
            
            
            basicInfo = NSMutableDictionary()
            basicInfo = Response as! NSMutableDictionary
            let success = basicInfo.object(forKey: "status") as! NSNumber
            
            if success==1 {
                //goto function for short and display in screen
                self.shortUserProfile(basicInfo)
                
            }else{
                
            }
            
            
            
            
        }
            
            
            
            
            ///if login from facebook and instagram it will comes here
        else
        {
            ////////if login from facebook or instagram
            let defaults = UserDefaults.standard
            
            
            jsonResult = NSDictionary()
            jsonResult = Response as! NSDictionary
            let success = jsonResult.object(forKey: "status") as! NSNumber
            
            
            if success == 1
            {
                print(jsonResult)
                
                CommonFunctionsClass.sharedInstance().showAlert(title: "Update Done", text: "\(jsonResult.value(forKey: "msg")!)" as NSString, imageName: "doneAlert")
                
                
                SettingApiClass.sharedInstance().delegate=self
                SettingApiClass.sharedInstance().getUSerProfile("\(uId)" as NSString, viewController: self)
                boolProfile=true
                
                
                
                
            }
                
            else
            {
                
                defaults.set("", forKey: "userLoginId")
                
                CommonFunctionsClass.sharedInstance().showAlert(title: "Opps!", text: "\(jsonResult.value(forKey: "msg")!)" as NSString, imageName: "exclamationAlert")
                
        
               
                
                
            }
            
        }
 
        
        
        
        
        
    }
 
    
    
    
    //MARK: Change profile module
    
    
    
    //MARK: //////////////////////// profile picture change Module starts here///////////////
    
    
    
    //MARK: Photo image picker
    
    //MARK: Image Picker Delegates
    
    
    @IBAction func changePhotoAction(_ sender: AnyObject) {
        
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
        
        userImg.image = nil
        
        
        let testImgView = UIImageView()
        testImgView.image=PostScreenViewController().scaleImage(chosenImage!, toSize: CGSize(width:200, height: 200))
        
        
       // profileIndicator.isHidden=false
      //  profileIndicator.startAnimating()
        
        self.startUploadingImage(testImgView.image!)
        profileChangeIndicator.startAnimating()
        profileChangeIndicator.isHidden = false
        dismiss(animated: true, completion: nil)
        
        
        
    }
    
    
    
    
    
    
    
    func startUploadingImage(_ profileImage:UIImage)
    {
        //let myGroup = dispatch_group_create()
        
        // for l in 0..<multipleImagesArray.count {
        
        // let S3UploadKeyName: String = "iqtBkg8alWc0rdsXXoxF6aMc9VJPWROfDDOj3TOd"
        
        
        let amazoneUrl = "https://s3-us-west-2.amazonaws.com/"
        
        let myIdentityPoolId = "us-west-2:47968651-2cda-46d4-b851-aea8cbcd663f"//liveserver
        let S3BucketName = "pytprofilepic" //change bucketname only in test server
        
        
        
        //dispatch_group_enter(myGroup)
        
        
        print("Different format \(Date())")
        
        let formatter = DateFormatter()
        formatter.dateFormat = "ddMMyyHHmmss"
        let stringDate: String = formatter.string(from: Date())
        print(stringDate)
        
        
        
        
       
        let userName = Udefaults .string(forKey: "userLoginName")
        let uEmail = Udefaults .string(forKey: "userLoginEmail")
        
        var localFileName:String? = "\(uId)profile-\(uEmail)-\(stringDate).jpg"
        localFileName = localFileName!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        print(localFileName)
        
        
        // Configure AWS Cognito Credentials
        //
        
        
        
        
        let credentialsProvider:AWSCognitoCredentialsProvider = AWSCognitoCredentialsProvider(regionType:AWSRegionType.USWest2, identityPoolId: myIdentityPoolId)
        
        let configuration = AWSServiceConfiguration(region:AWSRegionType.USWest2, credentialsProvider:credentialsProvider)
        
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        
        // Set up AWS Transfer Manager Request
        //            //let S3BucketName = "testpyt" // test sever
        //            let S3BucketName = "pytphotobucket"
        
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
                // self.profileIndicator.isHidden=true
                // self.profileIndicator.stopAnimating()
                //
            }
            
            if let error = task.error {
                print("Upload failed with exception (\(error.localizedDescription))")
                
               
                
            }
            
            if task.result != nil
            {
                DispatchQueue.main.async {
                    self.userImg.image = profileImage
                    print("Uploaded to:\n\(s3URL)")
                    
                    let parmDict: NSDictionary = ["userId":self.uId, "picture": String(describing: s3URL)]
                    Udefaults.set(String(describing: s3URL), forKey: "userProfilePic")
                    
                    print(parmDict)
                    self.boolProfile=true
                    self.changeUserProfileApi(parmDict)
                    
                    
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
                            
                            CommonFunctionsClass.sharedInstance().showAlert(title: "No Internet Connection", text: "You are currently offline.", imageName: "alertInternet")
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
            
            
            self.profileChangeIndicator.stopAnimating()
            self.profileChangeIndicator.isHidden = true
            
            
            
            return nil
            
            
            
            
            
            
            
        }
        
        
        
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
    
    @IBOutlet weak var changeNameBtn: UIButton!
    
    // MARK: Action Methods
    @IBAction func ChangeNameBtnAction(_ sender: Any) {
        if(changeNameBtn.imageView?.image == UIImage(named: "crossprofile"))
        {
            changeNameBtn.setImage(UIImage(named:"tickprofile") , for: .normal)
            nameTF.text = nil
            nameTF.becomeFirstResponder()
        }
        else
        {
            userNameIndicator.isHidden = false
            userNameIndicator.startAnimating()
             let parmDic: NSDictionary = ["userId": uId, "name": nameTF.text!]
            self.changeUserNameApi(parmDic)
            nameTF.resignFirstResponder()
        }
        
    }
    
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        changeNameBtn.tag = 1
       changeNameBtn.setImage(UIImage(named:"tickprofile") , for: .normal)
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let userName = Udefaults .string(forKey: "userLoginName")
        
        if textField.text=="" || textField.text == nil || textField.text == userName  {
          changeNameBtn.setImage(UIImage(named:"crossprofile") , for: .normal)
            nameTF.text = userName
        }
        else
        {
//            if(changeNameBtn.imageView?.image == UIImage(named: "crossprofile"))
//            {
//                changeNameBtn.setImage(UIImage(named:"tickprofile") , for: .normal)
//            }
//            else
//            {
//                changeNameBtn.setImage(UIImage(named:"crossprofile") , for: .normal)
//            }
            
           
        }
    }
    
    
    
   
    
    
    
    
    //MARK: Logout Button Action
    
    func ActionLogout() {
        
        self.tabBarController?.tabBar.isHidden = true
        //self.tabBarController?.setTabBarVisible(visible: false, animated: true)
        
        let nxtObj = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        
        
        // logOut = false
        
        DispatchQueue.main.async(execute: {
            self.dismiss(animated: true, completion: {})
            
            self.navigationController! .pushViewController(nxtObj, animated: true)
            
            OperationQueue.main.cancelAllOperations()
            
            //
        })
        
        
        
        let token = Udefaults.string(forKey: "deviceToken")!
        
        
        
        let deviceTokenDict = NSMutableDictionary()
        
        deviceTokenDict.setValue(token, forKey: "token")
        deviceTokenDict.setValue("iphone", forKey: "device")
        
        let parameter:NSMutableDictionary = ["deviceToken":deviceTokenDict ,"userId":uId]
        
        self.logoutApi(parameter)
        
        //let arr = NSMutableArray()
        UserDefaults.standard.set(nil, forKey: "arrayOfIntrest")
        
        
    }
    
    
    
    
    func logoutApi(_ parameterString: NSMutableDictionary) -> Void {
        
        
        
        
        let emptAr = NSMutableArray()
        
        Udefaults.set("", forKey: "userLoginId")
        Udefaults.set("", forKey: "userLoginName")
        Udefaults.set("", forKey: "userProfilePic")
        Udefaults.set("", forKey: "faceBookAccessToken")
        Udefaults.set(false, forKey: "savedDeviceToken")
        Udefaults.set(emptAr, forKey: "Interests")
        Udefaults.set(emptAr, forKey: "IntrestsId")
        Udefaults.set(emptAr, forKey: "categoriesFromWeb")
        Udefaults.set(emptAr, forKey: "multipleCity")
        
        
        SocketIOManager.sharedInstance.closeConnection()
        
        print("Parameter=\(parameterString)")
        
        let isConnectedInternet = CommonFunctionsClass.sharedInstance().isConnectedToNetwork()
        
        if isConnectedInternet
        {
            //            let request = NSMutableURLRequest(URL: NSURL(string: "\(appUrl)logout")!)//old version
            
            let request = NSMutableURLRequest(url: URL(string: "\(appUrl)logout_user")!) //latest version
            
            
            request.httpMethod = "POST"
            
            
            do {
                let jsonData = try!  JSONSerialization.data(withJSONObject: parameterString, options: [])
                request.httpBody = jsonData
                
                
                // here "jsonData" is the dictionary encoded in JSON data
            } catch let error as NSError {
                print(error)
            }
            
            
            
            // request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(prmt, options: [])
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            
            
            
            let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
                guard error == nil && data != nil else {                                                          // check for fundamental
                    return
                }
                
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200
                {
                }
                
                
                
                DispatchQueue.main.async(execute: {
                    
                    do {
                        
                        let result = NSString(data: data!, encoding:String.Encoding.ascii.rawValue)!
                        print("Body: \(result)")
                        //
                        //                        let anyObj: AnyObject = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                        //
                        //                        basicInfo = NSMutableDictionary()
                        //                        basicInfo = anyObj as! NSMutableDictionary
                        //
                        //                        let status = basicInfo .value(forKey: "status") as! NSNumber
                        
                        logOut = false
                        
                        
                        
                        
                        
                        
                        
                    } catch {
                        
                        
                    }
                    
                    
                    MBProgressHUD .hide(for: self.view, animated: true)
                    
                    
                    
                    
                    
                })
                
                
                
                
                
                
                
            }
            task.resume()
            
        }
        else
        {
            CommonFunctionsClass.sharedInstance().showAlert(title: "No Internet Connection", text: "You are currently offline.", imageName: "alertInternet")
        }
        
        
        
        
        
    }
    
    
    
    
    
    
    //MARK:
    //MARK: Change the Profile Picture of the user
    
    func changeUserProfileApi(_ parameterString:NSDictionary) {
        
        //userId
        let isConnectedInternet = CommonFunctionsClass.sharedInstance().isConnectedToNetwork()
        
        if isConnectedInternet
        {
            
            
            
            let urlString = NSString(string:"\(appUrl)edit_user_picture")
            
            
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
                
                
                
                
                let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
                    
                    OperationQueue.main.addOperation
                        {
                            
                            if data == nil
                            {
                                print("server not responding")
                                
                            }
                            else
                            {
                                
                                
                                do {
                                    
                                    let result = NSString(data: data!, encoding:String.Encoding.ascii.rawValue)!
                                    
                                    print("Body: \(result)")
                                    
                                    let anyObj: Any = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                                    
                                    
                                    basicInfo=NSMutableDictionary()
                                    basicInfo=anyObj as! NSMutableDictionary
                                    
                                    let success = basicInfo.object(forKey: "status") as! NSNumber
                                    
                                    if success==1 {
                                        
                                        print("Profile Picture is Updated")
                                        
                                        
                                    }else{
                                        self.userImg.image = nil
                                        SweetAlert().showAlert("PYT", subTitle: "Unable to update the profile picture, Please try again", style: AlertStyle.warning)
                                        print("Unable to update the picture")
                                        
                                        Udefaults.set("", forKey: "userProfilePic")
                                        
                                    }
                                    
                                    self.profileChangeIndicator.stopAnimating()
                                    self.profileChangeIndicator.isHidden = true
                                    
                                    
                                    
                                } catch
                                {
                                    print("json error: \(error)")
                                    self.profileChangeIndicator.stopAnimating()
                                    self.profileChangeIndicator.isHidden = true
                                    
                                    
                                }
                                
                                
                                
                                
                                
                                
                                
                            }
                    }
                })
                
                task.resume()
            }
            else
            {
                CommonFunctionsClass.sharedInstance().showAlert(title: "No Internet Connection", text: "You are currently offline.", imageName: "alertInternet")
                profileChangeIndicator.stopAnimating()
                profileChangeIndicator.isHidden = true
            }
            
            
        }
    }
    
    
    
    
    
    

}
class ProfileActionsCell: UITableViewCell {
    @IBOutlet weak var actionName: UILabel!
    @IBOutlet weak var actionImage: UIImageView!
    @IBOutlet weak var countLbl: CustomLabel!
}
class ProfileCollectionCell: UICollectionViewCell {
    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var countLbl: CustomLabel!
    
//    override func layoutSubviews() {
//        countLbl.layer.cornerRadius = 10.0
//        countLbl.layer.masksToBounds = true
//    }

}


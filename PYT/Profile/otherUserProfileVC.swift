//
//  otherUserProfileVC.swift
//  PYT
//
//  Created by osx on 24/07/17.
//  Copyright © 2017 osx. All rights reserved.
//

import UIKit

class otherUserProfileVC: UIViewController {

    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var userPicturesCollectionView: UICollectionView!
    var dataArray = NSMutableArray()
    var otheruserId = NSString()
    var countCategory = Int()
    var otherUserProfile = NSString()
    var otherUsername = NSString()
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameTextField.text = otherUsername as String
        userProfileImage.setImageWith(URL (string: otherUserProfile as String), placeholderImage: UIImage (named: ""))
        // Do any additional setup after loading the view.
        
        
        let prm:NSDictionary = ["userId":otheruserId as String, "status": "1"]
        self.postApiToGetPYTUserPhotosDetail(prm, urlToSend: "get_images_of_friend")
        
        
    }

    //MARK: Button_Actions  BACK
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
        //            obj.urlload=""
        //        }
        //        else{
        obj.urlload="get_images_of_friend"//"get_images_for_profile"
        //}
        
       // obj.username = nameTF.text!
        
        obj.countStrText = (dataArray.object(at: indexPath.row) as AnyObject).value(forKey: "count")! as! NSString
        
        self.navigationController?.pushViewController(obj, animated: true)
        
    }
    
    
    
    
    //MARK: All Api and there responses
    //MARK:
    //MARK: Api to get the images and count from server
    //MARK:
    //  url
    func postApiToGetPYTUserPhotosDetail(_ parameterReview: NSDictionary, urlToSend: NSString) {
        
        self.userPicturesCollectionView.isUserInteractionEnabled=false
        
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
                        print("Body: \(result)")
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
                        
                        
                        
                        
                        
                        self.userPicturesCollectionView.reloadData()
                        self.userPicturesCollectionView.isUserInteractionEnabled=true
                        
                        self.countCategory = 0
                        if(self.dataArray.count == 1 || self.dataArray.count == 2)
                        {
                            self.countCategory = 1
                        }
                        self.viewWillLayoutSubviews()
                        
                        
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

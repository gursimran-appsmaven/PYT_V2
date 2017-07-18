//
//  commentViewController.swift
//  PYT
//
//  Created by osx on 01/07/17.
//  Copyright © 2017 osx. All rights reserved.
//

import UIKit
import MBProgressHUD
import SDWebImage
import IQKeyboardManager

class commentViewController: UIViewController, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var commentsTableView: UITableView!
    var dictionaryData = NSDictionary()
    var addComment = Bool()
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var placeHolderLabel: UILabel!
    var reviewsArray = NSMutableArray()
    var foursqReviews = NSMutableArray()
    let uId = Udefaults .string(forKey: "userLoginId")!
    var parameter = NSString()
    var imageIdComment = NSString()
    var ownerId = NSString()
    var largeUrl = NSString()
    var revStr = NSString()
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.tabBarController?.setTabBarVisible(visible: false, animated: true)

        // Do any additional setup after loading the view.
        
        commentsTableView.estimatedRowHeight = 120.0
        commentsTableView.rowHeight = UITableViewAutomaticDimension
        
        self.postApiToGetPYTReview(parameter)
        IQKeyboardManager.shared().shouldResignOnTouchOutside=true
        IQKeyboardManager.shared().isEnableAutoToolbar=false
        NotificationCenter.default.addObserver(self, selector: #selector(commentViewController.refreshComments(_:)),name:NSNotification.Name(rawValue: "updateComments"), object: nil)
        addComment = true
        
        commentTextView.returnKeyType = .done
        commentTextView.delegate = self
        
    }
    
    
    func refreshComments(_ notification: Notification){
        
        self .postApiToGetPYTReview(parameter)
        
        
        
    }
    
    
    //MARK: TextView delegate

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.characters.count
        if(numberOfChars==0)
        {
            placeHolderLabel.isHidden = false
        }
        else
        {
            placeHolderLabel.isHidden = true
        }
        
        return numberOfChars < 200;
    }
    
    func textViewDidChange(_ textView: UITextView)
    {
        revStr = textView.text as NSString
        print(revStr)
    }
    

//    
//    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
//        if(text == "\n") {
//            textView.resignFirstResponder()
//            return false
//        }
//        return true
//    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        placeHolderLabel.isHidden = true
        
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if addComment == false
        {
        if textView.text != "" || textView.text != " " || textView.text != nil {
            placeHolderLabel.isHidden = false
            commentTextView.text = nil
        }
        }
        else
        {
            
        }
    }
    
    
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        let fixedWidth = commentTextView.frame.size.width
        commentTextView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        let newSize = commentTextView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        var newFrame = commentTextView.frame
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        
    }

    
    
    
    
    //MARK:-delegate and datasource of tableView
    //MARK:-
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return commentsTableView.frame.size.height/2 - 15
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let cell:headerCell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! headerCell
       
        
        return cell//.contentView
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
     return reviewsArray.count
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat
//    {
//        return
//    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {

        print(reviewsArray.object(at: indexPath.row))
        let cell:commentCell = tableView.dequeueReusableCell(withIdentifier: "commentCell") as! commentCell
        
        let imageName2 = (reviewsArray.object(at: indexPath.row) as AnyObject).value(forKey: "userPhoto") as! String
        
        let url2 = URL(string: imageName2 )
        let pImage : UIImage = UIImage(named:"dummyProfile1")!
        cell.userProfilePic .layer.cornerRadius = cell.userProfilePic.frame.size.width/2
        cell.userProfilePic.clipsToBounds = true
        
        let block: SDWebImageCompletionBlock = {(image, error, cacheType, imageURL) -> Void in
           
        }
        
        cell.userProfilePic.sd_setImage(with: url2, placeholderImage: pImage, options: SDWebImageOptions(rawValue: 0), completed: block)
        
        
        cell.userNameLbl.text = (self.reviewsArray.object(at: indexPath.row) as AnyObject).value(forKey: "userName") as? String ?? ""
        
        cell.userComment.text = (self.reviewsArray.object(at: indexPath.row) as AnyObject).value(forKey: "comment") as? String
        
        
        
        ///manage comment
       
        cell.editBtn.isHidden=true
        cell.editBtn.isUserInteractionEnabled=false
        cell.editBtn.tag = indexPath.row
        
        if uId == (self.reviewsArray.object(at: indexPath.row) as AnyObject).value(forKey: "reviewerId")! as? String ?? "" {
            cell.editBtn.isHidden=false //show the edit button
            
            cell.editBtn.isUserInteractionEnabled=true
            
            cell.editBtn.addTarget(self, action: #selector(commentViewController.deleteCommentAction(_:)), for: UIControlEvents.touchUpInside)
            
        }
        
        
        
        return cell
        
    }
    
    
    
    
    
    
    
    
    @IBAction func backAction(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }

    
    //Press send button to save the comment
    
    @IBAction func PostCommentAction(_ sender: Any)
    {
        
        commentTextView.text = nil
        placeHolderLabel.isHidden = false
        commentTextView.isScrollEnabled = false
       
        
            //Indicator
            let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
            loadingNotification.mode = MBProgressHUDMode.indeterminate
            loadingNotification.label.text = ""
        
            let userName = Udefaults .string(forKey: "userLoginName")!
            let userPic = Udefaults .string(forKey: "userProfilePic")!
            let imgId = dictionaryData.value(forKey: "imageId") as? String ?? ""
            let otherUserid = dictionaryData.value(forKey: "otherUserId") as? String ?? ""
        
            
            print("id=\(uId)\n name=\(userName)\n Pic=\(userPic)\n imageid=\(imgId)\n OtherId=\(otherUserid)")
        
            if addComment == false // edit comment
            {
                let reviewId = dictionaryData.value(forKey: "reviewId") as? String ?? ""
                self.EditCommentApi(uId, reviewId: reviewId, review: revStr as String )
            }
            else
            {
                self .AddCommentApi(uId, imageId: imgId, otherId: otherUserid, review: revStr as String, myProfilePic: userPic, myUsername: userName)
            }
        
        commentTextView.resignFirstResponder()
        self.commentTextView.layoutIfNeeded()
    }
    
    
    
    
    
    
    
    
    
    //MARK: Get the comments from pyt
    //MARK:
    
    
    
    func postApiToGetPYTReview(_ parameterReview: NSString)
    {
        
        print(parameterReview)
        
        let isConnectedInternet = CommonFunctionsClass.sharedInstance().isConnectedToNetwork()
        
        if isConnectedInternet
        {
            //let request = NSMutableURLRequest(URL: NSURL(string: "\(appUrl)get_reviews")!)//older version
            
            
            let request = NSMutableURLRequest(url: URL(string: "\(appUrl)get_review")!)//newer version
            
            
            
            request.httpMethod = "POST"
            let postString = parameterReview
            request.httpBody = postString.data(using: String.Encoding.utf8.rawValue)
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
                        
                        
                        let anyObj: Any = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                        
                        basicInfo = NSMutableDictionary()
                        basicInfo = anyObj as! NSMutableDictionary
                        
                        let status = basicInfo .value(forKey: "status") as! NSNumber
                        
                        if status == 1
                        {
                            
                            let review = basicInfo.value(forKey: "data") as! NSMutableArray
                            
                            if review.count > 0{
                                
                                self.reviewsArray.removeAllObjects()
                                for i in 0..<review.count
                                {
                                    print(review.object(at: i))
                                    let userPhotoDp = ((review.object(at: i) as AnyObject).value(forKey: "userId")! as AnyObject).value(forKey: "picture") as? String ?? " "
                                    
                                    let reviewTxt = (review.object(at: i) as AnyObject).value(forKey: "review") as? String ?? " "
                                    let reviewername = ((review.object(at: i) as AnyObject).value(forKey: "userId")! as AnyObject).value(forKey: "name") as? String ?? " "
                                    
                                    let reviewerId = ((review.object(at: i) as AnyObject).value(forKey: "userId")! as AnyObject).value(forKey: "_id") as? String ?? ""
                                    
                                    let revieweId = (review.object(at: i) as AnyObject).value(forKey: "_id") as? String ?? ""
                                    
                                    self.reviewsArray.add(["userPhoto": userPhotoDp, "userName": reviewername, "comment": reviewTxt, "reviewerId": reviewerId, "reviewId": revieweId])
                                    
                                }
                                
                                for j in 0..<self.foursqReviews.count{
                                    
                                    let dict = self.foursqReviews.object(at: j)
                                    self.reviewsArray .add(dict)
                                    
                                }
                                
                                
                                print(self.reviewsArray.count)
                                
                                
                                
                                
                            }
                            
                            
                           self.commentsTableView.reloadData()
                            
                            
                            
                        }
                        else
                        {
                           self.reviewsArray = self.foursqReviews
                        }
                        
                        
                        
                        
                    }
                    catch {
                        //print("json error: \(error)")
                        CommonFunctionsClass.sharedInstance().showAlert(title: "Server Alert", text: "Something doesn't seem right, Please try again!", imageName: "alertServer")
                        
                      
                        
                    }
                    
                })
            
                
            }
            task.resume()
            
        }
        else
        {
            CommonFunctionsClass.sharedInstance().showAlert(title: "No Internet Connection", text: "You are currently offline.", imageName: "alertInternet")
        }
        
        
        
        
        
        
        
    }
    
    
    
    
    
    
    
    //////Edit comment----
    
    func EditCommentApi(_ userId: String, reviewId: String, review: String) -> Void {
        
        
        let dict: NSDictionary = ["reviewId":reviewId, "userId": userId, "review": review]// newer version
        
        
        
        print("Parameter for edit comment\(dict)")
        
        let isConnectedInternet = CommonFunctionsClass.sharedInstance().isConnectedToNetwork()
        
        if isConnectedInternet
        {
            //let request = NSMutableURLRequest(URL: NSURL(string: "\(appUrl)add_review")!)// older version
            let request = NSMutableURLRequest(url: URL(string: "\(appUrl)edit_review")!) //new version
            
            
            request.httpMethod = "POST"
            
            
            
            do {
                let jsonData = try!  JSONSerialization.data(withJSONObject: dict, options: [])
                request.httpBody = jsonData
                
                
                // here "jsonData" is the dictionary encoded in JSON data
            } catch let error as NSError {
                print(error)
            }
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            
            
            
             let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
                guard error == nil && data != nil else {                                                          // check for
                    return
                }
                
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                }
                
                
                DispatchQueue.main.async(execute: {
                    
                    do {
                        
                        // let result = NSString(data: data!, encoding:NSASCIIStringEncoding)!
                        // print("Body: \(result)")
                        
                       let anyObj: Any = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                        
                        basicInfo = NSMutableDictionary()
                        basicInfo = anyObj as! NSMutableDictionary
                        
                        let status = basicInfo .value(forKey: "status") as! NSNumber
                        
                        if status == 1
                        {
                            
                            NotificationCenter.default.post(name: Notification.Name(rawValue: "updateComments"), object: nil)
                            
                        
                            
                            
                        }
                        else
                        {
                            
                            //status is 0
                            
                            
                        }
                        
                        
                        
                        
                        
                        
                    } catch {
                        //print("json error: \(error)")
                        CommonFunctionsClass.sharedInstance().showAlert(title: "Server Alert", text: "Something doesn't seem right, Please try again!", imageName: "alertServer")
                        
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
    
    
    
    
    ////MARK: Add Comment Api
    func AddCommentApi(_ userId: String, imageId: String, otherId: String, review: String, myProfilePic: String, myUsername: String ) -> Void
    {
        
        //        let dict: NSDictionary = ["imageId":imageId, "userId": userId, "imageOwner": otherId, "review": review, "userName": myUsername, "userDp": myProfilePic]// older version
        
        let dict: NSDictionary = ["imageId":imageId, "userId": userId, "imgOwner": otherId, "review": review]// newer version
        
        
        
        print("Parameter=\(dict)")
        
        let isConnectedInternet = CommonFunctionsClass.sharedInstance().isConnectedToNetwork()
        
        if isConnectedInternet
        {
            //let request = NSMutableURLRequest(URL: NSURL(string: "\(appUrl)add_review")!)// older version
            let request = NSMutableURLRequest(url: URL(string: "\(appUrl)save_review")!) //new version
            
            
            request.httpMethod = "POST"
            
            
            
            do {
                let jsonData = try!  JSONSerialization.data(withJSONObject: dict, options: [])
                request.httpBody = jsonData
                
                
                // here "jsonData" is the dictionary encoded in JSON data
            }
            catch let error as NSError
            {
                print(error)
            }
            
            
            
            // request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(prmt, options: [])
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            
            
            
          let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
                guard error == nil && data != nil else {                                                          // check for fundamental networking error
                    //print("error=\(error)")
                    return
                }
                
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200
                {           // check for http errors
                    //print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    //print("response = \(response)")
                }
                
                
                
                DispatchQueue.main.async(execute:
                    {
                    do
                    {
                      let anyObj: Any = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                        
                        basicInfo = NSMutableDictionary()
                        basicInfo = anyObj as! NSMutableDictionary
                        
                        let status = basicInfo .value(forKey: "status") as! NSNumber
                        
                        if status == 1
                        {
                            self.backAction(self)
                        }
                        else
                        {
                            //not comments status 0
                            
                            
                        }
                        
                        
                        
                        
                        
                        
                    } catch {
                        //print("json error: \(error)")
                        CommonFunctionsClass.sharedInstance().showAlert(title: "Server Alert", text: "Something doesn't seem right, Please try again!", imageName: "alertServer")
                        
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
    
    
    
    
    
    
    
    ////MARK: Add Comment Api
    func deleteCommentAction(_ sender: UIButton)
    {
        
        print(sender.tag)
        
        let actionSheetControllerIOS8: UIAlertController = UIAlertController(title: "Edit Comment", message: "", preferredStyle: .actionSheet)
        
        let cancelActionButton: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            print("Cancel")
        }
        actionSheetControllerIOS8.addAction(cancelActionButton)
        
      
        
        let deleteActionButton: UIAlertAction = UIAlertAction(title: "Delete", style: .default)
        { action -> Void in
            print("Delete")
            
            print(self.reviewsArray.object(at: sender.tag))
            
            let parmDic: NSDictionary = ["userId": self.uId, "reviewId": (self.reviewsArray.object(at: sender.tag) as AnyObject).value(forKey: "reviewId")!, "imageId": self.imageIdComment ]
            
            
            SweetAlert().showAlert("Are you Sure", subTitle: "Are you sure, you want to delete your review?", style: AlertStyle.customImag(imageFile: "exclamationAlert"), buttonTitle:"Yes I'm Sure", buttonColor: UIColor.clear , otherButtonTitle:  "Cancel", otherButtonColor: UIColor.clear) { (isOtherButton) -> Void in
                if isOtherButton == true
                {
                    print("delete Review tapped")
                    self.deletActionApi(parameter: parmDic, tag: sender.tag)
                }
                else
                {
                    
                    print("Cancel Pressed")

            }
            }
            
        }
        
        
        let editActionButton: UIAlertAction = UIAlertAction(title: "Edit", style: .default)
        { action -> Void in
            
            self.addComment = false
            let dictData = ["imageId": "", "largeImage": self.largeUrl, "thumbnailImage": "", "otherUserId": "", "otherUserName": "", "reviewId": (self.reviewsArray.object(at: sender.tag) as AnyObject).value(forKey: "reviewId")! ]
            self.dictionaryData = dictData as NSDictionary
            
            self.commentTextView.becomeFirstResponder()
            self.commentTextView.text = (self.reviewsArray.object(at: sender.tag) as AnyObject).value(forKey: "comment") as? String
            
            
        }
        
        
        actionSheetControllerIOS8.addAction(editActionButton)
        actionSheetControllerIOS8.addAction(deleteActionButton)
        self.present(actionSheetControllerIOS8, animated: true, completion: nil)
        
        
        
    }
    
    
    func deletActionApi(parameter: NSDictionary, tag: Int) {
        
        
        print("Parameter=\(parameter)")
        
        let isConnectedInternet = CommonFunctionsClass.sharedInstance().isConnectedToNetwork()
        
        if isConnectedInternet
        {
            let request = NSMutableURLRequest(url: URL(string: "\(appUrl)delete_review_v2")!)
            request.httpMethod = "POST"
            do {
                let jsonData = try!  JSONSerialization.data(withJSONObject: parameter, options: [])
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
                
                //  let responseString = String(data: data!, encoding: NSUTF8StringEncoding)
                ////print("responseString = \(responseString)")
                
                
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
                            
                            
                            self.reviewsArray.removeObject(at: tag)
                            
                            self.commentsTableView.reloadData()
                            
                            
                            
                        }
                        else
                        {
                            
                            
                            
                        }
                        
                        
                        
                        
                        
                        
                    } catch {
                        //print("json error: \(error)")
                        CommonFunctionsClass.sharedInstance().showAlert(title: "Server Alert", text: "Something doesn't seem right, Please try again!", imageName: "alertServer")
                        
                        
                        
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


class headerCell: UITableViewCell {
    //headerCell
    
    @IBOutlet weak var commentImage: UIImageView!
    
}

class commentCell: UITableViewCell {
    //commentCell
    
    @IBOutlet weak var userProfilePic: UIImageView!
    @IBOutlet weak var userComment: UILabel!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var userNameLbl: UILabel!
}




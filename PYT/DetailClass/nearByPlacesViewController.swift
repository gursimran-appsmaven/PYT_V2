//
//  nearByPlacesViewController.swift
//  PYT
//
//  Created by osx on 03/07/17.
//  Copyright © 2017 osx. All rights reserved.
//

import UIKit
import SDWebImage
import ImageSlideshow
import MBProgressHUD
import SwiftyJSON

class nearByPlacesViewController: UIViewController {

    
    var newDetail = NSDictionary()
    
    @IBOutlet weak var headerview: GradientView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var bakBtn: UIButton!
    var task1 = URLSessionDataTask()
    var task2 = URLSessionDataTask()
    
    
    //First View
    @IBOutlet weak var imageSlider: ImageSlideshow!
    @IBOutlet weak var hotelImageIcoon: UIImageView!
    @IBOutlet weak var hotelName: UILabel!
    @IBOutlet weak var hotelcategory: UILabel!
    @IBOutlet weak var webLinkImage: UIImageView!
    @IBOutlet weak var webLinkbutton: UIButton!
    var webLinkString = NSString()
    
    //second view
    @IBOutlet weak var moreImagesCollectionView: UICollectionView!
    var moreImagesArray = NSMutableArray()
    
    //OverView View
    @IBOutlet weak var descriptiontextView: UITextView!
    
    //Reviews View 
    @IBOutlet weak var commentsTableView: UITableView!
    var tempReviewArray = NSMutableArray()
    
    @IBOutlet weak var showMoreDescription: UIButton!
    @IBOutlet weak var showMoreComments: UIButton!

    
    //Constraints Outlet
    @IBOutlet weak var moreImagesViewHeight: NSLayoutConstraint!
    @IBOutlet weak var overViewHeight: NSLayoutConstraint!
    @IBOutlet weak var reviewsHeight: NSLayoutConstraint!
    @IBOutlet weak var mainViewHeight: NSLayoutConstraint!
    
    
    
    
    //zoom View
    var DirectionSwipe = NSString()
    var zoomImagesArray = NSMutableArray()
    var indexOfZoomImg = Int()
    var Thumbnails = Bool()
    @IBOutlet var zoomView: UIView!
    @IBOutlet var zoomimageView: UIImageView!
    @IBOutlet weak var zoomIndicator: UIActivityIndicatorView!
    @IBOutlet weak var zoomScrollView: UIScrollView!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
       self.tabBarController?.tabBar.isHidden = true
        //self.tabBarController?.setTabBarVisible(visible: false, animated: true)

        self.showMoreComments.isHidden = true
        self.showMoreDescription.isHidden=true
        self.zoomView.isHidden = true
        // Do any additional setup after loading the view.
        mainViewHeight.constant = 392+moreImagesViewHeight.constant + overViewHeight.constant + reviewsHeight.constant
        
        
        
        headerview.gradientLayer.colors = [UIColor.black.withAlphaComponent(0.75).cgColor, UIColor.clear.cgColor]
        headerview.gradientLayer.gradient = GradientPoint.topBottom.draw()
        
        
        ///// header view with animated effect
        self.view .bringSubview(toFront: headerview)
        self.view .bringSubview(toFront: bakBtn)
        self.headerview .bringSubview(toFront: headerLabel)
        
        
        let quary = newDetail .value(forKey: "name") as! String
        let location = newDetail .value(forKey: "placeName") as! String //"chandigarh"
       
        // let imageId = newDetail.valueForKey("imageId") as! String
        
        let parameter = "https://api.foursquare.com/v2/venues/search?intent=browse&limit=1&client_id=DAKFO3TURLDTUL33JNPRTIGX03NMZM2ACCDWC2HHHZTV2YMT&client_secret=ILF0G3U4DRSC0WDW2EH12SFGTOKIWSKFUIOXV4FFEQOIB34B&v=20140203&near=\(location)&query=\(quary)"
        
        self.datafromFoursquare(parameter)
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        
         let imageLink = newDetail.value(forKey: "images") as! String
        
        var sdWebImageSource = [InputSource]()
        self.imageSlider.slideshowInterval = 0
        self.imageSlider.pageControlPosition = PageControlPosition.hidden //PageControlPosition.InsideScrollView
        self.imageSlider.pageControl.currentPageIndicatorTintColor = UIColor.lightGray
        self.imageSlider.pageControl.pageIndicatorTintColor = UIColor.black
        self.imageSlider.draggingEnabled=true
        self.imageSlider.circular=false
        self.imageSlider.setCurrentPage(0, animated: true)
        
        self.imageSlider.contentScaleMode = UIViewContentMode.scaleAspectFill
        // self.slideShow.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.imageSlider.clipsToBounds=true
        
        sdWebImageSource.append(SDWebImageSource(urlString: imageLink as String)!)
        self.imageSlider.setImageInputs(sdWebImageSource )
        
        
        let singleTapGesture = GestureViewClass(target: self, action: #selector(nearByPlacesViewController.openZoomView))
        singleTapGesture.numberOfTapsRequired = 1 // Optional for single tap
        
        imageSlider.addGestureRecognizer(singleTapGesture)
        
        
        
        
        
        let singleTapGesture2 = GestureViewClass(target: self, action: #selector(nearByPlacesViewController.closeImageView))
        singleTapGesture.numberOfTapsRequired = 1 // Optional for single tap
        
        zoomView.addGestureRecognizer(singleTapGesture2)
        
        
        
        
        
        //////---- Add gesture on zoom view to swipe left and right
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(nearByPlacesViewController.swiped(_:))) // put : at the end of method name
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.zoomView.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(nearByPlacesViewController.swiped(_:))) // put : at the end of method name
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.zoomView.addGestureRecognizer(swipeLeft)
        
        
        
        
    }
    
    
    
    
    @IBAction func backAction(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)

    }
    
    
    
    
    
    //MARK:- Delegates and datasource of tableView
    //MARK:-
    
    
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int
    {
        return 1
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
            return tempReviewArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat
    {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "CommentsCell")!
        
        let imageName2 = (tempReviewArray.object(at: indexPath.row) as AnyObject).value(forKey: "userPhoto") as? String ?? ""
        let url2 = URL(string: imageName2 )
        let pImage : UIImage = UIImage(named:"dummyProfile1")!
        
        let userProfilePicture = cell.contentView .viewWithTag(111) as! UIImageView
        userProfilePicture.layer.cornerRadius = userProfilePicture.frame.size.width/2
        userProfilePicture.clipsToBounds = true
        
        let block: SDWebImageCompletionBlock = {(image, error, cacheType, imageURL) -> Void in
            
        }
        
        userProfilePicture.sd_setImage(with: url2, placeholderImage: pImage, options: SDWebImageOptions(rawValue: 0), completed: block)
        
        
        
        
        
        
        let userNameLabel = cell.contentView .viewWithTag(112) as! UILabel
        userNameLabel.text = (self.tempReviewArray.object(at: indexPath.row) as AnyObject).value(forKey: "userName") as? String
        
        
        let userCommentLabel = cell.contentView .viewWithTag(113) as! UILabel
        userCommentLabel.text = (self.tempReviewArray.object(at: indexPath.row) as AnyObject).value(forKey: "comment") as? String
        
        
//        let commentTimeLabel = cell.contentView .viewWithTag(114) as! UILabel
//        commentTimeLabel.text = ""
        
        return cell
        
        
        
        
    }
    
    
    
    
    
    
    
    //MARK:- CollectionView Data source and delegates
    //MARK:-
    
    func numberOfSectionsInCollectionView(_ collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView,numberOfItemsInSection section: Int) -> Int
    {
      
            return moreImagesArray.count

    }
    
    
    
    func collectionView(_ collectionView: UICollectionView,cellForItemAtIndexPath indexPath: IndexPath) -> UICollectionViewCell
    {
        //Location Images collectionview
                   let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellImages",for: indexPath)
            
            let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
            cell.backgroundView = activityIndicatorView
            activityIndicatorView.startAnimating()
            
            print(moreImagesArray.object(at: indexPath.row))
            
            let locationimage2 = cell.viewWithTag(11111) as! UIImageView
            let imageName2 = (moreImagesArray.value(forKey: "normal") as AnyObject).object(at: indexPath.row)
            
            
            
            let url2 = URL(string: imageName2 as! String)
            let pImage : UIImage = UIImage(named:"dummyBackground1")!
            
            activityIndicatorView .removeFromSuperview()
            
            let block: SDWebImageCompletionBlock = {(image, error, cacheType, imageURL) -> Void in
                
            }
            
            locationimage2.sd_setImage(with: url2, placeholderImage: pImage, options: SDWebImageOptions(rawValue: 0), completed: block)
            
            //completion block of the sdwebimageview
            locationimage2.contentMode = .scaleAspectFill
            locationimage2.layer.cornerRadius=5
            locationimage2.clipsToBounds=true
        
            
        
            
            cell.backgroundColor=UIColor.clear
            cell.layer.shadowColor = UIColor.lightGray .cgColor
            cell.layer.shadowOffset = CGSize(width: 0, height: 0.5)
            cell.layer.shadowOpacity = 1
            cell.layer.shadowRadius = 1.0
            cell.layer.masksToBounds=true
            cell.layer.cornerRadius=5
            
            
            return cell
        
            
    
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: IndexPath)
    {
       
            self.zoomScrollView.minimumZoomScale = 1.0
            self.zoomScrollView.maximumZoomScale = 5.0
            
            self.zoomScrollView.zoomScale = 1.0
            
            Thumbnails = true
            self.zoomimageView.transform = CGAffineTransform(scaleX: 1.0,y: 1.0 )
            DirectionSwipe = "None"
            zoomView.isHidden=false
            indexOfZoomImg=indexPath.row
            
            
            self.view .bringSubview(toFront: zoomView)
            zoomIndicator.startAnimating()
            zoomIndicator.isHidden=false
            
            
            
            
            self.changeZoomImage(indexOfZoomImg)
        
            
        
    
            
    
        
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        
        
        
            
            let width1 = collectionView.frame.size.width/4.20  //1.8
            
            return CGSize(width: width1, height: 110) // The size of one cell
            
        }
    
    
    

    
    
    
    
    //MARK:-
    //MARK:- scrolling detect for animating header view
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView == moreImagesCollectionView {
        }
        else
        {
            if scrollView.contentOffset.y >= 150.0 {
                
                UIView.animate(withDuration: 0.4, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                     //self.headerView.alpha = 1
                }, completion: nil)
                
                
            }
                
            else{
                
                UIView.animate(withDuration: 0.4, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                    //self.headerView.alpha = 0
                   
                }, completion: nil)
                
            }
            
            
        }
        
        
        
    }
    
    
    
    
    //MARK:-
    //MARK:-///////////// Zoom Image Pinch gesture, swipe gesture/////////////
    //MARK:-
    
    @IBAction func zoomImage(_ sender: UIPinchGestureRecognizer) {
        
    }
    
    
    
    func openZoomView() -> Void {
        
        self.zoomScrollView.minimumZoomScale = 1.0
        self.zoomScrollView.maximumZoomScale = 5.0
        
        self.zoomScrollView.zoomScale = 1.0
        
        
        Thumbnails=false
        
        zoomView.isHidden=false
        self.view .bringSubview(toFront: zoomView)
        let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        
        activityIndicatorView.startAnimating()
        
        let imageLink = newDetail.value(forKey: "images") as! String
        let url2 = URL(string: imageLink as String)
        
        
        let pImage : UIImage = UIImage(named:"dummyBackground1")!
        zoomimageView.sd_setImage(with: url2, placeholderImage: pImage)
        
        
        
        
        
//        let block: SDWebImageCompletionBlock! = {(image: UIImage!, error: NSError!, cacheType: SDImageCacheType!, imageURL: URL!) -> Void in
//            
//        }
//        
//        //completion block of the sdwebimageview
//        zoomImage.sd_setImage(with: url2, placeholderImage: pImage, completed: block)
        
        
    }
    
    
    func closeImageView() {
        
        
        zoomView.isHidden=true
        
    }
    
    
    /// swipe gesture to left and light ///////////
    func swiped(_ gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            
            switch swipeGesture.direction {
                
            case UISwipeGestureRecognizerDirection.right :
                print("User swiped right")
                
                DirectionSwipe = "Right"
                // decrease index first
                
                indexOfZoomImg -= 1
                
                // check if index is in range
                
                if Thumbnails==true {
                    
                    if indexOfZoomImg < 0 {
                        indexOfZoomImg = 0
                        
                    }else{
                        self.changeZoomImage(indexOfZoomImg)
                    }
                    
                }
                    
                    
                else{
                    if indexOfZoomImg < 0 {
                        
                        indexOfZoomImg = 0
                        
                    }else{
                        self.changeZoomImage(indexOfZoomImg)
                    }
                }
                
                
            case UISwipeGestureRecognizerDirection.left:
                print("User swiped Left")
                
                DirectionSwipe = "Left"
                
                // increase index first
                
                indexOfZoomImg += 1
                
                // check if index is in range
                
                if Thumbnails==true {
                    
                    if indexOfZoomImg > moreImagesArray.count - 1 {
                        indexOfZoomImg = moreImagesArray.count - 1
                        
                    }else{
                        self.changeZoomImage(indexOfZoomImg)
                    }
                    
                    
                }
                    
                else{
                    
                    if indexOfZoomImg > zoomImagesArray.count - 1 {
                        
                        indexOfZoomImg = zoomImagesArray.count - 1
                        
                    }else{
                        self.changeZoomImage(indexOfZoomImg)
                    }
                }
                
                
                
                
                
                
                
                
                
            default:
                break //stops the code/codes nothing.
                
                
            }
            
        }
        
        
    }
    
    //Change the image in zoomed view
    
    func changeZoomImage(_ index:Int) -> Void {
        
        self.zoomimageView.transform = CGAffineTransform(scaleX: 1.0,y: 1.0 )
        if DirectionSwipe == "Right" {
            
            CATransaction.begin()
            CATransaction.setAnimationDuration(0.5)
            let transition = CATransition()
            transition.type = kCATransitionPush
            transition.subtype = kCATransitionFromLeft
            
            zoomimageView.layer.add(transition, forKey: kCATransition)
            zoomimageView.layer.add(transition, forKey: kCATransition)
            
            
            
            if Thumbnails == true {
                
                let imageName = (moreImagesArray.value(forKey: "normal") as AnyObject).object(at: indexOfZoomImg)
                let url = URL(string: imageName as! String)
                self.zoomIndicator.startAnimating()
                self.zoomIndicator.isHidden=false
                zoomimageView.sd_setImage(with: url)
                
                let imageName2 = (moreImagesArray.value(forKey: "original") as AnyObject).object(at: indexOfZoomImg)
                let url2 = URL(string: imageName2 as! String)
                let pImage2 = UIImageView()
                pImage2.sd_setImage(with: url, placeholderImage: nil)
                
                let block: SDWebImageCompletionBlock = {(image, error, cacheType, imageURL) -> Void in
                    self.zoomIndicator.isHidden=true
                }
                
                zoomimageView.sd_setImage(with: url2, placeholderImage: pImage2.image, options: SDWebImageOptions(rawValue: 0), completed: block)
                
                
                
                
            }
                
            else
            {
                var zoomImageString = NSString()
                zoomImageString = zoomImagesArray .object(at: index) as! NSString
                
                
                let url2 = URL(string: zoomImageString as String)
                
                
                zoomimageView.sd_setImage(with: url2)
                
                
                let pImage : UIImage = UIImage(named:"dummyBackground1")!
                zoomIndicator.startAnimating()
                self.zoomIndicator.isHidden=false
                let block: SDWebImageCompletionBlock = {(image, error, cacheType, imageURL) -> Void in
                    self.zoomIndicator.isHidden=true
                }
                
                zoomimageView.sd_setImage(with: url2, placeholderImage: pImage, options: SDWebImageOptions(rawValue: 0), completed: block)
                
                
            }
            
            CATransaction.commit()//moving effect of images
            
            
        }
            
            
            
        else if(DirectionSwipe == "Left")
        {
            
            CATransaction.begin()
            CATransaction.setAnimationDuration(0.5)
            let transition = CATransition()
            transition.type = kCATransitionPush
            transition.subtype = kCATransitionFromRight
            
            zoomimageView.layer.add(transition, forKey: kCATransition)
            zoomimageView.layer.add(transition, forKey: kCATransition)
            
            
            
            if Thumbnails == true {
                
                let imageName = (moreImagesArray.value(forKey: "normal") as AnyObject).object(at: indexOfZoomImg)
                let url = URL(string: imageName as! String)
                
                zoomimageView.sd_setImage(with: url)
                
                let imageName2 = (moreImagesArray.value(forKey: "original") as AnyObject).object(at: indexOfZoomImg)
                let url2 = URL(string: imageName2 as! String)
                let pImage2 = UIImageView()
                pImage2.sd_setImage(with: url, placeholderImage: nil)
                self.zoomIndicator.startAnimating()
                self.zoomIndicator.isHidden=false
                let block: SDWebImageCompletionBlock = {(image, error, cacheType, imageURL) -> Void in
                    self.zoomIndicator.isHidden=true
                }
                
                zoomimageView.sd_setImage(with: url2, placeholderImage: pImage2.image, options: SDWebImageOptions(rawValue: 0), completed: block)
                
                
                
                
                
                
                
            }
                
            else
            {
                var zoomImageString = NSString()
                zoomImageString = zoomImagesArray .object(at: index) as! NSString
                
                
                let url2 = URL(string: zoomImageString as String)
                
                
                
                zoomimageView.sd_setImage(with: url2)
                
                
                let pImage : UIImage = UIImage(named:"dummyBackground1")!
                self.zoomIndicator.startAnimating()
                self.zoomIndicator.isHidden=false
                let block: SDWebImageCompletionBlock = {(image, error, cacheType, imageURL) -> Void in
                    self.zoomIndicator.isHidden=true
                }
                
                zoomimageView.sd_setImage(with: url2, placeholderImage: pImage, options: SDWebImageOptions(rawValue: 0), completed: block)
                
            }
            CATransaction.commit()//moving effect of images
            
        }
            
        else
        {
            
            if Thumbnails == true
            {
                let imageName = (moreImagesArray.value(forKey: "normal") as AnyObject).object(at: indexOfZoomImg)
                let url = URL(string: imageName as! String)
                
                self.zoomIndicator.startAnimating()
                self.zoomIndicator.isHidden=false
                zoomimageView.sd_setImage(with: url)
                
                let imageName2 = (moreImagesArray.value(forKey: "original") as AnyObject).object(at: indexOfZoomImg)
                let url2 = URL(string: imageName2 as! String)
                let pImage2 = UIImageView()
                pImage2.sd_setImage(with: url, placeholderImage: nil)
                
                let block: SDWebImageCompletionBlock = {(image, error, cacheType, imageURL) -> Void in
                    self.zoomIndicator.isHidden=true
                }
                
                zoomimageView.sd_setImage(with: url2, placeholderImage: pImage2.image, options: SDWebImageOptions(rawValue: 0), completed: block)
                
            }
                
            else
            {
                var zoomImageString = NSString()
                zoomImageString = zoomImagesArray .object(at: index) as! NSString
                let url2 = URL(string: zoomImageString as String)
                
                self.zoomIndicator.startAnimating()
                self.zoomIndicator.isHidden=false
                var slidImg:UIImage = UIImage (named: "dummyBackground1")!
                
                
                if imageSlider.currentSlideshowItem?.imageView.image==nil {
                    
                    
                }
                else{
                    slidImg = (imageSlider.currentSlideshowItem?.imageView.image!)!
                }
                
                let block: SDWebImageCompletionBlock = {(image, error, cacheType, imageURL) -> Void in
                    self.zoomIndicator.isHidden=true
                }
                
                zoomimageView.sd_setImage(with: url2, placeholderImage: slidImg, options: SDWebImageOptions(rawValue: 0), completed: block)
                
            }
        }
    }

    
    
    //MARK: Update layous of the UIViews 
    func updateThirdView() {
        
       // self.reviewsTopSpace.constant = 1
         var heightOfTableView = 0
        heightOfTableView = Int(self.commentsTableView.rowHeight)
        if showMoreComments.isHidden == true {
            //self.reviewsTopSpace.constant = 0
        }
        
        if tempReviewArray.count<1
        {
            self.showMoreComments.isHidden = true
            self.reviewsHeight.constant = 0
           
            self.commentsTableView.isHidden=true
            //self.reviewslableinView.isHidden = true
            
        }
        else if(tempReviewArray.count==2)
        {
            self.showMoreComments.isHidden = true
            self.reviewsHeight.constant = CGFloat(heightOfTableView + 80 + heightOfTableView)
            self.commentsTableView.isHidden=false
            //self.reviewslableinView.isHidden = false
        }
        else
        {
            self.showMoreComments.isHidden = false
            if tempReviewArray.count==1
            {
                self.reviewsHeight.constant = CGFloat(heightOfTableView + 80)
                self.showMoreComments.isHidden = true
            }
            else{
                self.reviewsHeight.constant = CGFloat(heightOfTableView + 80 + heightOfTableView)
            }
            
            self.commentsTableView.isHidden=false
            
         //   self.reviewslableinView.isHidden = false
        }
        
        self.commentsTableView.reloadData()
        
//        
//        self.thirdView.layoutIfNeeded()
//        self.view.layoutIfNeeded()
//        self.view.setNeedsLayout()
        
        
        
        
    }
    
    
    
    
    
    
    
    //MARK:- Get detail from foursquare api
    //MARK:-
    
    
    func datafromFoursquare(_ parameterStringHotels : String)
    {
        let isConnectedInternet = CommonFunctionsClass.sharedInstance().isConnectedToNetwork()
        
        if isConnectedInternet
        {
            
            
            
            let urlString = NSString(string:"\(parameterStringHotels)")
            print("WS URL----->>" + (urlString as String))
            
            //urlString = urlString .stringByReplacingOccurrencesOfString(" ", withString: "%20")
            
            
            let finalStr = urlString
            let safeURL = finalStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            
            let url:URL = URL(string: safeURL as String)!
            print("Final Url-----> " + (safeURL as String))
            
            
            let session = URLSession.shared
            
            let request = NSMutableURLRequest(url: url)
            request.httpMethod = "GET"
            request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
            
            
           
            task1 = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
                
                OperationQueue.main.addOperation
                    {
                        print("data from foursquare ")
                        
                      //  self.firstIndicator .removeFromSuperview()
                       // self.secondIndicator .removeFromSuperview()
                        
                        if data == nil
                        {
                            
                            
                            
                        }
                        else
                        {
                            
                            self.descriptiontextView.isEditable=true
                            self.moreImagesViewHeight.constant = 0
                            self.webLinkbutton.isHidden=true
                            self.webLinkImage.isHidden=true
                            self.showMoreDescription.isHidden=true
                            
                            
                            
                            // let result = NSString(data: data!, encoding:NSASCIIStringEncoding)!
                            
                            
                            
                            do{
                                
                                
                                if data?.count != 0{
                                    
                                    let jsonResult: AnyObject = try! JSONSerialization.jsonObject(with: data!, options:JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                                    print("in try ")
                                    var resultHotels = NSDictionary()
                                    resultHotels = jsonResult as! NSDictionary
                                    
                                    
                                    var hotelDetail = NSDictionary()
                                    hotelDetail = resultHotels.value(forKey: "response") as! NSDictionary
                                    
                                    
                                    let totalElements = hotelDetail.allKeys.count
                                    if totalElements >= 1{
                                        
                                        var venues = NSMutableArray()
                                        
                                        venues = hotelDetail.value(forKey: "venues") as! NSMutableArray
                                        
                                        
                                        
                                        
                                        if venues.count < 1 {
                                           
                                            self.showMoreDescription.isHidden=true
                                            self.moreImagesViewHeight.constant = 0
                                           
                                            
                                            
                                        }
                                        else
                                        {
                                             print(venues)
                                           
                                            let locationDict: NSDictionary = (venues[0] as AnyObject).value(forKey: "location") as! NSDictionary
                                            
                                            let latFS = locationDict["lat"] != nil
                                            
                                            let longFS = locationDict["lng"] != nil
                                            
                                            
                                            if let urlHotel = (venues.object(at: 0) as AnyObject).value(forKey: "url")
                                            {
                                                self.webLinkbutton.isHidden=false
                                                self.webLinkbutton.setTitle((urlHotel as! NSString) as String, for: .normal)
                                                self.webLinkImage.isHidden=false
                                                self.webLinkString=urlHotel as! NSString
                                                self.webLinkbutton.setTitle(self.webLinkString as String, for: .normal)
                                                
                                            }
                                            
                                            
                                            if let venueId = (venues[0] as AnyObject).value(forKey: "id"){
                                                
                                                
                                                
                                                self .getPhotosOfHotel(venueId as! NSString)
                                                
                                                
                                            }
                                            
                                            
                                            
                                            
                                            print((venues[0] as AnyObject).value(forKey: "name") as? String ?? "")
                                            
                                            self.hotelName.text = (venues[0] as AnyObject).value(forKey: "name") as? String ?? ""
                                            self.hotelName.textAlignment=NSTextAlignment .left
                                          
                                            let Locname = ((venues[0] as AnyObject).value(forKey: "location") as AnyObject).value(forKey: "address") as? String ?? ""
                                            self.hotelName.numberOfLines=0
                                            
                                            
                                        }
                                        
                                    }
                                    else
                                    {
                                        
                                        //self.collectionHeightThumbnails.constant=0
                                       // self.collectionContainView.constant=0
                                       // self.morePictureLabel.isHidden=true
                                        //self.reviewsTopSpace.constant = 0
                                        self.showMoreDescription.isHidden=true
                                        self.showMoreDescription.isUserInteractionEnabled=true
                                      
                                    }
                                    
                                    
                                    
                                }
                                
                                
                                
                                
                            }
                            catch
                            {
                                print("catch for task 1")
                            }
                            
                            
                        }
                }
                
            })
            
            task1.resume()
        }
        else
        {
            CommonFunctionsClass.sharedInstance().showAlert(title: "No Internet Connection", text: "You are currently offline.", imageName: "alertInternet")
            
            
            
        }
        
        
        
        
        
        
        
        
        
        
    }
    
    
    

    
    
    
    
    
    
    
    
    
    
    
    
    //MARK:- Get the images from the four square api of the hotels
    //MARK:-
    
    func getPhotosOfHotel(_ idString:NSString) -> Void {
        
        let isConnectedInternet = CommonFunctionsClass.sharedInstance().isConnectedToNetwork()
        
        if isConnectedInternet
        {
            
            
            let urlString = NSString(string:"https://api.foursquare.com/v2/venues/\(idString)?client_id=DAKFO3TURLDTUL33JNPRTIGX03NMZM2ACCDWC2HHHZTV2YMT&client_secret=ILF0G3U4DRSC0WDW2EH12SFGTOKIWSKFUIOXV4FFEQOIB34B&v=20140203")
            
            
            let needsLove = urlString
            let safeURL = needsLove.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            
            let url:URL = URL(string: safeURL as String)!
            print("Final Url-----> " + (safeURL as String))
            
            let session = URLSession.shared
            
            let request = NSMutableURLRequest(url: url)
            request.httpMethod = "GET"
            request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
            task2 = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
                
                
                OperationQueue.main.addOperation
                    {
                        
                        
                        
                       // self.firstIndicator.removeFromSuperview()
                        if data == nil
                        {
                            
                           // self.firstIndicator.removeFromSuperview()
                        }
                        else
                        {
                            do{
                                
                                if data?.count != 0{
                                    let anyObj: Any = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                                    
                                    var resultHotels = NSDictionary()
                                    resultHotels = anyObj as! NSDictionary
                                    
                                    
                                    
                                    let hotelDetail = resultHotels.value(forKey: "response") as! NSDictionary
                                    
                                    
                                    let totalElements = hotelDetail.allKeys.count
                                    if totalElements >= 1{
                                        
                                        
                                        
                                        
                                        let  venues = hotelDetail.value(forKey: "venue") as! NSMutableDictionary
                                        
                                        self.descriptiontextView.text=""
                                        
                                        
                                        
                                        if let desc =  venues.value(forKey: "description")
                                        {
                                            self.descriptiontextView.text=(desc as! NSString) as String
                                            self.descriptiontextView.isEditable=true
                                         
                                        //self.secondView.isHidden=false
                                            self.view .setNeedsLayout()
                                            
                                            self.showMoreDescription.isHidden=true
//                                            if self.descriptionTextv.text.length >350{
//                                                self.moreImagesViewHeight.constant = 210
//                                                self.showMoreDescription.isUserInteractionEnabled=true
//                                               
//                                                self.showMoreDescription.isHidden=false
//                                                
//                                            }
//                                            else{
//                                                self.moreImagesViewHeight.constant = self.heightDescription(self.descriptionString) //195
//                                            }
                                            
                                            
                                        }
                                        else
                                        {
                                            
                                            self.descriptiontextView?.isEditable=true
                                          
                                            self.descriptiontextView?.textColor = UIColor.lightGray
                                            self.descriptiontextView?.isEditable=false
                                            self.overViewHeight.constant = 0//self.heightDescription("") //130
                                            self.showMoreDescription.isHidden=true
                                            //self.descriptionTopSpace.constant = 1
                                          
                                            
                                        }
                                        
                                        
                                        
                                        
                                        
                                        
                                        
                                        
                                        
                                        
                                        
                                        
                                        if (venues.value(forKey: "photos")! as AnyObject).value(forKey: "count") as! Int == 0 {
                                            
                                            self.moreImagesViewHeight.constant = 0
                                            //self.collectionHeightThumbnails.constant=0
                                           // self.collectionContainView.constant=0
                                           // self.morePictureLabel.isHidden=true
                                           // self.reviewsTopSpace.constant = 0
                                          //  self.morePicturesTopSpace.constant = 0
                                            
                                            
                                        }
                                        else
                                        {
                                            
                                           // self.collectionHeightThumbnails.constant=80
                                            let photos = (((venues .value(forKey: "photos")! as AnyObject).object(forKey: "groups") as AnyObject).object(at: 0) as AnyObject).value(forKey: "items") as? NSMutableArray
                                            self.moreImagesViewHeight.constant = 120
                                          //  self.collectionContainView.constant=145
                                          //  self.morePictureLabel.isHidden=false
                                          //  self.reviewsTopSpace.constant = 1
                                           // self.morePicturesTopSpace.constant = 1
                                            
                                            
                                            
                                            
                                            
                                            
                                            
                                            for l in 0..<photos!.count
                                            {
                                                let str1 = (photos![l] as AnyObject).value(forKey: "prefix") as? String ?? ""
                                                let str2 = (photos![l] as AnyObject).value(forKey: "suffix") as? String ?? ""
                                                
                                                let combinedString = "\(str1)200x200\(str2)"
                                                let combinedString2 = "\(str1)original\(str2)"
                                                
                                                
                                                self.moreImagesArray .add(["normal": combinedString, "original": combinedString2])
                                            }
                                            
                                            
                                            
                                            self.moreImagesCollectionView .reloadData()
                                            
                                            
                                            
                                            
                                            
                                            
                                        }
                                        
                                        
                                        
                                        
                                        
                                        ////----- Get reviews
                                        if (venues.value(forKey: "tips")! as AnyObject).value(forKey: "count") as! Int == 0 {
                                            
                                            self.reviewsHeight.constant = 0
                                            
                                            
                                        }
                                            
                                        else
                                        {
                                            var itemsArray = NSMutableArray()
                                            
                                            itemsArray = (((venues.value(forKey: "tips")! as AnyObject).value(forKey: "groups") as AnyObject).object(at: 0) as AnyObject).value(forKey: "items") as! NSMutableArray
                                            
                                            self.tempReviewArray = NSMutableArray() //.removeAllObjects()
                                            for j in 0..<itemsArray.count{
                                                
                                                
                                                let text = (itemsArray.object(at: j)as AnyObject).value(forKey: "text") as! String
                                                
                                                
                                                let prefix = (((itemsArray.object(at: j) as AnyObject).value(forKey: "user") as AnyObject).value(forKey: "photo") as AnyObject).value(forKey: "prefix") as? String ?? ""
                                                
                                                
                                                let suffix = (((itemsArray.object(at: j) as AnyObject).value(forKey: "user") as AnyObject).value(forKey: "photo") as AnyObject).value(forKey: "suffix") as? String ?? ""
                                                
                                                let combinePhoto = "\(prefix)300x300\(suffix)"
                                                
                                                
                                                
                                                
                                                let firstName = ((itemsArray.object(at: j) as AnyObject).value(forKey: "user") as AnyObject ).value(forKey: "firstName") as? String ?? ""
                                                
                                                
                                                let lastName = ((itemsArray.object(at: j) as AnyObject).value(forKey: "user") as AnyObject).value(forKey: "lastName") as? String ?? ""
                                                
                                                
                                                let combineName = "\(firstName) \(lastName)"
                                                
                                                
                        
                                                
                                                self.tempReviewArray .add(["userPhoto": combinePhoto, "userName": combineName, "comment": text])
                                                
                                            }
                                          
                                            
                                        }
                                        
                                        
                                        
                                        
                                        
                                    }
                                    
                                    
                                   // self.firstIndicator .removeFromSuperview()
                                   // self.secondIndicator.removeFromSuperview()
                                    
                                    
                                    
                                    
                                    /// Manage the height of reviews View here
                                    
                                  //  print(self.reviewsArray.count)
                                    print(self.tempReviewArray.count)
                                    
                                    
                                    
                                    
                                    self.updateThirdView()
                                    
                                    
                                    
                                }
                            }catch {
                                print("Task 2 catch block")
                            }
                            
                            
                            
                        }
                        
                        
                        
                        
                        
                }
                
                
                
                
                
                
            })
            
            task2.resume()
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

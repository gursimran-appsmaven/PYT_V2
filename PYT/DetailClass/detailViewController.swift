//
//  detailViewController.swift
//  PYT
//
//  Created by Niteesh on 25/10/16.
//  Copyright © 2016 appsMaven. All rights reserved.
//

import UIKit
import SDWebImage
import ImageSlideshow
import MBProgressHUD
import SwiftyJSON
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.

//fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
//  switch (lhs, rhs) {
//  case let (l?, r?):
//    return l < r
//  case (nil, _?):
//    return true
//  default:
//    return false
//  }
//}


class detailViewController: UIViewController, apiClassDelegate {
    
    
    
    @IBOutlet var contentViewHeight: NSLayoutConstraint!
    
    @IBOutlet var heightOfFirstView: NSLayoutConstraint!//1st View of scroll
    
    @IBOutlet var heightOfSecondView: NSLayoutConstraint! //2nd View of scroll
    
    @IBOutlet var heightOfThirdView: NSLayoutConstraint!
    
    @IBOutlet var heightOfTableView: NSLayoutConstraint!
    
    var tipsView = UIView()
    
    
    @IBOutlet var firstView: UIView!//contains slide images and user info
    @IBOutlet var secondView: UIView!//contaion description view
    
    @IBOutlet var thirdView: UIView!//contains reviews table view
    
    @IBOutlet var forthView: UIView!//contains near by collection view
    
    @IBOutlet weak var ThumbnailsView: UIView!//Contaims thumbnails collection view
    
    @IBOutlet var userNameHeight: NSLayoutConstraint!
    
    @IBOutlet var locationHeight: NSLayoutConstraint!
    
    //zoomView
    
    @IBOutlet var zoomView: UIView!
    @IBOutlet var zoomimageView: UIImageView!
    @IBOutlet weak var zoomIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var zoomScrollView: UIScrollView!
    
    
    
    @IBOutlet var bottomView: UIView!
    
    @IBOutlet weak var bottomView2: UIView!
   
    
    
    @IBOutlet weak var reviewslableinView: UILabel!
    @IBOutlet var detailTable: UITableView!
    @IBOutlet var collectionViewImages: UICollectionView!
    
    @IBOutlet weak var webLinkImg: UIImageView!
    @IBOutlet var webLinkBtnOutlet: UIButton!
    
    
    
    
    
    @IBOutlet var collectionViewThumbnails: UICollectionView!
    
    
    
    @IBOutlet weak var collectionHeightThumbnails: NSLayoutConstraint!
    
    @IBOutlet weak var morePictureLabel: UILabel!
    @IBOutlet weak var collectionContainView: NSLayoutConstraint!
    
    // @IBOutlet var locationImage: UIImageView!
    @IBOutlet var slideShow: ImageSlideshow!
    
    
    @IBOutlet var profilePicImage: UIImageView!
    
    @IBOutlet var borderView: UIImageView!
    
    
    @IBOutlet var userNameTxtv: UILabel!
      @IBOutlet weak var locationTxtv: UILabel!

    @IBOutlet weak var categoryLabel: UILabel!
    
    
    
    @IBOutlet var categoryViewHeight: NSLayoutConstraint!
    
    
    
    @IBOutlet var descriptionTextv: UITextView!
    @IBOutlet var showMoreDescription: UIButton!
    
    
    
    @IBOutlet var timingsTextv: UITextView!
    
    
    @IBOutlet var showMoreComments: UIButton!
    
    
    @IBOutlet weak var headerView: GradientView!
    @IBOutlet var headerImageView: UIImageView!
    
    @IBOutlet weak var headerView2: UILabel!
    
    @IBOutlet var headerLabel: UILabel!
    @IBOutlet var BackBtn: UIButton!
    
    //bottom tab
    @IBOutlet var stImg: UIImageView!
    @IBOutlet var likeImg: UIImageView!
    @IBOutlet var bucketImg: UIImageView!
     @IBOutlet var deleteImg: UIImageView!
    
    @IBOutlet weak var stImg2: UIImageView!
    @IBOutlet var likeImg2: UIImageView!
    @IBOutlet var bucketImg2: UIImageView!
    
    
    
    var firstTime = true
    var fromStory = Bool()
    
    
    
    
    
    
    var arrayWithData = NSMutableArray()
    var webLinkString = NSString()
    var hotelImagesArray = NSMutableArray()
    var descriptionString = NSString()
    var nearByPlacesArray = NSMutableArray()
    var reviewsArray = NSMutableArray()
    var tempReviewArray = NSMutableArray()
    var zoomImagesArray = NSMutableArray()
    var indexOfZoomImg = Int()
    var Thumbnails = Bool()
    var DirectionSwipe = NSString()
    var countLikes = NSMutableArray()
    var fromInterest = Bool()
    var LAT = NSNumber()
    var LONG = NSNumber()
    var radiusNearBy = "100"
    
    
    
    
    ////// Indicators ////
    
    @IBOutlet var forthIndicator: UIActivityIndicatorView!
    
    @IBOutlet var secondIndicator: UIActivityIndicatorView!
    
    @IBOutlet var firstIndicator: UIActivityIndicatorView!
    
    
    
    
    //spacers
    
    @IBOutlet var morePicturesTopSpace: NSLayoutConstraint!
    @IBOutlet var descriptionTopSpace: NSLayoutConstraint!
    @IBOutlet var reviewsTopSpace: NSLayoutConstraint!
    
    @IBOutlet var nearByPlacesTopSpace: NSLayoutConstraint!
    @IBOutlet weak var descSeperaterLabel: UILabel!
    
    
    //Api's manage
    var task1 = URLSessionDataTask()
    var task2 = URLSessionDataTask()
    var task3 = URLSessionDataTask()
    
    
    
   
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
      //  print(arrayWithData)
        
        let profileImage = (self.arrayWithData[0] as AnyObject).value(forKey: "profileImage") as? NSString ?? ""
        let url = URL(string: profileImage as String)
        
        LAT = (self.arrayWithData[0] as AnyObject).value(forKey: "latitude") as! NSNumber
        LONG = (self.arrayWithData[0] as AnyObject).value(forKey: "longitude") as! NSNumber
        
        profilePicImage.sd_setImage(with: url, placeholderImage: UIImage (named: "dummyProfile1"))
        profilePicImage.layer.cornerRadius=profilePicImage.frame.size.width/2
        profilePicImage.clipsToBounds=true
        
      
        let locationImageStandard = (self.arrayWithData[0] as AnyObject).value(forKey: "standardImage") as! NSString
       // let urlStand = NSURL(string: locationImageStr as String)
        
        var multiImg = NSMutableArray()
        multiImg = (self.arrayWithData[0] as AnyObject).value(forKey: "multipleImagesLarge")as! NSMutableArray
        
        var multiImgStandard = NSMutableArray()
        multiImgStandard = (self.arrayWithData[0] as AnyObject).value(forKey: "multipleImagesStandard")as! NSMutableArray
        self.slideImages(multiImgStandard, imageLink: locationImageStandard)
        
        
        
        let NearLoc = "\((self.arrayWithData[0] as AnyObject).value(forKey: "Venue") as! NSString)"
        
        var locHeader = "\((self.arrayWithData[0] as AnyObject).value(forKey: "cityName")as? String ?? "Empty")"
        
        if locHeader == "Empty" {
            
           locHeader = "\((self.arrayWithData[0] as AnyObject).value(forKey: "CountryName")as? String ?? "\(NearLoc)")"
        }
        
        
        
        var tagGeo = (self.arrayWithData[0] as AnyObject).value(forKey: "geoTag") as! String
        
        
        if tagGeo == " " || tagGeo == "" {
            tagGeo=NearLoc as String
        }
        
        
        let imageId = (self.arrayWithData[0] as AnyObject).value(forKey: "imageId") as? String ?? ""
        
        //let uId = Udefaults .string(forKey: "userLoginId")
       // let otherUserId = (self.arrayWithData[0] as AnyObject).value(forKey: "otherUserId") as? String ?? ""
        
        
        //  DispatchQueue.main.async(execute: {
        
        var parameter = ""
        
        if self.LAT == 0
        {
            parameter = "https://api.foursquare.com/v2/venues/search?intent=browse&limit=1&client_id=DAKFO3TURLDTUL33JNPRTIGX03NMZM2ACCDWC2HHHZTV2YMT&client_secret=ILF0G3U4DRSC0WDW2EH12SFGTOKIWSKFUIOXV4FFEQOIB34B&v=20140203&near=\(NearLoc)&query=\(tagGeo)"
        }
        else
        {
            parameter = "https://api.foursquare.com/v2/venues/search?intent=browse&limit=1&client_id=DAKFO3TURLDTUL33JNPRTIGX03NMZM2ACCDWC2HHHZTV2YMT&client_secret=ILF0G3U4DRSC0WDW2EH12SFGTOKIWSKFUIOXV4FFEQOIB34B&v=20140203&query=\(tagGeo)&ll=\(String(describing: self.LAT)),\(String(describing: self.LONG))&radius=1500"
        }
         DispatchQueue.global(qos: .background).async {
        // DispatchQueue.main.async(execute: {
        self.datafromFoursquare(parameter)// get the data from four square api
        
       //  })
        }
        
            
            
            
            ///// zoom images
            self.zoomView.isHidden=true
            let singleTapGesture = GestureViewClass(target: self, action: #selector(detailViewController.openZoomView))
            singleTapGesture.numberOfTapsRequired = 1 // Optional for single tap
            self.slideShow.addGestureRecognizer(singleTapGesture)
            
            /// clos ethe zoom view
            let singleTapGesture2 = GestureViewClass(target: self, action: #selector(detailViewController.closeImageView))
            singleTapGesture2.numberOfTapsRequired = 1 // Optional for single tap
            self.zoomView.addGestureRecognizer(singleTapGesture2)
            
        
            
            //manage for Like and unlike
            let like = (self.arrayWithData[0] as AnyObject).value(forKey: "likeBool") as! Bool
            if like {
                self.likeImg.image = UIImage (named: "locationLike")
                self.likeImg2.image = UIImage (named: "locationLike")
            }
            else
            {
                self.likeImg.image=UIImage (named: "locationUnlike")
                self.likeImg2.image=UIImage (named: "locationUnlike")
            }
            
            
            
            
            
            
            
            
            var countst = NSArray()
            
            if countsDictionary.object(forKey: "bookings") != nil {
//                if let stCount = countsDictionary.value(forKey: "bookings"){
                    countst = countsDictionary.value(forKey: "bookings") as! NSArray
                //}
            }
            
            self.stImg.image=UIImage.init(named: "locationRemoveplan")
            self.stImg2.image=UIImage.init(named: "locationRemoveplan")
            if countst.count>0
            {
                // print(countst)
                if countst.contains(imageId)
                {
                    self.stImg.image=UIImage.init(named: "locationPlan")
                    self.stImg2.image=UIImage.init(named: "locationPlan")
                }
            }
            
            
            
            //bucket count
            
            var countBkt = NSArray()
            
            if countsDictionary.object(forKey: "bucketCount") != nil {
                if let bktCount = countsDictionary.value(forKey: "bucketCount"){
                    countBkt = countsDictionary.value(forKey: "bucketImages") as! NSArray
                }
            }
            
            
            self.bucketImg.image=UIImage.init(named: "locationRemoveBucket")
            self.bucketImg2.image=UIImage.init(named: "locationRemoveBucket")
            if countBkt.count>0
            {
                
                print(countBkt)
                if countBkt.contains(imageId) {
                    self.bucketImg.image=UIImage.init(named: "locationBucket")
                    self.bucketImg2.image=UIImage.init(named: "locationBucket")
                }
                
            }
            
            
            
            
            
            
           // })
        
        
        
        
        /// user name textview ///
        self.userNameTxtv.text = (self.arrayWithData[0] as AnyObject).value(forKey: "userName") as? String ?? " "
        let fixedWidth = self.userNameTxtv.frame.size.width
        self.userNameTxtv.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        let newSize = self.userNameTxtv.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        var newFrame = self.userNameTxtv.frame
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
       // self.userNameTxtv.frame = newFrame;
        
        self.updateFirstView()
        
        
        if (self.arrayWithData[0] as AnyObject).value(forKey: "Type") as! String == "PYT"
        {
            
            let descriptionAsComment = (self.arrayWithData[0] as AnyObject).value(forKey: "Description") as? String ?? ""
            
            if descriptionAsComment == "" || descriptionAsComment == "Enter description here.." {
                
            }
            
            
            self.updateThirdView()
            
            
        }
        

        
        firstIndicator .startAnimating()
        secondIndicator .startAnimating()
        forthIndicator .startAnimating()
        
        self.webLinkBtnOutlet.isHidden=true
        self.webLinkImg.isHidden=true
        
        apiClass.sharedInstance().delegate=self //delegate for response api
        
        
        
        

        
        
        var hotelname = (self.arrayWithData[0] as AnyObject).value(forKey: "geoTag") as! String
        if hotelname == ""{
            hotelname = (self.arrayWithData[0] as AnyObject).value(forKey: "cityName") as! String
            if hotelname == ""{
                hotelname = (self.arrayWithData[0] as AnyObject).value(forKey: "CountryName") as! String
            }
            
            
        }
        
         headerLabel.text=hotelname as String
        
      
        self.locationTxtv.text=locHeader   //hotelname
        self.locationTxtv.textAlignment=NSTextAlignment .left
        print(self.locationTxtv.frame)
        self.locationTxtv.numberOfLines=0
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(detailViewController.loadDeletedCell(_:)),name:NSNotification.Name(rawValue: "loadDeleteDetail"), object: nil)
        
        
        // reload the tableview of reviews
        NotificationCenter.default.addObserver(self, selector: #selector(detailViewController.loadReviews(_:)) ,name:NSNotification.Name(rawValue: "reloadReviews"), object: nil)
        
        
        
    }
    
    
    
    
    
    func loadDeletedCell(_ notification: Notification) {
        
        
       print("Delete image done")
        
        self.BackAction(self)
        
        
        
    }
    
    
    
    //Reviews table
    func loadReviews(_ notification: Notification){
        
       // print(tempReviewArray)
        print("enter here")
        self.detailTable.reloadData()
    
        
    }
    
    
    
    
    
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.showMoreComments.isHidden = true
        self.showMoreDescription.isHidden=true
        
        self.detailTable.estimatedRowHeight = 90.0

        let imageId = (self.arrayWithData[0] as AnyObject).value(forKey: "imageId") as? String ?? ""
        
        let defaults = UserDefaults.standard
        let uId = defaults .string(forKey: "userLoginId")
        
        let commentParameter = "imageId=\(imageId)&userId=\(uId!)&page=last"
        self.postApiToGetPYTReview(commentParameter as NSString) //get the comments from the pyt server
        
        
        
        
        URLCache.shared.removeAllCachedResponses()
        
        if firstTime==false {
            
        }else
        {
            
            
            self.view .setNeedsLayout()
            
            
            /////-------- Gradient background color ----/////////
            
//            let layer = CAGradientLayer()
//            layer.frame = CGRect(x: 0, y: 0, width: headerView.frame.size.width, height: self.headerView.frame.origin.y+self.headerView.frame.size.height)
//            let blueColor = UIColor(red: 0/255, green: 146/255, blue: 198/255, alpha: 1.0).cgColor as CGColor
//            let purpleColor = UIColor(red: 117/255, green: 42/255, blue: 211/255, alpha: 1.0).cgColor as CGColor
//            layer.colors = [purpleColor, blueColor]
//            layer.startPoint = CGPoint(x: 0.1, y: 0.5)
//            layer.endPoint = CGPoint(x: 1.0, y: 0.5)
//            layer.locations = [0.25,1.0]
            //self.headerView.layer.addSublayer(layer)
            
            headerView.gradientLayer.colors = [UIColor.black.withAlphaComponent(0.75).cgColor, UIColor.clear.cgColor]
            headerView.gradientLayer.gradient = GradientPoint.topBottom.draw()
            
            
            ///// header view with animated effect
            self.view .bringSubview(toFront: headerView)
            self.view .bringSubview(toFront: BackBtn)
            self.headerView .bringSubview(toFront: headerLabel)
          
            
            //// add border to profile picture///
            borderView.layer.cornerRadius=borderView.frame.size.width/2
            borderView.clipsToBounds=true
            //self.profilePicImage.bringSubviewToFront(borderView)
            
            firstTime=false
            
            
        }
        
        
        ////MANAGE the images to delete of pyt
        
        bottomView.isHidden=true
        bottomView2.isHidden=false
        let photoType = (self.arrayWithData[0] as AnyObject).value(forKey: "Type") as? String ?? ""
        let otherUserId = (self.arrayWithData[0] as AnyObject).value(forKey: "otherUserId") as? String ?? ""
        if photoType == "PYT" {
            
            if otherUserId == uId! {
                
                print("Enter if match the user id")
                
                bottomView.isHidden=false
                bottomView2.isHidden=true
            }
            
            
        }
        //Hide both views if coming from the plan or story
        if fromStory==true
        {
            bottomView.isHidden=true
            bottomView2.isHidden=true
        }
        
        
        
        ////category
        
        var type = (self.arrayWithData[0] as AnyObject).value(forKey: "Category") as? String ?? " "
        
        //// temporary change the category random to Others
        let newCatRr = type.components(separatedBy: ",") as NSArray //type .components(separatedBy: ",")
        print(newCatRr)
        
        let  newcat2 = NSMutableArray()
        
        for ll in 0..<newCatRr.count {
            
            var stCat = newCatRr.object(at: ll) as? String ?? ""
            print(stCat)
            
            if stCat == "Random" || stCat == "random" {
                stCat = "Others"
            }
            newcat2 .add(" \(stCat)")
        }
        
        
        type = newcat2.componentsJoined(by: ",")
        self.categoryLabel.text = type
        

        //////---- Add gesture on zoom view to swipe left and right on zoom view
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(detailViewController.swiped(_:))) // put : at the end of method name
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.zoomView.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(detailViewController.swiped(_:))) // put : at the end of method name
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.zoomView.addGestureRecognizer(swipeLeft)
    
        self.view .bringSubview(toFront: BackBtn)
        //self.tabBarController?.setTabBarVisible(visible: false, animated: true)
        self.tabBarController?.tabBar.isHidden = true
        showMoreDescription.isUserInteractionEnabled=false
     
        
        
        
        
        
    }
    
    
    
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        //self.tabBarController?.tabBar.isHidden = false
       self.tabBarController?.tabBar.isHidden = false
        //self.tabBarController?.setTabBarVisible(visible: true, animated: true)
        self.view .bringSubview(toFront: BackBtn)
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.view .layoutIfNeeded()
        self.view .setNeedsLayout()
        super.viewDidAppear(animated)
      
    }
    
    
    
    
    //MARK: update Reviews
    
    
    func updateThirdView() {
        
        self.reviewsTopSpace.constant = 1
        self.heightOfTableView.constant = self.detailTable.rowHeight
        if morePictureLabel.isHidden == true {
            self.reviewsTopSpace.constant = 0
        }
        
        if tempReviewArray.count<1
        {
            self.showMoreComments.isHidden = true
            self.heightOfThirdView.constant = 0
            self.heightOfTableView.constant = 0
            self.detailTable.isHidden=true
            self.reviewslableinView.isHidden = true
            
        }
            else if(tempReviewArray.count==2)
        {
            self.showMoreComments.isHidden = true
            self.heightOfThirdView.constant = self.heightOfTableView.constant + 80 + self.heightOfTableView.constant
            self.detailTable.isHidden=false
            self.reviewslableinView.isHidden = false
        }
        else
        {
            self.showMoreComments.isHidden = false
            if tempReviewArray.count==1
            {
                self.showMoreComments.isHidden = true
            }
            
            self.detailTable.isHidden=false
            self.heightOfThirdView.constant = self.heightOfTableView.constant + 80
            self.reviewslableinView.isHidden = false
        }
        
        self.detailTable.reloadData()

        
        self.thirdView.layoutIfNeeded()
       self.view.layoutIfNeeded()
        self.view.setNeedsLayout()
        
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    //MARK:- Slide Images of the image slider 
    //MARK:
    func slideImages(_ multipleImages:NSMutableArray, imageLink:NSString) -> Void {
        
        var sdWebImageSource = [InputSource]()
        
        self.slideShow.slideshowInterval = 0
        self.slideShow.pageControlPosition = PageControlPosition.insideScrollView
        self.slideShow.pageControl.currentPageIndicatorTintColor = UIColor.white
        self.slideShow.pageControl.numberOfPages = 5
        
        self.slideShow.pageControl.pageIndicatorTintColor = UIColor.black
        
        self.slideShow.draggingEnabled=true
        self.slideShow.circular=false
        self.slideShow.setCurrentPage(0, animated: true)
        
        self.slideShow.contentScaleMode = UIViewContentMode.scaleAspectFill
        // self.slideShow.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.slideShow.clipsToBounds=true
        
        sdWebImageSource.append(SDWebImageSource(urlString: imageLink as String)!)
        self.slideShow.setImageInputs(sdWebImageSource )
        
        
    

            for j in 0..<multipleImages.count{
                
                let imgLink = multipleImages[j] as! String
                if imgLink == imageLink as String
                {
                    //Do nothing
                }
                else
                {
                    sdWebImageSource.append(SDWebImageSource(urlString: imgLink as String)!)
                }
            }
            
            self.slideShow.setImageInputs(sdWebImageSource )
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //MARK:-
    //MARK:- scrolling detect for animating header view
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView == collectionViewImages {
            
//            for cell: UICollectionViewCell in self.collectionViewImages.visibleCells() {
//                let indexPath = self.collectionViewImages.indexPathForCell(cell)!
//                //print("\(indexPath)")
//                
//                if indexPath.row == self.nearByPlacesArray.count - 1 {
//                    
//                    let RadiusAdd:Int = Int(self.radiusNearBy as String)! + 1000
//                    print(RadiusAdd)
//                    self.radiusNearBy = String(RadiusAdd)
//                    
//                    self .nearByPlaces("\(String(self.LAT))", long: "\(String(self.LONG))", radius: self.radiusNearBy)
//                    
//                }
//                
//                
//            }
            
        }
          
        else if (scrollView == collectionViewThumbnails){
            
        }
            
            
        else
        {
            if scrollView.contentOffset.y >= 150.0 {
                
                UIView.animate(withDuration: 0.4, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                   // self.headerView.alpha = 1
                    //self.headerImageView.alpha=1
                    // self.headerView2.hidden=true
                    }, completion: nil)
                
                
            }
                
            else{
                
                UIView.animate(withDuration: 0.4, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                    //self.headerView.alpha = 0
                   // self.headerImageView.alpha=0
                   //  self.headerView2.hidden=true
                    }, completion: nil)
                
            }
            
            
        }
        
        
        
    }
    
    
    
    
    ////////////////////////////////////////////////////////////////////
    
    //MARK:-
    //MARK:-///////////// Zoom Image Pinch gesture, swipe gesture/////////////
    //MARK:-
    
    @IBAction func zoomImage(_ sender: UIPinchGestureRecognizer) {
        
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
                    
                    if indexOfZoomImg > hotelImagesArray.count - 1 {
                        indexOfZoomImg = hotelImagesArray.count - 1
                        
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
                
                let imageName = (hotelImagesArray.value(forKey: "normal") as AnyObject).object(at: indexOfZoomImg)
                let url = URL(string: imageName as! String)
                self.zoomIndicator.startAnimating()
                self.zoomIndicator.isHidden=false
                zoomimageView.sd_setImage(with: url)
                
                let imageName2 = (hotelImagesArray.value(forKey: "original") as AnyObject).object(at: indexOfZoomImg)
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
        
                let imageName = (hotelImagesArray.value(forKey: "normal") as AnyObject).object(at: indexOfZoomImg)
                let url = URL(string: imageName as! String)
                
                zoomimageView.sd_setImage(with: url)
                
                let imageName2 = (hotelImagesArray.value(forKey: "original") as AnyObject).object(at: indexOfZoomImg)
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
                let imageName = (hotelImagesArray.value(forKey: "normal") as AnyObject).object(at: indexOfZoomImg)
                let url = URL(string: imageName as! String)
                
                self.zoomIndicator.startAnimating()
                self.zoomIndicator.isHidden=false
                zoomimageView.sd_setImage(with: url)
                
                let imageName2 = (hotelImagesArray.value(forKey: "original") as AnyObject).object(at: indexOfZoomImg)
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
                
             
                if slideShow.currentSlideshowItem?.imageView.image==nil {
                    
                    
                }
                else{
                    slidImg = (slideShow.currentSlideshowItem?.imageView.image!)!
                }
                
                let block: SDWebImageCompletionBlock = {(image, error, cacheType, imageURL) -> Void in
                    self.zoomIndicator.isHidden=true
                }
                
                zoomimageView.sd_setImage(with: url2, placeholderImage: slidImg, options: SDWebImageOptions(rawValue: 0), completed: block)
           
            
            }
            
        }
        
        


        
        
        
    }
    
    
    
    
    
    ////close the zoomed image view
    func closeImageView()
    {
        
        zoomView.isHidden=true
        
    }
    
    
    ///////////////----- open the zoom image view
    
    
    func openZoomView() -> Void
    {
        
        self.zoomScrollView.minimumZoomScale = 1.0
        self.zoomScrollView.maximumZoomScale = 5.0
        
        self.zoomScrollView.zoomScale = 1.0
       
        Thumbnails = false
        DirectionSwipe = "None"
        
        var multiImg = NSMutableArray()
        multiImg = (self.arrayWithData[0] as AnyObject).value(forKey: "multipleImagesLarge")as! NSMutableArray
        
        
        
        zoomView.isHidden=false
        self.view .bringSubview(toFront: zoomView)
       
        
        zoomIndicator.startAnimating()
         self.zoomIndicator.isHidden=false
        
        var locationImageStr = ""
        if slideShow.currentPage==0 {
            locationImageStr = multiImg.object(at: slideShow.currentPage) as! String
        }
        else{
            locationImageStr = multiImg.object(at: slideShow.currentPage) as! String
        }
        
        zoomImagesArray .removeAllObjects()
        zoomImagesArray .add(locationImageStr)
        
        indexOfZoomImg = 0
        
       
        
        
        for i in 0..<multiImg.count {
            
            let locationImageStr2 = multiImg.object(at: i) as! String
            zoomImagesArray .add(locationImageStr2)
        
            
        }
        
        
        
        let copy = zoomImagesArray
        
        var index = copy.count - 1
//        for object: AnyObject in (copy as NSMutableArray).reverseObjectEnumerator() {
//            if (zoomImagesArray as NSArray).index(of: object, in: NSMakeRange(0, index)) != NSNotFound {
//                zoomImagesArray.removeObject(at: index)
//            }
//            index -= 1
//        }
        
         self.changeZoomImage(indexOfZoomImg)
        
        
        
    }
    
    
    
    
    
    func viewForZoomingInScrollView(_ scrollView: UIScrollView) -> UIView?
    {
        if scrollView==zoomScrollView {
            return self.zoomimageView
        }
        
        else{
            return self.view
        }
        
    }
    
    
    
    
    
    
    
    
    //////////////////////////////////////////////////////////////////////////////
    
    //MARK:- ////////Actions of buttons ////////
    //MARK:

    
    
    //MARK: Back Button Action
    @IBAction func BackAction(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: {})
        
        
        
    
//        if task1 != nil {
//            
//            if task1.state == .running {
//                task1.cancel()
//                print("\n\n Task 1 cancel\n\n")
//            }
//            
//            if task2 != nil {
//                
//                if task2.state == .running {
//                    task2.cancel()
//                    print("\n\n Task 2 cancel\n\n")
//                }
//                
//            }
//            
//            if task3 != nil {
//                
//                if task3.state == .running {
//                    task3.cancel()
//                    print("\n\n Task 3 cancel\n\n")
//              }
//                
//            }
        

            self.navigationController?.popViewController(animated: true)
       // }
       
        
        
        
        
        
       
        
        
       // self.dismissViewControllerAnimated(true, completion: {})
        URLCache.shared.removeAllCachedResponses()
        
        
    }
    
    
    
    
    func URLSessions(_ session: Foundation.URLSession, task: URLSessionTask, didCompleteWithError error: NSError?) {
    
    print("enter to cancel this")
    
    
    }
    
    
    
    
    //MARK: function to set the categories
    
    
    func setCategoryIcons(_ categoryIds: NSString) -> UIImage {
        
        var catimage = UIImage()
        
        catimage = UIImage (named: "Bucket")!
        
        /*
        switch categoryIds {
        
        case "58de647dbb35ba786a4788cd": //FoodANDWine
             catimage=UIImage (named: "detailFoodWine")!
        break
            
        case "58de647dbb35ba786a4788ce": //CityLife
            catimage=UIImage (named: "detailCityLife")!
        break
        
        case "58de647dbb35ba786a4788cf": //Nightlife ent.
            catimage=UIImage (named: "detailNightLife")!
        break
           
        case "58de647dbb35ba786a4788d0": //history art
            catimage=UIImage (named: "detailHistory")!
            break
        case "58de647dbb35ba786a4788d1": //nature
            catimage=UIImage (named: "detailNature")!
            break
        
        case "58de647dbb35ba786a4788d2": //Mountains
            catimage=UIImage (named: "detailMountains")!
            break
        
        case "58de647dbb35ba786a4788d3": //Beaches
            catimage=UIImage (named: "detailBeaches")!
            break
        
        case "58de647dbb35ba786a4788d4": //Lakes Rivers
            catimage=UIImage (named: "detailLake")!
            break
        
        case "58de647dbb35ba786a4788d5": //Wild Life
            catimage=UIImage (named: "detailWildLife")!
            break
        
        case "58de647dbb35ba786a4788d6": //Deserts
            catimage=UIImage (named: "detailDeserts")!
            break
            
        case "58de647dbb35ba786a4788d7": //road trips
            catimage=UIImage (named: "detailRoad")!
            break
            
        case "58de647ebb35ba786a4788d8": //crusies
            catimage=UIImage (named: "detailCruises")!
            break
            
        case "58de647ebb35ba786a4788d9": // Sports
            catimage=UIImage (named: "detailSports")!
            break
        
        case "58de647ebb35ba786a4788da": //Hotel Wellness
            catimage=UIImage (named: "detailHotel")!
            break
            
        case "58de647ebb35ba786a4788db": //Retail therapy
            catimage=UIImage (named: "detailRetailTherapy")!
            break

        case "58de647ebb35ba786a4788dc": //Kids friendly
            catimage=UIImage (named: "detailKidsEntertainment")!
            break
            
        default: //other
            catimage=UIImage (named: "detailOther")!
            break
            
        }
        */
        
       
        
    
      
        
        
        
        
        return catimage
        
    }
    
    
    
    
    
   //MARK: - action of add to story
    @IBAction func addStoryAction(_ sender: AnyObject) {
   
        
       // print(arrayWithData[0])
        
        //
        
        let imageId = (self.arrayWithData[0] as AnyObject).value(forKey: "imageId") as? String ?? ""
        
        let defaults = UserDefaults.standard
        let uId = defaults .string(forKey: "userLoginId")
        
       
        let globalPlaceid = (self.arrayWithData[0] as AnyObject).value(forKey: "placeId") as? String ?? ""
        let globalName = (self.arrayWithData[0] as AnyObject).value(forKey: "CountryName") as! String
        let ownersId = (self.arrayWithData[0] as AnyObject).value(forKey: "otherUserId") as? String ?? ""
        let countryId = (self.arrayWithData[0] as AnyObject).value(forKey: "countryId") as? String ?? ""
        let cname = (self.arrayWithData[0] as AnyObject).value(forKey: "CountryName") as? String ?? ""
        
         let placeIds = (countArray.value(forKey: "countryId")) as! NSArray
        
        if stImg.image==UIImage (named: "locationPlan") {
            stImg.image=UIImage.init(named: "locationRemoveplan")
            stImg2.image=UIImage.init(named: "locationRemoveplan")
            
          
            
           // let dataStr: NSDictionary = ["userId": uId!, "imageId": imageId]
           // print(dataStr)
            
            let indx = placeIds .index(of: countryId)
            
            let bookingid = ((countArray.object(at: indx)) as AnyObject).value(forKey: "_id") as? String ?? ""
            //print(dataStr)
           
            apiClass.sharedInstance().deleteLocationFromPlan(placeId: imageId as NSString, bookingIdFinal: bookingid as NSString)
              //  apiClassStory.sharedInstance().postRequestDeleteStory(dataStr, viewController: self)
                
            
        }
            
        else
        {
            stImg.image=UIImage.init(named: "locationPlan")
            stImg2.image=UIImage.init(named: "locationPlan")
           
            
            var dat = NSDictionary()
            
            if placeIds.contains(countryId)
            {
                print("Contains story")
                let indx = placeIds .index(of: countryId)
                print(indx)
                
                let bookingid = ((countArray.object(at: indx)) as AnyObject).value(forKey: "_id") as? String ?? ""
                
                dat = ["userId": "\(uId!)", "imageId": imageId, "countryId": countryId, "countryName": cname, "imageOwn": ownersId, "bookingId": bookingid ]
                
            }
            else
            {
                dat = ["userId": "\(uId!)", "imageId": imageId, "countryId": countryId, "countryName": cname, "imageOwn": ownersId ]
            }
            
            
           // let dat: NSDictionary = ["userId": "\(uId!)", "imageId": imageId, "countryId": globalPlaceid, "countryName": globalName, "imageOwn": ownersId ] //["userId": "\(uId!)", "imageId": imageId, "placeId": globalPlaceid, "placeType": globalType]
            
            
            print("Post parameters to select the images for story--- \(dat)")
            //add image to story
                apiClass.sharedInstance().postRequestWithMultipleImage(parameterString: "", parameters: dat, viewController: self)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { () -> Void in
                
                //  self.addToolTip()
                
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: "load"), object: nil)
            }
        }
        
      
        let tipsShow = defaults.bool(forKey: "tooldetail")
        
        if tipsShow == false {
            
                                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { () -> Void in
            
                                   //  self.addToolTip()
            
                                }
        }
        
        
    }
   
    
    
    
    func addToolTip() {
        let defaults = UserDefaults.standard
      //  let tipsShow = defaults.boolForKey("tooldetail")
        
        for view in self.tipsView.subviews {
            view.removeFromSuperview()
        }
        
        //tipsView.removeFromSuperview()
        
        tipsView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        tipsView.backgroundColor = UIColor .init(colorLiteralRed: 0/255, green: 0/255, blue: 0/255, alpha: 0.85)
        self.view.addSubview(tipsView)
      
        
        tipsView.isHidden = false
        
        
            
            let img = UIImageView()
            img.image = UIImage (named: "backTool")
            img.frame = CGRect(x: 10 , y: 30, width: (img.image?.size.width)!, height: img.image!.size.height)
            
            tipsView .addSubview(img)
            
            
            let buttonTips = UIButton()
            buttonTips.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            
            buttonTips.addTarget(self, action: #selector(detailViewController.tempRemove), for: UIControlEvents .touchUpInside)
            tipsView .addSubview(buttonTips)
            
        
            
            
            self.view .bringSubview(toFront: tipsView)
        
        defaults.set(true, forKey: "tooldetail")
            
        }
    
    
    func tempRemove() {
        
        tipsView .removeFromSuperview()
        
    }
    
    
    
    
    //MARK:- Like Button action
    
    @IBAction func likeBtnAction(_ sender: AnyObject) {
        
        
        let nxtObjMain = self.storyboard?.instantiateViewController(withIdentifier: "mainHomeViewController") as! mainHomeViewController
        
        print(countLikes)
        
        let defaults = UserDefaults.standard
        let uId = defaults .string(forKey: "userLoginId")
        let userNameMy = defaults.string(forKey: "userLoginName")
        
        let otherUserId = (self.arrayWithData[0] as AnyObject).value(forKey: "otherUserId") as? String ?? ""
        let imageId = (self.arrayWithData[0] as AnyObject).value(forKey: "imageId") as? String ?? ""
        
        
        let countBack = (self.arrayWithData[0] as AnyObject).value(forKey: "likeCount") as? NSNumber
        
        
        
        
        if countLikes.count>0 {
            
            let likCountar = countLikes.value(forKey: "imageId") as! NSArray
            
            if (likCountar.contains(imageId)) {
                
                let index = (self.countLikes.value(forKey: "imageId") as AnyObject).index(of: imageId)
                
                if (countLikes.object(at: index) as AnyObject).value(forKey: "like") as! Bool == true {
                    
                    let staticCount = (countLikes.object(at: index) as AnyObject).value(forKey: "count") as? NSNumber
                    
                    countLikes .removeObject(at: index)
                    
                    countLikes .add(["userId":uId!, "imageId":imageId, "like":false, "count": nxtObjMain.subtractTheLikes(staticCount!)])
                    
                    
                    
                    
                   likeImg.image=UIImage (named: "locationUnlike")
                    likeImg2.image=UIImage (named: "locationUnlike")
                    
                    let dat: NSDictionary = ["userId": "\(uId!)", "photoId":"\(imageId)", "userLiked":"\(uId!)", "status":"0", "imageOwn": "\(otherUserId)", "userName": "\(userNameMy!)"]
                    print("Post to like picture---- \(dat)")
                    DispatchQueue.main.async(execute: {
                        apiClass.sharedInstance().postRequestLikeUnlikeImage(parameters: dat, viewController: self)
                    })
                    
                }
                else
                {
                    let staticCount = (countLikes.object(at: index) as AnyObject).value(forKey: "count") as? NSNumber
                   
                    
                    countLikes .removeObject(at: index)
                    countLikes .add(["userId":uId!, "imageId":imageId, "like":true, "count": nxtObjMain.addTheLikes(staticCount!)])
                    
                    
                 
                    
                 likeImg.image=UIImage (named: "locationLike")
                    likeImg2.image=UIImage (named: "locationLike")
                    
                    let dat: NSDictionary = ["userId": "\(uId!)", "photoId":"\(imageId)", "userLiked":"\(uId!)", "status":"1", "imageOwn": "\(otherUserId)", "userName": "\(userNameMy!)"]
                    
                    
                    print("Post to like picture---- \(dat)")
                    DispatchQueue.main.async(execute: {
                        apiClass.sharedInstance().postRequestLikeUnlikeImage(parameters: dat, viewController: self)
                    })
                    
                }
            }
                // if not liked already
            else{
                countLikes .add(["userId":uId!, "imageId":imageId, "like":true, "count": nxtObjMain.addTheLikes(countBack!)])
              
                 likeImg.image=UIImage (named: "locationLike")
                likeImg2.image=UIImage (named: "locationLike")
                let dat: NSDictionary = ["userId": "\(uId!)", "photoId":"\(imageId)", "userLiked":"\(uId!)", "status":"1", "imageOwn": "\(otherUserId)", "userName": "\(userNameMy!)"]
                
                
                print("Post to like picture---- \(dat)")
                DispatchQueue.main.async(execute: {
                    apiClass.sharedInstance().postRequestLikeUnlikeImage(parameters: dat, viewController: self)
                })
            }
            
        }
            
        else
            
        {
            
            countLikes.add(["userId":uId!, "count":nxtObjMain.addTheLikes(countBack!), "like": true, "imageId": imageId])
           likeImg.image=UIImage (named: "locationLike")
           likeImg2.image=UIImage (named: "locationLike")
            
            let dat: NSDictionary = ["userId": "\(uId!)", "photoId":"\(imageId)", "userLiked":"\(uId!)", "status":"1", "imageOwn": "\(otherUserId)", "userName": "\(userNameMy!)"]
            
            
            print("Post to like picture---- \(dat)")
            DispatchQueue.main.async(execute: {
                apiClass.sharedInstance().postRequestLikeUnlikeImage(parameters: dat, viewController: self)
            })
        }

        
        
        
        
        
        if fromInterest {
        let nxtObjInterest = self.storyboard?.instantiateViewController(withIdentifier: "intrestViewController") as! intrestViewController
            
            nxtObjInterest.likeCount = countLikes
            NotificationCenter.default.post(name: Notification.Name(rawValue: "loadInterest"), object: nil)
        }
        else
        {
        nxtObjMain.likeCount=countLikes
        
         NotificationCenter.default.post(name: Notification.Name(rawValue: "load"), object: nil)
        }
        
        
        
        
        
      
        
        
        
        
    }
    
    
//    ////// call the api with status code for like or unlike 0 for unlike and 1 for like /////
//    
//    func callLikePostRequest(status: NSString) -> Void {
//        
//        let defaults = NSUserDefaults.standardUserDefaults()
//        let uId = defaults .stringForKey("userLoginId")
//        
//        let otherUserId = self.arrayWithData[0] .valueForKey("otherUserId") as? String ?? ""
//        let imageId = self.arrayWithData[0] .valueForKey("imageId") as? String ?? ""
//        
//        let dat: NSDictionary = ["userId": "\(otherUserId)", "photoId":"\(imageId)", "userLiked":"\(uId!)", "status":status]
//        
//        
//        print("Post to like picture---- \(dat)")
//        
//        apiClass.sharedInstance().postRequestLikeUnlikeImage(dat, viewController: self)
//        
//        //reload the data in first main view controller
//        
//        dispatch_async(dispatch_get_main_queue(), {
//            
//            
//            
//        NSNotificationCenter.defaultCenter().postNotificationName("load", object: nil)
//        })
//    }
//    
//    
    
    
    
    
    
    
    
    //MARK:- Add to bucket list action
    
    @IBAction func addToBucketAction(_ sender: AnyObject) {

        
        let imageId = (self.arrayWithData[0] as AnyObject).value(forKey: "imageId") as? String ?? ""
      let otherUserId = (self.arrayWithData[0] as AnyObject).value(forKey: "otherUserId") as? String ?? ""
        
        
        let defaults = UserDefaults.standard
        let uId = defaults .string(forKey: "userLoginId")
        
        
        
        
        
        if bucketImg.image == UIImage (named: "locationBucket") && bucketImg2.image == UIImage (named: "locationBucket") {
            bucketImg.image=UIImage (named: "locationRemoveBucket")
            bucketImg2.image=UIImage (named: "locationRemoveBucket")
            
            let parameter: NSDictionary = ["userId": uId!, "imageId": imageId]
            
           // bucketListApiClass.sharedInstance().postRequestForDeletBucketListFromFeed(parameter, viewController: self)
            
            
            //Delete from here
            
        }
            
        else
        {
            bucketImg.image=UIImage (named: "locationBucket")
            bucketImg2.image=UIImage (named: "locationBucket")
           
            let parameterDic: NSDictionary = ["userId": uId!,"imageOwn": otherUserId, "imageId": imageId ]
            
            //add image to bucket
            //bucketListApiClass.sharedInstance().postRequestForAddBucket(parameterDic, viewController: self)
            
            
            
            
            
        }
        
        
    }
    
    
    
    
    
    
    //MARK:-
    //MARK:- Delete image Action
    
    
    @IBAction func deleteImageAction(_ sender: AnyObject) {
       
        
        
        
        
        
    let nxtObj2 = self.storyboard?.instantiateViewController(withIdentifier: "EditPostViewController") as! EditPostViewController
        
    nxtObj2.screenName = "Detail/Feed"
        
        //print(self.arrayOfimages1[self.tableIndex])
        
        
        
        
        let imageId = (self.arrayWithData[0] as AnyObject).value(forKey: "imageId") as? String ?? ""
        let imageUrl = (self.arrayWithData[0] as AnyObject).value(forKey: "locationImage") as? String ?? ""
       // let countryName = self.arrayWithData[0] .valueForKey("CountryName") as? String ?? ""
        let thumbnailStr = (self.arrayWithData[0] as AnyObject).value(forKey: "standardImage") as? String ?? ""
        
      //  let tagGeo = self.arrayWithData[0] .valueForKey("geoTag") as? String ?? ""
        let descriptionStr = (self.arrayWithData[0] as AnyObject).value(forKey: "Description") as? String ?? ""
        let cateArr = (self.arrayWithData[0] as AnyObject).value(forKey: "categoryMainArray") as! NSMutableArray
        
        let geoTagStr = (self.arrayWithData[0] as AnyObject).value(forKey: "geoTag") as! String
        
        
      
             
        
        
        let dictionaryToEditdata = NSMutableDictionary()
        dictionaryToEditdata.setValue(geoTagStr, forKey: "geoTag")
        dictionaryToEditdata.setValue(thumbnailStr, forKey: "thumbnail")
        dictionaryToEditdata.setValue(imageUrl, forKey: "large")
        dictionaryToEditdata.setValue(descriptionStr, forKey: "description")
        dictionaryToEditdata.setValue(cateArr, forKey: "category")
        dictionaryToEditdata.setValue("public", forKey: "privacy")
        dictionaryToEditdata.setValue(imageId, forKey: "imgId")
        
        
        print(dictionaryToEditdata)
        nxtObj2.dataDictionary = dictionaryToEditdata
        

        
        
        
        
        
         self.navigationController! .pushViewController(nxtObj2, animated: true)
        
        
              
       
        
        
        
    }
   
    
    
    
    
    
    
    
    //MARK:-
    //MARK:- WEB Link action to open the url of the location on safari
    
    @IBAction func webLinkAction(_ sender: AnyObject) {
        
        print(webLinkString)
        
        UIApplication.shared.openURL(URL(string: webLinkString as String)!)
        
    }
    
    
    
    
    
    
    
    //MARK: Show whole description on the next page
    
    @IBAction func showDescriptionAction(_ sender: AnyObject)
    {
        //let nxtObj2 = self.storyboard?.instantiateViewController(withIdentifier: "DescriptionViewViewController") as? DescriptionViewViewController
       // nxtObj2!.descriptionString2=self.descriptionString
       // nxtObj2!.title=locationTxtv.text
        
       // self.navigationController! .pushViewController(nxtObj2!, animated: true)
        
        
    }
    
    
    
    
    //MARK: Show all comments on the new screen
    
    @IBAction func showCommentsAction(_ sender: AnyObject)
    {
        let nxtObj2 = self.storyboard?.instantiateViewController(withIdentifier: "commentViewController") as? commentViewController
        
        nxtObj2!.reviewsArray=self.reviewsArray
      
        
        let imageId = (self.arrayWithData[0] as AnyObject).value(forKey: "imageId") as? String ?? ""
        
        let defaults = UserDefaults.standard
        let uId = defaults .string(forKey: "userLoginId")
        
        let otherUserId = (self.arrayWithData[0] as AnyObject).value(forKey: "otherUserId") as? String ?? ""
//        let commentParameter = "imageId=\(imageId)&userId=\(uId!)&imageOwner=\(otherUserId)&paging=all" //older version
        
        
        let commentParameter = "imageId=\(imageId)&userId=\(uId!)&page=all"//newer version
        
        
      nxtObj2!.parameter = commentParameter as NSString
        nxtObj2!.imageIdComment = imageId as NSString
        nxtObj2!.ownerId = otherUserId as NSString
         nxtObj2?.foursqReviews = self.reviewsArray
       let wlargeUrl = (self.arrayWithData[0] as AnyObject).value(forKey: "locationImage") as? String ?? ""
         nxtObj2!.largeUrl = wlargeUrl as NSString
        
        self.navigationController! .pushViewController(nxtObj2!, animated: true)
        
    }
    
    
    
    
    
    ///////////////////////////////////////////////////////////////////////////////////
    
    //MARK:- Delegates and datasource of tableView
    //MARK:-
    
    
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int
    {
        return 1
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
       print(tempReviewArray.count)
            if tempReviewArray.count>0 {
                if tempReviewArray.count>1 {
                    showMoreComments.isHidden = true
                    if tempReviewArray.count>2 {
                        showMoreComments.isHidden = false
                    }
                    return 2
                }
                return 1
            }
            else{
                return 0
            }
        
       
    }
    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell
    {
        
       let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "CommentsCell")!
        
        print(tempReviewArray.object(at: indexPath.row))
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
            
            
            let commentTimeLabel = cell.contentView .viewWithTag(114) as! UILabel
            commentTimeLabel.text = ""
            
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
        if collectionView == collectionViewThumbnails
        {
            return hotelImagesArray.count
        }
        else
        {
            return nearByPlacesArray.count
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView,cellForItemAtIndexPath indexPath: IndexPath) -> UICollectionViewCell
    {
        //Location Images collectionview
        if collectionView == collectionViewThumbnails
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellImages",for: indexPath)
            
            let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
            cell.backgroundView = activityIndicatorView
            activityIndicatorView.startAnimating()

            print(hotelImagesArray.object(at: indexPath.row))
            
            let locationimage2 = cell.viewWithTag(11111) as! UIImageView
            let imageName2 = (hotelImagesArray.value(forKey: "normal") as AnyObject).object(at: indexPath.row)
            
            
            
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
            
         
            
        //Near by places collection view
            
        else
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imagesCell",for: indexPath)
            
            let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
            cell.backgroundView = activityIndicatorView
            activityIndicatorView.startAnimating()
            
            
            let nearByimage = cell.viewWithTag(11112) as! UIImageView
            let imageName2 = (nearByPlacesArray.value(forKey: "images") as AnyObject).object(at: indexPath.row)
            let url2 = URL(string: imageName2 as! String)
            let pImage : UIImage = UIImage(named:"dummyBackground1")!
            
            let block: SDWebImageCompletionBlock = {(image, error, cacheType, imageURL) -> Void in
                
            }
            
            nearByimage.sd_setImage(with: url2, placeholderImage: pImage, options: SDWebImageOptions(rawValue: 0), completed: block)
            
            nearByimage.layer.cornerRadius=5
            nearByimage.clipsToBounds=true
            
            
            
            
            
            
            cell.backgroundColor=UIColor.clear
            
            
            //label for near by places name
            let labelName = cell.viewWithTag(11113) as! UILabel
            //labelName.adjustsFontSizeToFitWidth = true
            labelName.numberOfLines=1
            labelName.text=(nearByPlacesArray.object(at: indexPath.row) as AnyObject).value(forKey: "name") as? String
            
            
            
            //distance label
            let labelDistance = cell.viewWithTag(11114) as! UILabel
            labelDistance.numberOfLines=1
            labelDistance.text=(nearByPlacesArray.object(at: indexPath.row) as AnyObject).value(forKey: "distance") as? String
            
            
            
            
            return cell
            
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: IndexPath)
    {
        if collectionView == collectionViewThumbnails
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
            
            
        ////////----- near by places
            
        else
        {
            let nxtObj2 = self.storyboard?.instantiateViewController(withIdentifier: "nearByPlacesViewController") as? nearByPlacesViewController
            
            let detail = self.nearByPlacesArray.object(at: indexPath.row)
            print(detail)
            
            nxtObj2!.newDetail = detail as! NSDictionary
            
            self.navigationController! .pushViewController(nxtObj2!, animated: true)

        }
        
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        
        
        if collectionView == collectionViewImages {
            
            
            let width1 = collectionView.frame.size.width/4.20  //1.8
            
            return CGSize(width: width1, height: 110) // The size of one cell
            
        }
            
        else//thumbnail
        {
            let width1 = collectionView.frame.size.width/4.30  //1.8
            
            return CGSize(width: width1, height: 75.0) // The size of one cell
        }
    }
    
    
    
    
    
    
    
    
    ////////////////////////////////////////////////////////////////////////////////
    
    //MARK:- Get detail from foursquare api
    //MARK:-
    
    
    func datafromFoursquare(_ parameterStringHotels : String)
    {
        //ttp://terminal2.expedia.com:80/x/nlp/results?q=jw%20marriot%20in%20chandigharh&apikey=4PKZ0dIDVwXoTQoPeac9F8681XRwgpyA
        reviewsTopSpace.constant = 0
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
            
            
           // task1 = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
            task1 = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            
                OperationQueue.main.addOperation
                    {
                         print("data from foursquare ")
                        
                        self.firstIndicator .removeFromSuperview()
                        self.secondIndicator .removeFromSuperview()
                        
                        if data == nil
                        {
                          
                           
                            
                        }
                        else
                        {
                           
                            self.descriptionTextv.isEditable=true
                            self.heightOfSecondView.constant = 0
                            self.webLinkBtnOutlet.isHidden=true
                            self.webLinkImg.isHidden=true
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
                                            
                                            
                                var hotelname = (self.arrayWithData.object(at: 0) as AnyObject).value(forKey: "geoTag") as! String
                                            if hotelname == ""{
                                                hotelname = (self.arrayWithData[0] as AnyObject).value(forKey: "cityName") as! String
                                                if hotelname == ""{
                                                    hotelname = (self.arrayWithData[0] as AnyObject).value(forKey: "CountryName") as! String
                                                }
                                                
                                                
                                            }
                                            
                                            
                                            
                                            
                                            
                                            self.collectionHeightThumbnails.constant=0
                                            self.collectionContainView.constant=0
                                            self.morePictureLabel.isHidden=true
                                            self.reviewsTopSpace.constant = 0
                                            self.morePicturesTopSpace.constant = 0
                                            
                                            
                    //No Venue found
            //let NearLoc = "\(self.arrayWithData[0] .valueForKey("Venue") as! NSString),\(self.arrayWithData[0] .valueForKey("CountryName") as! NSString)"
                                            
                                            
                                            self .nearByPlaces("\(String(describing: self.LAT))" as NSString, long: "\(String(describing: self.LONG))" as NSString, radius: self.radiusNearBy as NSString)
                                            
                                            
                                            
                                            let descStRing = (self.arrayWithData[0] as AnyObject).value(forKey: "Description") as? String ?? ""
                                            
                                            
                                            self.descriptionString=descStRing as NSString
                                            self.descriptionTextv.isEditable=true
                                            
                                            self.descriptionTextv.textColor = UIColor.lightGray
                                            self.descriptionTextv.isEditable=false
                                            self.heightOfSecondView.constant = self.heightDescription(descStRing as NSString) //130
                                            self.showMoreDescription.isHidden=true
                                            self.heightOfSecondView.constant = 0
                                            if self.descriptionString.length>350{
                                                //self.heightOfSecondView.constant = 200
                                                self.showMoreDescription.isUserInteractionEnabled=true
                                                self.descSeperaterLabel.isHidden=false
                                                self.showMoreDescription.isHidden=false
                                            }
                                            
                                            // }
                                            
                                            
                                            
                                            
                                            
                                            
                                            
                                        }
                                        else
                                        {
                                            
                                            
                                            //print(venues[0].valueForKey("location"))
                                            let locationDict: NSDictionary = (venues[0] as AnyObject).value(forKey: "location") as! NSDictionary
                                            
                                            let latFS = locationDict["lat"] != nil
                                            
                                            let longFS = locationDict["lng"] != nil
                                            
                                            
                                            if let urlHotel = (venues.object(at: 0) as AnyObject).value(forKey: "url")
                                            {
                                                self.webLinkBtnOutlet.isHidden=false
                                                self.webLinkBtnOutlet.setTitle((urlHotel as! NSString) as String, for: .normal)
                                                self.webLinkImg.isHidden=false
                                                self.webLinkString=urlHotel as! NSString
                                                
                                            }

                                            
                                            
                                            
                                            
                                            if latFS == true && longFS == true {
                                                
                                                if self.LAT == 0{
                                                    print("Latitude is 0")
                                                    let locLat = locationDict["lat"] as! NSNumber
                                                    let locLong = locationDict["lat"] as! NSNumber
                                                    
                                                    self.LAT = locLat
                                                    self.LONG = locLong
                                                    
                                                }
                                                
                                                
                                                
                                            }
                                            
                                            
                                            
                                            
                                            
                                            
                                            
                                            
                                            
                                            
                                            
                                            
                                            
                                            if let venueId = (venues[0] as AnyObject).value(forKey: "id"){
                                                
                                                
                                                
                                self .getPhotosOfHotel(venueId as! NSString)
                                                
                                                
                                            }
                                            else{
                                                
                                                
                                                let NearLoc = "\((self.arrayWithData[0] as AnyObject).value(forKey: "Venue") as! NSString),\((self.arrayWithData[0] as AnyObject).value(forKey: "CountryName") as! NSString)"
                                                
                                              
                                                self .nearByPlaces("\(String(describing: self.LAT))" as NSString, long: "\(String(describing: self.LONG))" as NSString, radius: self.radiusNearBy as NSString)
                                            }
                                            
                                            
                                            
                                            var hotelname = (self.arrayWithData.object(at: 0) as AnyObject).value(forKey: "geoTag") as? String ?? ""
                                            if hotelname == ""{
                                                hotelname = (self.arrayWithData[0] as AnyObject).value(forKey: "cityName") as! String
                                                if hotelname == ""{
                                                    hotelname = (self.arrayWithData[0] as AnyObject).value(forKey: "CountryName") as! String
                                                    
                                                    if hotelname == "" {
                                                        hotelname = (venues[0] as AnyObject).value(forKey: "name") as? String ?? ""
                                                        
                                                    }
                                                    
                                                    
                                                }
                                                
                                                
                                                
                                            }
                                            
                                           
                                            
                                            self.locationTxtv.text=hotelname
                                            self.locationTxtv.textAlignment=NSTextAlignment .left
                                            print(self.locationTxtv.frame)
                                            self.locationTxtv.numberOfLines=0
                                            
                                            
                                            
                                          
                                        //Can get other data of the hotel or location
                                            
                                           
                                            
                                        }
                                        
                                    }
                                    else
                                    {
                                        
                                        self.collectionHeightThumbnails.constant=0
                                        self.collectionContainView.constant=0
                                        self.morePictureLabel.isHidden=true
                                        self.reviewsTopSpace.constant = 0
                                        self.showMoreDescription.isHidden=true
                                        self.showMoreDescription.isUserInteractionEnabled=true
                                   
                                        self .nearByPlaces("\(String(describing: self.LAT))" as NSString, long: "\(String(describing: self.LONG))" as NSString, radius: self.radiusNearBy as NSString)
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
    
    
    
    
    
    
    
    
    
    //MARK:- Update the first view when got data from the api//
    func updateFirstView() -> Void {
    
        
        self.categoryViewHeight.constant = 84
//        if self.categoryViewHeight.constant < 104 {
//            self.categoryViewHeight.constant = 104
//            
//        }
        self.heightOfFirstView.constant =  360 + self.categoryViewHeight.constant
        print(self.heightOfFirstView.constant)
        
        
        
    }
    
    
    
    
    
    ////////////////////////////////////////////////////////////////////////////////////
    
    
    
    //MARK: Mange description height
    func heightDescription(_ string: NSString) -> CGFloat {
        
        let fixedWidth = self.descriptionTextv.frame.size.width
        
        let newSize = self.descriptionTextv.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        var newFrame = self.descriptionTextv.frame
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        
        if string == "" {
            return 0
        }
        else
        {
        return newFrame.height + 65
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
                       // let NearLoc = "\(self.arrayWithData[0] .valueForKey("Venue") as! NSString),\(self.arrayWithData[0] .valueForKey("CountryName") as! NSString)"
                       
                       
                         self .nearByPlaces("\(String(describing: self.LAT))" as NSString, long: "\(String(describing: self.LONG))" as NSString, radius: self.radiusNearBy as NSString)
                        
                        
                        
                        
                        print("Photos from foursquare ")
                        
                        
                        self.firstIndicator.removeFromSuperview()
                        if data == nil
                        {
                           
                            self.firstIndicator.removeFromSuperview()
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
                                
                                self.descriptionTextv.text=""
                                
                                
                                
                                let descStRing = (self.arrayWithData[0] as AnyObject).value(forKey: "Description") as? String ?? ""
                                
                              
                                
                                    if let desc =  venues.value(forKey: "description")
                                    {
                                        self.descriptionString=desc as! NSString
                                        self.descriptionTextv.isEditable=true
                                       // self.descriptionTextv.text=self.descriptionString as String
                                        let attributedString = NSMutableAttributedString(string: self.descriptionString as String)
                                        attributedString.addAttribute(NSKernAttributeName, value: CGFloat(1.0), range: NSRange(location: 0, length: attributedString.length))
                                        self.descriptionTextv.attributedText = attributedString
                                        
                                        
                                        self.descriptionTextv.textColor = UIColor.lightGray
                                        self.descriptionTextv.isEditable=false
                                      
                                        self.descriptionTopSpace.constant = 1
                                        
                                        self.secondView.isHidden=false
                                        self.view .setNeedsLayout()
                                        
                                        self.showMoreDescription.isHidden=true
                                        if self.descriptionString.length>350{
                                             self.heightOfSecondView.constant = 210
                                            self.showMoreDescription.isUserInteractionEnabled=true
                                            self.descSeperaterLabel.isHidden=false
                                            self.showMoreDescription.isHidden=false
                                            
                                        }
                                        else{
                                            self.heightOfSecondView.constant = self.heightDescription(self.descriptionString) //195
                                        }
                                        
                                        
                                    }
                                    else
                                    {
                                       
                                        self.descriptionTextv.isEditable=true
                                        //self.descriptionTextv.text=descStRing
                                        self.descriptionTextv.textColor = UIColor.lightGray
                                        self.descriptionTextv.isEditable=false
                                        self.heightOfSecondView.constant = self.heightDescription("") //130
                                        self.showMoreDescription.isHidden=true
                                       self.descriptionTopSpace.constant = 1
                                        if descStRing == ""{
                                            self.descriptionTopSpace.constant = 0
                                        }
                                        
                                    }
                                
                                    
                                    
                               
                                
                               
                                
                                
                                
                                
                                
                                
                                if (venues.value(forKey: "photos")! as AnyObject).value(forKey: "count") as! Int == 0 {
                                    
                                    
                                    self.collectionHeightThumbnails.constant=0
                                    self.collectionContainView.constant=0
                                    self.morePictureLabel.isHidden=true
                                    self.reviewsTopSpace.constant = 0
                                    self.morePicturesTopSpace.constant = 0
                    
                                    
                                }
                                else
                                {
                                    
                                    self.collectionHeightThumbnails.constant=80
                                    let photos = (((venues .value(forKey: "photos")! as AnyObject).object(forKey: "groups") as AnyObject).object(at: 0) as AnyObject).value(forKey: "items") as? NSMutableArray
                                    
                                    self.collectionContainView.constant=145
                                    self.morePictureLabel.isHidden=false
                                    self.reviewsTopSpace.constant = 1
                                    self.morePicturesTopSpace.constant = 1

                                    
                                    
                                    
                                   
                                        
                                        
                                        for l in 0..<photos!.count
                                        {
                                            let str1 = (photos![l] as AnyObject).value(forKey: "prefix") as? String ?? ""
                                            let str2 = (photos![l] as AnyObject).value(forKey: "suffix") as? String ?? ""
                                            
                                            let combinedString = "\(str1)200x200\(str2)"
                                            let combinedString2 = "\(str1)original\(str2)"
                                            
                                            
                                            self.hotelImagesArray .add(["normal": combinedString, "original": combinedString2])
                                        }
                                    
                                    
                                    
                                        self.collectionViewThumbnails .reloadData()
                                        
                                        
                                
                                    
                                    
                                    
                                }
                                
                                
                                
                                
                                
                                ////----- Get reviews
                                if (venues.value(forKey: "tips")! as AnyObject).value(forKey: "count") as! Int == 0 {
                                    
                            
                                    
                                    
                                }
                                    
                                else
                                {
                                    var itemsArray = NSMutableArray()
                                    
                                    itemsArray = (((venues.value(forKey: "tips")! as AnyObject).value(forKey: "groups") as AnyObject).object(at: 0) as AnyObject).value(forKey: "items") as! NSMutableArray
                                    
                                    self.reviewsArray = NSMutableArray() //.removeAllObjects()
                                    for j in 0..<itemsArray.count{
                                        
                                        
                                        let text = (itemsArray.object(at: j)as AnyObject).value(forKey: "text") as! String
                                        
                                        
                                        let prefix = (((itemsArray.object(at: j) as AnyObject).value(forKey: "user") as AnyObject).value(forKey: "photo") as AnyObject).value(forKey: "prefix") as? String ?? ""
                                        
                                        
                                        let suffix = (((itemsArray.object(at: j) as AnyObject).value(forKey: "user") as AnyObject).value(forKey: "photo") as AnyObject).value(forKey: "suffix") as? String ?? ""
                                        
                                        let combinePhoto = "\(prefix)300x300\(suffix)"
                                        
                                        
                                        
                                        
                                        let firstName = ((itemsArray.object(at: j) as AnyObject).value(forKey: "user") as AnyObject ).value(forKey: "firstName") as? String ?? ""
                                        
                                        
                                        let lastName = ((itemsArray.object(at: j) as AnyObject).value(forKey: "user") as AnyObject).value(forKey: "lastName") as? String ?? ""
                                        
                                        
                                        let combineName = "\(firstName) \(lastName)"
                                        
                                        
                                        self.reviewsArray .add(["userPhoto": combinePhoto, "userName": combineName, "comment": text,"reviewerId": ""])
                                        
                                        self.tempReviewArray .add(["userPhoto": combinePhoto, "userName": combineName, "comment": text, "reviewerId": ""])
                                        
                                    }
                                    
                                    
                                 
                                }
                                
                                
                                
                                
                                
                            }
                            
                            
                            self.firstIndicator .removeFromSuperview()
                            self.secondIndicator.removeFromSuperview()
                            
                            

                           
          /// Manage the height of reviews View here
                            
                            print(self.reviewsArray.count)
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
    
   
    
    
    
    
    
    
    
    
    
    
    /////////////////////////////////////////////////////////////////////
    
    
    //MARK:- Near by places from foursquare api
    //MARK:-
    
    

    func nearByPlaces(_ lat:NSString, long: NSString, radius: NSString) -> Void
    {
    
      
        
       let placeName:NSString = (arrayWithData[0] as AnyObject).value(forKey: "Venue") as! NSString
        
        let isConnectedInternet = CommonFunctionsClass.sharedInstance().isConnectedToNetwork()
        
        if isConnectedInternet
        {
            
            let urlString = NSString(string:"https://api.foursquare.com/v2/venues/explore/?ll=\(lat as String),\(long as String)&venuePhotos=1&radius=\(radius as String)&client_id=DAKFO3TURLDTUL33JNPRTIGX03NMZM2ACCDWC2HHHZTV2YMT&client_secret=ILF0G3U4DRSC0WDW2EH12SFGTOKIWSKFUIOXV4FFEQOIB34B&v=20140203")
            
          
            
            
            let needsLove = urlString
            let safeURL = needsLove.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            
            let url:URL = URL(string: safeURL as String)!
            print("Final Url-----> " + (safeURL as String))
            
            let session = URLSession.shared
            
            let request = NSMutableURLRequest(url: url)
            request.httpMethod = "GET"
            request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
            //task3 = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
            
             task3 = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            
                OperationQueue.main.addOperation
                    {
                        
                        print("Near by ")
                        
                        self.forthIndicator .removeFromSuperview()
                        if data == nil
                        {
                           
                            self.forthIndicator .removeFromSuperview()
                        }
                        else
                        {
                            
                            //dispatch_async(dispatch_get_main_queue(), {
                            do{
                                
                                if data?.count != 0{
                            
                            //let result = NSString(data: data!, encoding:NSASCIIStringEncoding)!
                            
                            
                          let anyObj: Any = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                            
                            var resultHotels = NSDictionary()
                            resultHotels = anyObj as! NSDictionary
                            
                            var groupsArray = NSMutableArray()
                            
                                    if let res = (resultHotels.value(forKey: "response") as AnyObject).value(forKey: "groups") as? NSMutableArray {
                                        
                                
                                print("comes here")
                                groupsArray = (resultHotels.value(forKey: "response")! as AnyObject).value(forKey: "groups") as! NSMutableArray
                                       // print(groupsArray)
                                        
                                if groupsArray.count>0
                                {
                                    var itemsArray = NSMutableArray()
                                    itemsArray = (groupsArray .object(at: 0) as AnyObject).value(forKey: "items") as! NSMutableArray
                                    
                                    for i in 0..<itemsArray.count{
                                        
                                        
                                        if ((((itemsArray.object(at: i) as AnyObject).value(forKey: "venue") as AnyObject).value(forKey: "photos") as AnyObject).value(forKey: "count")) as! NSNumber == 0{
                                            
                                            print("Entered if empty")
                                            
                                        }
                                        else
                                        {
                                            let nameOfVenue = ((itemsArray.object(at: i) as AnyObject).value(forKey: "venue") as AnyObject).value(forKey: "name") as! String
                                            
                                            
                                           // let address = itemsArray.objectAtIndex(i).valueForKey("venue")?.valueForKey("location")?.valueForKey("formattedAddress")
                                            
                                            
                                            let prefix = (((((((itemsArray.object(at: i) as AnyObject).value(forKey: "venue") as AnyObject).value(forKey: "photos") as AnyObject).value(forKey: "groups") as AnyObject).object(at: 0) as AnyObject).value(forKey: "items") as AnyObject).object(at: 0) as AnyObject).value(forKey: "prefix") as? String ?? ""
                                            
                                            
                                            
                                            let suffix = (((((((itemsArray.object(at: i) as AnyObject).value(forKey: "venue") as AnyObject).value(forKey: "photos") as AnyObject).value(forKey: "groups") as AnyObject).object(at: 0) as AnyObject).value(forKey: "items") as AnyObject).object(at: 0) as AnyObject).value(forKey: "suffix") as? String ?? ""
                                                
                                            
                                            
                                            
                                            let combineString = "\(prefix)400x400\(suffix)"
                                            
                                        let pictureId = (((((((itemsArray.object(at: i) as AnyObject).value(forKey: "venue") as AnyObject).value(forKey: "photos") as AnyObject).value(forKey: "groups") as AnyObject).object(at: 0) as AnyObject).value(forKey: "items") as AnyObject).object(at: 0) as AnyObject).value(forKey: "id") as? String ?? ""
                                           
                                            
                                            
                                            
                                        let distance = (((itemsArray.object(at: i) as AnyObject).value(forKey: "venue") as AnyObject).value(forKey: "location") as AnyObject).value(forKey: "distance") as! NSNumber
                                            
                                            
                                            var strDist:NSString = String(describing: distance) as NSString
                                            
                                            let tempNum = Int(strDist as String)
                                            
                                        
                                            if strDist.length>=4{
                                                
                                                strDist = String("\(Double(distance)/1000)") as NSString
                                                strDist = String (format: "%.2f", Double(distance)/1000) as NSString
                                                strDist = "\(strDist) Km" as NSString
                                                
                                                
                                            }
                                            else{
                                                strDist = String("\(distance) mt") as! NSString
                                            }
                                            
                                            
                                            //print(strDist)
                                            
                                            
                                            /*
 
                                             // distance in ltwo locations
                                            
                                             CLLocation *location1 = [[CLLocation alloc] initWithLatitude:lat1 longitude:long1];
                                             CLLocation *location2 = [[CLLocation alloc] initWithLatitude:lat2 longitude:long2];
                                             NSLog(@"Distance i meters: %f", [location1 distanceFromLocation:location2]);
                                             [location1 release];
                                             [location2 release];
                                             
                                                    */
                                            
                                            
                                            let arrCon = self.nearByPlacesArray.value(forKey: "imageId") as! NSArray
                                        
                                            if arrCon.contains(pictureId){
                                            
                                            print("contains picture id")
                                                
                                            }
                                            else{
                                                
                                                let dicArr:NSDictionary = ["images" : combineString,
                                                    "name" :nameOfVenue,
                                                    "placeName": placeName,
                                                    "imageId": pictureId,
                                                    "distance": strDist,
                                                    "num": tempNum!]
                                                
                                                 self.nearByPlacesArray .add(dicArr)
                                            }
                                            
                                            
                                            
                                            
                                            
                                            
                                           
                                        }
                                        
                                    }
                                    
                                    
                                    
                                    
                                    if self.nearByPlacesArray.count<1{
                                        
                                        if radius == "100"
                                        {
                                            self.radiusNearBy = "1000"
                                             self .nearByPlaces("\(String(describing: self.LAT))" as NSString, long: "\(String(describing: self.LONG))" as NSString, radius: self.radiusNearBy as NSString)
                                        }
                                        else
                                        {
                                            self.forthIndicator .removeFromSuperview()
                                            self.collectionViewImages.reloadData()
                                            
                                            
                                            self.updateFirstView()
                                            
                                            self.forthView.isHidden=true
                                    self.contentViewHeight.constant = 200 + self.heightOfFirstView.constant + self.heightOfSecondView.constant + self.heightOfThirdView.constant + self.collectionContainView.constant - 29
                                            
                                            self.nearByPlacesTopSpace.constant = 1
                                            
                                            self.view .setNeedsLayout()
                                            self.view .layoutIfNeeded()
                                        }
                                        
                                        
                                    }
                                        
                                        
//                                    else if(self.nearByPlacesArray.count < 50 && Int(self.radiusNearBy) < 5000 ){

                                    else if(self.nearByPlacesArray.count < 5){
                                    self.forthIndicator .removeFromSuperview()
                                        self.collectionViewImages.reloadData()
                                        self.updateFirstView()
                                        self.forthView.isHidden=false
                            self.contentViewHeight.constant = 200 + self.heightOfFirstView.constant + self.heightOfSecondView.constant + self.heightOfThirdView.constant + self.collectionContainView.constant - 29
                                        self.nearByPlacesTopSpace.constant = 1
                                        self.view .setNeedsLayout()
                                        self.view .layoutIfNeeded()
                                        
                                        
                                        if radius == "100"{
                                            self.radiusNearBy="1000"
                                         self .nearByPlaces("\(String(describing: self.LAT))" as NSString, long: "\(String(describing: self.LONG))" as NSString, radius: self.radiusNearBy as NSString)
                                        }
                                        else{
                                            
                                            let RadiusAdd:Int = Int(radius as String)! + 1000
                                            print(RadiusAdd)
                                            self.radiusNearBy = String(RadiusAdd)
                                            
                                            self .nearByPlaces("\(String(describing: self.LAT))" as NSString, long: "\(String(describing: self.LONG))" as NSString, radius: self.radiusNearBy as NSString)
                                            
                                            
                                        }
                                        
                                        
                                        
                                        
                                        
                                    }
                                        
                                        
                                    else
                                    {
                                    // sort
                                        
                                        // print(self.nearByPlacesArray)
                                        //sort here
    let sortAr = Array(self.nearByPlacesArray).sorted{
                                            (($0 as! Dictionary<String, AnyObject>)["num"] as? Int)! < (($1 as! Dictionary<String, AnyObject>)["num"] as? Int)!
                                        }

                                        
                                        ///print(sortAr)
                                        
                                        
                                        self.nearByPlacesArray = NSMutableArray(array: sortAr)
                                      
                                        
                                        
                                        self.forthIndicator .removeFromSuperview()
                                        self.collectionViewImages.reloadData()
                                        
                                        
                                        self.updateFirstView()
                                       self.forthView.isHidden=false
                            self.contentViewHeight.constant = 200 + self.heightOfFirstView.constant + self.heightOfSecondView.constant + self.heightOfThirdView.constant + self.collectionContainView.constant - 29
                                        self.nearByPlacesTopSpace.constant = 1
                                        self.view .setNeedsLayout()
                                        self.view .layoutIfNeeded()
                                    }
                                    
                                    
                                    
                                    
                                    
                                }
                                else
                                {
                                    
                                    self.updateFirstView()
                                    self.forthView.isHidden=true
                                    self.contentViewHeight.constant = 200 + self.heightOfFirstView.constant + self.heightOfSecondView.constant + self.heightOfThirdView.constant + self.collectionContainView.constant - 29
                                    self.nearByPlacesTopSpace.constant = 0
                                    self.view .setNeedsLayout()
                                    self.view .layoutIfNeeded()
                                    
                                    
                                }
                                
                                
                            }
                            else
                            {
                                
                                self.updateFirstView()
                                self.forthView.isHidden=true
                                self.contentViewHeight.constant = 10 + self.heightOfFirstView.constant + self.heightOfSecondView.constant + self.heightOfThirdView.constant + self.collectionContainView.constant - 10
                                self.nearByPlacesTopSpace.constant = 0
                                self.view .setNeedsLayout()
                                self.view .layoutIfNeeded()

                                
                                
                            }
                            
                        }}catch{
                            print("task3 catch block")
                }
                      
                        }
                }
                
            })
            
            task3.resume()
        }
        else
        {
            CommonFunctionsClass.sharedInstance().showAlert(title: "No Internet Connection", text: "You are currently offline.", imageName: "alertInternet")
            forthIndicator .removeFromSuperview()
        }
        
        
    }
    
    
    
    
    
    
    /////////////////////////////////////////////////////////////////////////////////////
    
    //MARK:- ///////// Response from the storyApi /////////
    //MARK:-
    
    func serverResponseArrived(Response:AnyObject)
    {
        
        
        //////////---------- REsponse for the add and delete image in story-----------////////
        
      
            
            jsonResult = NSDictionary()
            jsonResult = Response as! NSDictionary
            
            let success = jsonResult.object(forKey: "status") as! NSNumber
            
            if success != 1
            {
                
                  CommonFunctionsClass.sharedInstance().showAlert(title: "Server Alert", text: "Something doesn't seem right, Please try again!", imageName: "alertServer")
                
               // SweetAlert().showAlert("PYT", subTitle: "Sorry image is not added to story, Please try again!", style: AlertStyle.Error)
                
               
            }
            
            
        
            
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    ////////////-------- comment section---------/////////
    
    
    //MARK:-
    //MARK: Get the review from the api of pyt
    
    
    func postApiToGetPYTReview(_ parameterReview: NSString) {
        
        print(parameterReview)
        
      
        
        
        let isConnectedInternet = CommonFunctionsClass.sharedInstance().isConnectedToNetwork()
        
        if isConnectedInternet
        {
            
            let request = NSMutableURLRequest(url: URL(string: "\(appUrl)get_review")!)
            
            
            request.httpMethod = "POST"
            let postString = parameterReview
            request.httpBody = postString.data(using: String.Encoding.utf8.rawValue)
            let session = URLSession.shared
            
         let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            //let task = Foundation.URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
                guard error == nil && data != nil else {                                                          // check for fundamental networking error
                   
                    return
                }
                
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                   
                }
                
                
                DispatchQueue.main.async(execute: {
                    
                    do {
                        
                        let result = NSString(data: data!, encoding:String.Encoding.ascii.rawValue)!
                      
                        print("Body: result of get comment:\(result)")
                        
                        
                        
                       let anyObj: Any = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                        
                        basicInfo = NSMutableDictionary()
                        basicInfo = anyObj as! NSMutableDictionary
                        
                        let status = basicInfo .value(forKey: "status") as! NSNumber
                        
                        
                        if status == 1
                        {
                           
                            let review = basicInfo.value(forKey: "data") as! NSMutableArray
                            
                            if review.count > 0{
                                
                                self.tempReviewArray = NSMutableArray() //.removeAllObjects()
                                
                             
                                
                                let userPhotoDp = ((review[0] as AnyObject).value(forKey: "userId")! as AnyObject).value(forKey: "picture") as? String ?? " "
                                
                                let reviewTxt = (review[0] as AnyObject).value(forKey: "review") as? String ?? " "
                                let reviewername = ((review[0] as AnyObject).value(forKey: "userId")! as AnyObject).value(forKey: "name") as? String ?? " "
                                
                                
                                
                                self.tempReviewArray.insert(["userPhoto": userPhotoDp, "userName": reviewername, "comment": reviewTxt], at: 0)
                                
                                
                               
                                
                    }
                            else
                            {
                                
                            self.tempReviewArray = self.reviewsArray
                                
                            }
                            
                            
                            
                        }
                        else{
                            
                            self.tempReviewArray = NSMutableArray() //.removeAllObjects()
                            
                            let userPhotoDp = (self.arrayWithData[0] as AnyObject).value(forKey: "profileImage") as? NSString ?? ""
                            
                            let reviewTxt = (self.arrayWithData[0] as AnyObject).value(forKey: "Description") as? String ?? " "
                            
                            let reviewername = (self.arrayWithData[0] as AnyObject).value(forKey: "userName") as? String ?? ""
                            
                            
                            
                            if reviewTxt == "" || reviewTxt == " "{
                                
                             self.tempReviewArray = self.reviewsArray
                            }
                            else
                            {
                            
                            self.tempReviewArray.insert(["userPhoto": userPhotoDp, "userName": reviewername, "comment": reviewTxt], at: 0)
                               
                                print(self.reviewsArray)
                                
                                
                                if self.reviewsArray.count<1{
                                    self.reviewsArray = self.tempReviewArray
                                }
                            }
                            
                            
                            
                            
                        }
                       
                        self.updateThirdView()
                        
                       
                        
                        
                        
                    } catch {
                        //print("json error: \(error)")
                       CommonFunctionsClass.sharedInstance().showAlert(title: "Server Alert", text: "Something doesn't seem right, Please try again!", imageName: "alertServer")
                        
                        //  self .postRequestCategories("", viewController: viewController) //recall
                        
                    }
                    
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "reloadReviews"), object: nil)
                    

                    MBProgressHUD .hide(for: self.view, animated: true)
                    
                    
                    
                    
                    
                })
                
                
                
                
                
                
                
            })
            task.resume()
            
        }
        else
        {
            CommonFunctionsClass.sharedInstance().showAlert(title: "No Internet Connection", text: "You are currently offline.", imageName: "alertInternet")
        }
        
        
        
        
        
        
        
    }
    
    
    
    
    
    
    
    
    
    //MARK: ADD comment section
    //MARK:
    
    @IBAction func AddCommentAction(_ sender: AnyObject) {
    
        
        
        let otherUserName = (self.arrayWithData[0] as AnyObject).value(forKey: "userName") as? String ?? ""
        let imageId = (self.arrayWithData[0] as AnyObject).value(forKey: "imageId") as? String ?? ""
        let imageThumbnail = (self.arrayWithData[0] as AnyObject).value(forKey: "standardImage") as? String ?? ""
        let nxtObj2 = self.storyboard?.instantiateViewController(withIdentifier: "commentViewController") as? commentViewController
        let locationImageStr = (self.arrayWithData[0] as AnyObject).value(forKey: "locationImage") as? String ?? ""
        let otherUserId = (self.arrayWithData[0] as AnyObject).value(forKey: "otherUserId") as? String ?? ""
       
        var dictData = NSDictionary()
        dictData = ["imageId": imageId, "largeImage": locationImageStr, "thumbnailImage": imageThumbnail, "otherUserId": otherUserId, "otherUserName": otherUserName ]
        let uId = Udefaults .string(forKey: "userLoginId")
        let commentParameter = "imageId=\(imageId)&userId=\(uId!)&page=all"//newer
        nxtObj2?.dictionaryData = dictData
        nxtObj2?.addComment = true
         nxtObj2!.imageIdComment = imageId as NSString
        nxtObj2?.foursqReviews = self.reviewsArray
        nxtObj2?.parameter=commentParameter as NSString
        self.navigationController! .pushViewController(nxtObj2!, animated: true)
        
        
    }
    
    
    
    
    
      
    
    
    
    
    
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        URLCache.shared.removeAllCachedResponses()
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

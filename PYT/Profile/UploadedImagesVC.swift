//
//  UploadedImagesVC.swift
//  PYT
//
//  Created by osx on 04/07/17.
//  Copyright © 2017 osx. All rights reserved.
//

import UIKit

class UploadedImagesVC: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var headerName: UILabel!
    var parameters = NSString()
    var urlload = NSString()
    
    var photosArray = NSMutableArray()
    var countStrText = NSString()
    var username = String()
    var indexselectRow = Int()
    var indexSelectSection = Int()
    var MoreCount = Int()
    var moreShow=Bool()
    var agianHit = Bool()
    
    @IBOutlet weak var countLabel: CustomLabel!
    @IBOutlet weak var totalPhotosCollectionView: UICollectionView!
    
    @IBOutlet weak var imagesIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var zoomScrollView: UIScrollView!
    
    @IBOutlet var zoomView: UIView!
    @IBOutlet var zoomimageView: UIImageView!
    @IBOutlet weak var zoomIndicator: UIActivityIndicatorView!
     let uId = Udefaults .string(forKey: "userLoginId")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MoreCount = 0
        self.tabBarController?.tabBar.isHidden = true
        //self.tabBarController?.setTabBarVisible(visible: false, animated: true)

        // Do any additional setup after loading the view.
        
        print(parameters)
        
      //  let newPrm = "userId=\(uId)&\(parameters)&skip=0"
        
        imagesIndicator.isHidden=false
        imagesIndicator.startAnimating()
        self.countLabel.text = countStrText as String
        headerName.text = username
        
        let ParamDict: NSDictionary=["userId":uId, "status": parameters, "skip":0]
        print(ParamDict)
        self.getAllPhotos(ParamDict, urlToLoad: urlload)
        //self.getAllPhotos(newPrm as NSString, urlToLoad: urlload)
        
        
        
        /// close the zoom view
        let singleTapGesture2 = GestureViewClass(target: self, action: #selector(detailViewController.closeImageView))
        singleTapGesture2.numberOfTapsRequired = 1 // Optional for single tap
        zoomView.addGestureRecognizer(singleTapGesture2)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int{
        if moreShow == true {
            return photosArray.count + 1
        }
        return photosArray.count
    }
    
    //2
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        
        
        if section == photosArray.count  {
            return 1
        }
        let countAr = (photosArray.object(at: section) as AnyObject).value(forKey: "photos") as! NSMutableArray
       
        return countAr.count //(photosArray.object(at: section) as AnyObject).value(forKey: "photos")!.count
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var reusableview: UICollectionReusableView? = nil
        if kind == UICollectionElementKindSectionHeader{
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "ImagesHeader", for: indexPath) as! ImagesHeader
            //var title = "Recipe Group #\(indexPath.section + 1)"
            
            if indexPath.section == photosArray.count {
               reusableview = headerView
            }
            else{
                
            
            let date = ((photosArray.object(at: indexPath.section) as AnyObject).value(forKey: "_id") as AnyObject).value(forKey: "date") as? String ?? "NA"
            
            
            // change to your date format
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date2 = dateFormatter.date(from: date)
            // let date2 = dateFormatter.dateFromString("2017-03-28")
            
            dateFormatter.dateFormat = "MMM dd, YYYY"
            var goodDate = dateFormatter.string(from: date2!)
            print(goodDate)
            
            
            let calendar = Calendar.autoupdatingCurrent
            
            //let someDate = dateFormatter.dateFromString(date2)
            if calendar.isDateInYesterday(date2!) {
                goodDate = "Yesterday"
            }else if(calendar.isDateInToday(date2!))
            {
                goodDate = "Today"
            }
            
                
            let components = (calendar as NSCalendar).components([.day , .month , .year], from: date2!)
            
            let year =  components.year
            let month = components.month
            let day = components.day
            
            print(year!)
          //  print(month)
           // print(day)
            
            let todayDate = Date()
            let yearCheck = (calendar as NSCalendar).component(.year, from: todayDate)
            
            if year != yearCheck {
                goodDate = String(describing: year!)
            }
            
                var location = NSString()
                var stateArr = NSArray()
                var countryArr = NSArray()
            var cityArr = (photosArray.object(at: indexPath.section) as AnyObject).value(forKey: "city") as! NSArray
                if cityArr.count<1 {
                    stateArr = (photosArray.object(at: indexPath.section) as AnyObject).value(forKey: "state") as! NSArray
                    if stateArr.count<1 {
                        countryArr = (photosArray.object(at: indexPath.section) as AnyObject).value(forKey: "country") as! NSArray
                        if countryArr.count<1 {
                            //set nil in the location
                            location = "NA"
                        }
                        else{
                            //set the country in the location
                           let location2 = (countryArr.object(at: 0) as AnyObject) .value(forKey: "fullName") as? String ?? ""
                            location = location2 as NSString
                        }
                        
                    }
                    else{
                        //set the state in the location
                        let location2 = (stateArr.object(at: 0) as AnyObject) .value(forKey: "fullName") as? String ?? ""
                        location = location2 as NSString
                    }
                }
                else{
                    //set the city in the location
                    let location2 = (cityArr.object(at: 0) as AnyObject) .value(forKey: "fullName") as? String ?? ""
                    location = location2 as NSString
                }
                
                
                
                headerView.locationLabel.text = location as String
            
            headerView.dateLbl.text = goodDate
                
                
                
                
            //  var headerImage = UIImage(named: "header_banner.png")!
            // headerView.backgroundImage!.image = headerImage
            reusableview = headerView
                
            
        }
        
        }
        
        return reusableview!
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if indexPath.section == photosArray.count {
            let width1 = collectionView.frame.size.width   //1.8
            return CGSize(width: width1,height: 60 )
        }
        
        let width1 = collectionView.frame.size.width/3.03   //1.8
        
        return CGSize(width: width1,height: width1 )
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == photosArray.count {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MoreImages", for: indexPath) as! showMoreImg
            
            cell.loadMoreIndicator.startAnimating()
            cell.loadMoreIndicator.isHidden = false
            
            let ParamDict: NSDictionary=["userId":uId, "status": parameters, "skip":photosArray.count]
            print(ParamDict)
            if agianHit == false
            {
                agianHit = true
                 self.getAllPhotos(ParamDict, urlToLoad: urlload)
            }
           
            
            return cell
            
            
        }
        
        
        // normal cell will load
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Images", for: indexPath) as! Images
        
        //cell.imageView.backgroundColor = UIColor.redColor()
        
        
        
        let imageThumb = (((self.photosArray.object(at: indexPath.section) as AnyObject).value(forKey: "photos")! as AnyObject).object(at: indexPath.row) as AnyObject).value(forKey: "imageThumb") as? String ?? ""
        
        
        let imgUrl = URL(string: imageThumb)
        
        cell.loadIndicator.startAnimating()
        
        
        cell.imageView.sd_setImage(with: imgUrl) { (image, error, cache, urls) in
            cell.loadIndicator.stopAnimating()
            cell.loadIndicator.hidesWhenStopped=true
            if (error != nil) {
                cell.imageView.image = UIImage(named: "dummyBackground1")
                
            } else {
                cell.imageView.image = image
            }
        }
        
//        let block: SDWebImageCompletionBlock! = {(image: UIImage!, error: NSError!, cacheType: SDImageCacheType!, imageURL: URL!) -> Void in
//            
//            cell.loadIndicator.stopAnimating()
//            cell.loadIndicator.hidesWhenStopped=true
//        }
//        
//        //            //completion block of the sdwebimageview
//        cell.imageView.sd_setImage(with: imgUrl, placeholderImage: UIImage (named: "backgroundImage"), completed: block)
        
        
        
        
        
        cell.layoutIfNeeded()
        
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        indexselectRow = indexPath.row
        indexSelectSection = indexPath.section
        
        self.openZoomView()
        
    }
    
    
    //MARK: Open Zoom view
    
    ////close the zoomed image view
    func closeImageView()
    {
        
        zoomView.isHidden=true
        
    }
    
    
    ///////////////----- open the zoom image view
    
    
    func openZoomView() -> Void {
        
        self.zoomScrollView.minimumZoomScale = 1.0
        self.zoomScrollView.maximumZoomScale = 5.0
        
        self.zoomScrollView.zoomScale = 1.0
        
        // Thumbnails = false
        // DirectionSwipe = "None"
        
        // var multiImg = NSMutableArray()
        // multiImg = self.arrayWithData[0].valueForKey("multipleImagesLarge")as! NSMutableArray
        
        
        
        zoomView.isHidden=false
        self.view .bringSubview(toFront: zoomView)
        
        
        zoomIndicator.startAnimating()
        self.zoomIndicator.isHidden=false
        
        //var locationImageStr = ""
        //        if slideShow.currentItemIndex==0 {
        //            locationImageStr = multiImg.objectAtIndex(slideShow.currentItemIndex) as! String
        //        }
        //        else{
        //            locationImageStr = multiImg.objectAtIndex(slideShow.currentItemIndex) as! String
        //        }
        //
        //        zoomImagesArray .removeAllObjects()
        //        zoomImagesArray .addObject(locationImageStr)
        //
        //        indexOfZoomImg = 0
        
        
        
        
        //        for i in 0..<multiImg.count {
        //
        //            let locationImageStr2 = multiImg.objectAtIndex(i) as! String
        //            zoomImagesArray .addObject(locationImageStr2)
        //
        //
        //        }
        
        
        
        // let copy = zoomImagesArray
        
        //        var index = copy.count - 1
        //        for object: AnyObject in (copy as NSArray).reverseObjectEnumerator() {
        //            if (zoomImagesArray as NSArray).indexOfObject(object, inRange: NSMakeRange(0, index)) != NSNotFound {
        //                zoomImagesArray.removeObjectAtIndex(index)
        //            }
        //            index -= 1
        //        }
        
        self.changeZoomImage(0)
        
        
        
    }
    
    
    
    func changeZoomImage(_ indx:Int) {
        
        let pImage : UIImage = UIImage(named:"dummyBackground1")!
        zoomimageView.image = pImage
        let imageThumb = (((self.photosArray.object(at: indexSelectSection) as AnyObject).value(forKey: "photos")! as AnyObject).object(at: indexselectRow) as AnyObject).value(forKey: "imageThumb") as? String ?? ""
        
        let url2 = URL(string: imageThumb as String)
        
        
        zoomimageView.sd_setImage(with: url2, placeholderImage: pImage)
        
        
        let imageLarge = (((self.photosArray.object(at: indexSelectSection) as AnyObject).value(forKey: "photos")! as AnyObject).object(at: indexselectRow) as AnyObject).value(forKey: "imageLarge") as? String ?? ""
        
        let url = URL(string: imageLarge as String)
        
        
        
        
        zoomIndicator.startAnimating()
        self.zoomIndicator.isHidden=false
        
//        zoomimageView.sd_setImage(with: url) { (image, error, cache, urls) in
//            self.zoomIndicator.stopAnimating()
//            self.zoomIndicator.isHidden=true
//            if (error != nil) {
//                self.zoomimageView.image = self.zoomimageView.image
//            } else {
//                self.zoomimageView.image = image
//            }
//        }
    
        zoomimageView.sd_setImage(with: url, placeholderImage: zoomimageView.image)
        self.zoomIndicator.stopAnimating()
        self.zoomIndicator.isHidden=true
        
        
//        let block: SDWebImageCompletionBlock! = {(image: UIImage!, error: NSError!, cacheType: SDImageCacheType!, imageURL: URL!) -> Void in
//            
//            self.zoomIndicator.stopAnimating()
//            self.zoomIndicator.isHidden=true
//            
//        }
//        
//        //completion block of the sdwebimageview
//        zoomimageView.sd_setImage(with: url, placeholderImage: zoomimageView.image, completed: block)
        
        CATransaction.commit()//moving effect of images
        
    }
    
    
    
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView?
    {
        if scrollView==zoomScrollView {
            return self.zoomimageView
        }
            
        else{
            return self.view
        }
        
    }
    
    
    
    
    
    
    
    
    //////////////////////////////////////////////////////////////////////////////
    
    
    
    
    
    
    
    
    
    
    
    
    
    //MARK: Action methods back
    
    @IBAction func backBtnAction(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    
    
    
    
    
    
    
    //MARK: Get the photos of selected category// facebook, instagram, pyt
    
    func getAllPhotos(_ parmString: NSDictionary, urlToLoad: NSString) {
        
        let isConnectedInternet = CommonFunctionsClass.sharedInstance().isConnectedToNetwork()
        
        if isConnectedInternet
        {
            let request = NSMutableURLRequest(url: URL(string: "\(appUrl)\(urlToLoad)")!)
            
            
            request.httpMethod = "POST"
            request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
            do {
                let jsonData = try!  JSONSerialization.data(withJSONObject: parmString, options: [])
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
                   
                }
                
                
                DispatchQueue.main.async(execute: {
                    
                    do {
                        
                        let result = NSString(data: data!, encoding:String.Encoding.ascii.rawValue)!
                        print("Body: \(result)")
                        
                        
                        
                        
                      let anyObj: Any = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                        
                        basicInfo = NSMutableDictionary()
                        basicInfo = anyObj as! NSMutableDictionary
                        
                        let status = basicInfo .value(forKey: "status") as! NSNumber
                        
                        if status == 1{
                            
                            self.agianHit = false
                            //self.photosArray = basicInfo.value(forKey: "data") as! NSMutableArray
                            let newArr = basicInfo.value(forKey: "data") as! NSArray
                            
                            self.photosArray .addObjects(from: newArr as! [Any])
                            print(self.photosArray.count)
                            
                            let moreValue = basicInfo.value(forKey: "more") as! NSNumber
                            if moreValue == 1{
                            self.moreShow = true
                            }
                            else
                            {
                                self.moreShow = false
                            }
                        }
                        
                        
                        
                        self.totalPhotosCollectionView.reloadData()
                        
                        
                        
                        
                        
                    } catch {
                        //print("json error: \(error)")
                        CommonFunctionsClass.sharedInstance().showAlert(title: "Server Alert", text: "Something doesn't seem right, Please try again!", imageName: "alertServer")
                        
                        
                    }
                    
                    self.imagesIndicator.isHidden=true
                    self.imagesIndicator.stopAnimating()
                    
                    
                    
                })
                
                
                
                
            }
            task.resume()
            
        }
        else
        {
            CommonFunctionsClass.sharedInstance().showAlert(title: "No Internet Connection", text: "You are currently offline.", imageName: "alertInternet")
            
            self.imagesIndicator.isHidden=true
            self.imagesIndicator.stopAnimating()
        }
        
        
        
        
        
        
    }
    
    
    
    
}












class Images: UICollectionViewCell {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet weak var loadIndicator: UIActivityIndicatorView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.contentMode = .scaleAspectFill
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        imageView.clipsToBounds=true
    }
    
    
}
class showMoreImg : UICollectionViewCell{
    
    @IBOutlet weak var loadMoreIndicator: UIActivityIndicatorView!
    
}



class ImagesHeader: UICollectionReusableView {
    @IBOutlet var dateLbl: UILabel!
    @IBOutlet var shareBtn: UIButton!
    @IBOutlet var locationLabel: UILabel!
    
    
}




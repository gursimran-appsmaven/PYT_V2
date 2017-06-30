//
//  PostScreenViewController.swift
//  PYT
//
//  Created by osx on 27/06/17.
//  Copyright © 2017 osx. All rights reserved.
//

import UIKit
import DKImagePickerController
import MBProgressHUD
import GooglePlaces
import MBProgressHUD
import  AWSS3


class PostScreenViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {

    @IBOutlet weak var addImg1: UIButton!
    @IBOutlet weak var addImg2: UIButton!
    @IBOutlet weak var addImg3: UIButton!
    @IBOutlet weak var addImg4: UIButton!
    @IBOutlet weak var addImg5: UIButton!
    @IBOutlet weak var addImg6: UIButton!
    @IBOutlet weak var addImg7: UIButton!
    @IBOutlet weak var addImg8: UIButton!
    
    
    @IBOutlet weak var deleteImg1: UIButton!
    @IBOutlet weak var deleteImg2: UIButton!
    @IBOutlet weak var deleteImg3: UIButton!
    @IBOutlet weak var deleteImg4: UIButton!
    @IBOutlet weak var deleteImg5: UIButton!
    @IBOutlet weak var deleteImg6: UIButton!
    @IBOutlet weak var deleteImg7: UIButton!
    @IBOutlet weak var deleteImg8: UIButton!
    
    
    
    //Amasone server
    let S3UploadKeyName: String = "iqtBkg8alWc0rdsXXoxF6aMc9VJPWROfDDOj3TOd"
    let amazoneUrl = "https://s3-us-west-2.amazonaws.com/"
    let myIdentityPoolId = "us-west-2:47968651-2cda-46d4-b851-aea8cbcd663f"//live
    let S3BucketName = "pytprofilebucket" //"pytphotobucket"//live
    
    
    /////
    var imageData = Data()
    var isCamera = Bool()
    var multipleImagesArray = NSMutableArray()
    var originalArray = NSMutableArray()
    var thumbnailArray = NSMutableArray()
    var boolCount = Int()
    var catSelectedId = NSMutableArray()
    var editImagesArray = NSMutableArray()//Edit photos
    //Image Picker
    let imagePicker = UIImagePickerController()
    
    
    var pickerController: DKImagePickerController!
    
    //GeotagView Outlets
    @IBOutlet weak var geoTagview: UIView!
    @IBOutlet weak var searchView: UIView!
    
    @IBOutlet weak var geoTagLabel: UILabel!
    @IBOutlet weak var search_bar: UISearchBar!
    @IBOutlet weak var cancelButtonSearch: UIButton!
    @IBOutlet weak var geotagTableView: UITableView!
    @IBOutlet weak var geoTagTopView: NSLayoutConstraint!
    var locationsArr = NSMutableArray()
    var placesClient: GMSPlacesClient?
    var locationString = NSString()
    var locationType = NSString()
    var locationCountry = NSString()
    var locationLongitude = NSString()
    var locationLatitude = NSString()
    var locationcity = NSString()
    var locationState = NSString()
     var loadingNotification2 = MBProgressHUD()
    
    
    //Interest Outlets
    @IBOutlet weak var interestLabel: UILabel!
    
    
    
    //Description View Outlet
    @IBOutlet weak var descriptionTxtV: UITextView!
    
    
    
    //Privacy view Outlets
    @IBOutlet weak var publicBtnOutlet: UIButton!
    @IBOutlet weak var privateBtnOutlet: UIButton!
    var accessPhoto = String()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        accessPhoto = "public"
        self.setEmptyImageInbuttons()
         placesClient =  GMSPlacesClient.shared()
         Udefaults .setValue(nil, forKey: "PostInterest")
        
         NotificationCenter.default.addObserver(self, selector: #selector(PostScreenViewController.Start_Upload_Here(_:)),name:NSNotification.Name(rawValue: "uploadingStart"), object: nil)
        
        // Do any additional setup after loading the view.
    }

    
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.tabBarController?.setTabBarVisible(visible: true, animated: true)

        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        blurEffectView.alpha = 0.6
        blurEffectView.frame = geoTagview.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        geoTagview.addSubview(blurEffectView)
       
        self.geoTagview.bringSubview(toFront: searchView)
       // self.geoTagview.bringSubview(toFront: cancelButtonSearch)
        self.geoTagview.bringSubview(toFront: geotagTableView)
        search_bar.layer.cornerRadius = 5.0
        search_bar.clipsToBounds = true
        search_bar.barTintColor = UIColor .white
        search_bar.returnKeyType = UIReturnKeyType .done
        search_bar.showsCancelButton = false
        search_bar.delegate = self
        
        
        
        let postArray = Udefaults.mutableArrayValue(forKey: "PostInterest")
        if postArray.count < 1 {
            interestLabel.text = "Add"
        }
        else
        {
        let str = (postArray.value(forKey: "displayName") as! NSArray).componentsJoined(by: ",")
            interestLabel.text = str
            
        }
        
        
    }
    
    
    
    
    
    @IBAction func actionSheet(_ sender: AnyObject)
    {
        
       // print(sender.tag)
        
        if sender.imageView??.image == UIImage( named: "SmallImagethumb") {
            self.openActionSheet()
        }
        else
        {
            self.setBigImageInMiddle(senderImg: ((self.multipleImagesArray.object(at: sender.tag) as AnyObject).value(forKey: "originalImage")) as! UIImage)
        }
        
    }
    
    
    func openActionSheet()
    {
         imagePicker.delegate = self
            
            let alertController = UIAlertController(title: "Select Image", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
            
            let libAction = UIAlertAction(title: "Select from library", style: UIAlertActionStyle.default, handler: {(alert: UIAlertAction!) in
                self.photofromLibrary()
                
            })
            
            let captureAction = UIAlertAction(title: "Capture image", style: UIAlertActionStyle.default, handler: {(alert: UIAlertAction!) in self.capture()
                
            })
            
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: {(alert: UIAlertAction!) in print("cancel")})
            
            alertController.addAction(libAction)
            alertController.addAction(captureAction)
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true, completion:{})
        
        
        
    }
    
    
    
    
    //MARK: Image Picker Delegates
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController,didFinishPickingMediaWithInfo info: [String : Any])
    {
        
        if multipleImagesArray.count<7
        {
            var chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage!
            var finalImage = UIImage()
            finalImage=chosenImage!
            var uploadImg = UIImage()
            
            if Int((chosenImage?.size.width)!) > 1500 {
                
                finalImage =  scaleImage(chosenImage!, toSize: CGSize(width: 1500, height: 1300))
                
                uploadImg = scaleImage(chosenImage!, toSize: CGSize(width: 1500, height: 1300))
                imageData = UIImageJPEGRepresentation(uploadImg,0.2)!
                
                // print(imageData.bytes)
                
                
            }
            else
            {
                imageData = UIImageJPEGRepresentation(chosenImage!,0.2)!
                //print(imageData.bytes)
            }
            
            
            chosenImage = finalImage
            
            
            
            
            let testImgView = UIImageView()
            testImgView.image=self.scaleImage(chosenImage!, toSize: CGSize(width:350, height: 300))
            
            self.multipleImagesArray .add(["imageData": imageData, "originalImage":chosenImage, "urlImg":"camera", "thumbnail": testImgView.image! ])
            
            
            
            
            
            for i in 0..<self.multipleImagesArray.count {
                
                self.setImageInButtons(btntag: i)
                
            }
            
            
            
            
            print("original=\(chosenImage), other=\(testImgView.image)")
            
            
            dismiss(animated: true, completion: nil)
            
            
            
            
            
        }
            
        else
        {
            dismiss(animated: true, completion: nil)
            CommonFunctionsClass.sharedInstance().showAlert(title: "Too much to handle!", text: "You can't add more than eight pictures at once.", imageName: "alertLimit")
            
            
            
        }
        
        
    }
    
    
    
  
    
    //open capera to click photos
    func capture() {
        
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    func photofromLibrary() {
        
        
       let pickerController = DKImagePickerController.init()
        
        
        
//        pickerController.didSelectAssets = { (assets: [DKAsset]) in
//            print("didSelectAssets")
//            print(assets)
//            
//        }
        
        pickerController.didCancel = { ()
            print("didCancel")
        }
        
       
        
        
        
        
        
        self.present(pickerController, animated: true) {}
        
        pickerController.allowMultipleTypes=false
        pickerController.assetType = .allPhotos
        pickerController.maxSelectableCount = 7 - self.multipleImagesArray.count
        
        
        
        pickerController.didSelectAssets = { (assets: [DKAsset]) in
            print("didSelectAssets")
        
            
            
            
           // dispatch_async(dispatch_get_main_queue()) {
                
                
             DispatchQueue.main.async {
                
                
                
                for asset in assets {
                    
                    
                    asset.fetchOriginalImage(false, completeBlock: { image, info in
                        
                        if let img = image{
                            print(img)
                            
                            let dictInfo:NSDictionary = info! as NSDictionary
                            
                            let urlImg = dictInfo.value(forKey: "PHImageFileURLKey")
                            
                            
                            var uploadImg = UIImage()
                            
                            if img.size.width>1200 {
                                
                                
                                print("Going Inside")
                                
                                uploadImg = self.scaleImage(img, toSize: CGSize(width: 1500, height: 1300))
                                self.imageData = UIImageJPEGRepresentation(uploadImg,0.2)!
                                
                                print(self.imageData.count/1024/1024)
                                
                                
                            }
                            else
                            {
                                self.imageData = UIImageJPEGRepresentation(img,0.2)!
                                print(self.imageData.count/1024/1024)
                            }
                            
                            
                            
                            let testImgView = UIImageView()
                            testImgView.image=self.scaleImage(img, toSize: CGSize(width:700, height: 700))
                            
                            print(testImgView.image?.size)
                            print(testImgView.image)
                            
                            if self.multipleImagesArray.count<8 {
                                
                                let imArr = self.multipleImagesArray.value(forKey: "urlImg") as! NSArray
                                if imArr.contains(urlImg!)
                                {
                                    
                                    print("already contains")
                                    
                                }
                                else
                                {
                                    self.multipleImagesArray .add(["imageData": self.imageData, "originalImage":img, "urlImg": urlImg!, "thumbnail": testImgView.image!])
                                    
                                }
                                
                                
                                
                                
                            }
                            
                           
                            
                        }
                        
                        
                        
                        
                        
                        for i in 0..<self.multipleImagesArray.count {
                            
                            self.setImageInButtons(btntag: i)
                            
                        }
                        
                        
                    })
                    
                    
                  
            
            
          
                
            }
            
            
            
            }
            
            
        }
        
        
        
        
        
        
    }
    
    
    
    
    
    
    //MARK: Delete selected images
    
    //Remove image target from collectionView
    
    @IBAction func deleteImageAction(_ sender: AnyObject)
    {
        self.multipleImagesArray .removeObject(at: sender.tag)
        self.setEmptyImageInbuttons()
        for i in 0..<self.multipleImagesArray.count {
            
            self.setImageInButtons(btntag: i)
        }
        
        
    }

    
    
    //MARK: Function to scale image according to height and width and its ratio..
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
    
    
    
    //MARK: Set images in the button
    func setImageInButtons(btntag: Int) {
        //imageToPost.imageView?.contentMode = .scaleAspectFill
        // imageToPost.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        switch btntag {
//        case 0:
//            let imageBtn = self.scaleImage(((self.multipleImagesArray.object(at: btntag) as AnyObject).value(forKey: "originalImage"))  as! UIImage, toSize: addImg1.frame.size)
//            addImg1.setImage(imageBtn, for: .normal)
//            deleteImg1.isHidden = false
//            break
            
        case 0:
           
            addImg2.setImage(((self.multipleImagesArray.object(at: btntag) as AnyObject).value(forKey: "thumbnail"))  as? UIImage, for: .normal)
            deleteImg2.isHidden = false
            self.setBigImageInMiddle(senderImg: ((self.multipleImagesArray.object(at: btntag) as AnyObject).value(forKey: "originalImage")) as! UIImage)
            
            break
            
        case 1:
           
            addImg3.setImage(((self.multipleImagesArray.object(at: btntag) as AnyObject).value(forKey: "thumbnail"))  as? UIImage, for: .normal)
            deleteImg3.isHidden = false
            break
            
        case 2:
          
            addImg4.setImage(((self.multipleImagesArray.object(at: btntag) as AnyObject).value(forKey: "thumbnail"))  as? UIImage, for: .normal)
            deleteImg4.isHidden = false
            break
            
        case 3:
           
            addImg5.setImage(((self.multipleImagesArray.object(at: btntag) as AnyObject).value(forKey: "thumbnail"))  as? UIImage, for: .normal)
            deleteImg5.isHidden = false
            break
            
        case 4:
            
            addImg6.setImage(((self.multipleImagesArray.object(at: btntag) as AnyObject).value(forKey: "thumbnail"))  as? UIImage, for: .normal)
            deleteImg6.isHidden = false
            break
            
        case 5:
           
            addImg7.setImage(((self.multipleImagesArray.object(at: btntag) as AnyObject).value(forKey: "thumbnail"))  as? UIImage, for: .normal)
            deleteImg7.isHidden = false
            break
            
        default:
            
            addImg8.setImage(((self.multipleImagesArray.object(at: btntag) as AnyObject).value(forKey: "thumbnail"))  as? UIImage, for: .normal)
            deleteImg8.isHidden = false
            break
        }
        
        
        
    }
    
    //Set initial Images in the Buttons
    func setEmptyImageInbuttons()
    {
        addImg1.setImage(UIImage (named: "Bigimagethumbpost"), for: .normal)
        addImg2.setImage(UIImage (named: "SmallImagethumb"), for: .normal)
        addImg3.setImage(UIImage (named: "SmallImagethumb"), for: .normal)
        addImg4.setImage(UIImage (named: "SmallImagethumb"), for: .normal)
        addImg5.setImage(UIImage (named: "SmallImagethumb"), for: .normal)
        addImg6.setImage(UIImage (named: "SmallImagethumb"), for: .normal)
        addImg7.setImage(UIImage (named: "SmallImagethumb"), for: .normal)
        addImg8.setImage(UIImage (named: "SmallImagethumb"), for: .normal)
        
        addImg1.imageView?.contentMode = .scaleAspectFill
        addImg1.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addImg2.imageView?.contentMode = .scaleAspectFill
        addImg2.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addImg3.imageView?.contentMode = .scaleAspectFill
        addImg3.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addImg4.imageView?.contentMode = .scaleAspectFill
        addImg4.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addImg5.imageView?.contentMode = .scaleAspectFill
        addImg5.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addImg6.imageView?.contentMode = .scaleAspectFill
        addImg6.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addImg7.imageView?.contentMode = .scaleAspectFill
        addImg7.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addImg8.imageView?.contentMode = .scaleAspectFill
        addImg8.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        
        
        deleteImg1.isHidden = true
        deleteImg2.isHidden = true
        deleteImg3.isHidden = true
        deleteImg4.isHidden = true
        deleteImg5.isHidden = true
        deleteImg6.isHidden = true
        deleteImg7.isHidden = true
        deleteImg8.isHidden = true
        
       // deleteImg1.tag = 0
        deleteImg2.tag = 0
        deleteImg3.tag = 1
        deleteImg4.tag = 2
        deleteImg5.tag = 3
        deleteImg6.tag = 4
        deleteImg7.tag = 5
        deleteImg8.tag = 6
        
        
        addImg2.tag = 0
        addImg3.tag = 1
        addImg4.tag = 2
        addImg5.tag = 3
        addImg6.tag = 4
        addImg7.tag = 5
        addImg8.tag = 6
    
    }
    
    
    
    func setBigImageInMiddle(senderImg: UIImage) {
        
        
       // let imageBtn = self.scaleImage(((self.multipleImagesArray.object(at: sender.tag) as AnyObject).value(forKey: "originalImage"))  as! UIImage, toSize: addImg1.frame.size)
                   addImg1.setImage(senderImg, for: .normal)
                   deleteImg1.isHidden = true
        
        
        
        
        
        
    }
    
    
    
    
     //MARK: Geotag Functionality here
    
    
    @IBAction func cancelgeoTagAction(_ sender: Any)
    {
        UIView.animate(withDuration: 0.1, animations: {() -> Void in
            
            self.search_bar.showsCancelButton = false
            self.geoTagTopView.constant = 300
            self.view.layoutIfNeeded()
            UIView.animate(withDuration: 0.4, animations: {() -> Void in
                self.geoTagview.isHidden=true
                
                
            })
            
        })
        
        
        search_bar .resignFirstResponder()
        
        self.tabBarController?.setTabBarVisible(visible: true, animated: true)
    }
    
   
    //Open geotag view
    @IBAction func AddgeoTag(_ sender: Any) {
    
       

        UIView.animate(withDuration: 0.5, animations: {() -> Void in
            self.geoTagview.isHidden=false
            self.view .bringSubview(toFront: self.geoTagview)
            self.geoTagTopView.constant = 0
            self.search_bar.showsCancelButton = false
            self.search_bar.layer.borderWidth = 1.0
            self.search_bar.layer.borderColor = UIColor .lightGray.cgColor
            self.geotagTableView.contentInset = UIEdgeInsetsMake(0, 0, 10, 0)
            self.locationsArr .removeAllObjects()
            self.view.layoutIfNeeded()
           
        })
    
      let currntLocString = Location.locationInstance.locationString
        self.placeAutocomplete(currntLocString as String)
         self.tabBarController?.setTabBarVisible(visible: false, animated: true)
    }
    
   

    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar)
    {
        let SearchString: NSString = search_bar.text! as NSString
        locationsArr .removeAllObjects()
        geotagTableView .reloadData()
        geotagTableView.isUserInteractionEnabled = false
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //customDelegate.didChangeSearchText(searchText)
        
        print("While entering the characters this method gets called")
        self.checkTextField(searchBar: search_bar)
        
        
    }
    
    func checkTextField(searchBar: UISearchBar)
    {
            var SearchString = NSString()
            SearchString = searchBar.text! as NSString
        
            if SearchString.length >= 3
            {
                self.placeAutocomplete(SearchString as String)
            }
    }
    
    
    
    
    //MARK: DataSource and delegate of tableView
    //MARK:-
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
            return locationsArr.count
    }
    
    func tableView(_ tableView: UITableView , heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchLocationsCell") as! SearchLocationsCell
            if locationsArr.count - 1 < indexPath.row
            {
                
            }
            else
            {
                let dic = locationsArr[indexPath.row]
                cell.nameLabel.text = (dic as AnyObject).object(forKey: "name") as? String
                cell.placeLabel.text = (dic as AnyObject).object(forKey: "place") as? String
            }
            return cell
        }
        
    
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
        {
            let dic = locationsArr[indexPath.row]
    
            var locationStr = ""
            if (dic as AnyObject).object(forKey: "place")as? String == "" {
                locationStr = String(format: "%@",((dic as AnyObject).object(forKey: "name") as? String)! )
            }
            else{
                locationStr = String(format: "%@ , %@",((dic as AnyObject).object(forKey: "name") as? String)!,((dic as AnyObject).object(forKey: "place") as? String)! )
                }
    
    
    if locationStr == "" {
    geoTagLabel.text = "Add"
       
    }
    else
    {
    geoTagLabel.text = locationStr
    
    // dispatch_async(dispatch_get_main_queue(), {
    
    let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
    loadingNotification.mode = MBProgressHUDMode.indeterminate
    loadingNotification.label.text = "Please Wait..."
    self.googleReverse(locationStr as NSString)
    }
    
    
    Location.locationInstance.locationManager.stopUpdatingLocation()
    self.view.endEditing(true)
    geoTagview.isHidden = true
        self.tabBarController?.setTabBarVisible(visible: true, animated: true)
    }
    
    
    //PLACES API TO GET THE RESULT
    
    func placeAutocomplete(_ place:String) {
        
        let isConnectedInternet = CommonFunctionsClass.sharedInstance().isConnectedToNetwork()
        
        if isConnectedInternet
        {
            
            locationsArr.removeAllObjects()
            geotagTableView.isUserInteractionEnabled=false
            let offset = 200.0 / 1000.0;
            
            let latMax = Location.locationInstance.locationLatitude + offset;
            let latMin = Location.locationInstance.locationLatitude - offset;
            let lngOffset = offset * cos(Location.locationInstance.locationLatitude * M_PI / 200.0);
            let lngMax = Location.locationInstance.locationLongitude + lngOffset;
            let lngMin = Location.locationInstance.locationLongitude - lngOffset;
            let initialLocation = CLLocationCoordinate2D(latitude: latMax, longitude: lngMax)
            let otherLocation = CLLocationCoordinate2D(latitude: latMin, longitude: lngMin)
            let bounds = GMSCoordinateBounds(coordinate: initialLocation, coordinate: otherLocation)
            
            let filter = GMSAutocompleteFilter()
            filter.type = .noFilter
            
           
            
                
            //placesClient!.autocompleteQuery(place, bounds: bounds, filter: filter, callback: { (results, error: NSError?) -> Void in
              //  guard error == nil else {
                //    print("Autocomplete error \(error)")
                  //  return
                //}
                
            placesClient?.autocompleteQuery(place, bounds: bounds, filter: filter, callback: {(results, error) -> Void in
                if let error = error {
                    print("Autocomplete error \(error)")
                    return
                }
               // if let results = results {
                   
                    
                for result in results! {
                    
                    let dic = [
                        "name":result.attributedPrimaryText.string ,
                        "place":result.attributedSecondaryText!.string,
                        "tpye":result.types[0] as? String ?? ""
                    ]
                    
                    
                    self.locationsArr.add(dic)
                }
                self.geotagTableView.isUserInteractionEnabled=true
                if self.locationsArr.count>0{
                    self.geotagTableView.isHidden=false
                    self.geotagTableView.isUserInteractionEnabled=true
                }
                
                self.geotagTableView.reloadData()
            })
            
        }
        else
        {
            search_bar.resignFirstResponder()
           CommonFunctionsClass.sharedInstance().showAlert(title: "No Internet Connection", text: "You are currently offline.", imageName: "alertInternet")
            
        }
        self.view.layoutIfNeeded()
    }

    
    
    
    
    func googleReverse(_ name:NSString) -> Void
        
    {
        
        //capital letter first
        var str2 = String()
        str2=name as String
        var str = NSString()
        str=str2 as NSString
        
        
        print(str)
        
        if str.length<1 // check if empty textfield
        {
            
        }
            
            
            //finaly add location with G.Reverse api
        else
        {
            //str2.replaceRange(str2.startIndex...str2.startIndex, with: String(str2[str2.startIndex]).capitalizedString)
            str2 = str2.capitalized
            var str = NSString()
            print(str2)
            str = str2 .trimmingCharacters(in: CharacterSet.whitespaces) as NSString
            
            
            
            
            
            ///get the lat long if not avaliable
            let address = str2 as String
            let geocoder = CLGeocoder()
            geocoder
            
            geocoder.geocodeAddressString(address, completionHandler: {(placemarks, error) -> Void in
                if((error) != nil)
                {
                    print("Error", error)
                    self.locationType = "other"
                    
                    MBProgressHUD.hide(for: self.view, animated: true)
                    
                    
                }
                else{
                    if let placemark = placemarks?.first
                    {
                        
                        print(placemark)
                        
                        let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
                        print(coordinates)
                        let latitude = String(format:"%f", coordinates.latitude)
                        let longitude = String(format:"%f", coordinates.longitude)
                        //print(placemark.name)e
                        
                        // print(placemark.addressDictionary)
                        
                        
                        if placemark.addressDictionary==nil
                        {
                            
                        }
                            
                        else
                        {
                            
                            
                            
                            print("Name From PlaceApi-- \(str2)")
                            
                            
                            let subLoc = placemark.addressDictionary!["SubLocality"] as? String ?? ""
                            print("SubLocality-- \(subLoc)")
                            
                            
                            
                            
                            let state = placemark.addressDictionary!["State"] as? String ?? ""
                            print("State--\(state)")
                            
                            
                            
                            let city = placemark.addressDictionary!["City"] as? String ?? ""
                            print("City---\(city)")
                            
                            
                            
                            
                            
                            let country = placemark.addressDictionary!["Country"] as? String ?? ""
                            print("Country-- \(country)")
                            
                            print("Lat--- \(latitude)")
                            print("Long----\(longitude)")
                            
                            
                            self.locationString = self.changeSpecialCharacter(str2) as NSString//str2
                            self.locationLatitude = latitude as NSString
                            self.locationLongitude = longitude as NSString
                            self.locationCountry = self.changeSpecialCharacter(country) as NSString//country
                            self.locationcity=self.changeSpecialCharacter(city) as NSString//city
                            self.locationState = self.changeSpecialCharacter(state) as NSString //state
                            
                            
                            
                            var type = NSString()//used to find the entered string is a City, State, or country
                            type = ""
                            
                            if(str.caseInsensitiveCompare(city) == ComparisonResult.orderedSame)
                            {
                                print("is city")
                                self.locationString=self.changeSpecialCharacter(city) as NSString
                                type = "city"
                            }
                                
                            else if(str.caseInsensitiveCompare(state) == ComparisonResult.orderedSame)
                            {
                                print("is state")
                                self.locationcity=self.changeSpecialCharacter(state) as NSString
                                type = "state"
                            }
                            else if(str.caseInsensitiveCompare(country) == ComparisonResult.orderedSame)
                            {
                                print("is country")
                                self.locationCountry = self.changeSpecialCharacter(country) as NSString
                                type = "country"
                            }
                            
                            
                            self.locationType = type
                            
                            
                            
                            
                            
                        }
                        
                        
                    }
                    
                    MBProgressHUD.hide(for: self.view, animated: true)
                }
                
                
                
            })
            
            
        }
        
        
    }
    
    
    
    func changeSpecialCharacter(_ textAsString: String) -> String {
        
        
        
        let txtToChange = textAsString
        let safeURL = txtToChange.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        
        print("Final Url-----> " + (safeURL as String))
        
        return safeURL
        
        
    }
    
    
    
    
    
    
    
    //MARK:
    //MARK: Choose Interest Screen
    
    @IBAction func addInterestAction(_ sender: Any) {
    
        let nxtObj = self.storyboard?.instantiateViewController(withIdentifier: "ChooseInterestVC") as! ChooseInterestVC
        
        nxtObj.comingFrom = "Post Screen"
        self.navigationController! .pushViewController(nxtObj, animated: true)
    
    }
    
    
    //MARK: Description view
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Add" {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Add"
            textView.textColor = UIColor.lightGray
        }
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        // Combine the textView text and the replacement text to
        // create the updated text string
        let currentText:NSString = textView.text as NSString
        let updatedText = currentText.replacingCharacters(in: range, with:text)
        
      
        if updatedText.isEmpty {
            
            textView.text = "Add"
            textView.textColor = UIColor.lightGray
            
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            
            return false
        }
            
            
        else if textView.textColor == UIColor.lightGray && !text.isEmpty {
            textView.text = nil
            textView.textColor = UIColor.black
        }
        
        return true
    }
    
    
    
    
    
    
    //MARK: privacy Outlets
    
    @IBAction func PublicAction(_ sender: Any) {
        
        accessPhoto = "public"
        publicBtnOutlet.setImage(UIImage (named: "Seclected"), for: .normal)
        privateBtnOutlet.setImage(UIImage (named: "Unselect"), for: .normal)
        
    
    }
    
    @IBAction func privateAction(_ sender: Any) {
    
        accessPhoto = "private"
        publicBtnOutlet.setImage(UIImage (named: "Unselect"), for: .normal)
        privateBtnOutlet.setImage(UIImage (named: "Seclected"), for: .normal)
        
    }
    
    
    
    
    
    
    
    
    
    //MARK:
    //MARK: Manage Uploading 
    
    func Start_Upload_Here(_ notification: Notification) {
        
        self.uploadStart()
        
    }
    
    
    
    func uploadStart() {
        
        if((imageData as NSData).bytes != nil && interestLabel.text != "Add" && geoTagLabel.text != "Add")
        {
            
            
            
            
            let isConnectedInternet = CommonFunctionsClass.sharedInstance().isConnectedToNetwork()
            
            if isConnectedInternet
            {
                
                
                //Indicator
                loadingNotification2 = MBProgressHUD.showAdded(to: self.view, animated: true)
                
                
                
                loadingNotification2.mode = MBProgressHUDMode.indeterminate
                loadingNotification2.label.text = "Uploading...\n(\(String(multipleImagesArray.count))/\(String(multipleImagesArray.count)))"
                loadingNotification2.label.numberOfLines=2
                
                boolCount = self.multipleImagesArray.count
                
                
                DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async(execute: {
                    self.startUploadingImage()
                    
                })
            }
            else{
                CommonFunctionsClass.sharedInstance().showAlert(title: "No Internet Connection", text: "You are currently offline.", imageName: "alertInternet")
            }
            
            
            
        }
        else
        {
            if geoTagLabel.text == "Add" {
                
                CommonFunctionsClass.sharedInstance().showAlert(title: "Oops!", text: "Please enter geo tag.", imageName: "alertGeoTag")
                
            }
            else if interestLabel.text == "Add"{
                CommonFunctionsClass.sharedInstance().showAlert(title: "Oops!", text: "Please select categories.", imageName: "alertFill")
            }
                
            else
            {
                CommonFunctionsClass.sharedInstance().showAlert(title: "Oops!", text: "Please fill all the required fields for post.", imageName: "alertFill")
            }
            
            
            
        }
        
        
    }
    
    
    //MARK:- ///////////-------- NEW Images   S3 ----
    
    func startUploadingImage()
    {
        //let myGroup = dispatch_group_create()
        
        // for l in 0..<multipleImagesArray.count {
        
        if  multipleImagesArray.count>0
        {
            
            
        //dispatch_group_enter(myGroup)
            
            
            print("Different format \(Date())")
            
            let formatter = DateFormatter()
            formatter.dateFormat = "ddMMyyHHmmss"
            let stringDate: String = formatter.string(from: Date())
            print(stringDate)
            
            
            
            let imgSi = (multipleImagesArray.object(at: (multipleImagesArray.count - 1))as AnyObject).value(forKey: "originalImage") as! UIImage
            
         
            let uId = Udefaults .string(forKey: "userLoginId")
            
            print(imgSi.size.height)
            
            
            
            let localFileName:String? = "\(uId!)large\(Int(imgSi.size.width))x\(Int(imgSi.size.height))p\(stringDate).jpg"//st
            
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
            
            let remoteName = localFileName!
            let uploadRequest = AWSS3TransferManagerUploadRequest()
            uploadRequest?.body = self.generateImageUrl(remoteName, index: multipleImagesArray.count-1)
            uploadRequest?.acl=AWSS3ObjectCannedACL.publicRead
            uploadRequest?.key = remoteName
            uploadRequest?.bucket = S3BucketName
            uploadRequest?.contentType = "image/jpeg"
            
            
            let transferManager = AWSS3TransferManager.default()
            
            
            
            let s3URL = URL(string: "\(amazoneUrl)\(S3BucketName)/\(uploadRequest!.key!)")!
            print("Uploaded to:\n\(s3URL)")
            //            self.originalArray.addObject(String(s3URL))
            
            
            // Perform file upload
           // transferManager.upload(uploadRequest!).continue { (task) -> AnyObject! in
                
              transferManager.upload(uploadRequest!).continueWith { (task) -> AnyObject! in
                
                
                
                
                if let exception = task.error {
                    print("Upload failed with exception (\(exception))")
                    
                    
                    
                }
                
                if task.result != nil {
                    
                    print("Uploaded to:\n\(s3URL)")
                    // print(uploadRequest.key)
                    
                    self.originalArray.add(String(describing: s3URL))
                    self.remoteImageWithUrl((uploadRequest!.key!))
                    
                    
                    print(self.multipleImagesArray.count-1)
                    
                    
                    DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async(execute: {
                        
                        self.sendThumbnails(self.multipleImagesArray.count-1)
                        
                    })
                    //self.boolCount=self.boolCount+1
                    // print(self.boolCount)
                    
                    
                    
                    
                    
                    
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
                            DispatchQueue.main.async {
                                self.manageRetryOriginal()
                                
                            }
                        }
                        
                        
                        
                    }
                        
                    else{
                        
                        DispatchQueue.main.async {
                            self.manageRetryOriginal()
                            
                        }
                    }
                    
                    
                }
                
                
                
                
                //   dispatch_group_leave(myGroup)
                
                return nil
                
                
                
                
                
                
                
            }//
            
            
            
            
            
            
            
        }
        
        
        
        // dispatch_group_notify(myGroup, dispatch_get_main_queue(), {
        // print("Finished all Original requests.")
        
        
        //             self.sendThumbnails()
        // })
        
        
        
    }
    
    
    
    
    
    
    
    
    func sendThumbnails(_ indexAt: Int) {
        
        
        let formatter = DateFormatter()
        formatter.dateFormat = "ddMMyyHHmmss"
        let stringDate: String = formatter.string(from: Date())
        print(stringDate)
        
        
        //let myGroup2 = dispatch_group_create()
        
        //for l in 0..<multipleImagesArray.count {
        
        
        
        //  dispatch_group_enter(myGroup2)
        
        let defaults = UserDefaults.standard
        let uId = defaults .string(forKey: "userLoginId")
        
        let imgSi = (multipleImagesArray.object(at: (multipleImagesArray.count - 1))as AnyObject).value(forKey: "thumbnail") as! UIImage
        
        let localFileName:String? = "\(uId!)thumb\(Int(imgSi.size.width))x\(Int(imgSi.size.height))p\(stringDate).jpg"//st
        print(localFileName)
        
        
        // Configure AWS Cognito Credentials
        //let myIdentityPoolId = "us-west-2:47968651-2cda-46d4-b851-aea8cbcd663f"
        
        let credentialsProvider:AWSCognitoCredentialsProvider = AWSCognitoCredentialsProvider(regionType:AWSRegionType.USWest2, identityPoolId: myIdentityPoolId)
        
        let configuration = AWSServiceConfiguration(region:AWSRegionType.USWest2, credentialsProvider:credentialsProvider)
        
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        
        // Set up AWS Transfer Manager Request
        
        //let S3BucketName = "testpyt" //testbucket
        
        print("Locatl file name= \(localFileName)")
        
        let remoteName = localFileName!
        let uploadRequest = AWSS3TransferManagerUploadRequest()
        uploadRequest?.body = self.generateThumbnailImageUrl(remoteName, index: indexAt)
        uploadRequest?.acl=AWSS3ObjectCannedACL.publicRead
        uploadRequest?.key = remoteName
        uploadRequest?.bucket = S3BucketName
        uploadRequest?.contentType = "image/jpeg"
        
        
        let transferManager = AWSS3TransferManager.default()
        
        // Perform file upload
        
        let s3URL = URL(string: "\(amazoneUrl)\(S3BucketName)/\(uploadRequest!.key!)")!
        print("Uploaded to:\n\(s3URL)")
        
        // self.thumbnailArray .addObject(String(s3URL))
        
     
        transferManager.upload(uploadRequest!).continueWith { (task) -> AnyObject! in
            
        
        
       // transferManager.upload(uploadRequest!).continue { (task) -> AnyObject! in
            
            
            
            
            
            
            if let exception = task.error {
                print("Upload failed with exception (\(exception))")
            }
            
            if task.result != nil {
                
                
                 print("Uploaded to:\n\(s3URL)")
                self.thumbnailArray .add(String(describing: s3URL))
                
                // dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), {
                
                
                
                
                self.sendtoDataBase()
                
                
                
                
                // })
                
                
                
                
            }
            else {
                
                
                
                
                print("Unexpected empty result.")
                
                if let error = task.error {
                    print("Upload failed with error: (\(error.localizedDescription))")
                    if error.localizedDescription == "The Internet connection appears to be offline."
                    {
                        DispatchQueue.main.async {
                            CommonFunctionsClass.sharedInstance().showAlert(title: "No Internet Connection", text: "You are currently offline.", imageName: "alertInternet")
                            MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                        }
                    }
                    else if(error.localizedDescription == "An SSL error has occurred and a secure connection to the server cannot be made.")
                    {
                        DispatchQueue.main.async {
                            self.manageRetryThumbnail()
                            
                        }
                    }
                    
                }
                    
                else{
                    
                    DispatchQueue.main.async {
                        self.manageRetryThumbnail()
                        
                    }
                }
                
                
                
            }
            
            
            
            
            //dispatch_group_leave(myGroup2)
            
            return nil
            
            
            
            
        }
        
        
        
        
        
        
        
        //  }
        
        
        //dispatch_group_notify(myGroup2, dispatch_get_main_queue(), {
        // print("Finished all Thumbnail requests.")
        //self.boolCount=self.boolCount+1
        //print(self.boolCount)
        //self.sendtoDataBase()
        
        //})
        
        
        
    }
    
    
    
    
    func generateImageUrl(_ fileName: String, index: Int) -> URL
    {
        
        
        let tempImageV = (multipleImagesArray.object(at: index) as AnyObject).value(forKey: "originalImage") as! UIImage
        
        let fileURL = URL(fileURLWithPath: NSTemporaryDirectory() + "PytOriginal-\(fileName)")
        let data = UIImageJPEGRepresentation(tempImageV, 0.2)
        try? data!.write(to: fileURL, options: [.atomic])
        
        return fileURL
    }
    
    func generateThumbnailImageUrl(_ fileName: String, index: Int) -> URL
    {
        
        
        let tempImageV = (multipleImagesArray.object(at: index) as AnyObject).value(forKey: "thumbnail") as! UIImage
        
        let fileURL = URL(fileURLWithPath: NSTemporaryDirectory() + "\(fileName)")
        let data = UIImageJPEGRepresentation(tempImageV, 0.2)
        try? data!.write(to: fileURL, options: [.atomic])
        
        return fileURL
    }
    
    
    
    
    
    func remoteImageWithUrl(_ fileName: String)
    {
        let fileURL = URL(fileURLWithPath: NSTemporaryDirectory() + fileName)
        do {
            try FileManager.default.removeItem(at: fileURL)
        } catch
        {
            print(error)
        }
    }
    
    
    
    
    
    
    
    func manageRetryOriginal()
    {
        
        SweetAlert().showAlert("PYT", subTitle: "Sorry, there is some issue to upload image", style: AlertStyle.warning, buttonTitle:"Cancel", buttonColor: UIColor.red , otherButtonTitle:  "Retry", otherButtonColor: UIColor.green) { (isOtherButton) -> Void in
            if isOtherButton == true {
                
                MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                
            }
            else
            {
                
                //Retry function
                DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async(execute: {
                    self.startUploadingImage()
                    
                })
                
            }
        }
        
        
        
    }
    
    
    func manageRetryThumbnail() {
        
        SweetAlert().showAlert("PYT", subTitle: "Sorry, there is some issue to upload image", style: AlertStyle.warning, buttonTitle:"Cancel", buttonColor: UIColor.red , otherButtonTitle:  "Retry", otherButtonColor: UIColor.green) { (isOtherButton) -> Void in
            if isOtherButton == true {
                
                MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
            }
            else {
                
                //Retry function
                DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async(execute: {
                    self.sendThumbnails(self.multipleImagesArray.count-1)
                    
                })
                
            }
        }
        
        
    }
    
    
    
    
    
    
    
    
    func sendtoDataBase()
    {
        
        
        
        let defaults = UserDefaults.standard
        let uId = defaults .string(forKey: "userLoginId")
        
        
        if thumbnailArray.count==originalArray.count {
            
            // if self.boolCount==2{
            
            
            print("Upload to database")
            
            
            
            var location = ""
            var place = ""
            var state = ""
            var city = ""
            var country = ""
            
            
            let anArr = geoTagLabel.text?.components(separatedBy: ",")
            if anArr?.count ==  6{
                place = anArr![0]
                location = anArr![0]
                city = anArr![3]
                state = anArr![4]
                country = anArr![5]
                
            }
            else if anArr?.count ==  5{
                place = anArr![0]
                location = anArr![0]
                
                city = anArr![2]
                state = anArr![3]
                country = anArr![4]
            }
            else if anArr?.count ==  4{
                place = anArr![0]
                location = place
                city = anArr![1]
                state = anArr![2]
                country = anArr![3]
            }
            else if anArr?.count ==  3{
                place = anArr![0]
                location = place
                city = anArr![1]
                country = anArr![2]
            }
            else if anArr?.count ==  2{
                place = anArr![0]
                location = place
                country = anArr![1]
            }
            else if anArr?.count ==  1{
                country = anArr![0]
            }
            
            
            var descStr = ""
            if descriptionTxtV.text  == "Add" {
                descStr = ""
            }else{
                descStr = descriptionTxtV.text
            }
            
            
            var dic = NSDictionary()
            let add = geoTagLabel.text! as String
            if self.locationType=="other" {
                
                
                let cordArr : NSArray = [0,0]
                
                dic = [
                    "description": descStr,
                    "category": catSelectedId,
                    "placeTag":self.changeSpecialCharacter(place),
                    "city":self.changeSpecialCharacter(city),
                    "state":self.changeSpecialCharacter(state),
                    "country":self.changeSpecialCharacter(country),
                    "address":self.changeSpecialCharacter(add),
                    "userId":uId!,
                    "access": accessPhoto,
                    "coord": cordArr,
                    "imageLarge": "\(originalArray.object(at: 0) as? String ?? "")",
                    "imageThumb": "\(thumbnailArray.object(at: 0) as? String ?? "")"
                    
                ]
                
            }
            else
            {
                
                let cordArr : NSArray = [self.locationLongitude,self.locationLatitude]
                
                dic = [
                    "description": descStr,
                    "category": catSelectedId,
                    "city":self.locationcity,
                    "state":self.locationState,
                    "country":self.locationCountry,
                    "latitude":self.locationLatitude,
                    "longitude":self.locationLongitude,
                    "placeTag": self.changeSpecialCharacter(place),
                    "address":self.changeSpecialCharacter(add),
                    "userId":uId!,
                    "access":accessPhoto,
                    "imageLarge": "\(originalArray.object(at: 0) as? String ?? "")",
                    "imageThumb": "\(thumbnailArray.object(at: 0) as? String ?? "")",
                    "coord": cordArr
                ]
                
            }
            
            
            
            print(dic)
            
            
            
            
            let imagesDictionary = NSMutableDictionary()
            
            
            
            imagesDictionary .setValue(dic, forKey: "userData")
            imagesDictionary .setValue(originalArray, forKey: "originaPhoto")
            imagesDictionary .setValue(thumbnailArray, forKey: "thumbnailPhoto")
            
            ApiServices.sharedInstance.postRequest("",params:imagesDictionary,data: dic, onCompletion: {json, error, status in
                print(json)
                
                
                
                DispatchQueue.main.async {
                   // if(json["status"].int! == 1)
                    let stat = json["status"] as! Int
                    if (stat == 1)
                    {
                        
                        self.thumbnailArray.removeObject(at: 0)
                        self.originalArray.removeObject(at: 0)
                        
                        self.multipleImagesArray.removeLastObject()
                        
                        
                        // MBProgressHUD.hideHUDForView(self.view, animated: true)
                        self.loadingNotification2 = MBProgressHUD.showAdded(to: self.view, animated: true)
                        self.loadingNotification2.mode = MBProgressHUDMode.indeterminate
                        self.loadingNotification2.label.numberOfLines=2
                        self.loadingNotification2.label.text = "Uploading...\n(\(String(self.multipleImagesArray.count))/\(String(self.boolCount)))"
                        
                        
                        
                        print(self.multipleImagesArray.count)
                        
                        
                        if self.multipleImagesArray.count < 1{
                            
                            
                            MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                            
                            
               
//                            
//                            SweetAlert().showAlert("PYT", subTitle: json["msg"].string! , style: AlertStyle.success, buttonTitle:"Okay") { (isOtherButton) -> Void in
//                                if isOtherButton == true {
//                                    
//                                    Location.locationInstance.locationManager.stopUpdatingLocation()
//                                    
//                                    self.tabBarController?.selectedIndex = 0
//                                    
//                                }
//                            }
                            
                            
                          
                            
                            
                            
                            
                            
                            
                        }
                        else
                        {
                            self.startUploadingImage()
                            
                        }
                        
                        
                        
                        
                        
                        
                        
                        
                    }
                    else
                    {
                        
                        CommonFunctionsClass.sharedInstance().showAlert(title: "Server Alert", text: "Something doesn't seem right, Please try again!", imageName: "alertServer")
                        
                        
                        MBProgressHUD.hide(for: self.view, animated: true)
                        
                    }
                    
                    
                    
                    
                }
                
            })
            
            
            
            
            
            
        }
        else{
            print("not upload yet")
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

class SearchLocationsCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!

    @IBOutlet weak var placeLabel: UILabel!


}





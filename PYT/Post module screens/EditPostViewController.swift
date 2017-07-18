//
//  EditPostViewController.swift
//  PYT
//
//  Created by osx on 07/07/17.
//  Copyright © 2017 osx. All rights reserved.
//

import UIKit
import MBProgressHUD
import GooglePlaces
import  AWSS3

class EditPostViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {

    //Amasone server
    let S3UploadKeyName: String = "iqtBkg8alWc0rdsXXoxF6aMc9VJPWROfDDOj3TOd"
    let amazoneUrl = "https://s3-us-west-2.amazonaws.com/"
    let myIdentityPoolId = "us-west-2:47968651-2cda-46d4-b851-aea8cbcd663f"//live
    let S3BucketName = "pytphotobucket" //"pytphotobucket"//live
    
    var catSelectedId = NSMutableArray()
    var dataDictionary = NSMutableDictionary()
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
    
    //Top button to show image
    @IBOutlet weak var buttonImage: UIButton! // button used for future to change image from edit screen
    
    //Interest Outlets
    @IBOutlet weak var interestLabel: UILabel!
    
    //Description View Outlet
    @IBOutlet weak var descriptionTxtV: UITextView!
    
    
    //Privacy view Outlets
    @IBOutlet weak var publicBtnOutlet: UIButton!
    @IBOutlet weak var privateBtnOutlet: UIButton!
    var accessPhoto = String()
    
    //bools to update
    var updatecategory = Bool()
    var updateTag = Bool()
    var updatePrivacy = Bool()
    var updateDescription = Bool()
    
    var screenName = NSString()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        var categoryString = ""
       
        let categoryArrEdit = dataDictionary.value(forKey: "category") as! NSMutableArray
        print(categoryArrEdit)
        var postArray = NSMutableArray()
        for index in 0 ..< categoryArrEdit.count {
         
            
            let objectInt = ((categoryArrEdit.object(at: index)) as AnyObject).value(forKey: "displayName") as? String ?? ""
            let objId = ((categoryArrEdit.object(at: index)) as AnyObject).value(forKey: "_id") as? String ?? ""
            
            postArray.add(["displayName": objectInt, "_id": objId])
                
            }
         Udefaults .setValue(postArray, forKey: "PostInterest")
         placesClient =  GMSPlacesClient.shared()
        
        
        let geoStr = dataDictionary.value(forKey: "geoTag") as? String ?? ""
        geoTagLabel.text = geoStr
        
        
        
        let imgUrlThumb = dataDictionary.value(forKey: "thumbnail") as? String ?? ""
        let imgUrlLarge = dataDictionary.value(forKey: "large") as? String ?? ""
        //image
        
        print("Large edit url\(imgUrlLarge) ---  thumb\(imgUrlThumb)")
        
        
        let thumUrl = URL(string:  imgUrlThumb)
        let largeUrl = URL(string:  imgUrlLarge)
        
        
        self.buttonImage.sd_setImage(with: thumUrl!, for: .normal, placeholderImage: UIImage (named: ""))
    
        
        self.buttonImage.sd_setImage(with: largeUrl!, for: .normal, placeholderImage: self.buttonImage.imageView?.image)
        
        
        

        // Do any additional setup after loading the view.
    }

    
    override func viewWillAppear(_ animated: Bool)
    {
        
        self.tabBarController?.setTabBarVisible(visible: false, animated: true)
        
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
    
    
    
    
    
    //MARK: Geotag Functionality here
    
    
    @IBAction func cancelgeoTagAction(_ sender: UIButton)
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
        
        //self.tabBarController?.setTabBarVisible(visible: true, animated: true)
    }
    
    
    //Open geotag view
    @IBAction func AddgeoTag(_ sender: UIButton)
    {
        
        UIView.animate(withDuration: 0.5, animations: {() -> Void in
            self.geoTagview.isHidden=false
            self.view .bringSubview(toFront: self.geoTagview)
            self.geoTagTopView.constant = 0
            self.search_bar.showsCancelButton = false
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
        updateTag = true
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
        //self.tabBarController?.setTabBarVisible(visible: true, animated: true)
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
    
    @IBAction func addInterestAction(_ sender: UIButton) {
        
        let nxtObj = self.storyboard?.instantiateViewController(withIdentifier: "ChooseInterestVC") as! ChooseInterestVC
        updatecategory = true
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
        updateDescription = true
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
    
    @IBAction func PublicAction(_ sender: UIButton) {
        updatePrivacy = true
        accessPhoto = "public"
        publicBtnOutlet.setImage(UIImage (named: "Seclected"), for: .normal)
        privateBtnOutlet.setImage(UIImage (named: "Unselect"), for: .normal)
        
        
    }
    
    @IBAction func privateAction(_ sender: UIButton) {
        updatePrivacy = true
        accessPhoto = "private"
        publicBtnOutlet.setImage(UIImage (named: "Unselect"), for: .normal)
        privateBtnOutlet.setImage(UIImage (named: "Seclected"), for: .normal)
        
    }
    
    
    //MARK: Actions
    
    
    
    
    //Will Update the changes for image and also hide the view which opens (geotag view, categories view, descriptionView)
    
    
    @IBAction func postBtnAction(_ sender: AnyObject)
    {
        
        search_bar.resignFirstResponder()
        descriptionTxtV.resignFirstResponder()
        
        
      //  self.tabBarController?.tabBar.isHidden = true
        
       
            let defaults = UserDefaults.standard
            let uId = defaults .string(forKey: "userLoginId")
            
        
            //&& descriptionTV.text  != "Enter description here.."  removed
            if(interestLabel.text != "Add" && geoTagLabel.text != "Add")
            {
                
                
                
                
                let isConnectedInternet = CommonFunctionsClass.sharedInstance().isConnectedToNetwork()
                
                if isConnectedInternet
                {
                    
                    let mainEditDictionary = NSMutableDictionary()
                    let categoryEditDictionary = NSMutableDictionary()
                    let privacyEditDictionary = NSMutableDictionary()
                    let descriptionEditDictionary = NSMutableDictionary()
                    let geoTagEditDictionary = NSMutableDictionary()
                    
                    
                    
                    
                    //Add category in dictionary
                    if updatecategory == true {
                        //if needs to update
                        categoryEditDictionary.setValue(1, forKey: "status")
                        
                        let tempdic = ["text":catSelectedId]
                        categoryEditDictionary .setValue(tempdic, forKey: "data")
                        
                        
                        
                    }
                    else
                    {
                        //if not needs to update
                        categoryEditDictionary.setValue(0, forKey: "status")
                        
                        let tempdic = ["text":catSelectedId]
                        categoryEditDictionary .setValue(tempdic, forKey: "data")
                        
                    }
                    
                    
                    
                    
                    mainEditDictionary.setValue(categoryEditDictionary, forKey: "category")
                    
                    print(categoryEditDictionary)
                    // print(mainEditDictionary)
                    
                    
                    
                    
                    //add geotag in dictionary
                    
                    if updateTag == true {
                        
                        print("Upload to database")
                        
                        
                        
                        var location = ""
                        var place = ""
                        var state = ""
                        var city = ""
                        var country = ""
                        
                        
                        let anArr = geoTagLabel.text?.components(separatedBy: ",")
                        
                        print(anArr)
                        
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
                        
                        
                        
                        
                        
                        var dic = NSDictionary()
                        let add = geoTagLabel.text! as String
                        let nxtObj = self.storyboard?.instantiateViewController(withIdentifier: "PostScreenViewController") as! PostScreenViewController
                        
                        if self.locationType=="other" {
                            
                            
                            let cordArr : NSArray = [0,0]
                            
                            dic = [
                                "placeTag":nxtObj.changeSpecialCharacter(place),
                                "city":nxtObj.changeSpecialCharacter(city),
                                "state":nxtObj.changeSpecialCharacter(state),
                                "country":nxtObj.changeSpecialCharacter(country),
                                "address":nxtObj.changeSpecialCharacter(add),
                                "coord": cordArr,
                                "latitude": 0, "longitude": 0
                                
                                
                            ]
                            
                        }
                        else
                        {
                            
                            let cordArr : NSArray = [self.locationLongitude,self.locationLatitude]
                            
                            dic = [
                                
                                "city":self.locationcity,
                                "state":self.locationState,
                                "country":self.locationCountry,
                                "latitude":self.locationLatitude,
                                "longitude":self.locationLongitude,
                                "placeTag": nxtObj.changeSpecialCharacter(place),
                                "address":nxtObj.changeSpecialCharacter(add),
                                "coord": cordArr
                            ]
                            
                        }
                        
                        
                        
                        // print(dic)
                        
                        
                        
                        geoTagEditDictionary.setValue(1, forKey: "status")
                        
                        let tempdic = ["text":dic]
                        geoTagEditDictionary .setValue(tempdic, forKey: "data")
                        
                        
                        
                        
                        
                    }
                        //No need to update the geotag
                    else
                    {
                        geoTagEditDictionary.setValue(0, forKey: "status")
                        
                        let tempdic = ["text":"No Update"]
                        geoTagEditDictionary .setValue(tempdic, forKey: "data")
                    }
                    
                    
                    
                    
                    mainEditDictionary.setValue(geoTagEditDictionary, forKey: "geoTag")
                    
                    // print(geoTagEditDictionary)
                    //print(mainEditDictionary)
                    
                    
                    
                    
                    
                    //Update the Privacy
                    if updatePrivacy == true {
                        privacyEditDictionary.setValue(1, forKey: "status")
                        
                        let tempdic = ["text":accessPhoto]
                        privacyEditDictionary .setValue(tempdic, forKey: "data")
                    }
                        
                    else
                    {
                        //no need to update the privacy
                        privacyEditDictionary.setValue(0, forKey: "status")
                        
                        let tempdic = ["text":accessPhoto]
                        privacyEditDictionary .setValue(tempdic, forKey: "data")
                        
                    }
                    
                    
                    mainEditDictionary.setValue(privacyEditDictionary, forKey: "privacy")
                    
                    print(privacyEditDictionary)
                    //print(mainEditDictionary)
                    
                    
                    
                    
                    
                    //update the description
                    
                    
                    var descStr = ""
                    if descriptionTxtV.text  == "Add" {
                        descStr = ""
                    }else{
                        descStr = descriptionTxtV.text
                    }
                    
                    if updateDescription == true {
                        
                        descriptionEditDictionary.setValue(1, forKey: "status")
                        
                        let tempdic = ["text":descStr]
                        descriptionEditDictionary .setValue(tempdic, forKey: "data")
                    }
                    else{
                        //no need to update
                        descriptionEditDictionary.setValue(0, forKey: "status")
                        
                        let tempdic = ["text":descStr]
                        descriptionEditDictionary .setValue(tempdic, forKey: "data")
                    }
                    
                    
                    
                    mainEditDictionary.setValue(descriptionEditDictionary, forKey: "description")
                    mainEditDictionary.setValue(uId!, forKey: "userId")
                    
                    
                    let imageId = dataDictionary.value(forKey: "imgId") as? String ?? ""
                    
                    mainEditDictionary.setValue(imageId, forKey: "imageId")
                    
                    
                    // print(descriptionEditDictionary)
                    print(mainEditDictionary)
                    
                    
                    
                    if updateDescription == false && updatePrivacy == false && updateTag == false && updatecategory == false {
                        print("no need to update")
                    }
                    else{
                        print("update the content")
                        self.updateImage(mainEditDictionary)
                    }
                    
                    
                    
                    
                    
                    
                    
                    //dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), {
                    
                    
                    //})
                }
                else{
                    CommonFunctionsClass.sharedInstance().showAlert(title: "No Internet Connection", text: "You are currently offline.", imageName: "alertInternet")
                }
                
                
            }
            else
            {
                 CommonFunctionsClass.sharedInstance().showAlert(title: "Fill required fields", text: "Please fill all the required fields to continue \n Icon with * are mandatory to fill.", imageName: "oopsAlert")
            }
        }
    
    
    
    
    
    @IBAction func deleteImageAction(_ sender: AnyObject) {
        
        
        
        let defaults = UserDefaults.standard
        let uId = defaults .string(forKey: "userLoginId")
        
        
        
        
        
        SweetAlert().showAlert("Confirm Delete?", subTitle: "Once deleted, you will no longer be able to see this image.", style: AlertStyle.customImag(imageFile: "exclamationAlert"), buttonTitle:"Cancel", buttonColor: UIColor.clear , otherButtonTitle:  "Yes I'm Sure", otherButtonColor: UIColor.clear) { (isOtherButton) -> Void in
            if isOtherButton == true
            {
                
               
                print("Cancel Pressed")
                
                
            }
            else {
                //Retry function
                print("delete image tapped")
                
                
                let imageUrl = self.dataDictionary.value(forKey: "large") as? String ?? ""
                let imageId = self.dataDictionary.value(forKey: "imgId") as? String ?? ""
                let parameterString = "userId=\(uId!)&photoId=\(imageId)&imageUrl=\(imageUrl)"
                print(parameterString)
                
                MBProgressHUD.showAdded(to: self.view, animated: true)
                
                NotificationCenter.default.post(name: Notification.Name(rawValue: "loadDeleteinPost"), object: nil)
                
                
                self.postRequestDeleteImagePyt(parameterString as NSString, viewController: self)
                
            }
        }
        
        
        
        
        
        
    }
    
    //MARK: Back Button Action
      @IBAction func backBtnAction(_ sender: AnyObject)
      {
        if(self.screenName == "Interest"){
        
        }
        
        
        self.navigationController?.popViewController(animated: true)
      }
    
    
    
    
    //MARK:
    //MARK: Update Image data
    func updateImage(_ parameterdictionary: NSMutableDictionary) {
        
        let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = "Updating..."
        
        
        print(parameterdictionary)
        
        
        
        
        let isConnectedInternet = CommonFunctionsClass.sharedInstance().isConnectedToNetwork()
        
        if isConnectedInternet
        {
            // CommonFunctionsClass.sharedInstance().startIndicator(viewController.view)
            
            var urlString = NSString(string:"\(appUrl)update_image")
            print("WS URL----->>" + (urlString as String))
            
            urlString = urlString .replacingOccurrences(of: " ", with: "%20") as NSString
            
            let url:URL = URL(string: urlString as String)!
            let session = URLSession.shared
            
            
            //session.configuration.timeoutIntervalForRequest=20
            // session.configuration.timeoutIntervalForResource=30
            
            
            
            let request = NSMutableURLRequest(url: url)
            request.httpMethod = "POST"
            
            request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
            
            do {
                let jsonData = try!  JSONSerialization.data(withJSONObject: parameterdictionary, options: [])
                request.httpBody = jsonData
                let result = NSString(data: jsonData, encoding:String.Encoding.ascii.rawValue)!
                print("Body: \(result)")
                
                // here "jsonData" is the dictionary encoded in JSON data
            } catch let error as NSError {
                print(error)
            }
            
            
            
            // request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(prmt, options: [])
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            
            
            
            
            
            let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
                
                OperationQueue.main.addOperation
                    {
                        
                        MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                        
                        if data == nil
                        {
                          //  SweetAlert().showAlert("PYT", subTitle: "Server is not responding!", style: AlertStyle.error)
                            
                        }
                        else
                        {
                            
                            
                            do {
                                
                                let result = NSString(data: data!, encoding:String.Encoding.ascii.rawValue)!
                                print("Body: \(result)")
                                
                                
                                
                                
                                
                                let anyObj: Any = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                                
                                jsonResult = NSDictionary()
                                jsonResult = anyObj as! NSDictionary
                                
                                let status = jsonResult.value(forKey: "status") as! NSNumber
                                
                                if status == 1{
                                    MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                                    if(self.screenName == "Feed"){
                                        NotificationCenter.default.post(name: Notification.Name(rawValue: "refreshFromEdit"), object: nil)
                                        
                                        
                                    }
                                    else if (self.screenName == "Detail/Feed") {
                                        
                                        NotificationCenter.default.post(name: Notification.Name(rawValue: "refreshFromEdit"), object: nil)
                                        
                                    }
                                        
                                        
                                        
                                        
                                    else
                                    {
                                        Udefaults.set(true, forKey: "refreshInterest")
                                        Udefaults.synchronize()
                                        
                                        NotificationCenter.default.post(name: Notification.Name(rawValue: "refreshFromEdit"), object: nil)
                                        
                                       // NotificationCenter.default.post(name: Notification.Name(rawValue: "refreshFromEditInterst"), object: nil)
                                    }
                                    
                                    
                                    let msg = jsonResult.value(forKey: "msg") as? String ?? ""
                                    
                                    
                                    
                                    SweetAlert().showAlert("PYT", subTitle: msg, style: AlertStyle.warning, buttonTitle:"Ok") { (isOtherButton) -> Void in
                                        if isOtherButton == true {
                                            
                                            Location.locationInstance.locationManager.stopUpdatingLocation()
                                            
                                            self.backBtnAction(self)
                                            
                                            
                                        }
                                    }
                                    
                                    
                                    
                                }
                                else
                                {
                                    
                                    
                                    CommonFunctionsClass.sharedInstance().showAlert(title: "Server Alert", text: "Something doesn't seem right, Please try again!", imageName: "alertServer")
                                    
                                    MBProgressHUD.hide(for: self.view, animated: true)
                                    
                                    
                                    
                                    
                                }
                                
                                
                                
                                
                                
                                
                                
                                
                                
                                
                                
                            } catch
                            {
                                print("json error: \(error)")
                                
                                
                            }
                            
                            
                            
                            
                            
                            
                        }
                }
            })
            
            task.resume()
        }
        else
        {
            CommonFunctionsClass.sharedInstance().showAlert(title: "No Internet Connection", text: "You are currently offline.", imageName: "alertInternet")
            MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
        }
        
        
        
    }
    
    
    

    
    
    //MARK:
    //MARK: Delete image api
    
    func postRequestDeleteImagePyt(_ parameters: NSString , viewController : UIViewController)
    {
        let isConnectedInternet = CommonFunctionsClass.sharedInstance().isConnectedToNetwork()
        
        if isConnectedInternet
        {
            // CommonFunctionsClass.sharedInstance().startIndicator(viewController.view)
             let deletePytImage = "\(appUrl)delete_image" // latest version
            var urlString = NSString(string:"\(deletePytImage)")
            print("WS URL----->>" + (urlString as String))
            
            urlString = urlString .replacingOccurrences(of: " ", with: "%20") as NSString
            
            let url:URL = URL(string: urlString as String)!
            let session = URLSession.shared
            
            
            //session.configuration.timeoutIntervalForRequest=20
            // session.configuration.timeoutIntervalForResource=30
            
            
            
            let request = NSMutableURLRequest(url: url)
            request.httpMethod = "POST"
            
            request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
            let postString = parameters
            request.httpBody = postString.data(using: String.Encoding.utf8.rawValue)
            
            
         let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
                
                OperationQueue.main.addOperation
                    {
                        
                        MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                        
                        if data == nil
                        {
                            CommonFunctionsClass.sharedInstance().showAlert(title: "Server Alert", text: "Something doesn't seem right, Please try again!", imageName: "alertServer")
                            
                        }
                        else
                        {
                            
                            
                            do {
                                
                                let result = NSString(data: data!, encoding:String.Encoding.ascii.rawValue)!
                                print("Body: \(result)")
                                
                                
                               let anyObj: Any = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                                
                                jsonResult = NSDictionary()
                                jsonResult = anyObj as! NSDictionary
                                
                                let status = jsonResult.value(forKey: "status") as! NSNumber
                                
                                if status == 1{
                                    let text = jsonResult.value(forKey: "msg") as? String ?? ""
                                    
                                    SweetAlert().showAlert("Successfully Deleted", subTitle: "Picture deleted successfully.", style: AlertStyle.customImag(imageFile: "doneAlert"))
                                    
                                    
                                    
                                    
                                    if self.screenName == "Detail/Feed" {
                                        
                                        NotificationCenter.default.post(name: Notification.Name(rawValue: "refreshFromEdit"), object: nil)
                                        
                                    }
                                        
                                    else if(self.screenName == "Feed"){
                                        NotificationCenter.default.post(name: Notification.Name(rawValue: "loadDeleteinHome"), object: nil)
                                    }
                                        
                                    else if(self.screenName == "Interest"){
//                                        NotificationCenter.default.post(name: Notification.Name(rawValue: "loadDeleteInterest"), object: nil)
//                                        NotificationCenter.default.post(name: Notification.Name(rawValue: "loadDeleteinHome"), object: nil)
                                        
                                        Udefaults.set(true, forKey: "refreshInterest")
                                        Udefaults.synchronize()
                                        
                                        NotificationCenter.default.post(name: Notification.Name(rawValue: "refreshFromEdit"), object: nil)
                                        
                                        
                                    }
                                    // else
                                    //{
                                    //post screen
                                    
                                    //
                                    //}
                                    //  load in post screen
                                    NotificationCenter.default.post(name: Notification.Name(rawValue: "loadDeleteinPost"), object: nil)
                                    
                                    
                                    
                                    self.backBtnAction(self)
                                    
                                    
                                }
                                else
                                {
                                    let text = jsonResult.value(forKey: "msg") as? String ?? ""
                                    
                                    CommonFunctionsClass.sharedInstance().showAlert(title: "Server Alert", text: "text", imageName: "alertServer")
                                }
                                
                                
                                
                                
                                
                    
                                
                                
                                
                            } catch
                            {
                                print("json error: \(error)")
                                
                                
                            }
                            
                            
                            
                            
                            
                            
                        }
                }
            })
            
            task.resume()
        }
        else
        {
            CommonFunctionsClass.sharedInstance().showAlert(title: "No Internet Connection", text: "You are currently offline.", imageName: "alertInternet")
            MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
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

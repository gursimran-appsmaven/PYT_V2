//
//  PlanMapVC.swift
//  PYT
//
//  Created by osx on 07/07/17.
//  Copyright © 2017 osx. All rights reserved.
//

import UIKit
import GoogleMaps
import SDWebImage
import MBProgressHUD

class PlanMapVC: UIViewController,GMSMapViewDelegate {

    var countryId = String()
    @IBOutlet var mapView: GMSMapView!
    var locationsArray = NSMutableArray()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
        // Do any additional setup after loading the view.
        self.setPinsInMap()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK: Action Methods
    @IBAction func backBtnACtion(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: MAP Delegates
    
    func setPinsInMap() -> Void {
        
        mapView.isMyLocationEnabled = false
        
        let path = GMSMutablePath()
        
        for i in 0..<locationsArray.count {
            
            
//            print((locationsArray.object(at: i) as AnyObject).value(forKey:"image"))
            var latTemp:Double = 0
            var longTemp: Double = 0
           // print(locationsArray.object(at: i))
            if ((locationsArray.object(at: i) as AnyObject).value(forKey: "place") as AnyObject ).value(forKey: "latitude")  != nil {
                
                if ((locationsArray.object(at: i) as AnyObject).value(forKey: "place") as AnyObject ).value(forKey: "latitude") as? NSNull != NSNull() {
               
                latTemp = Double(((locationsArray.object(at: i) as AnyObject).value(forKey:"place")! as AnyObject).value(forKey:"latitude") as! NSNumber)
                
                longTemp = Double(((locationsArray.object(at: i) as AnyObject).value(forKey:"place")! as AnyObject).value(forKey:"longitude") as! NSNumber)
                }
            }
            
            let imgUrl = ((locationsArray.object(at: i) as AnyObject).value(forKey: "place") as AnyObject ).value(forKey: "imageThumb") as? String ?? ""
            
            
        
            let geoTag = ((locationsArray.object(at: i) as AnyObject).value(forKey:"place")! as AnyObject).value(forKey:"placeTag") as? String ?? ""
            
            
            if latTemp==0 {
                
            }
            else
            {
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2D(latitude: latTemp, longitude: longTemp)
                marker.title = geoTag
//                marker.appearAnimation = kGMSMarkerAnimationNone
                marker.map=mapView
                let customMarkerView = UIView()
                customMarkerView.frame = CGRect(x: 0.0, y: 0.0, width: 65, height: 65)
                customMarkerView.backgroundColor = UIColor .clear
                
                let imgvi = UIImageView()
                imgvi.frame=customMarkerView.frame
                imgvi.image = UIImage (named: "whiteMarker")
                //sd_setImage(with: URL(string: imgUrl), placeholderImage: UIImage (named: "dummyBackground1"))
                customMarkerView .addSubview(imgvi)
                
                let iconImage = UIImageView()
                iconImage.frame=CGRect(x: 5.0, y: 0.0, width: 55, height: 55)
                iconImage.sd_setImage(with: URL(string: imgUrl), placeholderImage: UIImage (named: "dummyBackground1"))
                iconImage.contentMode = .scaleAspectFill
                iconImage.clipsToBounds = true
                customMarkerView .addSubview(iconImage)
                
                
                marker.iconView = customMarkerView
                               ////additional
                let position = CLLocationCoordinate2DMake(latTemp, longTemp)
                path .add(position)
                
            }

        }
        let mapBounds = GMSCoordinateBounds(path: path)
        let cameraUpdate = GMSCameraUpdate.fit(mapBounds, withPadding: 20)
       
        self.mapView.moveCamera(cameraUpdate)
       
        
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
    
    
    ////////////------ MArker info window custom
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        let infoWindow = UIView()
        infoWindow.frame=CGRect(x:0,y:0,width:130,height:40)
        infoWindow.backgroundColor=UIColor .white
        infoWindow.layer.cornerRadius=5
        infoWindow.clipsToBounds=true
        
//        let labelBack = UILabel()
//        labelBack.backgroundColor=UIColor (colorLiteralRed: 32.0/255.0, green: 47.0/255.0, blue: 65.0/255.0, alpha: 1.0)
//        labelBack.frame=CGRect(x:0,y:0,width:30,height:30)
//        infoWindow .addSubview(labelBack)
        
        
        
        let titleLabel = UILabel()
        titleLabel.text=marker.title
        titleLabel.numberOfLines = 2
        titleLabel.textAlignment = .left
        titleLabel.font=UIFont(name: "Roboto-Regular", size: 12)!
        titleLabel.frame=CGRect(x:5 ,y:0,width:130,height:30)
        titleLabel.textColor=UIColor.black
        infoWindow .addSubview(titleLabel)
        
        //infoWindow.label.text = "\(marker.position.latitude) \(marker.position.longitude)"
        return infoWindow
    }

    
    //MARK: API Methods
    
    func getLocations()
    {
        
    }
}

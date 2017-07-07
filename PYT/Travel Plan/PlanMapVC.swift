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
        
        getLocations()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK: Action Methods
    @IBAction func backBtnACtion(_ sender: Any) {
        _=self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: MAP Delegates
    
    func setPinsInMap() -> Void {
        
        mapView.isMyLocationEnabled = false
        
        let path = GMSMutablePath()
        
        for i in 0..<locationsArray.count {
            
            
//            print((locationsArray.object(at: i) as AnyObject).value(forKey:"image"))
            
            let latTemp = Double(((locationsArray.object(at: i) as AnyObject).value(forKey:"image")! as AnyObject).value(forKey:"latitude") as! NSNumber)
            
            //            let latTempCheck = dataArray.objectAtIndex(i).valueForKey("image")!.valueForKey("latitude") != nil
            //
            //            var latTemp = Double()
            //            var longTemp = Double()
            //
            //            latTemp = 0
            //            longTemp = 0
            //
            //            if latTempCheck == true {
            
            // latTemp = Double(dataArray.objectAtIndex(i).valueForKey("image")!.valueForKey("longitude") as! NSNumber)
            
            let longTemp = Double(((locationsArray.object(at: i) as AnyObject).value(forKey:"image")! as AnyObject).value(forKey:"longitude") as! NSNumber)
            
            
            
            //  }
            
            
            //            let longTemp = Double(dataArray.objectAtIndex(i).valueForKey("image")!.valueForKey("longitude") as! NSNumber) //Double(dataArray.objectAtIndex(i).valueForKey("image")!.valueForKey("longitude") )
            let geoTag = ((locationsArray.object(at: i) as AnyObject).value(forKey:"image")! as AnyObject).value(forKey:"placeTag") as? String ?? ""
            
            
            if latTemp==0 {
                
            }
            else
            {
                // let latTemp =  dict["latitude"] as! Double
                //let longTemp =  dict["longitude"] as! Double
                
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2D(latitude: latTemp, longitude: longTemp)
                marker.title = geoTag
//                marker.appearAnimation = kGMSMarkerAnimationNone
                marker.map=mapView
                marker.icon=UIImage (named: "blueMarker")
                //path.addCoordinate(CLLocationCoordinate2DMake(latTemp!, longTemp!))
                
                
                ////additional
                let position = CLLocationCoordinate2DMake(latTemp, longTemp)
                path .add(position)
                
            }

        }
        let mapBounds = GMSCoordinateBounds(path: path)
        let cameraUpdate = GMSCameraUpdate.fit(mapBounds, withPadding: 20)
        // let cameraUpdate = GMSCameraUpdate.fitBounds(mapBounds) //GMSCameraUpdate.fit(mapBounds)
        self.mapView.moveCamera(cameraUpdate)
        
        //        let bounds = GMSCoordinateBounds(path: path)
        //       self.mapView!.animateWithCameraUpdate(GMSCameraUpdate.fitBounds(bounds, withPadding: 50.0))
        
        
    }
    
    
    ////////////------ MArker info window custom
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        let infoWindow = UIView()
        infoWindow.frame=CGRect(x:0,y:0,width:150,height:30)
        infoWindow.backgroundColor=UIColor .white
        infoWindow.layer.cornerRadius=5
        infoWindow.clipsToBounds=true
        
        let labelBack = UILabel()
        labelBack.backgroundColor=UIColor (colorLiteralRed: 32.0/255.0, green: 47.0/255.0, blue: 65.0/255.0, alpha: 1.0)
        labelBack.frame=CGRect(x:0,y:0,width:30,height:30)
        infoWindow .addSubview(labelBack)
        
        let imageIcon = UIImageView()
        imageIcon.backgroundColor=UIColor .clear //UIColor (colorLiteralRed: 32.0/255.0, green: 47.0/255.0, blue: 65.0/255.0, alpha: 0.8)
        imageIcon.frame=CGRect(x:4,y:4,width:22,height:22)
        imageIcon.image=UIImage (named: "whiteMarkerIcon")
        infoWindow .addSubview(imageIcon)
        
        let titleLabel = UILabel()
        titleLabel.text=marker.title
        titleLabel.font=UIFont(name: "Roboto-Regular", size: 12)!
        titleLabel.frame=CGRect(x:imageIcon.frame.origin.x + 31,y:0,width:80,height:30)
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

//
//  Location.swift
//  GOLF
//
//  Created by OSX on 22/06/16.
//  Copyright © 2016 OSX. All rights reserved.
//

import Foundation
import CoreLocation

class Location : NSObject,CLLocationManagerDelegate{
    let locationManager = CLLocationManager()
    var locationLatitude = Double()
    var locationLongitude = Double()
    var locationString = NSString()
    
    static let locationInstance: Location = Location()
    
    fileprivate override init() {
        print("AAA");
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        super.init()
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()

    }
    
    //MARK: Location manager delegates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let location = locations.last
       
        
        locationLatitude = (location?.coordinate.latitude)!
        locationLongitude = (location?.coordinate.longitude)!

        
        
        CLGeocoder().reverseGeocodeLocation(location!, completionHandler: {(placemarks, error) -> Void in
            print(location)
            
            if error != nil {
               
                return
            }
            
            if placemarks!.count > 0 {
                let pm = placemarks![0] 
                print(pm.locality)
                print(pm.addressDictionary)
//                print(pm.country)
//                print(pm.subLocality)
                
                self.locationString = pm.locality! as NSString
                
                
                
            }
                
            else
            {
                print("Problem with the data received from geocoder")
            }
        })
        
        
    }
    
    
    

    
    
    
    
    
    
    func displayLocationInfo(_ placemark: CLPlacemark) {
        //if placemark != nil {
            //stop updating location to save battery life
            locationManager.stopUpdatingLocation()
            
//            (print(placemark.locality ? placemark.locality : "") != nil)
//            print(placemark.postalCode ? placemark.postalCode : "")
//            print(placemark.administrativeArea ? placemark.administrativeArea : "")
//            print(placemark.country ? placemark.country : "")
       // }
        
       print(placemark.locality)
        print(placemark.addressDictionary)
        
        
    }
    
    
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Errors: " + error.localizedDescription)
        
        
        
        
    }
 
//    for call in other classes
//    Location.locationInstance.locationManager.startUpdatingLocation()
//    Location.locationInstance.locationManager.stopUpdatingLocation()

}

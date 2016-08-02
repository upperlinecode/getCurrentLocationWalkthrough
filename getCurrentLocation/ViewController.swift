//
//  ViewController.swift
//  getCurrentLocation
//
//  Created by Angelica Bato on 8/2/16.
//  Copyright © 2016 Angelica Bato. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var myMapView: MKMapView!
    
    var locationManager:CLLocationManager!
    var currentLocation:CLLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        currentLocation = CLLocation()
        
        getLocation()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getLocation() {
        let locationServiceOn = CLLocationManager.locationServicesEnabled()
        
        if locationServiceOn {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.requestWhenInUseAuthorization()
            if (locationManager.respondsToSelector(#selector(CLLocationManager.requestWhenInUseAuthorization))) {
                print("Loc manager can respond to request")
                locationManager.requestWhenInUseAuthorization()
            }
            
            locationManager.startUpdatingLocation()
        } else {
            print("Hey, turn on your Loc Services please!")
        }
        
    }
    
    func centerOnLocation(location: CLLocation, mapview: MKMapView) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 1000, 1000)
        mapview.setRegion(coordinateRegion, animated: true)
        
        let annot = MKPointAnnotation()
        annot.coordinate = location.coordinate
        mapview.addAnnotation(annot)
        
    }
    
    // LOCATION SERVICES METHODS
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last
        print(currentLocation)
        locationManager.stopUpdatingLocation()
        
        centerOnLocation(currentLocation, mapview: myMapView)
        
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {
        case .NotDetermined:
            print("User is still thinking...")
            self.locationManager.requestWhenInUseAuthorization()
            break
        case .Denied:
            print("User hates you")
            break
        case .AuthorizedWhenInUse, .AuthorizedAlways:
            self.locationManager.startUpdatingLocation()
            break
        default:
            break
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Could not access location")
    }


}


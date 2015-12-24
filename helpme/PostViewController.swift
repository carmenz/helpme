//
//  PostViewController.swift
//  helpme
//
//  Created by Carmen Zhuang on 2015-12-23.
//  Copyright (c) 2015 helpm. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class PostViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{
    
    //@IBOutlet weak var longtitutelabel: UILabel!
    //@IBOutlet weak var latitutelabel: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!

    let locationManager = CLLocationManager()
    var currlocation:CLLocation?{
        didSet{
            print(currlocation)
            //self.longtitutelabel.text = String(stringInterpolationSegment: currlocation!.coordinate.longitude)
            //self.latitutelabel.text = String(stringInterpolationSegment: currlocation!.coordinate.latitude)
            self.addAnnotationsOnMap(currlocation!)
        }
    }
    
    @IBAction func loggedin(segue:UIStoryboardSegue){
        print("hahahha")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // user activated automatic authorization info mode
        var status = CLLocationManager.authorizationStatus()
        print(status)
        if status == .NotDetermined || status == .Denied || status == .AuthorizedWhenInUse {
            // present an alert indicating location authorization required
            // and offer to take the user to Settings for the app via
            // UIApplication -openUrl: and UIApplicationOpenSettingsURLString
        }
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
            print("authorizing")
        
        print(status)
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.mapType = MKMapType(rawValue:0)!
        mapView.userTrackingMode = MKUserTrackingMode(rawValue: 2)!

        
        
        // Do ""any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        CLGeocoder().reverseGeocodeLocation(manager.location, completionHandler: {(placemarks, error)->Void in
            if (error != nil)
            {
                println("Error: " + error.localizedDescription)
                println("")
                return
            }
//            print(self.locationManager.location.coordinate.longitude)
//            print(self.locationManager.location.coordinate.latitude)
            self.currlocation=self.locationManager.location
            if placemarks.count > 0
            {
                let pm = placemarks[0] as! CLPlacemark
                self.locationManager.stopUpdatingLocation()
            }
            else
            {
                println("Error with the data.")
            }
        })
    }
    
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!)
    {
        println("Error: " + error.localizedDescription)
    }
    
    
    func addAnnotationsOnMap(locationToPoint:CLLocation){
        var annotation = MKPointAnnotation()
        annotation.coordinate = locationToPoint.coordinate
        var geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(locationToPoint, completionHandler: {(placemarks, errpr) ->Void in
            if let placemarks = placemarks as? [CLPlacemark] where placemarks.count > 0 {
                var placemark = placemarks[0]
                var addressDictionary = placemark.addressDictionary;
                annotation.title = addressDictionary["Name"] as? String
                self.mapView.addAnnotation(annotation)
            }
        })
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

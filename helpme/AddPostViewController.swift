//
//  AddPostViewController.swift
//  helpme
//
//  Created by Carmen Zhuang on 2015-12-28.
//  Copyright (c) 2015 helpm. All rights reserved.
//

import UIKit
import CoreLocation

class AddPostViewController: UIViewController,CLLocationManagerDelegate {
    
    var user:PFUser!
    let locationManager = CLLocationManager()
    var currlatitude:Double?
    var currlongitude:Double?
    
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
        // Do any additional setup after loading the view.
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
            self.currlatitude=self.locationManager.location.coordinate.latitude
            self.currlongitude=self.locationManager.location.coordinate.longitude
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

    
    
    
    
    @IBOutlet weak var descriptiontextfield: UITextField!
    @IBOutlet weak var contactnumbertextfield: UITextField!
    @IBOutlet weak var titletextfield: UITextField!
    
    
    @IBAction func submit(sender: AnyObject) {
        let post = Post(ptle: titletextfield.text, dscp: descriptiontextfield.text, ctcnmb: contactnumbertextfield.text, longitude: currlongitude!, latitude: currlatitude!,user:user!)
        post.saveInBackgroundWithBlock{ succeeded, error in
            if succeeded {
                //3
                self.performSegueWithIdentifier("submitunwind", sender: self)
            } else {
                //4
                if let errorMessage = error?.userInfo?["error"] as? String {
                    print("error uploading")
                }
            }
        }
        
    }

    @IBAction func Cancel(sender: AnyObject) {
        self.performSegueWithIdentifier("submitunwind", sender: self)
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

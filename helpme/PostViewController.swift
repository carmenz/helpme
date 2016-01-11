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

class PostViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, SideBarDelegate,UIPopoverPresentationControllerDelegate,UISearchResultsUpdating{
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var loginbutton: UIButton!
    
//    @IBAction func loginpopover(sender: AnyObject) {
//        var loginviewcontroller:LoginViewController = self.storyboard!.instantiateViewControllerWithIdentifier("loginviewcontroller") as! LoginViewController
//        loginviewcontroller.modalPresentationStyle = .Popover
//        //loginviewcontroller.preferredContentSize = CGSizeMake(50, 100)
//        presentViewController(loginviewcontroller, animated: true, completion: nil)
//    }

    let locationManager = CLLocationManager()
    var currlocation:CLLocation?
    var curruser :PFUser?{
        didSet{
            if(curruser != nil){
                sideBar.sideBarTableViewController.tableData=["Profile", "Add", "Manage","Logout","About Us"]
                self.loginbutton.hidden = true
            }
            else{
                sideBar.sideBarTableViewController.tableData=["About Us"]
                self.loginbutton.hidden = false
            }
            sideBar.sideBarTableViewController.tableView.reloadData()
        }
    }
    
    @IBAction func backtopostview(segue:UIStoryboardSegue){
        if let source = segue.sourceViewController as? LoginViewController{
            curruser = source.curruser
        }
    }
    

    

    @IBOutlet weak var addbutton: UIButton!
    var sideBar:SideBar = SideBar()
    
    @IBOutlet weak var searchbarview: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.searchbarview.backgroundColor = UIColor.clearColor()
        
        sideBar = SideBar(sourceView: self.view, menuItems: ["About Us"])
    
        
        curruser = PFUser.currentUser()
        
        sideBar.delegate = self

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

    override func viewWillAppear(animated: Bool) {
        if(self.curruser != nil){
            self.loginbutton.hidden = true
        }
        else{
            self.loginbutton.hidden = false
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        mapView.removeAnnotations(mapView.annotations.filter { $0 !== self.mapView.userLocation })
        self.loadallannotation()
        
        let resultSearchController = UISearchController(searchResultsController: nil)
        resultSearchController.searchResultsUpdater = self
        resultSearchController.dimsBackgroundDuringPresentation = false
        resultSearchController.searchBar.sizeToFit()
        resultSearchController.searchBar.backgroundImage = UIImage()
        resultSearchController.searchBar.frame = self.searchbarview.bounds
        
        
        
        self.searchbarview.addSubview(resultSearchController.searchBar)
    }
    
    override func viewDidDisappear(animated: Bool) {
        if(sideBar.isSideBarOpen){
            sideBar.showSideBar(false)
        }
    }
    
    func loadallannotation(){
        let query = Post.query()!
        query.findObjectsInBackgroundWithBlock{ objects,error in
            if error == nil{
                if let objects = objects as? [Post]{
                    self.addannotationarraytomap(objects)
                }
            }
            else if let error = error{
                print("error:\(error.localizedDescription)")
            }
        }
    }
    
    func addannotationarraytomap(objects:[Post]){
        for singlepost:Post in objects{
            if(singlepost.status=="notAccepted"){
                addAnnotationsOnMap(CLLocation(latitude: singlepost.currlatitude, longitude: singlepost.currlongitude),posttitle: singlepost.posttitle, postdescription: singlepost.contactnumber)
            }
        }
    }
    

    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        println("viewForanotation")
        if annotation is MKUserLocation {
            return nil
        }
    
    
    let reuseId = "pin"
    var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
    if pinView == nil {
        pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        pinView!.canShowCallout = true
        pinView!.animatesDrop = true
    }
    var button = UIButton.buttonWithType(UIButtonType.DetailDisclosure)as! UIButton
        
    pinView?.rightCalloutAccessoryView = button
    
    return pinView
    
    }
    
    var selectedannotation:MKAnnotation?
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        selectedannotation=view.annotation
        if(self.curruser != nil){performSegueWithIdentifier("showpostdetailsegue", sender: self)}
        else{
            showErrorView("You need to login first")
        }
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
    
    
    func addAnnotationsOnMap(locationToPoint:CLLocation,posttitle:String, postdescription:String){
        var annotation = MKPointAnnotation()
        annotation.coordinate = locationToPoint.coordinate
        var geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(locationToPoint, completionHandler: {(placemarks, errpr) ->Void in
            if let placemarks = placemarks as? [CLPlacemark] where placemarks.count > 0 {
                var placemark = placemarks[0]
                var addressDictionary = placemark.addressDictionary;
                //annotation.title = addressDictionary["Name"] as? String
                annotation.title = posttitle
                annotation.subtitle = postdescription
                self.mapView.addAnnotation(annotation)
            }
        })
    }
    
    
    func sideBarDidSelectButtonAtIndex(index: Int) {
        
        if(index == 3){
            if(self.curruser != nil){
                PFUser.logOut()
                print("here")
                self.curruser = nil
                sideBar.showSideBar(false)
            }
        }
        
        //manage
        if(index == 2){
            if(self.curruser != nil){
                self.storyboard!.instantiateViewControllerWithIdentifier("ManageViewController")
                self.performSegueWithIdentifier("toManagePost", sender: self)
            }
            else{
                let alertController = UIAlertController(title: "You Need to Login First!",
                    message: "", preferredStyle: .Alert)
                
                let OKAction = UIAlertAction(title: "OK", style: .Default) {
                    (action: UIAlertAction!) in
                }
                
                alertController.addAction(OKAction)
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }

        
        //add
        if(index == 1){
            if(self.curruser != nil){
                self.storyboard!.instantiateViewControllerWithIdentifier("AddViewController")
                self.performSegueWithIdentifier("toAddPost", sender: self)
            }
            else{
                let alertController = UIAlertController(title: "You Need to Login First!",
                    message: "", preferredStyle: .Alert)
                
                let OKAction = UIAlertAction(title: "OK", style: .Default) {
                    (action: UIAlertAction!) in
                }
                
                alertController.addAction(OKAction)
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
        
        if(index == 0){
            if(sideBar.sideBarTableViewController.tableView.cellForRowAtIndexPath(sideBar.sideBarTableViewController.tableView.indexPathForSelectedRow()!)!.textLabel!.text! == "About Us"){
                print("this is About us")
            }
            else{
                print("this is Profile")
            }
        }
        
        
    }
    
    
    func sideBarWillClose() {
        
    }
    
    func sideBarWillOpen() {
        
    }
    
    @IBAction func showmenu(sender: AnyObject) {
        self.sideBar.showSideBar(true)
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let destination = segue.destinationViewController as? AddPostViewController{
            destination.user = curruser!
        }
        if(segue.identifier == "loginpopover"){
            let popoverViewController = segue.destinationViewController as! LoginViewController
            popoverViewController.modalPresentationStyle = UIModalPresentationStyle.Popover
            popoverViewController.popoverPresentationController!.delegate = self
            
        }
        
        if(segue.identifier == "showpostdetailsegue"){
            let detailcontroller = segue.destinationViewController as! PostDetailViewController
            detailcontroller.currnumber = selectedannotation?.subtitle
        }
        
//        if(segue.identifier == "toManagePost"){
//            let destinationcontroller = segue.destinationViewController as! ManageViewController
//            destinationcontroller.
//        }
    }
    
    
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    
    @IBAction func logout(sender: AnyObject) {
        if(curruser != nil){
            self.loginbutton.setTitle("Login", forState: .Normal)
            self.curruser = nil
        }
    }


    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.sideBar.showSideBar(false)
    }

    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
    }
}

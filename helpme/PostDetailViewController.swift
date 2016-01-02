//
//  PostDetailViewController.swift
//  helpme
//
//  Created by Carmen Zhuang on 2015-12-29.
//  Copyright (c) 2015 helpm. All rights reserved.
//

import UIKit

class PostDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var currpost:Post?
    
    override func viewWillAppear(animated: Bool) {
        let query=PFQuery(className: "Post")
        query.whereKey("contactnumber", equalTo: currnumber!)
        var posts = query.findObjects() as! [Post]
        var done = false
        for post in posts { // message is of PFObject type
            print(post.posttitle)
            if done == false{
                self.currpost = post
                self.titlelabel.text = post.posttitle
                self.descriptionlabel.text = post.postdescription
                self.phonelabel.text = post.contactnumber
                                            CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: post.currlatitude, longitude: post.currlongitude), completionHandler: {(placemarks, error)->Void in
                                                if (error != nil)
                                                {
                                                    println("Error: " + error.localizedDescription)
                                                    println("")
                                                    return
                                                }
                                        //            print(self.locationManager.location.coordinate.longitude)
                                        //            print(self.locationManager.location.coordinate.latitude)
                                                if placemarks.count > 0
                                                {
                                                    let pm = placemarks[0] as! CLPlacemark
                                                    self.locationlabel.text = pm.thoroughfare
                                                }
                                                else
                                                {
                                                    println("Error with the data.")
                                                }
                                            })
                
            }
            break
        }
    }

    
    // MARK: - Navigation
    @IBOutlet weak var titlelabel: UILabel!
    @IBOutlet weak var locationlabel: UILabel!
    @IBOutlet weak var descriptionlabel: UITextView!
    @IBOutlet weak var phonelabel: UILabel!

    var currnumber:String?

    @IBAction func ContactUser(sender: AnyObject) {
        //dial the number
        var url:NSURL = NSURL(string: "telprompt://\(currnumber!)")!
        UIApplication.sharedApplication().openURL(url)
        
        
        if let post = currpost{
            post.status = "inProgress"
            post.acceptedbyuser = PFUser.currentUser()
            post.saveInBackground()
        }
        
        
    }
    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        // Get the new view controller using segue.destinationViewController.
//        print("here")
//        // Pass the selected object to the new view controller.
//        if let source = segue.sourceViewController as? PostViewController{
//            print("here")
//            if let annotation = source.selectedannotation{
//                self.currlocation = annotation.coordinate
//                print("here")
//            }
//        }
//        
//    }
    

}

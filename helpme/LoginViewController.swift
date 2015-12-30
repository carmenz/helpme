//
//  LoginViewController.swift
//  helpme
//
//  Created by Carmen Zhuang on 2015-12-23.
//  Copyright (c) 2015 helpm. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    
    @IBOutlet weak var usernamefield: UITextField!
    @IBOutlet weak var passwordfield: UITextField!
    
    var curruser:PFUser?
    
    @IBAction func login(sender: AnyObject) {
        PFUser.logInWithUsernameInBackground(usernamefield.text!, password: passwordfield.text!) { user, error in
            if user != nil {
                print("login successfully")
                self.curruser = user
                self.performSegueWithIdentifier("unwindtopostview", sender: self)
            } else if let error = error {
                let alertController = UIAlertController(title: "Invalid Username or Password!",
                    message: "Try Again", preferredStyle: .Alert)
                
                let OKAction = UIAlertAction(title: "OK", style: .Default) {
                    (action: UIAlertAction!) in
                }
                
                alertController.addAction(OKAction)
                self.presentViewController(alertController, animated: true, completion: nil)

            }
        }

        
    }
    
    @IBAction func backtologinview(segue:UIStoryboardSegue){
        if let source = segue.sourceViewController as? SignUpViewController{
            let curruser = source.user
            if(curruser.username==nil || curruser.password==nil){
                return
            }
            PFUser.logInWithUsernameInBackground(curruser.username!, password: curruser.password!){user,error in
                if user != nil {
                    print("login successfully")
                    self.curruser = user
                    self.performSegueWithIdentifier("unwindtopostview", sender: self)
                } else if let error = error {
                    let alertController = UIAlertController(title: "Invalid Username or Password!",
                        message: "Try Again", preferredStyle: .Alert)
                    
                    let OKAction = UIAlertAction(title: "OK", style: .Default) {
                        (action: UIAlertAction!) in
                    }
                    
                    alertController.addAction(OKAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                    
                }
            }
        }
        
    }
    
        override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
            // Get the new view controller using segue.destinationViewController.
            // Pass the selected object to the new view controller.
    
            if(segue.identifier == "signupshowdetail"){
                let showdetailViewController = segue.destinationViewController as! SignUpViewController
                showdetailViewController.modalPresentationStyle = UIModalPresentationStyle.CurrentContext
                showdetailViewController.showDetailViewController(SignUpViewController(), sender: self)
            }
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        self.view.addGestureRecognizer(tap)
        
        // Do any additional setup after loading the view.
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

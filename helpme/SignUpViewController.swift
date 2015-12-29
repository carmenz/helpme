//
//  SignUpViewController.swift
//  helpme
//
//  Created by Carmen Zhuang on 2015-12-23.
//  Copyright (c) 2015 helpm. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var usernamefield: UITextField!
    @IBOutlet weak var passwordfield: UITextField!
    
    let user = PFUser()
    
    @IBAction func signup(sender: AnyObject) {
    
       
        user.username = usernamefield.text
        user.password = passwordfield.text
        if(isvalidaccount(user)){
            user.signUpInBackgroundWithBlock { (succeeded, error) -> Void in
                if succeeded {
                    println("Object Uploaded")
                    self.performSegueWithIdentifier("unwindtologinview", sender: self)
                } else {
                    println("Error: \(error) \(error!.userInfo!)")
                    let alertController = UIAlertController(title: "Account Already Exist!",
                    message: "try another", preferredStyle: .Alert)
                
                    let OKAction = UIAlertAction(title: "OK", style: .Default) {
                        (action: UIAlertAction!) in
                    }
                
                    alertController.addAction(OKAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                
                }
            }
        }
        
    }
    
    func isvalidaccount(user:PFUser)->Bool{
        if(count(user.username!)==0 || count(user.password!)==0){
            showerroralertviewcontroller("both fields must not be empty!")
            return false
        }
        if(count(user.password!)<6){
            showerroralertviewcontroller("Password must have a minimum length of 6 characters!")
            return false
        }
        return true
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
    

    func showerroralertviewcontroller(message:String){
        let alertController = UIAlertController(title: message,
            message: "", preferredStyle: .Alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .Default) {
            (action: UIAlertAction!) in
        }
        
        alertController.addAction(OKAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}

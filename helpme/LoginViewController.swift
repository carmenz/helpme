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
    
    @IBAction func login(sender: AnyObject) {
        PFUser.logInWithUsernameInBackground(usernamefield.text, password: passwordfield.text) { user, error in
            if user != nil {
                print("login successfully")
            } else if let error = error {
                //self.showErrorView(error)
            }
        }

        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

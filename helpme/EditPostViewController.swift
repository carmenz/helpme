//
//  EditPostViewController.swift
//  helpme
//
//  Created by Carmen Zhuang on 2016-01-02.
//  Copyright (c) 2016 helpm. All rights reserved.
//

import UIKit

class EditPostViewController: UIViewController {

    @IBOutlet weak var posttitle: UITextField!
    @IBOutlet weak var postdescription: UITextField!
    @IBOutlet weak var contactnumber: UITextField!
    
    var post:Post?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        posttitle.text = post?.posttitle ?? ""
        postdescription.text = post?.postdescription ?? ""
        contactnumber.text = post?.contactnumber ?? ""
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func UpdatePost(sender: AnyObject) {
        post?.posttitle = posttitle.text
        post?.postdescription = postdescription.text
        post?.contactnumber = contactnumber.text
        post?.saveInBackground()
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

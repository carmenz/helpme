//
//  ManageViewController.swift
//  helpme
//
//  Created by Carmen Zhuang on 2015-12-29.
//  Copyright (c) 2015 helpm. All rights reserved.
//

import UIKit

class ManageViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableview: UITableView!
    var curruser=PFUser.currentUser()
    var Jobposts:[Post]?{
        didSet{
            tableview.reloadData()
        }
    }
    var Listpost:[Post]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let query = PFQuery(className: "Post")
        
        // Do any additional setup after loading the view.
        if let user = curruser {
            
            query.whereKey("acceptedbyuser", equalTo: user)
            Jobposts = query.findObjects() as? [Post] ?? []
        }
    }

    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0) {
            return Jobposts?.count ?? 0
        }
        else if (section == 1){
            return Listpost?.count ?? 0
        }
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let dequeued: AnyObject = tableView.dequeueReusableCellWithIdentifier("eventCell", forIndexPath: indexPath)
        
        //allocate a table view cell
        let cell = dequeued as! UITableViewCell
        cell.backgroundColor=UIColor.lightGrayColor()
        cell.frame = CGRect(x: 0, y: 0, width: tableview.frame.width, height: 100)
        cell.textLabel?.text = Jobposts?[indexPath.row].posttitle ?? ""
        return cell
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section == 0){
            return "Your Jobs"
        }
        else if (section == 1){
            return "Your Postings"
        }
        return ""
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

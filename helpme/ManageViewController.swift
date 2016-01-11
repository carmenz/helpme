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
    var Pendingjobs:[Post]?{
        didSet{
            tableview.reloadData()
        }
    }
    var Listposts:[Post]?{
        didSet{
            tableview.reloadData()
        }
    }
    var AcceptedJobs:[Post]?{
        didSet{
            tableview.reloadData()
        }
    }
    var AcceptedPosts:[Post]?{
        didSet{
            tableview.reloadData()
        }
    }
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
        
        
        updatePostings()
       
        
        
    }

    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0) {
            //print("section 0")
            //print(Jobposts?.count)
            return Pendingjobs?.count ?? 0
        }
        else if (section == 1){
            //print("section 1")
            //print(Listposts?.count)
            return Listposts?.count ?? 0
        }
        else if (section == 2){
            return AcceptedJobs?.count ?? 0
        }
        else if (section == 3){
            return AcceptedPosts?.count ?? 0
        }
        //print("dont know")
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let dequeued: AnyObject = tableView.dequeueReusableCellWithIdentifier("eventCell", forIndexPath: indexPath)
        
        
        //allocate a table view cell
        let cell = dequeued as! UITableViewCell
        cell.backgroundColor=UIColor.lightGrayColor()
        cell.frame = CGRect(x: 0, y: 0, width: tableview.frame.width, height: 100)
        cell.backgroundColor = UIColor.clearColor()
        if indexPath.section == 0 {
            cell.textLabel?.text = Pendingjobs?[indexPath.row].posttitle ?? ""
        }
        else if indexPath.section == 1 {
            if let name = Listposts?[indexPath.row].acceptedbyuser?.username{
                let footer = name as String
                cell.textLabel?.text = Listposts![indexPath.row].posttitle + "-" + footer
            }
            else{
                cell.textLabel?.text = Listposts![indexPath.row].posttitle
            }
        }
        else if indexPath.section == 2 {
            cell.textLabel?.text = AcceptedJobs?[indexPath.row].posttitle ?? ""
        }
        else if indexPath.section == 3 {
            cell.textLabel?.text = AcceptedPosts?[indexPath.row].posttitle ?? ""
        }
        
        return cell
    }



    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section == 0){
            return "Pending Jobs"
        }
        else if (section == 1){
            return "Your Active Postings"
        }
        else if (section == 2){
            return "Accepted Jobs"
        }
        else if (section == 3){
            return "Accepted Postings"
        }
        return ""
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.storyboard!.instantiateViewControllerWithIdentifier("EditPostViewController")
        self.performSegueWithIdentifier("PostEditing", sender: self)
    }
    
    
    @IBAction func BackToManage(segue: UIStoryboardSegue){
        updatePostings()
    }
    
    
    func updatePostings(){
        if let user = curruser {
            let query1 = PFQuery(className: "Post")
            query1.whereKey("acceptedbyuser", equalTo: user)
            query1.whereKey("status", equalTo: "inProgress")
            Pendingjobs = query1.findObjects() as? [Post] ?? []
        
            let query3 = PFQuery(className: "Post")
            query3.whereKey("postedbyuser", equalTo: user)
            query3.whereKey("status", notEqualTo: "Complete")
            Listposts = query3.findObjects() as? [Post] ?? []
            
            let query5 = PFQuery(className: "Post")
            query5.whereKey("acceptedbyuser", equalTo: user)
            query5.whereKey("status", equalTo: "Complete")
            AcceptedJobs = query5.findObjects() as? [Post] ?? []
            
            let query6 = PFQuery(className: "Post")
            query6.whereKey("postedbyuser", equalTo: user)
            query6.whereKey("status", equalTo: "Complete")
            AcceptedPosts = query6.findObjects() as? [Post] ?? []
            
        }
    
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "PostEditing"{
            let destination = segue.destinationViewController as! EditPostViewController
            destination.post = Listposts![tableview.indexPathForSelectedRow()!.row]
        }
    }
    

}

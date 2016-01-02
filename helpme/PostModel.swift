//
//  PostModel.swift
//  helpme
//
//  Created by Carmen Zhuang on 2015-12-28.
//  Copyright (c) 2015 helpm. All rights reserved.
//

import Foundation

class Post: PFObject, PFSubclassing {
    @NSManaged var posttitle:String
    @NSManaged var postdescription:String
    @NSManaged var contactnumber:String
    @NSManaged var currlatitude:Double
    @NSManaged var currlongitude:Double
    @NSManaged var acceptedbyuser:PFUser?
    @NSManaged var status:String
    @NSManaged var postedbyuser:PFUser?
    
    class func parseClassName() -> String {
        return "Post"
    }
    override class func initialize() {
        var onceToken: dispatch_once_t = 0
        dispatch_once(&onceToken) {
            self.registerSubclass()
        }
    }
    
    override class func query() -> PFQuery? {
        let query = PFQuery(className: Post.parseClassName())
        query.includeKey("user")
        query.orderByDescending("createdAt")
        return query
    }
    
    init(ptle:String,dscp:String,ctcnmb:String,longitude:Double,latitude:Double,user:PFUser){
        super.init()
        self.postedbyuser = user
        self.posttitle = ptle
        self.postdescription = dscp
        self.contactnumber = ctcnmb
        self.currlongitude = longitude
        self.currlatitude = latitude
        self.acceptedbyuser = nil
        self.status = "notAccepted"
    }
    override init() {
        super.init()
    }
}


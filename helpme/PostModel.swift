//
//  PostModel.swift
//  helpme
//
//  Created by Carmen Zhuang on 2015-12-28.
//  Copyright (c) 2015 helpm. All rights reserved.
//

import Foundation

class Post: PFObject, PFSubclassing {
    @NSManaged var postdescription:String
    @NSManaged var contactnumber:String
    @NSManaged var currlatitude:Double
    @NSManaged var currlongitude:Double
    @NSManaged var user:PFUser
    
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
        let query = PFQuery(className: Post.parseClassName()) //1
        query.includeKey("user") //2
        query.orderByDescending("createdAt") //3
        return query
    }
    init(dscp:String,ctcnmb:String,longitude:Double,latitude:Double,user:PFUser){
        super.init()
        self.postdescription = dscp
        self.contactnumber = ctcnmb
        self.currlongitude = longitude
        self.currlatitude = latitude
        self.user = user
    }
    override init() {
        super.init()
    }
}


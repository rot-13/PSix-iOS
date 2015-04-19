//
//  Event.swift
//  PSix
//
//  Created by Turzion, Avihu on 4/15/15.
//  Copyright (c) 2015 PayPal. All rights reserved.
//

import Foundation
import Parse

class Event: PFObject, PFSubclassing {
    
    convenience init(fbId: String, ownerFbId: String, name: String) {
        self.init()
        self.fbId = fbId
        self.ownerFbId = ownerFbId
        self.name = name
    }
    
    override static func initialize() {
        var onceToken : dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            self.registerSubclass()
        }
    }
    
    static func parseClassName() -> String {
        return "Event"
    }
    
    @NSManaged var fbId: String
    @NSManaged var ownerFbId: String
    @NSManaged var name: String
    @NSManaged var eventDescription: String
    @NSManaged var amountPerAttendee: Int
    @NSManaged var location: String
    @NSManaged var startTime: NSDate
    
}

typealias Events = [Event]
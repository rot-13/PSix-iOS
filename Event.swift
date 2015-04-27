//
//  Event.swift
//  PSix
//
//  Created by Turzion, Avihu on 4/15/15.
//  Copyright (c) 2015 PayPal. All rights reserved.
//

import Foundation
import Parse

class Event: PFObject, PFSubclassing, Comparable {
    
    convenience init(fbId: String, ownerFbId: String, name: String) {
        self.init()
        self.fbId = fbId
        self.ownerFbId = ownerFbId
        self.name = name
    }
    
    override static func initialize() {
        var onceToken: dispatch_once_t = 0;
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
    @NSManaged var eventDescription: String?
    @NSManaged var amountPerAttendee: Int
    @NSManaged var location: String?
    @NSManaged var startTime: NSDate?
    @NSManaged var endTime: NSDate?
    var coverImageUrl: NSURL?
    
    var moneyCollected: Int? {
        return nil
    }
    
    var totalMoneyToCollect: Int? {
        return nil
    }
    
}

func <(lhs: Event, rhs: Event) -> Bool {
    if let lhsStartTime = lhs.startTime,
       let rhsStartTime = rhs.startTime {
        return lhsStartTime.compare(rhsStartTime) == NSComparisonResult.OrderedAscending
    } else if lhs.startTime == nil && rhs.startTime != nil {
        return true
    }
    return false
}

func ==(lhs: Event, rhs: Event) -> Bool {
    if let lhsStartTime = lhs.startTime,
       let rhsStartTime = rhs.startTime {
        return lhsStartTime.compare(rhsStartTime) == NSComparisonResult.OrderedSame
    }
    return false
}

typealias Events = [Event]
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
    
    static func findOrCreateBlocking(fbId: String) -> Event {
        let findEventQuery = PFQuery(className: parseClassName()).whereKey("fbId", equalTo: fbId)
        if let events = findEventQuery.findObjects() as? Events, event = events.first {
            return event
        }
        return Event(fbId)
    }
    
    convenience init(_ fbId: String) {
        self.init()
        self.fbId = fbId
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
    @NSManaged var amountPerAttendee: Int
    
    var name: String?
    var eventDescription: String?
    var location: String?
    var startTime: NSDate?
    var endTime: NSDate?
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
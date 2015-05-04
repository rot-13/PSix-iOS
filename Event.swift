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
        if let event = findEventQuery.getFirstObject() as? Event {
            return event
        }
        return Event(fbId)
    }
    
    convenience init(_ fbId: String) {
        self.init()
        self.fbId = fbId
    }
    
    override static func initialize() {
        var onceToken: dispatch_once_t = 0
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
    
    var _paymentsRelation: PFRelation?
    var paymentsRelation: PFRelation {
        if let _paymentsRelation = _paymentsRelation {
            return _paymentsRelation
        }
        _paymentsRelation = self.relationForKey("payments")
        return _paymentsRelation!
    }
    
    var guests = RSVPs()
    var attending: RSVPs {
        return RSVP.filterAttending(guests)
    }
    var tentative: RSVPs {
        return RSVP.filterMaybe(guests)
    }
    var declined: RSVPs {
        return RSVP.filterDeclined(guests)
    }
    
    var moneyCollected: Int? {
        // For some fucking reason I cannot seem to convert the relation query response to a Payments collection,
        // and so I am stuck with this ugliness :(
        // Still trying to resolve this.
        if let payments = paymentsRelation.query()?.findObjects() as? Payments {
            return payments.map { $0["amount"] as! Int }.reduce(0, combine: +)
        }
        return nil
    }
    
    var totalMoneyToCollect: Int? {
        if amountPerAttendee > 0 {
            return RSVP.filterAttending(guests).count * amountPerAttendee
        }
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
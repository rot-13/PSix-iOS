//
//  RSVP.swift
//  PSix
//
//  Created by Turzion, Avihu on 4/30/15.
//  Copyright (c) 2015 PayPal. All rights reserved.
//

import Foundation

typealias RSVPs = [RSVP]

enum RsvpStatus {
    case Attending
    case Maybe
    case Declined
}

class RSVP {
    
    let event: Event
    var status: RsvpStatus
    
    init(event: Event, status: RsvpStatus) {
        self.event = event
        self.status = status
    }
    
    private static func filterRsvpsByStatus(rsvps: RSVPs, status: RsvpStatus) -> RSVPs {
        return rsvps.filter { $0.status == status }
    }
    
    static func filterAttending(rsvps: RSVPs) -> RSVPs {
        return filterRsvpsByStatus(rsvps, status: .Attending)
    }
    
    static func filterMaybe(rsvps: RSVPs) -> RSVPs {
        return filterRsvpsByStatus(rsvps, status: .Maybe)
    }
    
    static func filterDeclined(rsvps: RSVPs) -> RSVPs {
        return filterRsvpsByStatus(rsvps, status: .Declined)
    }
    
}
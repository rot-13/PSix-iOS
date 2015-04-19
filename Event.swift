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
    
    override static func initialize() {
        var onceToken : dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            self.registerSubclass()
        }
    }
    
    static func parseClassName() -> String {
        return "Event"
    }
    
}

typealias Events = [Event]
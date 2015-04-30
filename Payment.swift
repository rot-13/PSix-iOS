//
//  Payment.swift
//  PSix
//
//  Created by Turzion, Avihu on 4/27/15.
//  Copyright (c) 2015 PayPal. All rights reserved.
//

import Foundation
import Parse

typealias Payments = [Payment]

class Payment: PFObject, PFSubclassing {
    
    override static func initialize() {
        var onceToken: dispatch_once_t = 0
        dispatch_once(&onceToken) {
            self.registerSubclass()
        }
    }
    
    static func parseClassName() -> String {
        return "Payment"
    }
    
    @NSManaged var amount: Int
    @NSManaged var payeeFbId: String
    
    var event: Event?
    
}
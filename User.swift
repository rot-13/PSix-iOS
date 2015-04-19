//
//  User.swift
//  PSix
//
//  Created by Turzion, Avihu on 4/15/15.
//  Copyright (c) 2015 PayPal. All rights reserved.
//

import Foundation
import Parse

class User: PFUser, PFSubclassing {
    
    override static func initialize() {
        var onceToken : dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            self.registerSubclass()
        }
    }
    
    override static func parseClassName() -> String {
        return "_User"
    }
    
    @NSManaged var facebookId: String
    
}
//
//  CurrentUser.swift
//  PSix
//
//  Created by Turzion, Avihu on 4/14/15.
//  Copyright (c) 2015 PayPal. All rights reserved.
//

import Foundation
import Parse

class User {
    
    private static let FB_READ_PERMISSIONS = ["public_profile", "user_events"]
    
    static func current() -> PFUser? {
        return PFUser.currentUser()
    }
    
    static func loginWithFacebook(callback: (PFUser?, NSError?) -> () ) {
        PFFacebookUtils.logInInBackgroundWithReadPermissions(FB_READ_PERMISSIONS) {
            (user, error) -> Void in callback(user, error)
        }
    }
    
    static func isLoggedIn() -> Bool {
        return current() != nil
    }
    
    static func logout() {
        PFUser.logOut()
    }
    
}
//
//  CurrentUser.swift
//  PSix
//
//  Created by Turzion, Avihu on 4/14/15.
//  Copyright (c) 2015 PayPal. All rights reserved.
//

import Foundation
import Parse

class ParseUserSession {
    
    private static let FB_READ_PERMISSIONS = ["public_profile", "user_events"]
    
    static var currentUser: User? {
        return PFUser.currentUser() as? User
    }
    
    static func loginWithFacebook(callback: ()->()) {
        PFFacebookUtils.logInInBackgroundWithReadPermissions(FB_READ_PERMISSIONS) { (parseUser, error) -> Void in
            if let user = parseUser as? User {
                FacebookService.getLoggedInUserId() { (fbId) -> Void in
                    user.facebookId = fbId
                    user.pinInBackground()
                    user.saveInBackground()
                    callback()
                }
            }
        }
    }
    
    static var isLoggedIn: Bool {
        return currentUser != nil
    }
    
    static func logout() {
        PFUser.logOut()
    }
    
}
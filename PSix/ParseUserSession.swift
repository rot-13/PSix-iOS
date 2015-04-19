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
    
    static private var currentLoggedInUser: User? = nil
    
    static var currentUser: User? {
        get {
            if currentLoggedInUser == nil && PFUser.currentUser() != nil {
                currentLoggedInUser = User(withoutDataWithObjectId: PFUser.currentUser()?.objectId)
                currentLoggedInUser?.fetch()
            } else if currentLoggedInUser == nil && PFUser.currentUser() == nil {
                return nil
            }
            return currentLoggedInUser
        }
    }
    
    static func loginWithFacebook(callback: ()->()) {
        PFFacebookUtils.logInInBackgroundWithReadPermissions(FB_READ_PERMISSIONS) { (parseUser, error) -> Void in
            if let actualUser = parseUser {
                actualUser.saveInBackground()
                FacebookService.getLoggedInUserId() { (fbId) -> Void in
                    let user = User(withoutDataWithObjectId: actualUser.objectId)
                    user.facebookId = fbId
                    user.pinInBackground()
                    user.saveInBackground()
                    self.currentLoggedInUser = user
                    callback()
                }
            }
        }
    }
    
    static var isLoggedIn: Bool {
        get {
            return PFUser.currentUser() != nil
        }
    }
    
    static func logout() {
        PFUser.logOut()
    }
    
}
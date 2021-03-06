//
//  CurrentUser.swift
//  PSix
//
//  Created by Turzion, Avihu on 4/14/15.
//  Copyright (c) 2015 PayPal. All rights reserved.
//

import Foundation
import Parse

typealias FBLoginCallback = () -> ()

class ParseUserSession {
  
  private static let FB_READ_PERMISSIONS = ["public_profile", "user_events"]
  static var delegate: ParseUserSessionDelegate?
  
  static var currentUser: User? {
    return PFUser.currentUser() as? User
  }
  
  static func loginWithFacebook(callback: FBLoginCallback) {
    PFFacebookUtils.logInInBackgroundWithReadPermissions(FB_READ_PERMISSIONS) { (parseUser, error) -> Void in
      if let user = parseUser as? User {
        FacebookService.getLoggedInUserId() { (fbId) -> Void in
          user.facebookId = fbId
          user.pinInBackground()
          user.saveInBackground()
          self.delegate?.userLoggedIn()
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
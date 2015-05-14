//
//  FBUserRequest.swift
//  PSix
//
//  Created by Turzion, Avihu on 4/20/15.
//  Copyright (c) 2015 PayPal. All rights reserved.
//

import Foundation

protocol FBUser {
  var facebookId: String { get }
}

class FBUserRequest: FBRequest {
  
  init(fbId: String) {
    super.init(fromPath: fbId)
  }
  
  convenience init(_ user: FBUser) {
    self.init(fbId: user.facebookId)
  }
  
  var events: FBUserEventsRequest {
    return FBUserEventsRequest(fromUserRequest: self)
  }
  
}
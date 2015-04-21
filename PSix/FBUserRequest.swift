//
//  FBUserRequest.swift
//  PSix
//
//  Created by Turzion, Avihu on 4/20/15.
//  Copyright (c) 2015 PayPal. All rights reserved.
//

import Foundation


class FBUserRequest: FBRequest {
    
    init(fbId: String) {
        super.init(forResource: fbId)
    }
    
    func attributes(attributes: [String]) -> FBRequest {
        addParam("fields", value: ",".join(attributes))
        return self
    }
    
    var events: FBUserEventsRequest {
        return FBUserEventsRequest(fromUserRequest: self)
    }
    
}
//
//  FBUserEventsRequest.swift
//  PSix
//
//  Created by Turzion, Avihu on 4/20/15.
//  Copyright (c) 2015 PayPal. All rights reserved.
//

import Foundation

class FBUserEventsRequest: FBRequest {
    
    init(fromUserRequest request: FBUserRequest) {
        super.init(fromPath: request.path + URI_SEP + "events")
    }
    
    private init(fromOtherRequest request: FBUserEventsRequest, edge: String) {
        super.init(fromPath: request.path + URI_SEP + edge, params: request.params)
    }
    
    var created: FBUserEventsRequest {
        if !path.contains("created") {
            return FBUserEventsRequest(fromOtherRequest: self, edge: "created")
        }
        return self
    }
    
    override func fields(attributes: [String]) -> FBUserEventsRequest {
        return super.fields(attributes) as! FBUserEventsRequest
    }
    
    func since(startTime: Int) -> FBUserEventsRequest {
        addParam("since", value: startTime)
        return self
    }
    
}
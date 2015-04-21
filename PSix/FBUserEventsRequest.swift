//
//  FBUserEventsRequest.swift
//  PSix
//
//  Created by Turzion, Avihu on 4/20/15.
//  Copyright (c) 2015 PayPal. All rights reserved.
//

import Foundation


extension String {
    func contains(other: String) -> Bool {
        return rangeOfString(other) != nil
    }
}


class FBUserEventsRequest: FBRequest {
    
    init(otherRequest: FBUserRequest) {
        super.init(path: otherRequest.path + URI_SEP + "events")
    }
    
    private init(copyRequest: FBUserEventsRequest, edge: String) {
        super.init(path: copyRequest.path + URI_SEP + edge, params: copyRequest.params)
    }
    
    var created: FBUserEventsRequest {
        if !path.contains("created") {
            return FBUserEventsRequest(copyRequest: self, edge: "created")
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
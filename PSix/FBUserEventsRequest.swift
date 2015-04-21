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
    
    init(fromUserRequest: FBUserRequest) {
        super.init(forResource: fromUserRequest.path + URI_SEP + "events")
    }
    
    private init(copyRequest: FBUserEventsRequest, withAddedEdge: String) {
        super.init(forResource: copyRequest.path + URI_SEP + withAddedEdge, withParams: copyRequest.params)
    }
    
    var created: FBUserEventsRequest {
        if !path.contains("created") {
            return FBUserEventsRequest(copyRequest: self, withAddedEdge: "created")
        }
        return self
    }
    
    func attributes(values: [String]) -> FBUserEventsRequest {
        addParam("fields", value: ",".join(values))
        return self
    }
    
    func since(startTime: Int) -> FBUserEventsRequest {
        addParam("since", value: startTime)
        return self
    }
    
}
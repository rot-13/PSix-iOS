//
//  FacebookService.swift
//  PSix
//
//  Created by Turzion, Avihu on 4/16/15.
//  Copyright (c) 2015 PayPal. All rights reserved.
//

import Foundation
import Parse


class FacebookService {
    
    private static let FB_EVENT_ATTRIBUTES = ["cover", "name","id", "start_time", "description"]
    
    static func getLoggedInUserId(callback: (fbId: String) -> ()) {
        FBUserRequest(fbId: "me").about(["id"]).execute() { (result) -> Void in
            if let fbId = result["id"] as? String {
                callback(fbId: fbId)
            }
        }
    }
    
    private static func nowAsEpoch() -> Int {
        return Int((NSDate.timeIntervalSinceReferenceDate() + NSTimeIntervalSince1970))
    }
    
    static func getFutureEventsCreatedByUser(user: User, failure: ((NSError) -> ())?, success: (result: NSArray) -> ()) {
        if FBSDKAccessToken.currentAccessToken() != nil {
            FBUserRequest(fbId:"\(user.facebookId)").events.created.attributes(FB_EVENT_ATTRIBUTES).since(nowAsEpoch()).execute() { (result) -> Void in
                if let eventsData = result as? NSDictionary {
                    if let events = eventsData["data"] as? NSArray {
                        success(result: events)
                    }
                }
            }
        }
    }

}
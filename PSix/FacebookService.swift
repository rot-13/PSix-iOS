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
    
    private static let FB_EVENT_ATTRIBUTES = "cover,name,id,start_time,description"
    
    static func getLoggedInUserId(callback: (fbId: String) -> ()) {
        if FBSDKAccessToken.currentAccessToken() != nil {
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id"]).startWithCompletionHandler() {
                (connection, result, error) -> Void in
                if let fbId = result["id"] as? String {
                    callback(fbId: fbId)
                }
            }
        }
    }
    
    static func getFutureEventsCreatedByUser(user: User, failure: ((NSError?) -> ())?, success: (result: NSArray) -> ()) {
        let params = [
            "fields": FB_EVENT_ATTRIBUTES,
            "since":  Int((NSDate.timeIntervalSinceReferenceDate() + NSTimeIntervalSince1970))
        ]
        if FBSDKAccessToken.currentAccessToken() != nil {
            FBSDKGraphRequest(graphPath: "\(user.facebookId)/events/created", parameters: params as [NSObject : AnyObject]).startWithCompletionHandler() { (connection, result, error) -> Void in
                if let eventsData = result as? NSDictionary {
                    if let events = eventsData["data"] as? NSArray {
                        success(result: events)
                    }
                } else {
                    failure?(error)
                }
            }
        }
    }

}
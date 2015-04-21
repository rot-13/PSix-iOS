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
    
    private static let FB_EVENT_ATTRIBUTES = [
        FBReq.Event.ID,
        FBReq.Event.NAME,
        FBReq.Event.COVER,
        FBReq.Event.START_TIME,
        FBReq.Event.DESCRIPTION
    ]
    
    static func getLoggedInUserId(callback: (fbId: String) -> ()) {
        FBUserRequest(fbId: FBReq.User.ME).attributes([FBReq.User.ID]).execute() { (response) -> Void in
            if let fbId = response[FBReq.User.ID] as? String {
                callback(fbId: fbId)
            }
        }
    }
    
    private static func nowAsEpoch() -> Int {
        return Int(NSDate.timeIntervalSinceReferenceDate() + NSTimeIntervalSince1970)
    }
    
    private static func extractEventsFromResponse(response: FBResponse, previousEvents: Events = Events(), onCompletionCB: (Events) -> ()) {
        println("Starting to populate events")
        var events = Events(previousEvents)
        if let eventsData = response.data {
            for eventData in eventsData {
                if let fbId = eventData[FBReq.Event.ID] as? String,
                   let currentUser = ParseUserSession.currentUser,
                   let name = eventData["name"] as? String {
                    
                    let event = Event(fbId: fbId, ownerFbId: currentUser.facebookId, name: name)
                    event.eventDescription = eventData[FBReq.Event.DESCRIPTION] as? String
                    event.location = eventData[FBReq.Event.LOCATION] as? String
                    event.saveEventually()
                    events.append(event)
                }
            }
        }
        
        if let nextReq = response.requestNext() {
            nextReq.execute(failure: { (error) -> Void in
                println("There was an error getting the next page: \(error)")
                onCompletionCB(events)
            }) { (nextResponse) -> Void in
                self.extractEventsFromResponse(nextResponse, previousEvents: events, onCompletionCB: onCompletionCB)
            }
        } else {
            onCompletionCB(events)
        }
    }
    
    static func getFutureEventsCreatedByUser(user: User, callback: (Events) -> ()) {
        if FBSDKAccessToken.currentAccessToken() != nil {
            FBUserRequest(fbId: user.facebookId).events.created.attributes(FB_EVENT_ATTRIBUTES).since(nowAsEpoch()).execute() { (response) -> Void in
                self.extractEventsFromResponse(response) { (Events) -> Void in
                    callback(Events)
                }
            }
        }
    }

}
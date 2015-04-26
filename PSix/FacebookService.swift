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
        FBReq.Event.DESCRIPTION,
        FBReq.Event.LOCATION,
        FBReq.Event.IS_DATE_ONLY
    ]
    
    static func getLoggedInUserId(callback: (fbId: String) -> ()) {
        if FBSDKAccessToken.currentAccessToken() != nil {
            FBUserRequest(fbId: FBReq.User.ME).fields([FBReq.User.ID]).execute() { (response) -> Void in
                if let fbId = response[FBReq.User.ID] as? String {
                    callback(fbId: fbId)
                }
            }
        }
    }
    
    private static func nowAsEpoch() -> Int {
        return Int(NSDate.timeIntervalSinceReferenceDate() + NSTimeIntervalSince1970)
    }
    
    private static func extractLocation(eventData: AnyObject) -> String? {
        if let locationData: AnyObject? = eventData[FBReq.Event.LOCATION] {
            if let locationName = locationData?["name"] as? String {
                return locationName
            }
        }
        return nil
    }
    
    private static func extractTimeAttribute(eventData: AnyObject, attributeName: String) -> NSDate? {
        if let dateOnly = eventData[FBReq.Event.IS_DATE_ONLY] as? Bool,
           let timeAttribute = eventData[attributeName] as? String {
            
            let dateFormatter = NSDateFormatter()
            if !dateOnly {
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
            } else {
                dateFormatter.dateFormat = "yyyy-MM-dd"
            }
            return dateFormatter.dateFromString(timeAttribute)
        }
        return nil
    }
    
    private static func extractCoverImageUrl(eventData: AnyObject) -> NSURL? {
        if let coverData: AnyObject? = eventData["cover"] {
            if let sourceUrl = coverData?["source"] as? String {
                return NSURL(string: sourceUrl)
            }
        }
        return nil
    }
    
    private static func extractEventsFromResponse(response: FBResponse, previousEvents: Events = Events(), onCompletionCB: (Events) -> ()) {
        var events = Events(previousEvents)
        if let eventsData = response.data {
            for eventData in eventsData {
                if let fbId = eventData[FBReq.Event.ID] as? String,
                   let currentUser = ParseUserSession.currentUser,
                   let name = eventData["name"] as? String {
                    
                    let event = Event(fbId: fbId, ownerFbId: currentUser.facebookId, name: name)
                    event.eventDescription = eventData[FBReq.Event.DESCRIPTION] as? String
                    event.location = extractLocation(eventData)
                    event.startTime = extractTimeAttribute(eventData, attributeName: FBReq.Event.START_TIME)
                    event.endTime = extractTimeAttribute(eventData, attributeName: FBReq.Event.END_TIME)
                    event.coverImageUrl = extractCoverImageUrl(eventData)
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
            FBUserRequest(user).events.created.fields(FB_EVENT_ATTRIBUTES).since(nowAsEpoch()).execute() { (response) -> Void in
                self.extractEventsFromResponse(response) { (Events) -> Void in
                    callback(Events)
                }
            }
        }
    }

}
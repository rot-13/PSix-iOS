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
        if let locationData: AnyObject? = eventData[FBReq.Event.LOCATION],
           let locationName = locationData?["name"] as? String {
            return locationName
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
        if let coverData: AnyObject? = eventData["cover"],
           let sourceUrl = coverData?["source"] as? String {
            return NSURL(string: sourceUrl)
        }
        return nil
    }
    
    private static func storeFBEventInParse(eventData: AnyObject) -> Event? {
        if let fbId = eventData[FBReq.Event.ID] as? String,
           let currentUser = ParseUserSession.currentUser,
           let name = eventData[FBReq.Event.NAME] as? String {
            
            let event = Event.findOrCreateBlocking(fbId)
            event.ownerFbId = currentUser.facebookId
            event.name = name
            event.eventDescription = eventData[FBReq.Event.DESCRIPTION] as? String
            event.location = FacebookService.extractLocation(eventData)
            event.startTime = FacebookService.extractTimeAttribute(eventData, attributeName: FBReq.Event.START_TIME)
            event.endTime = FacebookService.extractTimeAttribute(eventData, attributeName: FBReq.Event.END_TIME)
            event.coverImageUrl = FacebookService.extractCoverImageUrl(eventData)
            event.saveEventually()
            return event
            
        }
        return nil
    }
    
    private static func extractEventsFromResponse(response: FBResponse, previousEvents: Events = Events(), completionCallback: (Events) -> ()) {
        var events = Events(previousEvents)
        if let eventsData = response.data {
            events = events + Array.filterNils(eventsData.map(storeFBEventInParse))
        }
        
        if let nextReq = response.requestNext() {
            nextReq.execute(failure: { (error) -> Void in
                println("There was an error getting the next page: \(error)")
                completionCallback(events)
            }, success: { (nextResponse) -> Void in
                self.extractEventsFromResponse(nextResponse, previousEvents: events, completionCallback: completionCallback)
            })
        } else {
            completionCallback(events)
        }
    }
    
    static func getFutureEventsCreatedByUserAsync(user: User, callback: (Events) -> ()) {
        dispatch_async(dispatch_get_main_queue()) {
            FacebookService.getFutureEventsCreatedByUser(user, callback: callback)
        }
    }
    
    private static func pinParseUserEvents(user: User) {
        let userEventsQuery = PFQuery(className: Event.parseClassName()).whereKey("ownerFbId", equalTo: user.facebookId)
        PFObject.pinAll(userEventsQuery.findObjects())
    }

    static func getFutureEventsCreatedByUser(user: User, callback: (Events) -> ()) {
        if FBSDKAccessToken.currentAccessToken() != nil {
            pinParseUserEvents(user)
            FBUserRequest(user).events.created.fields(FB_EVENT_ATTRIBUTES).since(nowAsEpoch()).execute() { (response) -> Void in
                self.extractEventsFromResponse(response) { (Events) -> Void in
                    callback(Events)
                }
            }
        }
    }

}
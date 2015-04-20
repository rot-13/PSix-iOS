//
//  FacebookEventParser.swift
//  PSix
//
//  Created by Turzion, Avihu on 4/20/15.
//  Copyright (c) 2015 PayPal. All rights reserved.
//

import Foundation

class FacebookEventsParser {
    
    private(set) var events = Events()
    
    init(eventsData: NSArray) {        for eventData in eventsData {
            if let fbId = eventData["id"] as? String,
               let ownerFbId = ParseUserSession.currentUser?["facebookId"] as? String,
               let name = eventData["name"] as? String {
                
                let event = Event(fbId: fbId, ownerFbId: ownerFbId, name: name)
                event.eventDescription = eventData["description"] as? String
                event.location = eventData["location"] as? String
                event.saveEventually()
                events.append(event)
                
            } else {
                println("Missing event information. Event object was not created.")
            }
        }
    }
    
}
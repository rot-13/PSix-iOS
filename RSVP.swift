//
//  RSVP.swift
//  PSix
//
//  Created by Turzion, Avihu on 4/30/15.
//  Copyright (c) 2015 PayPal. All rights reserved.
//

import Foundation

typealias RSVPs = [RSVP]

enum RsvpStatus {
  case Attending
  case Tentative
  case NotGoing
}

class RSVP {
  
  let event: Event
  var status: RsvpStatus
  
  init(event: Event, status: RsvpStatus) {
    self.event = event
    self.status = status
  }
  
  static func filter(rsvps: RSVPs, whoAre status: RsvpStatus) -> RSVPs {
    return rsvps.filter { $0.status == status }
  }
  
}
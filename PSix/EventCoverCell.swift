//
//  EventCoverCell.swift
//  PSix
//
//  Created by Turzion, Avihu on 5/7/15.
//  Copyright (c) 2015 PayPal. All rights reserved.
//

import UIKit

class EventCoverCell: UITableViewCell {

    @IBOutlet weak var coverView: EventDetailsCoverView!
    
    var event: Event? {
        didSet {
            coverView.event = event
        }
    }
    
}

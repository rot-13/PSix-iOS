//
//  EventCell.swift
//  PSix
//
//  Created by Turzion, Avihu on 4/26/15.
//  Copyright (c) 2015 PayPal. All rights reserved.
//

import UIKit

class EventCell: UITableViewCell {

    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var paymentCollectionStatusLabel: UILabel!
    @IBOutlet weak var eventDateMonthLabel: UILabel!
    @IBOutlet weak var eventDateDayLabel: UILabel!
    @IBOutlet weak var eventThumbImage: UIImageView!
    
    override func awakeFromNib() {
        eventNameLabel.adjustsFontSizeToFitWidth = false
        eventNameLabel.lineBreakMode = NSLineBreakMode.ByTruncatingTail
    }
    
    var event: Event? {
        didSet {
            eventNameLabel.text = event?.name
            locationLabel.text = event?.location
            eventDateMonthLabel.text = event?.startTime?.monthShortName.uppercaseString
            eventDateDayLabel.text = event?.startTime?.dayDoubleDigit
        }
    }

}

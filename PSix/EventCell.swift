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
    @IBOutlet weak var eventDateDayAndTime: UILabel!
    @IBOutlet weak var eventDateMonthLabel: UILabel!
    @IBOutlet weak var eventDateDayLabel: UILabel!
    @IBOutlet weak var eventThumbImage: UIImageView!
    @IBOutlet weak var paymentCollectionStatus: UILabel!
    
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
            setDayAndTimeLabel()
        }
    }
    
    private func setDayAndTimeLabel() {
        if let startDate = event?.startTime {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "EEEE, h:mm"
            let extendedText = dateFormatter.stringFromDate(startDate) as NSString
            let extTextSize = extendedText.sizeWithAttributes([NSFontAttributeName: eventDateDayAndTime.font])
            if eventDateDayAndTime.bounds.width < extTextSize.width {
                dateFormatter.dateFormat = "E, h:mm"
                eventDateDayAndTime.text = dateFormatter.stringFromDate(startDate)
            } else {
                eventDateDayAndTime.text = extendedText as String
            }
        }
    }

}

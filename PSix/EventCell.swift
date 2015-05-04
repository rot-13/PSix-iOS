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
    @IBOutlet weak var amountPerAttendee: UILabel!
    
    private static var placeholderThumb = UIImage(named: "PlaceholderEventThumb")
    
    override func awakeFromNib() {
        eventThumbImage.image = EventCell.placeholderThumb
    }
    
    var event: Event? {
        didSet {
            if let event = event {
                let presenter = EventPresenter(event)
                eventNameLabel.text = presenter.title
                locationLabel.text = presenter.location
                eventDateMonthLabel.text = event.startTime?.monthShortName.uppercaseString
                eventDateDayLabel.text = event.startTime?.dayDoubleDigit
                eventDateDayAndTime.text = presenter.getDayHourOfStartConsideringWidth(eventDateDayAndTime.bounds.width, font: eventDateDayAndTime.font)
                let paymentCollectionStatus = presenter.paymentStatus
                if paymentCollectionStatus != "" {
                    amountPerAttendee.text = paymentCollectionStatus
                } else {
                    amountPerAttendee.text = presenter.attendanceFee
                }
                
                eventThumbImage.image = EventCell.placeholderThumb
                presenter.getCoverImageAsync { [unowned self] (image) -> Void in
                    self.eventThumbImage.image = image
                }
            }
        }
    }

}

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
    @IBOutlet weak var eventThumbImage: ShadedImageView!
    @IBOutlet weak var amountPerAttendee: UILabel!
    @IBOutlet weak var eventMonthDayView: MonthDay!
    
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
                eventDateDayAndTime.text = presenter.getDayHourOfStartConsideringWidth(eventDateDayAndTime.bounds.width, font: eventDateDayAndTime.font)
                let paymentCollectionStatus = presenter.paymentStatus
                eventMonthDayView.date = event.startTime
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

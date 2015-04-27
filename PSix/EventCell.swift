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
    
    private static var placeholderThumb = UIImage(named: "PlaceholderEventThumb")
    
    override func awakeFromNib() {
        eventThumbImage.image = EventCell.placeholderThumb
    }
    
    var event: Event? {
        didSet {
            eventNameLabel.text = event?.name
            locationLabel.text = event?.location
            eventDateMonthLabel.text = event?.startTime?.monthShortName.uppercaseString
            eventDateDayLabel.text = event?.startTime?.dayDoubleDigit
            eventDateDayAndTime.text = EventPresenter.getDayHourOfStartConsideringWidth(event, boxWidth: eventDateDayAndTime.bounds.width, font: eventDateDayAndTime.font)
            paymentCollectionStatus.text = EventPresenter.getPaymentStatus(event)
            setEventThumbImage()
        }
    }
    
    private func setEventThumbImage() {
        if let coverImageUrl = event?.coverImageUrl {
            dispatch_async(dispatch_get_main_queue()) { [unowned self] () -> Void in
                if let coverImageData = NSData(contentsOfURL: coverImageUrl) {
                    self.eventThumbImage.image = UIImage(data: coverImageData)
                }
            }
        } else {
            eventThumbImage.image = EventCell.placeholderThumb
        }
    }

}

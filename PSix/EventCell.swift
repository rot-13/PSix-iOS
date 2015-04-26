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
        eventNameLabel.adjustsFontSizeToFitWidth = false
        eventNameLabel.lineBreakMode = NSLineBreakMode.ByTruncatingTail
        eventThumbImage.image = EventCell.placeholderThumb
    }
    
    var event: Event? {
        didSet {
            eventNameLabel.text = event?.name
            locationLabel.text = event?.location
            eventDateMonthLabel.text = event?.startTime?.monthShortName.uppercaseString
            eventDateDayLabel.text = event?.startTime?.dayDoubleDigit
            setDayAndTimeLabel()
            setPaymentStatus()
            setEventThumbImage()
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
    
    private func setPaymentStatus() {
        if let amountToCollect = event?.totalMoneyToCollect {
            let amountCollected = event?.moneyCollected ?? 0
            paymentCollectionStatus.text = "\(amountCollected) / \(amountToCollect)$"
        } else {
            paymentCollectionStatus.text = ""
        }
    }

}

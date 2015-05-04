//
//  EventPresenter.swift
//  PSix
//
//  Created by Turzion, Avihu on 4/27/15.
//  Copyright (c) 2015 PayPal. All rights reserved.
//

import Foundation

class EventPresenter {
    
    static let formatter = NSDateFormatter()
    
    private static var eventCoverImages = [NSURL:UIImage]()
    
    private static func doesTextFitInWidth(text: String, width: CGFloat, font: UIFont) -> Bool {
        return width >= (text as NSString).sizeWithAttributes([NSFontAttributeName: font]).width
    }
    
    static func getEventImageAsync(event: Event, callback: (UIImage) -> ()) {
        if let coverImageUrl = event.coverImageUrl {
            if let preloadedImage = eventCoverImages[coverImageUrl] {
                callback(preloadedImage)
            } else {
                dispatch_async(dispatch_get_main_queue()) {
                    if let coverImageData = NSData(contentsOfURL: coverImageUrl) {
                        EventPresenter.eventCoverImages[coverImageUrl] = UIImage(data: coverImageData)
                        callback(EventPresenter.eventCoverImages[coverImageUrl]!)
                    }
                }
            }
        }
    }
    
    static func getDayHourOfStartConsideringWidth(event: Event, boxWidth: CGFloat, font: UIFont) -> String {
        if let startDate = event.startTime {
            formatter.dateFormat = "EEEE, H:mm"
            let extendedText = formatter.stringFromDate(startDate)
            if !doesTextFitInWidth(extendedText, width: boxWidth, font: font) {
                formatter.dateFormat = "E, H:mm"
                return formatter.stringFromDate(startDate)
            }
            return extendedText as String
        }
        return ""
    }
    
    static func getFeePerAttendee(event: Event) -> String {
        if event.amountPerAttendee > 0 {
            return "$\(event.amountPerAttendee)"
        }
        return ""
    }
    
    static func getPaymentStatus(event: Event) -> String {
        if event.attending.count > 0 {
            if let amountToCollect = event.totalMoneyToCollect {
                let amountCollected = event.moneyCollected ?? 0
                return "$\(amountCollected) / $\(amountToCollect)"
            }
        }
        return ""
    }
    
}
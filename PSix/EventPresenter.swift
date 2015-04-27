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
    
    private static func doesTextFitInWidth(text: String, width: CGFloat, font: UIFont) -> Bool {
        return width >= (text as NSString).sizeWithAttributes([NSFontAttributeName: font]).width
    }
    
    static func getDayHourOfStartConsideringWidth(event: Event?, boxWidth: CGFloat, font: UIFont) -> String {
        if let startDate = event?.startTime {
            formatter.dateFormat = "EEEE, h:mm"
            let extendedText = formatter.stringFromDate(startDate)
            if !doesTextFitInWidth(extendedText, width: boxWidth, font: font) {
                formatter.dateFormat = "E, h:mm"
                return formatter.stringFromDate(startDate)
            }
            return extendedText as String
        }
        return ""
    }
    
    static func getPaymentStatus(event: Event?) -> String {
        if let amountToCollect = event?.totalMoneyToCollect {
            let amountCollected = event?.moneyCollected ?? 0
            return "\(amountCollected) / \(amountToCollect)"
        }
        return ""
    }
    
}
//
//  EventPresenter.swift
//  PSix
//
//  Created by Turzion, Avihu on 4/27/15.
//  Copyright (c) 2015 PayPal. All rights reserved.
//

import Foundation

typealias ImageByUrlIndex = [NSURL:UIImage]

private var eventCoverImages = ImageByUrlIndex()

class EventPresenter {
  
  private static func doesTextFitInWidth(text: String, width: CGFloat, font: UIFont) -> Bool {
    return width >= (text as NSString).sizeWithAttributes([NSFontAttributeName: font]).width
  }
  
  private let event: Event
  
  init(_ event: Event) {
    self.event = event
  }
  
  func getCoverImageAsync(callback: (UIImage) -> ()) {
    if let coverImageUrl = event.coverImageUrl {
      if let preloadedImage = eventCoverImages[coverImageUrl] {
        callback(preloadedImage)
      } else {
        dispatch_async(dispatch_get_main_queue()) {
          if let coverImageData = NSData(contentsOfURL: coverImageUrl) {
            eventCoverImages[coverImageUrl] = UIImage(data: coverImageData)
            callback(eventCoverImages[coverImageUrl]!)
          }
        }
      }
    }
  }
  
  func getDayHourOfStartConsideringWidth(boxWidth: CGFloat, font: UIFont) -> String {
    if let startDate = event.startTime {
      let startDatePresenter = NSDatePresenter(startDate)
      if isAllDayEvent {
        return startDatePresenter.longDayName
      }
      let extendedText = startDatePresenter.longDayNameBigHour
      if !EventPresenter.doesTextFitInWidth(extendedText, width: boxWidth, font: font) {
        return startDatePresenter.shortDayNameBigHour
      }
      return extendedText
    }
    return ""
  }
  
  var attendanceFee: String {
    if event.amountPerAttendee > 0 {
      return "$\(event.amountPerAttendee)"
    }
    return ""
  }
  
  var paymentStatus: String {
    if event.attending.count > 0 {
      if let amountToCollect = event.totalMoneyToCollect {
        let amountCollected = event.moneyCollected ?? 0
        return "$\(amountCollected) / $\(amountToCollect)"
      }
    }
    return ""
  }
  
  var title: String {
    return event.name ?? ""
  }
  
  var location: String {
    return event.location ?? ""
  }
  
  var isAllDayEvent: Bool {
    if let startDate = event.startTime {
      let calendar = NSCalendar.currentCalendar()
      let components = calendar.components((.HourCalendarUnit | .MinuteCalendarUnit), fromDate: startDate)
      if components.hour == 0 && components.minute == 0 {
        return true
      }
    }
    return false
  }
  
}
//
//  NSDatePresenter.swift
//  PSix
//
//  Created by Turzion, Avihu on 7/15/15.
//  Copyright (c) 2015 PayPal. All rights reserved.
//

import Foundation

private let formatter = NSDateFormatter()

class NSDatePresenter {
  
  private let date: NSDate
  
  init(_ date: NSDate) {
    self.date = date
  }
  
  private func format(dateFormat: String) -> String {
    formatter.dateFormat = dateFormat
    return formatter.stringFromDate(date)
  }
  
  var monthShortName: String      { return format("MMM") }
  var dayDoubleDigit: String      { return format("dd") }
  var longDayNameBigHour: String  { return format("EEEE, H:mm") }
  var shortDayNameBigHour: String { return format("E, H:mm") }
  var longDayName: String         { return format("EEEE") }
  
}
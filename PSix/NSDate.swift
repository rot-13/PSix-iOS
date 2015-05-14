//
//  NSDate.swift
//  PSix
//
//  Created by Turzion, Avihu on 4/26/15.
//  Copyright (c) 2015 PayPal. All rights reserved.
//

import Foundation

private let formatter = NSDateFormatter()

extension NSDate {
  var monthShortName: String {
    formatter.dateFormat = "MMM"
    return formatter.stringFromDate(self)
  }
  
  var dayDoubleDigit: String {
    formatter.dateFormat = "dd"
    return formatter.stringFromDate(self)
  }
}
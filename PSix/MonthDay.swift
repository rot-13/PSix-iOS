//
//  MonthDay.swift
//  PSix
//
//  Created by Turzion, Avihu on 5/3/15.
//  Copyright (c) 2015 PayPal. All rights reserved.
//

import UIKit

@IBDesignable
class MonthDay: UIXibView {
  
  @IBOutlet private weak var monthLabel: UILabel!
  @IBOutlet private weak var dayLabel: UILabel!
  @IBOutlet private weak var view: UIView!
  
  @IBInspectable var date: NSDate? = NSDate() {
    didSet {
      updateUI()
    }
  }
  
  @IBInspectable var textColor: UIColor = UIColor.blackColor() {
    didSet {
      monthLabel.textColor = textColor
      dayLabel.textColor = textColor
    }
  }
  
  @IBInspectable var shadowColor: UIColor? {
    didSet {
      monthLabel.shadowColor = shadowColor
      dayLabel.shadowColor = shadowColor
    }
  }
  
  @IBInspectable var shadowOffset: CGSize = CGSize(width: 0, height: 0) {
    didSet {
      monthLabel.shadowOffset = shadowOffset
      dayLabel.shadowOffset = shadowOffset
    }
  }
  
  override func setup() {
    updateUI()
    monthLabel.textColor = textColor
    dayLabel.textColor = textColor
  }
  
  private func updateUI() {
    monthLabel.text = date?.monthShortName.uppercaseString
    dayLabel.text = date?.dayDoubleDigit
  }
  
}
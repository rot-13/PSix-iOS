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
  @IBOutlet private weak var containerView: UIView!
  @IBOutlet weak var background: UIView!
  
  private var datePresenter = NSDatePresenter(NSDate())
  
  @IBInspectable var showFrame: Bool = false {
    didSet {
      if showFrame {
        renderBorder()
      } else {
        containerView.layer.borderWidth = 0
      }
    }
  }
  
  @IBInspectable var frameColor: UIColor = UIColor.whiteColor() {
    didSet {
      if showFrame {
        containerView.layer.borderColor = frameColor.CGColor
      }
    }
  }
  
  @IBInspectable var frameWidth: CGFloat = 1 {
    didSet {
      if showFrame {
        containerView.layer.borderWidth = frameWidth
      }
    }
  }
  
  @IBInspectable var cornerRadius: CGFloat = 8 {
    didSet {
      if showFrame {
        containerView.layer.cornerRadius = cornerRadius
      }
    }
  }
  
  @IBInspectable var date: NSDate? = NSDate() {
    didSet {
      if let date = date {
        datePresenter = NSDatePresenter(date)
      }
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
    
    containerView.backgroundColor = UIColor.clearColor()
    let blurView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Light))
    blurView.frame = background.frame
    background.addSubview(blurView)
    containerView.layer.masksToBounds = true
  }
  
  private func updateUI() {
    monthLabel.text = datePresenter.monthShortName.uppercaseString
    dayLabel.text = datePresenter.dayDoubleDigit
  }
  
  private func renderBorder() {
    containerView.layer.borderWidth = frameWidth
    containerView.layer.borderColor = frameColor.CGColor
    containerView.layer.cornerRadius = cornerRadius
  }
  
}
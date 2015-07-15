//
//  PaymentSetupButton.swift
//  PSix
//
//  Created by Turzion, Avihu on 7/15/15.
//  Copyright (c) 2015 PayPal. All rights reserved.
//

import Foundation

private let kUnsetColor = UIColor(red: 1, green: 0.537, blue: 0.2, alpha: 1)

@IBDesignable
class PaymentSetupButton: UIXibView {
  
  @IBOutlet var containerView: UIView!
  @IBOutlet weak var setupFeeButton: UIButton!
  
  @IBInspectable var frameColor: UIColor = UIColor(red: 1, green: 0.537, blue: 0.2, alpha: 1) {
    didSet {
      containerView.layer.borderColor = frameColor.CGColor
    }
  }
  
  override func setup() {
    frameColor = kUnsetColor
  }
  
}
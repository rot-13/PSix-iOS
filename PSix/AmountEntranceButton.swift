//
//  PaymentSetupButton.swift
//  PSix
//
//  Created by Turzion, Avihu on 7/15/15.
//  Copyright (c) 2015 PayPal. All rights reserved.
//

import Foundation

typealias OnFinishedEnteringAmountBlock = (Int) -> ()

private let kUnsetStateColor = UIColor(red: 1, green: 0.537, blue: 0.2, alpha: 1)
private let kEditingStateColor = UIColor(red: 0.019, green: 0.56, blue: 1, alpha: 1)
private let kEnteredAmountStateColor = UIColor(red:0, green:0.741, blue:0.326, alpha:1)
private let kUnsetStateButtonLabel = "Enter Amount"

private enum PaymentState: Int {
  case Unset, Editing, EnteredAmount
}

@IBDesignable
class AmountEntranceButton: UIXibView {
  
  private var state: PaymentState = .Unset {
    didSet {
      switch(state) {
      case .Unset:
        color = unsetStateColor
      case .Editing:
        color = editingAmountColor
      case .EnteredAmount:
        color = enteredAmounColor
      }
    }
  }
  
  private var color: UIColor {
    set {
      containerView.layer.borderColor = newValue.CGColor
      setupFeeButton.setTitleColor(newValue, forState: .Normal)
    }
    get {
      return setupFeeButton.titleColorForState(.Normal)!
    }
  }
  
  var onFinishedEditingAmountBlock: OnFinishedEnteringAmountBlock?
  
  @IBOutlet var containerView: UIView!
  @IBOutlet weak var setupFeeButton: UIButton!
  
  @IBInspectable var payedAmount: Int?
  @IBInspectable var unsetStateColor: UIColor = kUnsetStateColor {
    didSet {
      if state == .Unset { state = .Unset }
    }
  }
  
  @IBInspectable var editingAmountColor: UIColor = kEditingStateColor {
    didSet {
      if state == .Editing { state = .Editing }
    }
  }
  @IBInspectable var enteredAmounColor: UIColor = kEnteredAmountStateColor {
    didSet {
      if state == .EnteredAmount { state = .EnteredAmount }
    }
  }
  
  override func setup() {
    if let amount = payedAmount {
      state = .EnteredAmount
    } else {
      state = .Unset
    }
  }
  
}
//
//  PaymentSetupButton.swift
//  PSix
//
//  Created by Turzion, Avihu on 7/15/15.
//  Copyright (c) 2015 PayPal. All rights reserved.
//

import Foundation

typealias ResponseBlock = () -> ()

protocol AmountEntranceButtonDelegate {
  func startedEditingAmount(sender: AmountEntranceButton)
  func finishedEditingAmount(newAmount: Double?)
  func canceledEditing()
  func validateAmountToBeCleared(yes: ResponseBlock, no: ResponseBlock)
}

private let kUnsetStateColor = UIColor(red: 1, green: 0.537, blue: 0.2, alpha: 1)
private let kEditingStateColor = UIColor(red: 0.019, green: 0.56, blue: 1, alpha: 1)
private let kEnteredAmountStateColor = UIColor(red:0, green:0.741, blue:0.326, alpha:1)
private let kUnsetStateButtonLabel = "Enter Amount"

private enum PaymentState {
  case Unset
  case Editing
  case Set
}

private enum DisplayedElement {
  case Button
  case TextField
  case None
}

@IBDesignable
class AmountEntranceButton: UIXibView {
  
  private var actualState: PaymentState = .Unset
  
  private var state: PaymentState {
    set {
      displayedElement = .None
      previousState = actualState
      actualState = newValue
      
      switch(state) {
      case .Unset:
        color = unsetStateColor
        setupFeeButton.setTitle(amountEntranceLabel, forState: .Normal)
        displayedElement = .Button
      case .Editing:
        color = editingAmountColor
        displayedElement = .TextField
      case .Set:
        setupFeeButton.setTitle("$\(fee!)", forState: .Normal)
        color = enteredAmounColor
        displayedElement = .Button
      }
    }
    
    get {
      return actualState
    }
  }
  
  private var previousState: PaymentState?
  
  private var displayedElement: DisplayedElement = .Button {
    didSet {
      switch(displayedElement) {
      case .Button:
        setupFeeButton.hidden = false
        amountEntranceField.hidden = true
      case .TextField:
        setupFeeButton.hidden = true
        amountEntranceField.hidden = false
      case .None:
        setupFeeButton.hidden = true
        amountEntranceField.hidden = true
      }
    }
  }
  
  private var color: UIColor = kUnsetStateColor {
    didSet {
      containerView.layer.borderColor = color.CGColor
      setupFeeButton.setTitleColor(color, forState: .Normal)
      amountEntranceField.tintColor = color
      amountEntranceField.textColor = color
    }
  }
  
  var delegate: AmountEntranceButtonDelegate?
  
  @IBOutlet var containerView: UIView!
  @IBOutlet weak var setupFeeButton: UIButton!
  @IBOutlet weak var amountEntranceField: UITextField!
  
  @IBInspectable var amountEntranceLabel: String = "Enter Amount" {
    didSet {
      if state == .Unset {
        setupFeeButton.setTitle(amountEntranceLabel, forState: .Normal)
      }
    }
  }
  
  @IBInspectable var fee: Double? {
    didSet {
      if fee != nil {
        state = .Set
      } else {
        state = .Unset
      }
    }
  }
  
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
      if state == .Set { state = .Set }
    }
  }
  
  @IBInspectable var cornerRadius: CGFloat = 5 {
    didSet { containerView.layer.cornerRadius = cornerRadius }
  }
  
  @IBInspectable var borderWidth: CGFloat = 1 {
    didSet { containerView.layer.borderWidth = borderWidth }
  }
  
  override func setup() {
    amountEntranceField.delegate = self
    if let amount = fee {
      state = .Set
    } else {
      state = .Unset
    }
  }
  
  @IBAction func onChangeAmount() {
    state = .Editing
    delegate?.startedEditingAmount(self)
    amountEntranceField.becomeFirstResponder()
  }
  
  func cancelEditing() {
    delegate?.canceledEditing()
    if let previousState = previousState {
      state = previousState
    } else {
      state = .Unset
    }
    amountEntranceField.resignFirstResponder()
  }
  
  func doneEditing() {
    finishedEnteringAmount()
  }
  
  private func finishedEnteringAmount() {
    amountEntranceField.resignFirstResponder()
    let amountText = amountEntranceField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    let newFee = (amountText as NSString).doubleValue
    if newFee == 0 && previousState == .Set {
      if let delegate = delegate {
        delegate.validateAmountToBeCleared({
          println("confirmed clearing fee")
          self.fee = nil
          self.delegate?.finishedEditingAmount(nil)
        }, no: {
          self.amountEntranceField.text = "\(self.fee!)"
          self.amountEntranceField.becomeFirstResponder()
        })
      } else {
        fee = nil
        delegate?.finishedEditingAmount(nil)
      }
    } else if newFee != 0 {
      fee = newFee
      state = .Set
      delegate?.finishedEditingAmount(fee)
    } else {
      state = .Unset
      delegate?.canceledEditing()
    }
  }
  
}

extension AmountEntranceButton: UITextFieldDelegate {
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    finishedEnteringAmount()
    return true
  }
  
}
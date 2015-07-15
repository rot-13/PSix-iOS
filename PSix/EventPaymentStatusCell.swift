//
//  EventPaymentStatusCell.swift
//  PSix
//
//  Created by Turzion, Avihu on 5/7/15.
//  Copyright (c) 2015 PayPal. All rights reserved.
//

import UIKit

class EventPaymentStatusCell: UITableViewCell {
  
  @IBOutlet weak var paidOutOfTotal: UILabel!
  
  var event: Event? {
    didSet {
      if let event = event {
        let presenter = EventPresenter(event)
        paidOutOfTotal.text = presenter.paymentStatus
      }
    }
  }
  
}
//
//  EventDetailsCoverView.swift
//  PSix
//
//  Created by Turzion, Avihu on 5/7/15.
//  Copyright (c) 2015 PayPal. All rights reserved.
//

import UIKit

class EventDetailsCoverView: UIXibView {
  
  @IBOutlet private weak var coverImageView: ShadedImageView!
  @IBOutlet private weak var eventDateView: MonthDay!
  @IBOutlet private weak var eventTitleLabel: UILabel!
  
  var event: Event? {
    didSet {
      updateUI()
    }
  }
  
  private func updateUI() {
    if let event = event {
      let presenter = EventPresenter(event)
      eventDateView.date = event.startTime
      eventTitleLabel.text = presenter.title
      presenter.getCoverImageAsync { [unowned self] (coverImage) -> Void in
        self.coverImageView.image = coverImage
      }
    }
  }
  
}

//
//  EventDetailsViewController.swift
//  PSix
//
//  Created by Turzion, Avihu on 5/5/15.
//  Copyright (c) 2015 PayPal. All rights reserved.
//

import UIKit

class EventDetailsViewController: UIViewController {
    
    @IBOutlet var baseView: UIView!
    @IBOutlet weak var emptyStateLabel: UILabel!
    @IBOutlet weak var eventInformationTable: UITableView!
    
    private let emptyStateBackgroundColor = UIColor(red: 240, green: 240, blue: 240, alpha: 1)
    
    var event: Event? {
        didSet {
            if self.isViewLoaded() {
                updateUI()
            }
        }
    }
    
    override func viewDidLoad() {
        updateUI()
    }
    
    private func updateUI() {
        if let event = event {
            emptyStateLabel.hidden = true
            eventInformationTable.hidden = false
            
            let presenter = EventPresenter(event)
            baseView.backgroundColor = UIColor.whiteColor()
        } else {
            emptyStateLabel.hidden = false
            eventInformationTable.hidden = true
            
            baseView.backgroundColor = emptyStateBackgroundColor
        }
    }

}
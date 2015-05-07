//
//  EventDetailsViewController.swift
//  PSix
//
//  Created by Turzion, Avihu on 5/5/15.
//  Copyright (c) 2015 PayPal. All rights reserved.
//

import UIKit

class EventDetailsViewController: UIViewController {
    
    private struct CellType {
        static let COVER = "EventDetailsCoverCell"
        static let PAYMENT_STATUS = "EventDetailsPaymentStatusCell"
        static let RSVP_TPYE = "EventDetailsRsvpSelectionCell"
        static let RSVP = "EventDetailsRsvpCell"
    }
    
    @IBOutlet var baseView: UIView!
    @IBOutlet weak var emptyStateLabel: UILabel!
    @IBOutlet weak var eventInformationTable: UITableView!
    
    private let emptyStateBackgroundColor = UIColor(red: 240, green: 240, blue: 240, alpha: 1)
    
    private var previousHideBarsOnSwipe: Bool?
    private var previousHidesBarsWhenVerticallyCompact: Bool?
    
    var event: Event? {
        didSet {
            if self.isViewLoaded() {
                updateUI()
            }
        }
    }
    
    private func setNavHideOptions() {
        previousHideBarsOnSwipe = self.navigationController?.hidesBarsOnSwipe
        previousHidesBarsWhenVerticallyCompact = self.navigationController?.hidesBarsWhenVerticallyCompact
        
        self.navigationController?.hidesBarsOnSwipe = true
        self.navigationController?.hidesBarsWhenVerticallyCompact = true
    }
    
    private func unsetNavHideOptions() {
        self.navigationController?.hidesBarsOnSwipe = previousHideBarsOnSwipe ?? false
        self.navigationController?.hidesBarsWhenVerticallyCompact = previousHidesBarsWhenVerticallyCompact ?? false
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        println("Setting nav options")
        setNavHideOptions()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        println("Unsetting nav options")
        unsetNavHideOptions()
    }
    
    override func viewDidLoad() {
        updateUI()
        
        eventInformationTable.delegate = self
        eventInformationTable.dataSource = self
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

private enum SectionTypes: Int {
    case Header = 0, RSVPs
    
    static let allValues = [Header, RSVPs]
}

private enum HeaderCellTypes: Int {
    case Cover = 0, PaymentStatus, RsvpTypeSelection
    
    static let allValues = [Cover, PaymentStatus, RsvpTypeSelection]
}

private let DEFAULT_ROW_HEIGHT = CGFloat(44)

extension EventDetailsViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if SectionTypes(rawValue: indexPath.section) == .Header {
            if let cellType = HeaderCellTypes(rawValue: indexPath.row) {
                switch cellType {
                case .Cover: return eventInformationTable.frame.width / 2
                default: return DEFAULT_ROW_HEIGHT
                }
            }
        }
        return DEFAULT_ROW_HEIGHT
    }
    
}

extension EventDetailsViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return SectionTypes.allValues.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sectionType = SectionTypes(rawValue: section) {
            switch sectionType {
            case .Header: return HeaderCellTypes.allValues.count
            case .RSVPs: return 0
            }
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let sectionType = SectionTypes(rawValue: indexPath.section) {
            switch sectionType {
            case .Header:
                return createHeaderCell(HeaderCellTypes(rawValue: indexPath.row))
            case .RSVPs:
                return UITableViewCell()
            }
        }
        return UITableViewCell()
    }
    
    private func createRsvpCell(rsvpIndex: Int) -> UITableViewCell {
        return eventInformationTable.dequeueReusableCellWithIdentifier(CellType.RSVP) as! UITableViewCell
    }
    
    private func createHeaderCell(headerCellType: HeaderCellTypes?) -> UITableViewCell {
        if let type = headerCellType {
            switch type {
            case .Cover:
                let cell = eventInformationTable.dequeueReusableCellWithIdentifier(CellType.COVER) as! EventCoverCell
                cell.event = event
                return cell
            case .PaymentStatus:
                let cell = eventInformationTable.dequeueReusableCellWithIdentifier(CellType.PAYMENT_STATUS) as! EventPaymentStatusCell
                cell.event = event
                return cell
            case .RsvpTypeSelection:
                return eventInformationTable.dequeueReusableCellWithIdentifier(CellType.RSVP_TPYE) as! RsvpSelectionCell
            }
        }
        return UITableViewCell()
    }
    
}
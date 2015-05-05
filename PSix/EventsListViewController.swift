//
//  EventsListViewController.swift
//  PSix
//
//  Created by Turzion, Avihu on 4/13/15.
//  Copyright (c) 2015 PayPal. All rights reserved.
//

import UIKit

class EventsListViewController: UIViewController {
    
    static let EVENT_CELL_ID = "EventCell"
    
    private var userCreatedEvents = Events() {
        didSet {
            sort(&userCreatedEvents)
            updateUI()
        }
    }
    
    private(set) var eventSelected: Bool = false
    
    @IBOutlet weak var eventsListTable: UITableView!
    @IBOutlet weak var noEventsRefreshSpinner: UIActivityIndicatorView!
    
    private let refreshControl = UIRefreshControl()
    
    private func updateUserEvents(finished: (() -> ())? = nil) {
        if let currentUser = ParseUserSession.currentUser {
            refreshControl.beginRefreshing()
            FacebookService.getFutureEventsCreatedByUserAsync(currentUser) { [unowned self] (events) -> Void in
                self.userCreatedEvents = events
                self.refreshControl.endRefreshing()
                finished?()
            }
        }
    }
    
    override func viewDidLoad() {
        refreshControl.addTarget(self, action: "refreshData", forControlEvents: UIControlEvents.ValueChanged)
        eventsListTable.addSubview(refreshControl)
        
        if ParseUserSession.isLoggedIn {
            updateUserEvents()
        }
        
        eventsListTable.dataSource = self
        eventsListTable.delegate = self
    }
    
    func refreshData() {
        updateUserEvents()
    }
    
    func updateUI() {
        eventsListTable.reloadData()
        eventsListTable.hidden = userCreatedEvents.count == 0
    }
    
    @IBAction func refreshForNewEvents() {
        noEventsRefreshSpinner.startAnimating()
        updateUserEvents() { [unowned self] in
            self.noEventsRefreshSpinner.stopAnimating()
        }
    }
    
}

extension EventsListViewController: UITableViewDelegate {

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        eventSelected = true
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        eventSelected = false
    }
    
}

extension EventsListViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userCreatedEvents.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = eventsListTable.dequeueReusableCellWithIdentifier(EventsListViewController.EVENT_CELL_ID, forIndexPath: indexPath) as! EventCell
        
        cell.event = userCreatedEvents[indexPath.row]
        
        return cell
    }
    
}

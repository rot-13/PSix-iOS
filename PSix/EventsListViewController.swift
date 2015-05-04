//
//  EventsListViewController.swift
//  PSix
//
//  Created by Turzion, Avihu on 4/13/15.
//  Copyright (c) 2015 PayPal. All rights reserved.
//

import UIKit
import Parse

class EventsListViewController: UIViewController {
    
    static let EVENT_CELL_ID = "EventCell"
    
    private var userCreatedEvents = Events() {
        didSet {
            sort(&userCreatedEvents)
            updateUI()
        }
    }
    
    @IBOutlet weak var eventsListTable: UITableView!
    @IBOutlet weak var noEventsRefreshSpinner: UIActivityIndicatorView!
    
    let refreshControl = UIRefreshControl()
    
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
        
        if !ParseUserSession.isLoggedIn {
            presentUserOnboarding()
        } else {
            updateUserEvents()
        }
        
        eventsListTable.dataSource = self
        eventsListTable.delegate = self
    }
    
    func refreshData() {
        updateUserEvents()
    }
    
    private func presentUserOnboarding() {
        let onboardingStoryboard = UIStoryboard(name: "Onboarding", bundle: nil)
        let onboardingVC = onboardingStoryboard.instantiateViewControllerWithIdentifier("OnboardingViewController") as! OnboardingViewController
        onboardingVC.successfulLoginCallback = { [unowned self] () -> Void in
            self.updateUserEvents()
            onboardingVC.dismissViewControllerAnimated(true, completion: nil)
        }
        presentViewController(onboardingVC, animated: true, completion: nil)
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


extension EventsListViewController: UITableViewDelegate {}


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

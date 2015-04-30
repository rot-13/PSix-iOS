//
//  EventsListViewController.swift
//  PSix
//
//  Created by Turzion, Avihu on 4/13/15.
//  Copyright (c) 2015 PayPal. All rights reserved.
//

import UIKit
import Parse

class EventsListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    static let EVENT_CELL_ID = "EventCell"
    
    private var userCreatedEvents = Events() {
        didSet {
            sort(&userCreatedEvents)
            updateUI()
        }
    }
    
    @IBOutlet weak var eventsListTable: UITableView!
    let refreshControl = UIRefreshControl()
    
    private func updateUserEvents(finished: (() -> ())? = nil) {
        if let currentUser = ParseUserSession.currentUser {
            FacebookService.getFutureEventsCreatedByUserAsync(currentUser) { [unowned self] (events) -> Void in
                self.userCreatedEvents = events
                finished?()
            }
        }
    }
    
    override func viewDidLoad() {
        refreshControl.addTarget(self, action: "refreshData", forControlEvents: UIControlEvents.ValueChanged)
        eventsListTable.addSubview(refreshControl)
        
        if !ParseUserSession.isLoggedIn {
            getUserOnboard()
        } else {
            updateUserEvents()
        }
        
        eventsListTable.dataSource = self
        eventsListTable.delegate = self
    }
    
    func refreshData() {
        updateUserEvents() { [unowned self] () -> Void in
            self.refreshControl.endRefreshing()
        }
    }
    
    private func getUserOnboard() {
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
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userCreatedEvents.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = eventsListTable.dequeueReusableCellWithIdentifier(EventsListViewController.EVENT_CELL_ID, forIndexPath: indexPath) as! EventCell
        
        cell.event = userCreatedEvents[indexPath.row]
        
        return cell
    }
    
}
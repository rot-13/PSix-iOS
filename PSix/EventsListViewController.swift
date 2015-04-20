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
    
    private var userCreatedEvents = Events()
    
    @IBOutlet weak var eventsListTable: UITableView!
    
    override func viewWillAppear(animated: Bool) {
        if !ParseUserSession.isLoggedIn {
            let onboardingStoryboard = UIStoryboard(name: "Onboarding", bundle: nil)
            let onboardingVC = onboardingStoryboard.instantiateViewControllerWithIdentifier("OnboardingViewController") as! UIViewController
            presentViewController(onboardingVC, animated: true, completion: nil)
        } else if let currentUser = ParseUserSession.currentUser {
            FacebookService.getFutureEventsCreatedByUser(currentUser) { [unowned self] (events) -> Void in
                self.userCreatedEvents = events
                self.updateUI()
            }
        }
        
        eventsListTable.dataSource = self
        eventsListTable.delegate = self
    }
    
    func updateUI() {
        eventsListTable.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userCreatedEvents.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = eventsListTable.dequeueReusableCellWithIdentifier(EventsListViewController.EVENT_CELL_ID, forIndexPath: indexPath) as! UITableViewCell
        
        let event = userCreatedEvents[indexPath.row]
        cell.textLabel?.text = event.name
        cell.detailTextLabel?.text = event.eventDescription
        
        return cell
    }
    
}
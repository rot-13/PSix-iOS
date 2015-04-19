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
        } else {
            if let currentUser = ParseUserSession.currentUser {
                FacebookService.getFutureEventsCreatedByUser(currentUser, failure: nil, success: extractEventsFromFbResponse)
            }
        }
        
        eventsListTable.dataSource = self
        eventsListTable.delegate = self
    }
    
    func extractEventsFromFbResponse(events: NSDictionary) {
        if let data = events["data"] as? NSArray {
            for eventData in data {
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = eventsListTable.dequeueReusableCellWithIdentifier(EventsListViewController.EVENT_CELL_ID, forIndexPath: indexPath) as! UITableViewCell
        
        cell.textLabel?.text = "Event Name"
        cell.detailTextLabel?.text = "Event description"
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CGFloat(50)
    }
    
}
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
            FacebookService.getFutureEventsCreatedByUser(currentUser, failure: nil) { [unowned self] (eventsData) -> Void in
                self.extractEventsFromFbResponse(eventsData)
                self.updateUI()
            }
        }
        
        eventsListTable.dataSource = self
        eventsListTable.delegate = self
    }
    
    func updateUI() {
        eventsListTable.reloadData()
    }
    
    func extractEventsFromFbResponse(events: NSDictionary) {
        if let data = events["data"] as? NSArray {
            for eventData in data {
                if let fbId = eventData["id"] as? String,
                   let ownerFbId = ParseUserSession.currentUser?["facebookId"] as? String,
                   let name = eventData["name"] as? String {
                    let event = Event(fbId: fbId, ownerFbId: ownerFbId, name: name)
                    if let eventDescription = eventData["description"] as? String {
                        event.eventDescription = eventDescription
                    }
                    if let location = eventData["location"] as? String {
                        event.location = location
                    }
                    event.saveEventually()
                    userCreatedEvents.append(event)
                    
                } else {
                    println("Missing event information. Event object was not created.")
                }
            }
        }
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
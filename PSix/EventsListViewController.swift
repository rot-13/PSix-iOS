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
  
  @IBOutlet weak var initialDataLoadingSpinner: UIActivityIndicatorView!
  @IBOutlet weak var eventsListTable: UITableView!
  @IBOutlet weak var noEventsRefreshSpinner: UIActivityIndicatorView!
  @IBOutlet weak var eventTypesTabBar: UITabBar!
  
  private var initialDataLoading = false
  private let refreshControl = UIRefreshControl()
  private var eventSelected = false
  private var selectedEvent: Event?
  
  private func updateUserEvents(finished: (() -> ())? = nil) {
    if let currentUser = ParseUserSession.currentUser {
      FacebookService.getFutureEventsCreatedByUserAsync(currentUser) { [unowned self] (events) -> Void in
        if self.initialDataLoading {
          self.stopInitialDataLoadingSpinner()
        } else {
          self.refreshControl.endRefreshing()
        }
        self.userCreatedEvents = events
        finished?()
      }
    }
  }
  
  override func viewDidLoad() {
    refreshControl.addTarget(self, action: "refreshData", forControlEvents: UIControlEvents.ValueChanged)
    eventsListTable.addSubview(refreshControl)
    
    ParseUserSession.delegate = self
    
    if ParseUserSession.isLoggedIn {
      startInitialDataLoadingSpinner()
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
    eventTypesTabBar.hidden = eventsListTable.hidden
    navigationController?.navigationBarHidden = eventsListTable.hidden
  }
  
  @IBAction func refreshForNewEvents() {
    noEventsRefreshSpinner.startAnimating()
    updateUserEvents() { [unowned self] in
      self.noEventsRefreshSpinner.stopAnimating()
    }
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if let eventDetailsVC = segue.destinationViewController as? EventDetailsViewController {
      eventDetailsVC.event = selectedEvent
    }
  }
  
  private func startInitialDataLoadingSpinner() {
    initialDataLoading = true
    initialDataLoadingSpinner.hidden = false
    initialDataLoadingSpinner.startAnimating()
  }
  
  private func stopInitialDataLoadingSpinner() {
    initialDataLoading = false
    
    let fadeOutTransition = CATransition()
    fadeOutTransition.type = kCATransitionFade
    fadeOutTransition.duration = 0.4
    initialDataLoadingSpinner.layer.addAnimation(fadeOutTransition, forKey: nil)
    
    initialDataLoadingSpinner.hidden = true
    initialDataLoadingSpinner.stopAnimating()
  }
  
}

// MARK: ParseUserSessionDelegate extension

extension EventsListViewController: ParseUserSessionDelegate {
  func userLoggedIn() {
    updateUserEvents()
  }
}

// MARK: UITableViewDelegate extension

extension EventsListViewController: UITableViewDelegate {
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    selectedEvent = userCreatedEvents[indexPath.row]
    performSegueWithIdentifier("ShowEventDetailsSegue", sender: self)
  }
}

// MARK: UITableViewDataSource extension

extension EventsListViewController: UITableViewDataSource {
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return userCreatedEvents.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = eventsListTable.dequeueReusableCellWithIdentifier(EventsListViewController.EVENT_CELL_ID, forIndexPath: indexPath) as! EventCell
    cell.event = userCreatedEvents[indexPath.row]
    cell.delegate = self
    return cell
  }
  
}

// MARK: AmountEntranceButtonDelegate

extension EventsListViewController: EventCellDelegate {
  
  func enterEditMode(sender: EventCell) {
    navigationItem.leftBarButtonItem = createEditModeCancelButton(sender)
    navigationItem.rightBarButtonItem = createEditModeDoneButton(sender)
  }
  
  func leaveEditMode() {
    navigationItem.leftBarButtonItem = nil
    navigationItem.rightBarButtonItem = nil
  }
  
  private func createEditModeCancelButton(target: EventCell) -> UIBarButtonItem {
    return UIBarButtonItem(title: "Cancel", style: .Plain, target: target, action: "cancelEditing")
  }
  
  private func createEditModeDoneButton(target: EventCell) -> UIBarButtonItem {
    return UIBarButtonItem(title: "Done", style: .Plain, target: target, action: "doneEditing")
  }
  
}
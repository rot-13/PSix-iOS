//
//  P6RootViewController.swift
//  PSix
//
//  Created by Turzion, Avihu on 5/5/15.
//  Copyright (c) 2015 PayPal. All rights reserved.
//

import UIKit

class P6RootViewController: UISplitViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let eventsVC = UIViewController.fromStoryboard("EventsList", controllerIdentifier: "EventsListNavigationViewController"),
           let eventDetailVC = UIViewController.fromStoryboard("EventDetails", controllerIdentifier: "EventDetailsNavigationViewController") {
            self.viewControllers = [eventsVC, eventDetailVC]
        }
    }

}
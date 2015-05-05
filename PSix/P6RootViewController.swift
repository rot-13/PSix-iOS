//
//  P6RootViewController.swift
//  PSix
//
//  Created by Turzion, Avihu on 5/5/15.
//  Copyright (c) 2015 PayPal. All rights reserved.
//

import UIKit

class P6RootViewController: UISplitViewController {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        if let eventsNavVC = UIViewController.fromStoryboard("EventsList", controllerIdentifier: "EventsListNavigationViewController") as? UINavigationController,
            let eventDetailVC = UIViewController.fromStoryboard("EventDetails", controllerIdentifier: "EventDetailsNavigationViewController"),
            let eventsVC = eventsNavVC.viewControllers[0] as? EventsListViewController {
                self.viewControllers = [eventsNavVC, eventDetailVC]
                self.delegate = eventsVC
        }
    }

}

extension EventsListViewController: UISplitViewControllerDelegate {
    
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController!, ontoPrimaryViewController primaryViewController: UIViewController!) -> Bool {
        return !eventSelected
    }
    
}
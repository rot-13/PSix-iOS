//
//  P6RootViewController.swift
//  PSix
//
//  Created by Turzion, Avihu on 5/5/15.
//  Copyright (c) 2015 PayPal. All rights reserved.
//

import UIKit

class P6RootViewController: UISplitViewController {
    
    private var eventsListVC: EventsListViewController? = nil
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        if let eventsNavVC = UIViewController.fromStoryboard("EventsList", controllerIdentifier: "EventsListNavigationViewController") as? UINavigationController,
           let eventDetailNavVC = UIViewController.fromStoryboard("EventDetails", controllerIdentifier: "EventDetailsNavigationViewController") as? UINavigationController,
           let eventsListVC = eventsNavVC.viewControllers[0] as? EventsListViewController,
           let eventDetailsVC = eventDetailNavVC.viewControllers[0] as? EventDetailsViewController {
            
            self.eventsListVC = eventsListVC
            self.viewControllers = [eventsNavVC, eventDetailNavVC]
            self.delegate = self
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        if !ParseUserSession.isLoggedIn {
            presentUserOnboarding()
        }
    }
    
    private func presentUserOnboarding() {
        let onboardingVC = UIViewController.fromStoryboard("Onboarding", controllerIdentifier: "OnboardingViewController") as! OnboardingViewController
        onboardingVC.successfulLoginCallback = { [unowned self] in
            self.eventsListVC?.refreshData()
            onboardingVC.dismissViewControllerAnimated(true, completion: nil)
        }
        presentViewController(onboardingVC, animated: true, completion: nil)
    }

}

extension P6RootViewController: UISplitViewControllerDelegate {
    
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController!, ontoPrimaryViewController primaryViewController: UIViewController!) -> Bool {
        return true
    }
    
}
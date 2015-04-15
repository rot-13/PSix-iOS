//
//  EventsListViewController.swift
//  PSix
//
//  Created by Turzion, Avihu on 4/13/15.
//  Copyright (c) 2015 PayPal. All rights reserved.
//

import UIKit

class EventsListViewController: UIViewController {
    
    override func viewWillAppear(animated: Bool) {
        if !User.isLoggedIn() {
            let onboardingStoryboard = UIStoryboard(name: "Onboarding", bundle: nil)
            let onboardingVC = onboardingStoryboard.instantiateViewControllerWithIdentifier("OnboardingViewController") as! UIViewController
            presentViewController(onboardingVC, animated: true, completion: nil)
        }
    }
    
}
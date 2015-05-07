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
        self.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if !ParseUserSession.isLoggedIn {
            presentUserOnboarding()
        }
    }
    
    private func presentUserOnboarding() {
        let onboardingVC = UIViewController.fromStoryboard("Onboarding", controllerIdentifier: "OnboardingViewController") as! OnboardingViewController
        onboardingVC.successfulLoginCallback = { [unowned self] in
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
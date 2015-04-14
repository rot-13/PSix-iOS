//
//  OnboardingViewController.swift
//  PSix
//
//  Created by Turzion, Avihu on 4/13/15.
//  Copyright (c) 2015 PayPal. All rights reserved.
//

import UIKit
import Parse

class OnboardingViewController: UIViewController {
    
    enum LoginMode {
        case Login, Logout
    }
    
    private let LOGIN_BUTTON_TITLE = "Login with Facebook"
    private let LOGOUT_BUTTON_TITLE = "Sign out"
    
    private var loginMode: LoginMode = .Login
    
    @IBOutlet weak var loginButton: UIButton!

    @IBAction func loginButtonClicked(sender: UIButton) {
        switch loginMode {
        case .Login:
            PFFacebookUtils.logInInBackgroundWithReadPermissions(["public_profile", "user_events"]) { (user, error) -> Void in
                if let user = user {
                    self.setToLogoutMode()
                }
            }
        case .Logout:
            CurrentUser.logout()
            self.setToLoginMode()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        if CurrentUser.isLoggedIn() {
            setToLoginMode()
        } else {
            setToLogoutMode()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func setToLoginMode() {
        loginButton.setTitle(LOGIN_BUTTON_TITLE, forState: UIControlState.Normal)
        loginMode = .Login
    }
    
    private func setToLogoutMode() {
        loginButton.setTitle(LOGOUT_BUTTON_TITLE, forState: UIControlState.Normal)
        loginMode = .Logout
    }
    
}

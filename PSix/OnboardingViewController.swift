//
//  OnboardingViewController.swift
//  PSix
//
//  Created by Turzion, Avihu on 4/13/15.
//  Copyright (c) 2015 PayPal. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    enum LoginMode {
        case Login, Logout, DuringLogin
    }
    
    private let LOGIN_BUTTON_TITLE = "Login with Facebook"
    private let LOGOUT_BUTTON_TITLE = "Sign out"
    private let LOGGING_IN_BUTTON_TITLE = "Logging in..."
    private let FB_BLUE_COLOR = UIColor(red: 59.0/255.0, green: 89.0/255.0, blue: 152.0/255, alpha: 1.0)
    
    private var loginMode: LoginMode = .Login
    
    @IBOutlet weak var loginButton: UIButton!

    @IBAction func loginButtonClicked(sender: UIButton) {
        switch loginMode {
        case .Login:
            setLoggingInMode()
            CurrentUser.loginWithFacebook(["public_profile", "user_events"]) {
                (user, error) -> Void in
                if let user = user {
                    self.setToLogoutMode()
                    self.performSegueWithIdentifier("showEventsList", sender: self)
                }
            }
        case .Logout:
            CurrentUser.logout()
            self.setToLoginMode()
        case .DuringLogin: break
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
        setButtonActive()
        loginButton.setTitle(LOGIN_BUTTON_TITLE, forState: UIControlState.Normal)
        loginMode = .Login
    }
    
    private func setToLogoutMode() {
        setButtonActive()
        loginButton.setTitle(LOGOUT_BUTTON_TITLE, forState: UIControlState.Normal)
        loginMode = .Logout
    }
    
    private func setLoggingInMode() {
        setButtonInactive()
        loginButton.setTitle(LOGGING_IN_BUTTON_TITLE, forState: UIControlState.Normal)
    }
    
    private func setButtonInactive() {
        loginButton.enabled = false
        loginButton.backgroundColor = UIColor.grayColor()
    }
    
    private func setButtonActive() {
        loginButton.enabled = true
        loginButton.backgroundColor = FB_BLUE_COLOR
    }
    
}

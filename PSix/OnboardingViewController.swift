//
//  OnboardingViewController.swift
//  PSix
//
//  Created by Turzion, Avihu on 4/13/15.
//  Copyright (c) 2015 PayPal. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    enum LoginState {
        case Login, Logout, DuringLogin
        func buttonTitle() -> String {
            switch self {
            case .Login: return "Login with Facebook"
            case .Logout: return "Sign out"
            case .DuringLogin: return "Loggin in..."
            }
        }
    }
    
    private let FB_BLUE_COLOR = UIColor(red: 59.0/255.0, green: 89.0/255.0, blue: 152.0/255, alpha: 1.0)
    
    private var loginState: LoginState = .Login
    
    var successfulLoginCallback: (() -> ())? = nil
    
    @IBOutlet weak var loginButton: UIButton!

    @IBAction func loginButtonClicked(sender: UIButton) {
        switch loginState {
        case .Login:
            setLoggingInMode()
            ParseUserSession.loginWithFacebook() { [unowned self] (user) -> Void in
                if ParseUserSession.isLoggedIn {
                    self.didSignIn()
                }
            }
        case .Logout:
            ParseUserSession.logout()
            setToLoginState()
        case .DuringLogin: break
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        if !ParseUserSession.isLoggedIn {
            setToLoginState()
        } else {
            setToLogoutMode()
        }
    }
    
    private func didSignIn() {
        setToLogoutMode()
        successfulLoginCallback?()
    }
    
    private func updateLoginButtonTitle() {
        loginButton.setTitle(loginState.buttonTitle(), forState: UIControlState.Normal)
    }
    
    private func setToLoginState() {
        loginState = .Login
        setButtonActive()
        updateLoginButtonTitle()
    }
    
    private func setToLogoutMode() {
        loginState = .Logout
        setButtonActive()
        updateLoginButtonTitle()
    }
    
    private func setLoggingInMode() {
        setButtonInactive()
        updateLoginButtonTitle()
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

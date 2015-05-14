//
//  UIViewController.swift
//  PSix
//
//  Created by Turzion, Avihu on 5/5/15.
//  Copyright (c) 2015 PayPal. All rights reserved.
//

import Foundation

extension UIViewController {
  
  static func fromStoryboard(storyboardName: String, controllerIdentifier: String) -> UIViewController? {
    let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
    return storyboard.instantiateViewControllerWithIdentifier(controllerIdentifier) as? UIViewController
  }
  
}
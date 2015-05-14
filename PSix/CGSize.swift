//
//  UIImage.swift
//  PSix
//
//  Created by Turzion, Avihu on 5/13/15.
//  Copyright (c) 2015 PayPal. All rights reserved.
//

import Foundation

extension CGSize {
  
  var aspectRatio: CGFloat {
    return height > 0 ? width / height : 0
  }
  
}
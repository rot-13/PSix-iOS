//
//  CGRect.swift
//  PSix
//
//  Created by Turzion, Avihu on 6/10/15.
//  Copyright (c) 2015 PayPal. All rights reserved.
//

import Foundation

private let zeroPoint = CGPoint(x: 0, y: 0)

extension CGRect {
  
  static func fromAxisWith(#size: CGSize) -> CGRect {
    return CGRect(origin: zeroPoint, size: size)
  }
  
}
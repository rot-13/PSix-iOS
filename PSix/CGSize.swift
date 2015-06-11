//
//  UIImage.swift
//  PSix
//
//  Created by Turzion, Avihu on 5/13/15.
//  Copyright (c) 2015 PayPal. All rights reserved.
//

import Foundation

extension CGSize {
  
  /**
    Width / Height
  */
  var aspectRatio: CGFloat {
    return height > 0 ? width / height : 0
  }
  
  func sizeThatFitsInside(#extents: CGSize) -> CGSize {
    if self.aspectRatio < extents.aspectRatio {
      println("AR1 is bigger")
      return CGSize(width: self.width, height: self.width / extents.aspectRatio)
    } else if self.aspectRatio > extents.aspectRatio {
      println("AR2 is bigger")
      return CGSize(width: self.height * extents.aspectRatio, height: self.height)
    }
    return self
  }
  
}
//
//  DarkenedImageView.swift
//  PSix
//
//  Created by Turzion, Avihu on 5/3/15.
//  Copyright (c) 2015 PayPal. All rights reserved.
//

import UIKit

class ShadedImageView: UIXibView {
  
  enum ShadeType {
    case None, TopLeft, Bottom
    init(_ rawValue: String) {
      switch rawValue.lowercaseString {
      case "topleft": self = .TopLeft
      case "bottom": self = .Bottom
      default: self = .None
      }
    }
  }
  
  @IBOutlet private weak var imageView: UIImageView!
  @IBOutlet private weak var shadeImageView: UIImageView!
  
  private var shadeImage: UIImage?
  private var _shadeType: ShadeType = .None {
    didSet {
      shadeImage = UIImage.fromShadeType(_shadeType)
    }
  }
  
  @IBInspectable var shadeType: String = "None" {
    didSet {
      _shadeType = ShadeType(shadeType)
    }
  }
  
  @IBInspectable var placeholderImage: UIImage? {
    didSet {
      if image == nil {
        setPlaceholderImage()
      }
    }
  }
  
  @IBInspectable var image: UIImage? {
    didSet {
      if let newImage = image {
        setImage(newImage)
      } else {
        setPlaceholderImage()
      }
    }
  }
  
  private func setImage(newImage: UIImage) {
    imageView.image = newImage.cropCenterToFit(extents: imageView.bounds.size)
    shadeImageView.image = shadeImage
  }
  
  private func setPlaceholderImage() {
    imageView.image = placeholderImage
    shadeImageView.image = nil
  }
  
}

// MARK: UIImage extension

private extension UIImage {
  static func fromShadeType(shadeType: ShadedImageView.ShadeType) -> UIImage? {
    switch shadeType {
    case .TopLeft: return UIImage(named: "DarkTopLeftCorner")
    case .Bottom: return UIImage(named: "BottomShade")
    default: return nil
    }
  }
  
  func cropCenterToFit(#extents: CGSize) -> UIImage {
    let newSize = size.sizeThatFitsInside(extents: extents)
    let cropExtents = CGRect.fromAxisWith(size: size.sizeThatFitsInside(extents: extents))
    
    if let croppedImage = UIImage(CGImage: CGImageCreateWithImageInRect(self.CGImage, cropExtents)) {
      return croppedImage
    }
    return self
  }
}
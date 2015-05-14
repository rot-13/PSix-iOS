//
//  FBResponse.swift
//  PSix
//
//  Created by Turzion, Avihu on 4/20/15.
//  Copyright (c) 2015 PayPal. All rights reserved.
//

import Foundation

private typealias FBResponseData = [String: AnyObject]
typealias FBDataValue = [AnyObject]

class FBResponse {
  
  private let fbResponseData: FBResponseData
  
  init(fromResult result: AnyObject) {
    fbResponseData = result as! FBResponseData
  }
  
  subscript(key: String) -> AnyObject? {
    return fbResponseData[key]
  }
  
  var data: FBDataValue? {
    return self["data"] as? FBDataValue
  }
  
  var hasNext: Bool {
    return nextPath != nil
  }
  
  private var nextPath: String? {
    if let paging = self["paging"] as? FBResponseData {
      return paging["next"] as? String
    }
    return nil
  }
  
  func requestNext() -> FBRequest? {
    if let path = nextPath {
      return FBRequest(fromPath: path)
    }
    return nil
  }
  
}
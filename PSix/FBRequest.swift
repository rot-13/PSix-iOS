//
//  FBRequest.swift
//  PSix
//
//  Created by Turzion, Avihu on 4/20/15.
//  Copyright (c) 2015 PayPal. All rights reserved.
//

import Foundation
import Parse

typealias FBParamsList = [NSObject: AnyObject]
typealias FBReqFailureCallback = (NSError) -> ()
typealias FBReqSuccessCallback = (FBResponse) -> ()

let URI_SEP = "/"

class FBRequest {
  
  private(set) var path: String
  private(set) var params: FBParamsList
  
  init(fromPath path: String, params: FBParamsList = FBParamsList()) {
    self.path = path
    self.params = params
  }
  
  func addParam(param: String, value: AnyObject) -> FBRequest {
    params[param] = value
    return self
  }
  
  func edge(name: String) -> FBRequest {
    return FBRequest(fromPath: path + URI_SEP + name)
  }
  
  func fields(attributes: [String]) -> FBRequest {
    addParam("fields", value: ",".join(attributes))
    return self
  }
  
  func execute(failure: FBReqFailureCallback? = nil, success: FBReqSuccessCallback) {
    FBSDKGraphRequest(graphPath: path, parameters: params).startWithCompletionHandler() { (connection, result, fbError) -> Void in
      if let error = fbError {
        failure?(error)
      } else {
        success(FBResponse(fromResult: result))
      }
    }
  }
  
}
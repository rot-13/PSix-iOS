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

let URI_SEP = "/"


class FBRequest {
    
    private(set) var path: String
    private(set) internal var params = FBParamsList()
    
    init(forResource: String) {
        path = forResource
    }
    
    func addParam(param: String, value: AnyObject) -> FBRequest {
        params[param] = value
        return self
    }
    
    func edge(name: String) -> FBRequest {
        return FBRequest(forResource: path + URI_SEP + name)
    }
    
    func execute(failure: ((NSError) -> ())? = nil, success: (AnyObject) -> ()) {
        if FBSDKAccessToken.currentAccessToken() != nil {
            FBSDKGraphRequest(graphPath: path, parameters: params).startWithCompletionHandler() { (connection, result, fbError) -> Void in
                if let error = fbError {
                    failure?(error)
                } else {
                    success(result)
                }
            }
        }
    }
    
}
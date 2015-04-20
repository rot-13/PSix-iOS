//
//  FBResponse.swift
//  PSix
//
//  Created by Turzion, Avihu on 4/20/15.
//  Copyright (c) 2015 PayPal. All rights reserved.
//

import Foundation

class FBResponse {
    
    private let fbResponse: [String: AnyObject]
    
    init(fromResult: AnyObject) {
        fbResponse = fromResult as! [String: AnyObject]
    }
    
    subscript(hash: String) -> AnyObject? {
        return fbResponse[hash]
    }
    
    var data: [AnyObject]? {
        return self["data"] as? [AnyObject]
    }
    
    var hasNext: Bool {
        return nextPath != nil
    }
    
    private var nextPath: String? {
        if let paging = self["paging"] as? [String: AnyObject] {
            return paging["next"] as? String
        }
        return nil
    }
    
    func requestNext() -> FBRequest? {
        if let path = nextPath {
            return FBRequest(forResource: path)
        }
        return nil
    }

}
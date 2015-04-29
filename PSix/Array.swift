//
//  Array.swift
//  PSix
//
//  Created by Turzion, Avihu on 4/29/15.
//  Copyright (c) 2015 PayPal. All rights reserved.
//

import Foundation

extension Array {
    
    static func filterNils(array: [T?]) -> [T] {
        return array.filter { $0 != nil }.map { $0! }
    }
    
}
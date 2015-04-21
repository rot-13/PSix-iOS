//
//  String.swift
//  PSix
//
//  Created by Turzion, Avihu on 4/21/15.
//  Copyright (c) 2015 PayPal. All rights reserved.
//

import Foundation

extension String {
    func contains(other: String) -> Bool {
        return rangeOfString(other) != nil
    }
}
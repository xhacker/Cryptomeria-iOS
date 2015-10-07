//
//  ArrayExtensions.swift
//  Cryptomeria
//
//  Created by Dongyuan Liu on 2015-10-06.
//  Copyright © 2015 Xhacker. All rights reserved.
//

import Foundation

extension Array {
    mutating func shuffle() {
        for i in 0..<count {
            // select a random element between i and end of array to swap with
            let nElements = count - i
            let n = Int(arc4random_uniform(UInt32(nElements))) + i
            
            // swap
            let tmp = self[i]
            self[i] = self[n]
            self[n] = tmp
        }
    }
}

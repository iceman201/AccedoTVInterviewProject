//
//  Extension.swift
//  Colour memory
//
//  Created by Liguo Jiao on 26/05/17.
//  Copyright © 2017 Liguo Jiao. All rights reserved.
//

import Foundation

extension Array {
    /// Returns an array containing this sequence shuffled
    var shuffled: Array {
        var elements = self
        return elements.shuffle()
    }
    
    @discardableResult
    /// Shuffles this sequence in place
    mutating func shuffle() -> Array {
        indices.dropLast().forEach {
            guard case let index = Int(arc4random_uniform(UInt32(count - $0))) + $0, index != $0 else {
                return
            }
            self.swapAt($0, index)
        }
        return self
    }
    
    var chooseOne: Element { return self[Int(arc4random_uniform(UInt32(count)))] }
    
    func choose(_ n: Int) -> Array {
        return Array(shuffled.prefix(n))
    }
    
    var randomPairs: [Int] {
        let pairArray = self
        return pairArray.generatePairRandomNumber(numberOfPair: 8)
    }
    
    private func generatePairRandomNumber(numberOfPair: Int) -> [Int] {
        var result: [Int] = []
        for _ in 0..<numberOfPair {
            let number = Int(arc4random_uniform(UInt32(numberOfPair) + 1))
            result.append(number)
            result.append(number)
        }
        return result.shuffled
    }
}

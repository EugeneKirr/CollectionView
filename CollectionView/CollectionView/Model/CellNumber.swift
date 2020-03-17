//
//  CellNumber.swift
//  CollectionView
//
//  Created by Eugene Kireichev on 17/03/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import Foundation

class CellNumber {
    
    static func getShuffledNumbers(cellCounter: Int, repeatCounter: Int) -> [Int] {
        var numbers = [Int]()
        for number in 1...(cellCounter/repeatCounter) {
            for _ in 1...repeatCounter {
                numbers.append(number)
            }
        }
        return numbers.shuffled()
    }
    
}


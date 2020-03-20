//
//  CellModel.swift
//  CollectionView
//
//  Created by Eugene Kireichev on 18/03/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import Foundation

struct CellModel: Codable {
    
    var isVisible: Bool
    let value: Int
    
}

extension CellModel {
    
    static func getCells(cellCounter: Int, repeatCounter: Int) -> [CellModel] {
        let shuffledNumbers = CellNumber.getShuffledNumbers(cellCounter: cellCounter, repeatCounter: repeatCounter)
        var cells = [CellModel]()
        for index in 0...(cellCounter-1) {
            let newCell = CellModel(isVisible: false, value: shuffledNumbers[index])
            cells.append(newCell)
        }
        return cells
    }
    
}

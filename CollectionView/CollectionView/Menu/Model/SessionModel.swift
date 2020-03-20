//
//  SessionModel.swift
//  CollectionView
//
//  Created by Eugene Kireichev on 20/03/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import Foundation

struct Session: Codable {
    
    var cellAmount: Int
    var repeatedValues: Int
    var cells: [CellModel]
    var selectedCells: [Int:Int]
    
}

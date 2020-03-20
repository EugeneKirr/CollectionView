//
//  UserDefaultsKeys.swift
//  CollectionView
//
//  Created by Eugene Kireichev on 20/03/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import Foundation

enum UDKeys {
    case cellAmount
    case repeatedValues
    case encodedCells
    case encodedSelectedCells
    case encodedSession
}

extension UDKeys {
    var key: String {
        switch self {
        case.cellAmount: return "Cell Amount"
        case.repeatedValues: return "Repeated Values"
        case.encodedCells: return "Encoded Cells"
        case.encodedSelectedCells: return "Encoded Selected Cells"
        case.encodedSession: return "Encoded Session"
        }
    }
}

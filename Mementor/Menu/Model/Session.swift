//
//  Session.swift
//  Mementor
//
//  Created by Eugene Kireichev on 20/03/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import Foundation

struct Session: Codable {
    let repeatPics: Int
    let cells: [CellModel]
    let selectCounter: Int
}

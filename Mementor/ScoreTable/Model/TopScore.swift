//
//  TopScore.swift
//  Mementor
//
//  Created by Eugene Kireichev on 16/04/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import Foundation

struct TopScore: Codable {
    let name: String
    let score: Int
}

extension Array where Element == TopScore {
    func sorted() -> [TopScore] {
        self.sorted {
            $0.score > $1.score
        }
    }
}

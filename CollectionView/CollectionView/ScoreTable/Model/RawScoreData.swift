//
//  RawScoreData.swift
//  CollectionView
//
//  Created by Eugene Kireichev on 16/04/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import Foundation

struct RawScoreData: Codable {
    
    let id: Int
    let name: String
    let score: Int
    let createdAt: String
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, score
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    
}

extension RawScoreData {
    
    init(_ name: String, _ score: Int) {
        self.id = 0
        self.name = name
        self.score = score
        self.createdAt = ""
        self.updatedAt = ""
    }
    
}


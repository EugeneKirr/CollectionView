//
//  RawScorePosting.swift
//  CollectionView
//
//  Created by Eugene Kireichev on 20/04/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import Foundation

protocol RawScorePosting: Codable {
    
    init(_ name: String, _ score: Int)
    
}

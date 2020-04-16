//
//  TopScoreData.swift
//  CollectionView
//
//  Created by Eugene Kireichev on 16/04/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import Foundation

struct TopScoreData {
    
    let scores: [Score]
    
}

extension TopScoreData {
    
    init(_ rawTopScores: [RawScoreData]) {
        let rawScoresSorted = rawTopScores.sorted { (firstRaw, secondRaw) -> Bool in
            return firstRaw.score > secondRaw.score
        }
        var topScores = [Score]()
        for rawScoreData in rawScoresSorted {
            let score = Score(name: rawScoreData.name, score: "\(rawScoreData.score)")
            topScores.append(score)
        }
        self.scores = topScores
    }
    
}

//
//  ScoreTableCell.swift
//  CollectionView
//
//  Created by Eugene Kireichev on 15/04/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import UIKit

class ScoreTableCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    func updateLabels(with score: Score) {
        nameLabel.text = score.name
        scoreLabel.text = score.score
    }
    
}

//
//  ScoreTableCell.swift
//  CollectionView
//
//  Created by Eugene Kireichev on 15/04/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import UIKit

class ScoreTableCell: UITableViewCell {

    
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    func updateLabels(with score: Score, for number: Int) {
        numberLabel.text = "\(number)."
        nameLabel.text = score.name
        scoreLabel.text = score.score
    }
    
}

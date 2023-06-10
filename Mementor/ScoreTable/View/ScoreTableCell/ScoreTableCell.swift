//
//  ScoreTableCell.swift
//  Mementor
//
//  Created by Eugene Kireichev on 15/04/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import UIKit

final class ScoreTableCell: UITableViewCell {
    
    @IBOutlet private weak var numberLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var scoreLabel: UILabel!
    
    func updateLabels(with topScore: TopScore, for number: Int) {
        numberLabel.text = "\(number)."
        nameLabel.text = topScore.name
        scoreLabel.text = "\(topScore.score)"
    }
}

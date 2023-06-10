//
//  ScoreTableCell.swift
//  Mementor
//
//  Created by Eugene Kireichev on 15/04/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import UIKit

final class ScoreTableCell: UITableViewCell {
    
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    func updateLabels(with topScore: TopScore, for number: Int) {
        changeAlpha(to: 1, for: [numberLabel, nameLabel, scoreLabel])
        numberLabel.text = "\(number)."
        nameLabel.text = topScore.name
        scoreLabel.text = "\(topScore.score)"
    }
    
    func showActivityIndicator() {
        changeAlpha(to: 0, for: [numberLabel, nameLabel, scoreLabel])
        activityIndicator.startAnimating()
    }
    
    private func changeAlpha(to value: CGFloat, for labels: [UILabel]) {
        for label in labels {
            label.alpha = value
        }
    }
    
}

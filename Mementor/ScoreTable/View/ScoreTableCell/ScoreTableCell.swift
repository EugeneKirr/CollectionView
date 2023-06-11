//
//  ScoreTableCell.swift
//  Mementor
//
//  Created by Eugene Kireichev on 15/04/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import UIKit

final class ScoreTableCell: UITableViewCell {
    private let numberLabel = UILabel()
    private let nameLabel = UILabel()
    private let scoreLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        commonInit()
    }

    private func commonInit() {
        selectionStyle = .none
        backgroundColor = .clear

        let labels: [UILabel] = [numberLabel, nameLabel, scoreLabel]
        labels.forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.textColor = .systemPurple
            $0.font = Fonts.regularText
        }

        setupNumberLabel()
        setupNameLabel()
        setupScoreLabel()
    }

    private func setupNumberLabel() {
        numberLabel.textAlignment = .right
        NSLayoutConstraint.activate([
            numberLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            numberLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            numberLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8.0),
            numberLabel.widthAnchor.constraint(equalToConstant: 24.0)
        ])
    }

    private func setupNameLabel() {
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: numberLabel.trailingAnchor, constant: 8.0),
            nameLabel.trailingAnchor.constraint(equalTo: scoreLabel.leadingAnchor, constant: -8.0)
        ])
    }

    private func setupScoreLabel() {
        scoreLabel.textAlignment = .right
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            scoreLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            scoreLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12.0),
            scoreLabel.widthAnchor.constraint(equalToConstant: 80.0)
        ])
    }
    
    func updateLabels(with topScore: TopScore, for number: Int) {
        numberLabel.text = "\(number)."
        nameLabel.text = topScore.name
        scoreLabel.text = "\(topScore.score)"
    }
}

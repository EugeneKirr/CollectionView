//
//  CollectionCell.swift
//  Mementor
//
//  Created by Eugene Kireichev on 13/03/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import UIKit

final class CollectionCell: UICollectionViewCell {
    private let cellImageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        commonInit()
    }

    private func commonInit() {
        cellImageView.layer.borderColor = Colors.text.cgColor
        cellImageView.layer.borderWidth = 1.0
        cellImageView.layer.cornerRadius = 24.0
        cellImageView.clipsToBounds = true

        contentView.addSubview(cellImageView)
        cellImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cellImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4.0),
            cellImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4.0),
            cellImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 4.0),
            cellImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -4.0)
        ])
    }
    
    func showCover() {
        cellImageView.image = UIImage(named: "mem_cover")
    }
    
    func showPicture(named: String) {
        cellImageView.image = UIImage(named: named)
    }
}

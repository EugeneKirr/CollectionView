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
        contentView.addSubview(cellImageView)
        cellImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cellImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cellImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            cellImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            cellImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor)
        ])
    }
    
    func showCover() {
        cellImageView.image = UIImage(named: "vortex")
    }
    
    func showPicture(named: String) {
        cellImageView.image = UIImage(named: named)
    }
}

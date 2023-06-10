//
//  CollectionCell.swift
//  Mementor
//
//  Created by Eugene Kireichev on 13/03/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import UIKit

final class CollectionCell: UICollectionViewCell {
    
    @IBOutlet private weak var cellImageView: UIImageView!
    
    func showCover() {
        cellImageView.image = UIImage(named: "cover")
    }
    
    func showPicture(named: String) {
        cellImageView.image = UIImage(named: named)
    }
    
}

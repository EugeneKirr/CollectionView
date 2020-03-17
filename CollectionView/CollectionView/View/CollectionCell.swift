//
//  CollectionCell.swift
//  CollectionView
//
//  Created by Eugene Kireichev on 13/03/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import UIKit

class CollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var cellLabel: UILabel!
    
}

extension CollectionCell {
    
    func showCover() {
        cellLabel.text = "?"
        cellLabel.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        self.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
    }
    
    func showNumber(number: Int) {
        cellLabel.text = "\(number)"
        cellLabel.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        self.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
    }
    
}

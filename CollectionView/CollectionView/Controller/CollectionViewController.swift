//
//  CollectionViewController.swift
//  CollectionView
//
//  Created by Eugene Kireichev on 13/03/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import UIKit

private let cellCounter = 8 // number of cell instances
private let repeatCounter = 2 // number of cells with equal value

class CollectionViewController: UICollectionViewController {
    
    let numbers = CellNumber.getShuffledNumbers(cellCounter: cellCounter, repeatCounter: repeatCounter)
    
    typealias CellIndex = Int
    typealias CellValue = Int
    var selectedCells: [CellIndex:CellValue] = [:]
    
    var guessedCellsStatus = [Bool](repeating: false, count: cellCounter)

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellCounter
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as? CollectionCell else { return UICollectionViewCell() }
        cell.showCover()
        return cell
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        guard !guessedCellsStatus[indexPath.row] && !selectedCells.keys.contains(indexPath.row) else { return false }
        return true
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CollectionCell else { return }
        cell.showNumber(number: numbers[indexPath.row])
        selectedCells[indexPath.row] = numbers[indexPath.row]
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard selectedCells.count == repeatCounter else { return }
        for index in selectedCells.keys {
            guard let cell = collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? CollectionCell else { break }
            if selectedCells.values.max() == selectedCells.values.min() {
                guessedCellsStatus[index] = true
            } else {
                cell.showCover()
            }
        }
        selectedCells = [:]
    }

} // end of class

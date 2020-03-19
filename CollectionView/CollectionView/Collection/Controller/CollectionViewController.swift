//
//  CollectionViewController.swift
//  CollectionView
//
//  Created by Eugene Kireichev on 13/03/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import UIKit

protocol CollectionViewControllerDelegate: NSObjectProtocol {
    
    var cellAmount: Int { get }
    var repeatedValues: Int { get }

}

class CollectionViewController: UICollectionViewController {
    
    weak var delegate: CollectionViewControllerDelegate?
    
    var cellAmount: Int {
        guard let amount = self.delegate?.cellAmount else { return 8 }
        return amount
    }
    var repeatedValues: Int {
        guard let repeated = self.delegate?.repeatedValues else { return 2 }
        return repeated
    }
    
    var cells: [CellModel] = []
    var selectedCells: [Int:Int] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        cells = CellModel.getCells(cellCounter: cellAmount, repeatCounter: repeatedValues)
    }
    
    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cells.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as? CollectionCell else { return UICollectionViewCell() }
        cell.showCover()
        return cell
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return !cells[indexPath.row].isVisible
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        cells[indexPath.row].isVisible = true
        reloadCellViews()
        selectedCells[indexPath.row] = cells[indexPath.row].value
        guard selectedCells.count == repeatedValues else { return }
        checkSelectedCells()
        checkGuessedCells()
    }
    
    func reloadCellViews() {
        for index in 0...(cells.count-1) {
            guard let cell = collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? CollectionCell else { break }
            cells[index].isVisible ? cell.showNumber(number: cells[index].value) : cell.showCover()
        }
    }
    
    func checkSelectedCells() {
        let cellsAreEqual = selectedCells.values.max() == selectedCells.values.min()
        for index in selectedCells.keys {
            cells[index].isVisible = cellsAreEqual
        }
        selectedCells = [:]
    }
        
    func checkGuessedCells() {
        var guessedCellCount = 0
        for index in 0...(cells.count-1) {
            cells[index].isVisible ? guessedCellCount += 1 : nil
        }
        guard guessedCellCount == cells.count else { return }
        showNewGameAlert()
    }
    
    func showNewGameAlert() {
        let ac = UIAlertController(title: "You win!", message: "Press OK to start new game", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { (action) in
            self.cells = CellModel.getCells(cellCounter: self.cellAmount, repeatCounter: self.repeatedValues)
            self.collectionView.reloadData()
        }
        let menu = UIAlertAction(title: "Menu", style: .default) { (action) in
            self.navigationController?.popViewController(animated: true)
        }
        ac.addAction(ok)
        ac.addAction(menu)
        present(ac, animated: true)
    }

}

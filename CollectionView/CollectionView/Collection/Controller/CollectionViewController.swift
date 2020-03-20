//
//  CollectionViewController.swift
//  CollectionView
//
//  Created by Eugene Kireichev on 13/03/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import UIKit

protocol CollectionViewControllerDelegate: AnyObject {
    func saveCurrentSession(_ session: Session)
}

class CollectionViewController: UICollectionViewController {
    
    weak var delegate: CollectionViewControllerDelegate?
    
    var session = Session(cellAmount: 0, repeatedValues: 0, cells: [], selectedCells: [:])

    override func viewDidLoad() {
        super.viewDidLoad()
        configueNavBar()
    }
    
    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return session.cellAmount
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as? CollectionCell else { return UICollectionViewCell() }
        session.cells[indexPath.row].isVisible ? cell.showNumber(number: session.cells[indexPath.row].value) : cell.showCover()
        return cell
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return !session.cells[indexPath.row].isVisible
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        session.cells[indexPath.row].isVisible = true
        updateCellViews()
        session.selectedCells[indexPath.row] = session.cells[indexPath.row].value
        
        guard session.selectedCells.count == session.repeatedValues else { return }
        checkSelectedCells()
        checkGuessedCells()
        
    }
    
    func updateCellViews() {
        for index in 0...(session.cellAmount-1) {
            guard let cell = collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? CollectionCell else { break }
            session.cells[index].isVisible ? cell.showNumber(number: session.cells[index].value) : cell.showCover()
        }
    }
    
    func checkSelectedCells() {
        let cellsAreEqual = session.selectedCells.values.max() == session.selectedCells.values.min()
        for index in session.selectedCells.keys {
            session.cells[index].isVisible = cellsAreEqual
        }
        session.selectedCells.removeAll()
    }
        
    func checkGuessedCells() {
        var guessedCellCount = 0
        for index in 0...(session.cellAmount-1) {
            session.cells[index].isVisible ? guessedCellCount += 1 : nil
        }
        guard guessedCellCount == session.cellAmount else { return }
        showNewGameAlert()
    }
    
    func showNewGameAlert() {
        let ac = UIAlertController(title: "You win!", message: "Press OK to start new game", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { (action) in
            self.reloadCollectionView()
        }
        let menu = UIAlertAction(title: "Menu", style: .default) { (action) in
            self.goToMenu()
        }
        ac.addAction(ok)
        ac.addAction(menu)
        present(ac, animated: true)
    }
    
    func configueNavBar() {
        let navReloadButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(reloadCollectionView))
        let navMenuButton = UIBarButtonItem(title: "Menu", style: .plain, target: self, action: #selector(goToMenu))
        self.navigationItem.hidesBackButton = true
        self.navigationItem.rightBarButtonItem = navReloadButton
        self.navigationItem.leftBarButtonItem = navMenuButton
        self.navigationItem.title = "Find matched cells"
    }
    
    @objc func reloadCollectionView() {
        session.cells = CellModel.getCells(cellCounter: session.cellAmount, repeatCounter: session.repeatedValues)
        session.selectedCells.removeAll()
        collectionView.reloadData()
    }
    
    @objc func goToMenu() {
        delegate?.saveCurrentSession(session)
        self.navigationController?.popViewController(animated: true)
    }

}

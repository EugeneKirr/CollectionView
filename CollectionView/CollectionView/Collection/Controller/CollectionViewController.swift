//
//  CollectionViewController.swift
//  CollectionView
//
//  Created by Eugene Kireichev on 13/03/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import UIKit

class CollectionViewController: UICollectionViewController {
    
    private let sessionManager = SessionManager()
    private let networkManager = NetworkManager()
    
    private var session: Session {
        return sessionManager.getFromUD()
    }
    
    private var currentSelectedCells = [Int]()
    private var currentSelectCounter = 0
    
    private let scoreMultiplier = 100_000
    private var sessionScore: Int {
        return scoreMultiplier*session.cells.count/currentSelectCounter
    }
    private var minTopScore = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        currentSelectCounter = session.selectCounter
        configueNavBar()
        registerCollectionCell()
        
        networkManager.fetchRawScoreData { [weak self] rawTopScores in
            let minRawScoreData = rawTopScores.min { (firstRaw, secondRaw) -> Bool in
                firstRaw.score < secondRaw.score
            }
            guard let minTopScoreValue = minRawScoreData?.score else { return }
            self?.minTopScore = minTopScoreValue
        }
    }
    
    func registerCollectionCell() {
        let nib = UINib(nibName: "CollectionCell", bundle: nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: "collectionCell")
    }
    
    func configueNavBar() {
        let navReloadButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(reloadCollectionView))
        let navMenuButton = UIBarButtonItem(title: "Menu", style: .plain, target: self, action: #selector(goToMenu))
        self.navigationItem.hidesBackButton = true
        self.navigationItem.rightBarButtonItem = navReloadButton
        self.navigationItem.leftBarButtonItem = navMenuButton
        updateNavBarTitle()
    }
    
    func updateNavBarTitle() {
        guard currentSelectCounter != 0 else {
            self.navigationItem.title = "Find matched cells"
            return
        }
        self.navigationItem.title = "Score: \(sessionScore)"
    }
    
    // MARK: - UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return session.cells.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as? CollectionCell else { return UICollectionViewCell() }
        session.cells[indexPath.row].isGuessed ? cell.showPicture(named: session.cells[indexPath.row].pictureName) : cell.showCover()
        return cell
    }

    // MARK: - UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let isGuessed = session.cells[indexPath.row].isGuessed
        var isSelected = false
        for index in currentSelectedCells {
            guard index == indexPath.row else { continue }
            isSelected = true
            break
        }
        return !(isGuessed || isSelected)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        updateCellViews()
        guard let cell = collectionView.cellForItem(at: indexPath) as? CollectionCell else { return }
        cell.showPicture(named: session.cells[indexPath.row].pictureName)
        
        currentSelectCounter += 1
        currentSelectedCells.append(indexPath.row)
        updateNavBarTitle()
        
        guard currentSelectedCells.count == session.repeatPics else { return }
        checkSelectedCells()
        countGuessedCells()
    }
    
    func updateCellViews() {
        guard currentSelectedCells.count == 0 else { return }
        for index in 0...(session.cells.count-1) {
            guard let cell = collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? CollectionCell else { return }
            session.cells[index].isGuessed ? cell.showPicture(named: session.cells[index].pictureName): cell.showCover()
        }
    }
    
    func checkSelectedCells() {
        guard sessionManager.areSelectedCellsEqual(in: session, for: currentSelectedCells) else { currentSelectedCells.removeAll(); return }
        sessionManager.updateGuessedFlag(in: session, for: currentSelectedCells)
        currentSelectedCells.removeAll()
    }

    func countGuessedCells() {
        guard sessionManager.areCellsAllGuessed(in: session) else { return }
        sessionScore > minTopScore ? showTopScoreAlert() : showNewGameAlert()
    }
    
    func showTopScoreAlert() {
        let ac = UIAlertController(title: "You have one of the top scores!\n\(sessionScore)", message: "Please enter your name", preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .default) { (ok) in
            guard var userName = ac.textFields?.first?.text else { return }
            if userName == "" {
                userName = "Player"
            }
            let userScore = self.sessionScore
            self.networkManager.postNewScore(userName, userScore) { [weak self] in
                let scoreTableSB = UIStoryboard(name: "ScoreTable", bundle: nil)
                let scoreTableVC = scoreTableSB.instantiateViewController(identifier: "scoreTableVC")
                self?.navigationController?.pushViewController(scoreTableVC, animated: true)
            }
        }
        ac.addAction(ok)
        ac.addTextField { (textField) in
            textField.autocapitalizationType = .words
            textField.text = "Player"
        }
        present(ac, animated: true)
    }

    func showNewGameAlert() {
        let ac = UIAlertController(title: "You win!", message: "Your score is \(sessionScore)", preferredStyle: .alert)
        let ok = UIAlertAction(title: "New game", style: .default) { (action) in
            self.reloadCollectionView()
        }
        let menu = UIAlertAction(title: "Menu", style: .default) { (action) in
            self.goToMenu()
        }
        ac.addAction(ok)
        ac.addAction(menu)
        present(ac, animated: true)
    }
    
    @objc func reloadCollectionView() {
        sessionManager.createNewSession(cellAmount: session.cells.count, repeatPics: session.repeatPics)
        currentSelectCounter = 0
        currentSelectedCells.removeAll()
        updateNavBarTitle()
        collectionView.reloadData()
    }

    @objc func goToMenu() {
        sessionManager.updateSelectCounter(in: session, with: currentSelectCounter)
        self.navigationController?.popViewController(animated: true)
    }

}

// MARK: - Dynamic Collection Layout

extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize = calculateMaxCellWidth(minNumberOfCellsInRow: 3, maxNumberOfCellsInRow: 4, defaultCellWidth: 40)
        return CGSize(width: cellSize, height: cellSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let topInset = calculateTopInset(minNumberOfCellsInRow: 3, maxNumberOfCellsInRow: 4, defaultTopInset: 0)
        return UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)
    }
    
    func calculateMaxCellWidth(minNumberOfCellsInRow: Int, maxNumberOfCellsInRow: Int, defaultCellWidth: CGFloat) -> CGFloat {
        var cellWidth = defaultCellWidth
        for numberOfCellsInRow in minNumberOfCellsInRow...maxNumberOfCellsInRow {
            guard (session.cells.count % numberOfCellsInRow == 0) else { continue }
            cellWidth = collectionView.bounds.width/CGFloat(numberOfCellsInRow)
            break
        }
        return cellWidth
    }
    
    func calculateTopInset(minNumberOfCellsInRow: Int, maxNumberOfCellsInRow: Int, defaultTopInset: CGFloat) -> CGFloat {
        var topInset = defaultTopInset
        for numberOfCellsInRow in minNumberOfCellsInRow...maxNumberOfCellsInRow {
            guard (session.cells.count % numberOfCellsInRow == 0) else { continue }
            let cellSize = collectionView.bounds.width/CGFloat(numberOfCellsInRow)
            let numberOfRows = session.cells.count / numberOfCellsInRow
            topInset = (collectionView.bounds.height - cellSize * CGFloat(numberOfRows)) / 2
            break
        }
        return topInset
    }

}

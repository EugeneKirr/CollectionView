//
//  CollectionViewController.swift
//  Mementor
//
//  Created by Eugene Kireichev on 13/03/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import UIKit

final class CollectionViewController: UIViewController {
    private let titleLabel = UILabel()
    private let closeButton = UIButton()
    private let reloadButton = UIButton()

    private let collectionViewFlowLayout = UICollectionViewFlowLayout()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
    
    private let sessionManager = SessionManager()
    private let topScoreManager = TopScoreManager()
    
    private var session: Session {
        sessionManager.fetchSession()
    }
    
    private var currentSelectedCells = [Int]()
    private var currentSelectCounter = 0
    
    private let scoreMultiplier = 100_000

    private var sessionScore: Int {
        scoreMultiplier * session.cells.count / currentSelectCounter
    }

    private lazy var minTopScore = topScoreManager.fetchTopScores().last?.score ?? 0

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemYellow
        currentSelectCounter = session.selectCounter
        configureTitle()
        configureCollectionView()
        configureButtonCommonParameters()
        configureCloseButton()
        configureReloadButton()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        sessionManager.updateSelectCounter(in: session, with: currentSelectCounter)
    }

    private func configureTitle() {
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16.0),
            titleLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16.0),
            titleLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16.0)
        ])
        titleLabel.font = Fonts.regular
        titleLabel.textColor = .systemPurple
        titleLabel.textAlignment = .center
        updateTitleText()
    }

    private func updateTitleText() {
        guard currentSelectCounter != 0 else {
            titleLabel.text = "Find matched cells"
            return
        }

        titleLabel.text = "Score: \(sessionScore)"
    }

    private func configureCollectionView() {
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = false
        collectionView.dataSource = self
        collectionView.delegate = self

        collectionView.register(CollectionCell.self, forCellWithReuseIdentifier: String(describing: CollectionCell.self))

        collectionViewFlowLayout.scrollDirection = .vertical
        collectionViewFlowLayout.minimumLineSpacing = .zero
        collectionViewFlowLayout.minimumInteritemSpacing = .zero

        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        ])
    }

    private func configureButtonCommonParameters() {
        let buttons: [UIButton] = [closeButton, reloadButton]
        buttons.forEach {
            $0.tintColor = .white
            $0.backgroundColor = .systemPurple
            $0.layer.cornerRadius = 32.0 / 2
            $0.layer.shadowOpacity = 0.7
            $0.layer.shadowRadius = 2
            $0.layer.shadowOffset = CGSize(width: 0, height: 2)
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12.0),
                $0.widthAnchor.constraint(equalToConstant: 32.0),
                $0.heightAnchor.constraint(equalToConstant: 32.0)
            ])
        }
    }

    private func configureCloseButton() {
        closeButton.setImage(Images.close, for: .normal)
        closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        closeButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16.0).isActive = true
    }

    private func configureReloadButton() {
        let reloadImage = UIImage(systemName: "arrow.counterclockwise", withConfiguration: UIImage.SymbolConfiguration(weight: .heavy))
        reloadButton.setImage(reloadImage, for: .normal)
        reloadButton.addTarget(self, action: #selector(reloadCollectionView), for: .touchUpInside)
        reloadButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16.0).isActive = true
    }
}
    
    // MARK: - UICollectionViewDataSource

extension CollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        session.cells.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CollectionCell.self), for: indexPath) as? CollectionCell
        else {
            return UICollectionViewCell()
        }

        session.cells[indexPath.row].isGuessed ? cell.showPicture(named: session.cells[indexPath.row].pictureName) : cell.showCover()
        return cell
    }
}

    // MARK: - UICollectionViewDelegate

extension CollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let isGuessed = session.cells[indexPath.row].isGuessed
        var isSelected = false
        for index in currentSelectedCells {
            guard index == indexPath.row else { continue }
            isSelected = true
            break
        }
        return !(isGuessed || isSelected)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        updateCellViews()
        guard let cell = collectionView.cellForItem(at: indexPath) as? CollectionCell else { return }
        cell.showPicture(named: session.cells[indexPath.row].pictureName)
        
        currentSelectCounter += 1
        currentSelectedCells.append(indexPath.row)
        updateTitleText()
        
        guard currentSelectedCells.count == session.repeatPics else { return }

        checkSelectedCells()
        countGuessedCells()
    }
    
    private func updateCellViews() {
        guard currentSelectedCells.count == 0 else { return }

        for index in 0 ..< session.cells.count {
            guard let cell = collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? CollectionCell else { return }

            session.cells[index].isGuessed ? cell.showPicture(named: session.cells[index].pictureName) : cell.showCover()
        }
    }
    
    private func checkSelectedCells() {
        guard
            sessionManager.areSelectedCellsEqual(in: session, for: currentSelectedCells)
        else {
            currentSelectedCells.removeAll()
            return
        }

        sessionManager.updateGuessedFlag(in: session, for: currentSelectedCells)
        currentSelectedCells.removeAll()
    }

    private func countGuessedCells() {
        guard sessionManager.areCellsAllGuessed(in: session) else { return }

        sessionScore > minTopScore ? showTopScoreAlert() : showNewGameAlert()
    }
    
    private func showTopScoreAlert() {
        let ac = UIAlertController(title: "You have one of the top scores!\n\(sessionScore)", message: "Please enter your name", preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            guard
                let self,
                var userName = ac.textFields?.first?.text
            else {
                return
            }

            if userName == "" {
                userName = "Player"
            }
            let userScore = self.sessionScore

            var topScores = self.topScoreManager.fetchTopScores()
            topScores.append(TopScore(name: userName, score: userScore))
            self.topScoreManager.saveTopScores(topScores)

            self.openTopScores()
        }

        ac.addAction(ok)
        ac.addTextField { (textField) in
            textField.autocapitalizationType = .words
            textField.text = "Player"
        }
        present(ac, animated: true)
    }

    private func showNewGameAlert() {
        let ac = UIAlertController(title: "You win!", message: "Your score is \(sessionScore)", preferredStyle: .alert)
        let ok = UIAlertAction(title: "New game", style: .default) { [weak self] _ in
            self?.reloadCollectionView()
        }

        let menu = UIAlertAction(title: "Menu", style: .default) { [weak self] _ in
            self?.close()
        }

        ac.addAction(ok)
        ac.addAction(menu)
        present(ac, animated: true)
    }
    
    @objc
    private func reloadCollectionView() {
        sessionManager.createNewSession(cellAmount: session.cells.count, repeatPics: session.repeatPics)
        currentSelectCounter = 0
        currentSelectedCells.removeAll()
        updateTitleText()
        collectionView.reloadSections(IndexSet(integer: 0))
    }

    @objc
    private func close() {
        dismiss(animated: true)
    }

    private func openTopScores() {
        let topScoresViewController = ScoreTableViewController()
        present(topScoresViewController, animated: true)
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
    
    private func calculateMaxCellWidth(minNumberOfCellsInRow: Int, maxNumberOfCellsInRow: Int, defaultCellWidth: CGFloat) -> CGFloat {
        var cellWidth = defaultCellWidth
        for numberOfCellsInRow in minNumberOfCellsInRow ... maxNumberOfCellsInRow {
            guard (session.cells.count % numberOfCellsInRow == 0) else { continue }

            cellWidth = collectionView.bounds.width / CGFloat(numberOfCellsInRow)
            break
        }
        return cellWidth
    }
    
    private func calculateTopInset(minNumberOfCellsInRow: Int, maxNumberOfCellsInRow: Int, defaultTopInset: CGFloat) -> CGFloat {
        var topInset = defaultTopInset
        for numberOfCellsInRow in minNumberOfCellsInRow ... maxNumberOfCellsInRow {
            guard session.cells.count % numberOfCellsInRow == 0 else { continue }

            let cellSize = collectionView.bounds.width / CGFloat(numberOfCellsInRow)
            let numberOfRows = session.cells.count / numberOfCellsInRow
            topInset = (collectionView.bounds.height - cellSize * CGFloat(numberOfRows)) / 2
            break
        }
        return topInset
    }
}

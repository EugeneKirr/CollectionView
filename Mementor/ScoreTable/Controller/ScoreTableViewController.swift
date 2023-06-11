//
//  ScoreTableViewController.swift
//  Mementor
//
//  Created by Eugene Kireichev on 15/04/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import UIKit

final class ScoreTableViewController: UIViewController {
    private let titleLabel = UILabel()
    private let closeButton = UIButton()
    private let resetButton = UIButton()

    private let tableView = UITableView()

    private let topScoreManager = TopScoreManager()
    
    private var topScores: [TopScore] {
        topScoreManager.fetchTopScores()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemYellow
        configureTitle()
        configureTableView()
        configureButtonCommonParameters()
        configureCloseButton()
        configureResetButton()
    }

    private func configureTitle() {
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16.0),
            titleLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16.0),
            titleLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16.0)
        ])
        titleLabel.font = Fonts.regularText
        titleLabel.textColor = .systemPurple
        titleLabel.textAlignment = .center
        titleLabel.text = "Top Scores"
    }

    private func configureTableView() {
        tableView.backgroundColor = .clear
        tableView.alwaysBounceVertical = false
        tableView.separatorStyle = .none
        tableView.rowHeight = 60.0
        tableView.dataSource = self

        tableView.register(ScoreTableCell.self, forCellReuseIdentifier: String(describing: ScoreTableCell.self))

        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16.0),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        ])
    }

    private func configureButtonCommonParameters() {
        let buttons: [UIButton] = [closeButton, resetButton]
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

    private func configureResetButton() {
        let resetImage = UIImage(systemName: "trash", withConfiguration: UIImage.SymbolConfiguration(weight: .heavy))
        resetButton.setImage(resetImage, for: .normal)
        resetButton.addTarget(self, action: #selector(resetTopScores), for: .touchUpInside)
        resetButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16.0).isActive = true
    }
    
    @objc
    private func close() {
        dismiss(animated: true)
    }

    @objc
    private func resetTopScores() {
        topScoreManager.resetTopScores()
        tableView.reloadSections(IndexSet(integer: 0), with: .fade)
    }
}

    // MARK: - UITableViewDataSource

extension ScoreTableViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        topScores.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ScoreTableCell.self), for: indexPath) as? ScoreTableCell
        else {
            return UITableViewCell()
        }

        guard !topScores.isEmpty else {
            return cell
        }

        cell.updateLabels(with: topScores[indexPath.row], for: (indexPath.row + 1) )
        return cell
    }
}

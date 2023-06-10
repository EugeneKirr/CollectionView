//
//  ScoreTableViewController.swift
//  Mementor
//
//  Created by Eugene Kireichev on 15/04/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import UIKit

final class ScoreTableViewController: UIViewController {

    private let tableView = UITableView()

    private let topScoreManager = TopScoreManager()
    
    private var topScores: [TopScore] {
        topScoreManager.fetchTopScores()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        registerTableCell()
        configueNavBar()

        view.backgroundColor = .systemYellow

        tableView.backgroundColor = .clear
        tableView.alwaysBounceVertical = false
        tableView.separatorStyle = .none
        tableView.rowHeight = 60.0
        tableView.dataSource = self

        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        ])
    }
    
    private func registerTableCell() {
        tableView.register(ScoreTableCell.self, forCellReuseIdentifier: String(describing: ScoreTableCell.self))
    }
    
    private func configueNavBar() {
        let navMenuButton = UIBarButtonItem(title: "Menu", style: .plain, target: self, action: #selector(goToMenu))
        let navResetButton = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(resetTopScores))
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = navMenuButton
        navigationItem.rightBarButtonItem = navResetButton
        navigationItem.title = NSLocalizedString("top_scores_title", comment: "")
    }
    
    @objc
    private func goToMenu() {
        navigationController?.popToRootViewController(animated: true)
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

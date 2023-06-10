//
//  ScoreTableViewController.swift
//  Mementor
//
//  Created by Eugene Kireichev on 15/04/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import UIKit

final class ScoreTableViewController: UITableViewController {

    private let topScoreManager = TopScoreManager()
    
    private var topScores: [TopScore] {
        topScoreManager.fetchTopScores()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        registerTableCell()
        configueNavBar()

        tableView.alwaysBounceVertical = false
    }
    
    func registerTableCell() {
        let nib = UINib(nibName: "ScoreTableCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "scoreTableCell")
    }
    
    func configueNavBar() {
        let navMenuButton = UIBarButtonItem(title: "Menu", style: .plain, target: self, action: #selector(goToMenu))
        let navResetButton = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(resetTopScores))
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = navMenuButton
        navigationItem.rightBarButtonItem = navResetButton
        navigationItem.title = NSLocalizedString("top_scores_title", comment: "")
    }
    
    @objc func goToMenu() {
        navigationController?.popToRootViewController(animated: true)
    }

    @objc
    private func resetTopScores() {
        topScoreManager.resetTopScores()
        tableView.reloadSections(IndexSet(integer: 0), with: .fade)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        topScores.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "scoreTableCell", for: indexPath) as? ScoreTableCell
        else {
            return UITableViewCell()
        }

        guard !topScores.isEmpty else {
            return cell
        }

        cell.updateLabels(with: topScores[indexPath.row], for: (indexPath.row + 1) )
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return !topScores.isEmpty ? 60 : tableView.bounds.height
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

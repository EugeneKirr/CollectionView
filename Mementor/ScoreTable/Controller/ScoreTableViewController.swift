//
//  ScoreTableViewController.swift
//  Mementor
//
//  Created by Eugene Kireichev on 15/04/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import UIKit

class ScoreTableViewController: UITableViewController {
    
    private var topScores: [TopScore] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        registerTableCell()
        configueNavBar()
    }
    
    func registerTableCell() {
        let nib = UINib(nibName: "ScoreTableCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "scoreTableCell")
    }
    
    func configueNavBar() {
        let navMenuButton = UIBarButtonItem(title: "Menu", style: .plain, target: self, action: #selector(goToMenu))
        self.navigationItem.hidesBackButton = true
        self.navigationItem.leftBarButtonItem = navMenuButton
        self.navigationItem.title = "Top Scores"
    }
    
    @objc func goToMenu() {
        self.navigationController?.popToRootViewController(animated: true)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        !topScores.isEmpty ? topScores.count : 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "scoreTableCell", for: indexPath) as? ScoreTableCell
        else {
            return UITableViewCell()
        }

        guard !topScores.isEmpty else {
            cell.showActivityIndicator()
            return cell
        }

        cell.updateLabels(with: topScores[indexPath.row], for: (indexPath.row + 1) )
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return !topScores.isEmpty ? 80 : tableView.bounds.height
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

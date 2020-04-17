//
//  ScoreTableViewController.swift
//  CollectionView
//
//  Created by Eugene Kireichev on 15/04/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import UIKit

class ScoreTableViewController: UITableViewController {
    
    private let networkManager = NetworkManager()
    
    private var topScoreData = TopScoreData(scores: [])

    override func viewDidLoad() {
        super.viewDidLoad()
        registerTableCell()
        configueNavBar()
        
        networkManager.fetchRawScoreData { (rawTopScores) in
            self.topScoreData = TopScoreData(rawTopScores)
            self.tableView.reloadData()
        } 
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
        return topScoreData.scores.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "scoreTableCell", for: indexPath) as? ScoreTableCell else { return UITableViewCell() }
        cell.updateLabels(with: topScoreData.scores[indexPath.row], for: (indexPath.row + 1) )
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

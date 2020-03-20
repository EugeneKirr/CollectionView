//
//  MenuViewController.swift
//  CollectionView
//
//  Created by Eugene Kireichev on 18/03/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    
    @IBOutlet weak var amountSegmentedControl: UISegmentedControl!
    @IBOutlet weak var repeatedSegmentedControl: UISegmentedControl!
    @IBOutlet weak var continueButton: UIButton!
    
    var cellAmount: Int {
        return 8*(amountSegmentedControl.selectedSegmentIndex + 1)
    }
    
    var repeatedValues: Int {
        return Int(pow(2.0, Double(repeatedSegmentedControl.selectedSegmentIndex + 1) ))
    }

    @IBAction func tapPlayButton(_ sender: UIButton) {
        let main = UIStoryboard(name: "Main", bundle: nil)
        guard let collectionVC = main.instantiateViewController(identifier: "CollectionVC") as? CollectionViewController else { return }
        collectionVC.session = Session(cellAmount: cellAmount,
                                 repeatedValues: repeatedValues,
                                 cells: CellModel.getCells(cellCounter: cellAmount, repeatCounter: repeatedValues),
                                 selectedCells: [:])
        collectionVC.delegate = self
        self.navigationController?.pushViewController(collectionVC, animated: true)
    }
    
    @IBAction func tapContinueButton(_ sender: UIButton) {
        let defaults = UserDefaults.standard
        guard let savedSession = defaults.object(forKey: UDKeys.encodedSession.key) as? Data else { return }
        let decoder = JSONDecoder()
        guard let loadedSession = try? decoder.decode(Session.self, from: savedSession) else { return }
        
        let main = UIStoryboard(name: "Main", bundle: nil)
        guard let collectionVC = main.instantiateViewController(identifier: "CollectionVC") as? CollectionViewController else { return }
        collectionVC.session = loadedSession
        collectionVC.delegate = self
        self.navigationController?.pushViewController(collectionVC, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Menu"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let defaults = UserDefaults.standard
        guard let _ = defaults.object(forKey: UDKeys.encodedSession.key) as? Data else { return }
        self.continueButton.isEnabled = true
        self.continueButton.alpha = 1.0
    }

}

// MARK: - CollectionViewControllerDelegate

extension MenuViewController: CollectionViewControllerDelegate {
    
    func saveCurrentSession(_ session: Session) {
        let encoder = JSONEncoder()
        guard let encodedSession = try? encoder.encode(session) else { return }
        let defaults = UserDefaults.standard
        defaults.set(encodedSession, forKey: UDKeys.encodedSession.key)
    }
    
}

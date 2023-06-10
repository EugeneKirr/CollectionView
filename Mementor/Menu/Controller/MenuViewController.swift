//
//  MenuViewController.swift
//  Mementor
//
//  Created by Eugene Kireichev on 18/03/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import UIKit

final class MenuViewController: UIViewController {
    
    @IBOutlet weak var amountSegmentedControl: UISegmentedControl!
    @IBOutlet weak var repeatedSegmentedControl: UISegmentedControl!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var topScoreButton: UIButton!
    
    private let sessionManager = SessionManager()
    
    var selectedCellAmount: Int {
        guard
            let selectedSegmentTitle = amountSegmentedControl.titleForSegment(at: amountSegmentedControl.selectedSegmentIndex),
            let selectedAmount = Int(selectedSegmentTitle)
        else {
            return 8
        }

        return selectedAmount
    }
    
    var selectedRepeatPics: Int {
        guard
            let selectedSegmentTitle = repeatedSegmentedControl.titleForSegment(at: repeatedSegmentedControl.selectedSegmentIndex),
            let selectedRepeat = Int(selectedSegmentTitle)
        else {
            return 2
        }

        return selectedRepeat
    }
    
    @IBAction func changeAmountValue(_ sender: UISegmentedControl) {
        checkAvailableModes()
    }

    @IBAction func tapPlayButton(_ sender: UIButton) {
        pushViewController(storyboardName: "Collection", vcIdentifier: "collectionVC") { (collectionVC: CollectionViewController) in
            sessionManager.createNewSession(cellAmount: selectedCellAmount, repeatPics: selectedRepeatPics)
        }
    }
    
    @IBAction func tapContinueButton(_ sender: UIButton) {
        pushViewController(storyboardName: "Collection", vcIdentifier: "collectionVC") { (collectionVC: CollectionViewController) in }
    }
    
    @IBAction func tapTopScoreButton(_ sender: UIButton) {
        pushViewController(storyboardName: "ScoreTable", vcIdentifier: "scoreTableVC") { (ScoreTableViewController) in }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        modifyViewFor(buttons: [playButton, continueButton, topScoreButton])
        checkAvailableModes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard sessionManager.isSessionExist() else { return }
        continueButton.isEnabled = true
        continueButton.alpha = 1.0
    }
    
    func configureNavBar() {
        navigationItem.title = "Menu"
    }
    
    func modifyViewFor(buttons: [UIButton]) {
        for button in buttons {
            button.layer.cornerRadius = button.bounds.height / 4
            button.layer.shadowOpacity = 0.7
            button.layer.shadowRadius = 2
            button.layer.shadowOffset = CGSize(width: 0, height: 4)
        }
    }
    
    func checkAvailableModes() {
        for index in (0...(repeatedSegmentedControl.numberOfSegments - 1)).reversed() {
            guard
                let segmentTitle = repeatedSegmentedControl.titleForSegment(at: index),
                let segmentValue = Int(segmentTitle)
            else {
                break
            }

            let remainder = selectedCellAmount % segmentValue
            guard remainder == 0 else {
                repeatedSegmentedControl.setEnabled(false, forSegmentAt: index)
                continue
            }

            repeatedSegmentedControl.setEnabled(true, forSegmentAt: index)
            repeatedSegmentedControl.selectedSegmentIndex = index
        }
    }
    
    func pushViewController<VC: UIViewController>(storyboardName: String, vcIdentifier: String, completionHandler: ((VC) -> Void)) {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        guard let viewController = storyboard.instantiateViewController(identifier: vcIdentifier) as? VC else { return }

        navigationController?.pushViewController(viewController, animated: true)
        completionHandler(viewController)
    }
}

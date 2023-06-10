//
//  MenuViewController.swift
//  Mementor
//
//  Created by Eugene Kireichev on 18/03/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import UIKit

final class MenuViewController: UIViewController {
    
    @IBOutlet private weak var amountSegmentedControl: UISegmentedControl!
    @IBOutlet private weak var repeatedSegmentedControl: UISegmentedControl!
    @IBOutlet private weak var playButton: UIButton!
    @IBOutlet private weak var continueButton: UIButton!
    @IBOutlet private weak var topScoreButton: UIButton!
    
    private let sessionManager = SessionManager()
    
    private var selectedCellAmount: Int {
        guard
            let selectedSegmentTitle = amountSegmentedControl.titleForSegment(at: amountSegmentedControl.selectedSegmentIndex),
            let selectedAmount = Int(selectedSegmentTitle)
        else {
            return 8
        }

        return selectedAmount
    }
    
    private var selectedRepeatPics: Int {
        guard
            let selectedSegmentTitle = repeatedSegmentedControl.titleForSegment(at: repeatedSegmentedControl.selectedSegmentIndex),
            let selectedRepeat = Int(selectedSegmentTitle)
        else {
            return 2
        }

        return selectedRepeat
    }
    
    @IBAction private func changeAmountValue(_ sender: UISegmentedControl) {
        checkAvailableModes()
    }

    @IBAction private func tapPlayButton(_ sender: UIButton) {
        sessionManager.createNewSession(cellAmount: selectedCellAmount, repeatPics: selectedRepeatPics)
        openCollection()
    }
    
    @IBAction private func tapContinueButton(_ sender: UIButton) {
        openCollection()
    }
    
    @IBAction private func tapTopScoreButton(_ sender: UIButton) {
        openTopScores()
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

    // TODO: add title to screen
    private func configureNavBar() {
        navigationItem.title = NSLocalizedString("menu_title", comment: "")
    }
    
    private func modifyViewFor(buttons: [UIButton]) {
        for button in buttons {
            button.layer.cornerRadius = button.bounds.height / 4
            button.layer.shadowOpacity = 0.7
            button.layer.shadowRadius = 2
            button.layer.shadowOffset = CGSize(width: 0, height: 4)
        }
    }
    
    private func checkAvailableModes() {
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

    private func openCollection() {
        let collectionStoryboard = UIStoryboard(name: "Collection", bundle: nil)
        let collectionViewController = collectionStoryboard.instantiateViewController(identifier: "collectionVC")
        present(collectionViewController, animated: true)
    }

    private func openTopScores() {
        let topScoresViewController = ScoreTableViewController()
        present(topScoresViewController, animated: true)
    }
}

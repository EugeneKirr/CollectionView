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
        pushViewController(storyboardName: "Collection", vcIdentifier: "collectionVC")
    }
    
    @IBAction private func tapContinueButton(_ sender: UIButton) {
        pushViewController(storyboardName: "Collection", vcIdentifier: "collectionVC")
    }
    
    @IBAction private func tapTopScoreButton(_ sender: UIButton) {
        pushViewController(storyboardName: "ScoreTable", vcIdentifier: "scoreTableVC")
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
    
    private func pushViewController(storyboardName: String, vcIdentifier: String) {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: vcIdentifier)
        navigationController?.pushViewController(viewController, animated: true)
    }
}

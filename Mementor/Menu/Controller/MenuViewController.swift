//
//  MenuViewController.swift
//  Mementor
//
//  Created by Eugene Kireichev on 18/03/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import UIKit

final class MenuViewController: UIViewController {
    private let titleLabel = UILabel()

    private let amountDescriptionLabel = UILabel()
    private let amountSegmentedControl = UISegmentedControl()

    private let repeatedDescriptionLabel = UILabel()
    private let repeatedSegmentedControl = UISegmentedControl()

    private let playButton = UIButton()
    private let continueButton = UIButton()
    private let topScoreButton = UIButton()
    private let buttonStackView = UIStackView()
    
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

    @objc
    private func changeAmountValue(_ sender: UISegmentedControl) {
        checkAvailableModes()
    }

    @objc
    private func tapPlayButton(_ sender: UIButton) {
        sessionManager.createNewSession(cellAmount: selectedCellAmount, repeatPics: selectedRepeatPics)
        openCollection()
    }

    @objc
    private func tapContinueButton(_ sender: UIButton) {
        openCollection()
    }

    @objc
    private func tapTopScoreButton(_ sender: UIButton) {
        openTopScores()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemYellow
        configureTitle()
        configureAmountSelector()
        configureRepeatedSelector()
        configureButtons()
        checkAvailableModes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard sessionManager.isSessionExist() else { return }

        continueButton.isEnabled = true
        continueButton.alpha = 1.0
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
        titleLabel.text = "Menu"
    }

    private func configureAmountSelector() {
        let views: [UIView] = [amountDescriptionLabel, amountSegmentedControl]
        views.forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            amountDescriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40.0),
            amountDescriptionLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16.0),
            amountDescriptionLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16.0),
            amountSegmentedControl.topAnchor.constraint(equalTo: amountDescriptionLabel.bottomAnchor, constant: 8.0),
            amountSegmentedControl.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16.0),
            amountSegmentedControl.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16.0)
        ])

        amountDescriptionLabel.font = Fonts.smallText
        amountDescriptionLabel.textColor = .systemPurple
        amountDescriptionLabel.textAlignment = .center
        amountDescriptionLabel.text = "Select amount of cells"

        amountSegmentedControl.addTarget(self, action: #selector(changeAmountValue), for: .valueChanged)
        amountSegmentedControl.insertSegment(withTitle: "8", at: 0, animated: false)
        amountSegmentedControl.insertSegment(withTitle: "9", at: 1, animated: false)
        amountSegmentedControl.insertSegment(withTitle: "12", at: 2, animated: false)
        amountSegmentedControl.insertSegment(withTitle: "16", at: 3, animated: false)
        amountSegmentedControl.selectedSegmentIndex = 0
    }

    private func configureRepeatedSelector() {
        let views: [UIView] = [repeatedDescriptionLabel, repeatedSegmentedControl]
        views.forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            repeatedDescriptionLabel.topAnchor.constraint(equalTo: amountSegmentedControl.bottomAnchor, constant: 40.0),
            repeatedDescriptionLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16.0),
            repeatedDescriptionLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16.0),
            repeatedSegmentedControl.topAnchor.constraint(equalTo: repeatedDescriptionLabel.bottomAnchor, constant: 8.0),
            repeatedSegmentedControl.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16.0),
            repeatedSegmentedControl.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16.0)
        ])

        repeatedDescriptionLabel.font = Fonts.smallText
        repeatedDescriptionLabel.textColor = .systemPurple
        repeatedDescriptionLabel.textAlignment = .center
        repeatedDescriptionLabel.text = "Select amount of repeated pics"

        repeatedSegmentedControl.insertSegment(withTitle: "2", at: 0, animated: false)
        repeatedSegmentedControl.insertSegment(withTitle: "3", at: 1, animated: false)
        repeatedSegmentedControl.insertSegment(withTitle: "4", at: 2, animated: false)
        repeatedSegmentedControl.selectedSegmentIndex = 0
    }

    private func configureButtons() {
        let buttons: [UIButton] = [playButton, continueButton, topScoreButton]
        buttons.forEach {
            buttonStackView.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.heightAnchor.constraint(equalToConstant: 60.0).isActive = true
            $0.setTitleColor(.white, for: .normal)
            $0.setTitleColor(.lightGray, for: .highlighted)
            $0.titleLabel?.font = Fonts.regularText
            $0.backgroundColor = .systemPurple
            $0.layer.cornerRadius = 60.0 / 4
            $0.layer.shadowOpacity = 0.7
            $0.layer.shadowRadius = 2
            $0.layer.shadowOffset = CGSize(width: 0, height: 4)
        }

        playButton.setTitle("Play", for: .normal)
        continueButton.setTitle("Continue", for: .normal)
        topScoreButton.setTitle("TopScore", for: .normal)

        playButton.addTarget(self, action: #selector(tapPlayButton), for: .touchUpInside)
        continueButton.addTarget(self, action: #selector(tapContinueButton), for: .touchUpInside)
        topScoreButton.addTarget(self, action: #selector(tapTopScoreButton), for: .touchUpInside)

        buttonStackView.axis = .vertical
        buttonStackView.spacing = 12.0

        view.addSubview(buttonStackView)
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16.0),
            buttonStackView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16.0),
            buttonStackView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16.0)
        ])
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
        let collectionViewController = CollectionViewController()
        present(collectionViewController, animated: true)
    }

    private func openTopScores() {
        let topScoresViewController = ScoreTableViewController()
        present(topScoresViewController, animated: true)
    }
}

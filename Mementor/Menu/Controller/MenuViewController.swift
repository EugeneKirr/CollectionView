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
    private let settingsButton = UIButton()

    private let cellAmountLabel = UILabel()
    private let repeatedPicsLabel = UILabel()

    private let projectLabel = UILabel()

    private let playButton = UIButton()
    private let continueButton = UIButton()
    private let topScoresButton = UIButton()
    private let buttonStackView = UIStackView()
    
    private let sessionManager = SessionManager()
    private let settingsManager = SettingsManager()

    @objc
    private func tapPlayButton(_ sender: UIButton) {
        let settings = settingsManager.fetchSettings()
        sessionManager.createNewSession(cellAmount: settings.cellAmount, repeatPics: settings.repeatedPics)
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

        view.backgroundColor = Colors.background
        configureTitle()
        configureProjectLabel()
        configureCellAmountLabel()
        configureRepeatedPicsLabel()
        configureSettingsButton()
        configureButtons()
        checkIfContinueButtonEnabled()
        configureSavedSettings()
    }

    private func configureTitle() {
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16.0),
            titleLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16.0),
            titleLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16.0)
        ])
        titleLabel.font = Fonts.regular
        titleLabel.textColor = Colors.text
        titleLabel.textAlignment = .center
        titleLabel.text = "Menu"
    }

    private func configureProjectLabel() {
        view.addSubview(projectLabel)
        projectLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            projectLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 48.0),
            projectLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16.0),
            projectLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16.0)
        ])
        projectLabel.font = Fonts.heading
        projectLabel.textColor = Colors.accent
        projectLabel.text = "Mementor"
    }

    private func configureCellAmountLabel() {
        view.addSubview(cellAmountLabel)
        cellAmountLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cellAmountLabel.topAnchor.constraint(equalTo: projectLabel.bottomAnchor, constant: 48.0),
            cellAmountLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16.0),
            cellAmountLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16.0)
        ])
        cellAmountLabel.font = Fonts.small
        cellAmountLabel.textColor = Colors.text
    }

    private func configureRepeatedPicsLabel() {
        view.addSubview(repeatedPicsLabel)
        repeatedPicsLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            repeatedPicsLabel.topAnchor.constraint(equalTo: cellAmountLabel.bottomAnchor, constant: 16.0),
            repeatedPicsLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16.0),
            repeatedPicsLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16.0)
        ])
        repeatedPicsLabel.font = Fonts.small
        repeatedPicsLabel.textColor = Colors.text
    }

    private func configureSettingsButton() {
        let settingsImage = UIImage(systemName: "gearshape", withConfiguration: UIImage.SymbolConfiguration(weight: .heavy))
        settingsButton.setImage(settingsImage, for: .normal)
        settingsButton.tintColor = Colors.onAccent
        settingsButton.backgroundColor = Colors.accent
        settingsButton.layer.cornerRadius = 32.0 / 2
        settingsButton.layer.shadowOpacity = 0.7
        settingsButton.layer.shadowRadius = 2
        settingsButton.layer.shadowOffset = CGSize(width: 0, height: 2)

        settingsButton.addTarget(self, action: #selector(openSettings), for: .touchUpInside)

        view.addSubview(settingsButton)
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            settingsButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12.0),
            settingsButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16.0),
            settingsButton.widthAnchor.constraint(equalToConstant: 32.0),
            settingsButton.heightAnchor.constraint(equalToConstant: 32.0)
        ])
    }

    private func configureButtons() {
        let buttons: [UIButton] = [playButton, continueButton, topScoresButton]
        buttons.forEach {
            buttonStackView.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.heightAnchor.constraint(equalToConstant: 60.0).isActive = true
            $0.setTitleColor(Colors.onAccent, for: .normal)
            $0.setTitleColor(.gray, for: .highlighted)
            $0.titleLabel?.font = Fonts.regular
            $0.backgroundColor = Colors.accent
            $0.layer.cornerRadius = 60.0 / 4
            $0.layer.shadowOpacity = 0.7
            $0.layer.shadowRadius = 2
            $0.layer.shadowOffset = CGSize(width: 0, height: 4)
        }

        playButton.setTitle("Play", for: .normal)
        continueButton.setTitle("Continue", for: .normal)
        topScoresButton.setTitle("Top Scores", for: .normal)

        playButton.addTarget(self, action: #selector(tapPlayButton), for: .touchUpInside)
        continueButton.addTarget(self, action: #selector(tapContinueButton), for: .touchUpInside)
        topScoresButton.addTarget(self, action: #selector(tapTopScoreButton), for: .touchUpInside)

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

    private func checkIfContinueButtonEnabled() {
        if sessionManager.isSessionExist() {
            continueButton.isEnabled = true
            continueButton.alpha = 1.0
        } else {
            continueButton.isEnabled = false
            continueButton.alpha = 0.5
        }
    }

    private func configureSavedSettings() {
        let savedSettings = settingsManager.fetchSettings()
        let selectedCellAmount = savedSettings.cellAmount
        let selectedRepeatedPics = savedSettings.repeatedPics

        cellAmountLabel.text = "Amount of cells: \(selectedCellAmount)"
        repeatedPicsLabel.text = "Amount of repeated pics: \(selectedRepeatedPics)"
    }

    private func openCollection() {
        let collectionViewController = CollectionViewController()
        collectionViewController.delegate = self
        present(collectionViewController, animated: true)
    }

    private func openTopScores() {
        let topScoresViewController = ScoreTableViewController()
        present(topScoresViewController, animated: true)
    }

    @objc
    private func openSettings() {
        let settingsViewController = SettingsViewController()
        settingsViewController.delegate = self
        present(settingsViewController, animated: true)
    }
}

extension MenuViewController: CollectionViewControllerDelegate {
    func collectionViewDidClose() {
        checkIfContinueButtonEnabled()
    }
}

extension MenuViewController: SettingsViewControllerDelegate {
    func settingsViewDidClose() {
        configureSavedSettings()
    }
}

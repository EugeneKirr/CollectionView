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
        sessionManager.createNewSession(cellAmount: settings.cellAmount, repeatPics: settings.repeatedPictures)
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
        configureProjectLabel()
        configureSettingsButton()
        configureButtons()
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
        titleLabel.font = Fonts.regular
        titleLabel.textColor = .systemPurple
        titleLabel.textAlignment = .center
        titleLabel.text = "Menu"
    }

    private func configureProjectLabel() {
        view.addSubview(projectLabel)
        projectLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            projectLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            projectLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16.0),
            projectLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16.0)
        ])
        projectLabel.font = Fonts.heading
        projectLabel.textColor = .systemPurple
        projectLabel.textAlignment = .center
        projectLabel.text = "Mementor"
    }

    private func configureSettingsButton() {
        let settingsImage = UIImage(systemName: "gearshape", withConfiguration: UIImage.SymbolConfiguration(weight: .heavy))
        settingsButton.setImage(settingsImage, for: .normal)
        settingsButton.tintColor = .white
        settingsButton.backgroundColor = .systemPurple
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
            $0.setTitleColor(.white, for: .normal)
            $0.setTitleColor(.gray, for: .highlighted)
            $0.titleLabel?.font = Fonts.regular
            $0.backgroundColor = .systemPurple
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

    private func openCollection() {
        let collectionViewController = CollectionViewController()
        present(collectionViewController, animated: true)
    }

    private func openTopScores() {
        let topScoresViewController = ScoreTableViewController()
        present(topScoresViewController, animated: true)
    }

    @objc
    private func openSettings() {
        let settingsViewController = SettingsViewController()
        present(settingsViewController, animated: true)
    }
}

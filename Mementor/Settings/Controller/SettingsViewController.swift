//
//  SettingsViewController.swift
//  Mementor
//
//  Created by Evgeniy Kireichev on 11.06.2023.
//  Copyright © 2023 Eugene Kireichev. All rights reserved.
//

import UIKit

protocol SettingsViewControllerDelegate: AnyObject {
    func settingsViewDidClose()
}

final class SettingsViewController: UIViewController {
    weak var delegate: SettingsViewControllerDelegate?

    private let titleLabel = UILabel()
    private let closeButton = UIButton()

    private let amountDescriptionLabel = UILabel()
    private let amountSegmentedControl = UISegmentedControl()

    private let repeatedDescriptionLabel = UILabel()
    private let repeatedSegmentedControl = UISegmentedControl()

    private let settingsManager = SettingsManager()
    private let availableCellAmounts = [8, 9, 12, 16]
    private let availableRepeatedPics = [2, 3, 4]

    private var selectedCellAmount: Int {
        guard
            let selectedSegmentTitle = amountSegmentedControl.titleForSegment(at: amountSegmentedControl.selectedSegmentIndex),
            let selectedAmount = Int(selectedSegmentTitle)
        else {
            return availableCellAmounts[0]
        }

        return selectedAmount
    }

    private var selectedRepeatedPics: Int {
        guard
            let selectedSegmentTitle = repeatedSegmentedControl.titleForSegment(at: repeatedSegmentedControl.selectedSegmentIndex),
            let selectedRepeat = Int(selectedSegmentTitle)
        else {
            return availableRepeatedPics[0]
        }

        return selectedRepeat
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Colors.background
        configureTitle()
        configureCloseButton()
        configureAmountSelector()
        configureRepeatedSelector()
        configureSavedSettings()
        checkAvailableModes(shouldResetState: false)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        let settings = Settings(cellAmount: selectedCellAmount, repeatedPics: selectedRepeatedPics)
        settingsManager.saveSettings(settings)
        delegate?.settingsViewDidClose()
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
        titleLabel.text = "Settings"
    }

    private func configureCloseButton() {
        closeButton.setImage(Images.close, for: .normal)
        closeButton.tintColor = Colors.onAccent
        closeButton.backgroundColor = Colors.accent
        closeButton.layer.cornerRadius = 32.0 / 2
        closeButton.layer.shadowOpacity = 0.7
        closeButton.layer.shadowRadius = 2
        closeButton.layer.shadowOffset = CGSize(width: 0, height: 2)

        closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)

        view.addSubview(closeButton)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12.0),
            closeButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16.0),
            closeButton.widthAnchor.constraint(equalToConstant: 32.0),
            closeButton.heightAnchor.constraint(equalToConstant: 32.0)
        ])
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

        amountDescriptionLabel.font = Fonts.small
        amountDescriptionLabel.textColor = Colors.text
        amountDescriptionLabel.textAlignment = .center
        amountDescriptionLabel.text = "Select amount of cells"

        amountSegmentedControl.addTarget(self, action: #selector(changeAmountValue), for: .valueChanged)
        availableCellAmounts.enumerated().forEach {
            amountSegmentedControl.insertSegment(withTitle: "\($1)", at: $0, animated: false)
        }
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

        repeatedDescriptionLabel.font = Fonts.small
        repeatedDescriptionLabel.textColor = Colors.text
        repeatedDescriptionLabel.textAlignment = .center
        repeatedDescriptionLabel.text = "Select amount of repeated pics"

        availableRepeatedPics.enumerated().forEach {
            repeatedSegmentedControl.insertSegment(withTitle: "\($1)", at: $0, animated: false)
        }
        repeatedSegmentedControl.selectedSegmentIndex = 0
    }

    private func checkAvailableModes(shouldResetState: Bool) {
        for index in (0 ..< repeatedSegmentedControl.numberOfSegments).reversed() {
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
            if shouldResetState {
                repeatedSegmentedControl.selectedSegmentIndex = index
            }
        }
    }

    private func configureSavedSettings() {
        let savedSettings = settingsManager.fetchSettings()
        let selectedCellAmount = savedSettings.cellAmount
        let selectedRepeatedPics = savedSettings.repeatedPics
        amountSegmentedControl.selectedSegmentIndex = availableCellAmounts.firstIndex { $0 == selectedCellAmount } ?? 0
        repeatedSegmentedControl.selectedSegmentIndex = availableRepeatedPics.firstIndex { $0 == selectedRepeatedPics } ?? 0
    }

    @objc
    private func changeAmountValue(_ sender: UISegmentedControl) {
        checkAvailableModes(shouldResetState: true)
    }

    @objc
    private func close() {
        dismiss(animated: true)
    }
}

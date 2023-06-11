//
//  SettingsManager.swift
//  Mementor
//
//  Created by Evgeniy Kireichev on 11.06.2023.
//  Copyright © 2023 Eugene Kireichev. All rights reserved.
//

import Foundation

final class SettingsManager {
    private let userDefaults = UserDefaults.standard

    private lazy var defaultSettings = Settings(cellAmount: 8, repeatedPictures: 2)

    func fetchSettings() -> Settings {
        guard
            let savedSettings = userDefaults.object(forKey: UserDefaultsKeys.settings.key) as? Data,
            let fetchedSettings = try? JSONDecoder().decode(Settings.self, from: savedSettings)
        else {
            return defaultSettings
        }

        return fetchedSettings
    }

    func saveSettings(_ settings: Settings) {
        guard let encodedSettings = try? JSONEncoder().encode(settings) else { return }

        userDefaults.set(encodedSettings, forKey: UserDefaultsKeys.settings.key)
    }
}

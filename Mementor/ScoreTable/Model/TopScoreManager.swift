//
//  TopScoreManager.swift
//  Mementor
//
//  Created by Evgeniy Kireichev on 10.06.2023.
//  Copyright © 2023 Eugene Kireichev. All rights reserved.
//

import Foundation

final class TopScoreManager {
    private let userDefaults = UserDefaults.standard

    private lazy var defaultTopScores: [TopScore] = [
        TopScore(name: "John Appleseed", score: 100000),
        TopScore(name: "Kate Bell", score: 90000),
        TopScore(name: "Anna Haro", score: 80000),
        TopScore(name: "Daniel Higgins", score: 70000),
        TopScore(name: "David Taylor", score: 60000),
        TopScore(name: "Hank Zakroff", score: 50000)
    ]

    func fetchTopScores() -> [TopScore] {
        guard
            let savedTopScores = userDefaults.object(forKey: UserDefaultsKeys.topScores.key) as? Data,
            let fetchedTopScores = try? JSONDecoder().decode([TopScore].self, from: savedTopScores)
        else {
            return defaultTopScores
        }

        return fetchedTopScores
    }

    func saveTopScores(_ topScores: [TopScore]) {
        guard let encodedTopScores = try? JSONEncoder().encode(topScores.sorted()) else { return }

        userDefaults.set(encodedTopScores, forKey: UserDefaultsKeys.topScores.key)
    }

    func resetTopScores() {
        guard let encodedTopScores = try? JSONEncoder().encode(defaultTopScores) else { return }

        userDefaults.set(encodedTopScores, forKey: UserDefaultsKeys.topScores.key)
    }
}

//
//  UserDefaultsKeys.swift
//  Mementor
//
//  Created by Eugene Kireichev on 20/03/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import Foundation

enum UserDefaultsKeys: String {
    case session
    case topScores
    case settings
}

extension UserDefaultsKeys {
    var key: String {
        rawValue
    }
}

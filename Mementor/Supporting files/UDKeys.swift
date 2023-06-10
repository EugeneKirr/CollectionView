//
//  UDKeys.swift
//  Mementor
//
//  Created by Eugene Kireichev on 20/03/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import Foundation

enum UDKeys {
    case encodedSession
}

extension UDKeys {
    var key: String {
        switch self {
        case .encodedSession: return "Encoded Session"
        }
    }
}

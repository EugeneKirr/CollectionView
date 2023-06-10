//
//  NetworkErrorHandling.swift
//  Mementor
//
//  Created by Eugene Kireichev on 20/04/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import Foundation


protocol NetworkErrorHandling: Error {
    
    init (errorDescription: String)
    
}

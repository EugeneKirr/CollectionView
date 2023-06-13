//
//  SessionManager.swift
//  Mementor
//
//  Created by Eugene Kireichev on 15/04/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import Foundation

final class SessionManager {
    private let userDefaults = UserDefaults.standard
    private let emptySession = Session(repeatPics: 0, cells: [], selectCounter: 0)
    
    private let assetsPicNames = (0 ... 25).map { "mem_card-\($0)" }
    
    func fetchSession() -> Session {
        guard
            let savedSession = userDefaults.object(forKey: UserDefaultsKeys.session.key) as? Data,
            let loadedSession = try? JSONDecoder().decode(Session.self, from: savedSession)
        else {
            return emptySession
        }

        return loadedSession
    }
    
    func isSessionExist() -> Bool {
        userDefaults.object(forKey: UserDefaultsKeys.session.key) != nil
    }
    
    func createNewSession(cellAmount: Int, repeatPics: Int) {
        var picNames = assetsPicNames.shuffled()
        var newCells = [CellModel]()
        for _ in 1...(cellAmount/repeatPics) {
            let picName = picNames.removeFirst()
            for _ in 1...repeatPics {
                let newCell = CellModel(isGuessed: false, pictureName: picName)
                newCells.append(newCell)
            }
        }
        let newSession = Session(repeatPics: repeatPics, cells: newCells.shuffled(), selectCounter: 0)
        saveSession(newSession)
    }
    
    func areSelectedCellsEqual(in session: Session, for selectedCells: [Int]) -> Bool {
        var selectedPicNames = [String]()
        for index in selectedCells {
            selectedPicNames.append(session.cells[index].pictureName)
        }
        return selectedPicNames.max() == selectedPicNames.min()
    }
    
    func updateGuessedFlag(in session: Session, for selectedCells: [Int]) {
        var updatedCells = session.cells
        for selectedIndex in selectedCells {
            updatedCells[selectedIndex] = CellModel(isGuessed: true, pictureName: session.cells[selectedIndex].pictureName)
        }
        let updatedSession = Session(repeatPics: session.repeatPics, cells: updatedCells, selectCounter: session.selectCounter)
        saveSession(updatedSession)
    }
    
    func updateSelectCounter(in session: Session, with counter: Int) {
        let updatedSession = Session(repeatPics: session.repeatPics, cells: session.cells, selectCounter: counter)
        saveSession(updatedSession)
    }
    
    func areCellsAllGuessed(in session: Session) -> Bool {
        var guessedCellCounter = 0
        for cell in session.cells {
            cell.isGuessed ? guessedCellCounter += 1 : nil
        }
        return guessedCellCounter == session.cells.count
    }

    private func saveSession(_ session: Session) {
        guard let encodedSession = try? JSONEncoder().encode(session) else { return }

        userDefaults.set(encodedSession, forKey: UserDefaultsKeys.session.key)
    }
}

//
//  SessionManager.swift
//  Mementor
//
//  Created by Eugene Kireichev on 15/04/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import Foundation

final class SessionManager {
    
    private let emptySession = Session(repeatPics: 0, cells: [], selectCounter: 0)
    
    private let assetsPicNames = ["birdperson", "chair", "evil", "jerry", "meeseeks", "mister", "morty", "nightmare", "pickle", "pluto", "rick", "santa", "show", "snowball", "squanchy", "summer", "sun"]
    
    func getFromUD() -> Session {
        let defaults = UserDefaults.standard
        guard let savedSession = defaults.object(forKey: UserDefaultsKeys.encodedSession.key) as? Data else { return emptySession }
        let decoder = JSONDecoder()
        guard let loadedSession = try? decoder.decode(Session.self, from: savedSession) else { return emptySession }
        return loadedSession
    }
    
    func isSessionExist() -> Bool {
        let defaults = UserDefaults.standard
        return defaults.object(forKey: UserDefaultsKeys.encodedSession.key) != nil
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
        self.putToUD(newSession)
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
        self.putToUD(updatedSession)
    }
    
    func updateSelectCounter(in session: Session, with counter: Int) {
        let updatedSession = Session(repeatPics: session.repeatPics, cells: session.cells, selectCounter: counter)
        self.putToUD(updatedSession)
    }
    
    func areCellsAllGuessed(in session: Session) -> Bool {
        var guessedCellCounter = 0
        for cell in session.cells {
            cell.isGuessed ? guessedCellCounter += 1 : nil
        }
        return guessedCellCounter == session.cells.count
    }

    private func putToUD(_ session: Session) {
        let encoder = JSONEncoder()
        guard let encodedSession = try? encoder.encode(session) else { return }
        let defaults = UserDefaults.standard
        defaults.set(encodedSession, forKey: UserDefaultsKeys.encodedSession.key)
    }
}

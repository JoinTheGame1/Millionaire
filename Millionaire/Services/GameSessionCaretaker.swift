//
//  GameSessionCaretaker.swift
//  Millionaire
//
//  Created by Никитка on 07.12.2021.
//

import Foundation
import RealmSwift

class GameSessionCaretaker {
    lazy var configuration = Realm.Configuration(objectTypes: [GameStatistics.self, GamePersisted.self])
    lazy var realm = try! Realm(configuration: configuration)
    
    private let key = "inProgress"
    
    func load() -> GamePersisted? {
        return realm.objects(GamePersisted.self).first
    }
    
    func save(_ gameSession: GameSession) {
        let game = GamePersisted()
        
        game.id = key
        game.currentQuestionNumber = gameSession.currentQuestionNumber
        game.isFiftyFiftyUsed = gameSession.isFiftyFiftyUsed
        game.isPhoneUsed = gameSession.isPhoneUsed
        game.isAskAudienceUsed = gameSession.isAskAudienceUsed
        
        do {
            try realm.write {
                let oldGame = realm.objects(GamePersisted.self)
                realm.delete(oldGame)
                realm.add(game, update: .all)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func delete() {
        let game = GamePersisted()
        game.id = key
        do {
            try realm.write {
                realm.add(game, update: .all)
                realm.delete(game)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}

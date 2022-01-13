//
//  GameSession.swift
//  Millionaire
//
//  Created by Никитка on 06.12.2021.
//

import Foundation
import RealmSwift

class GameSession: Object {
    @objc dynamic var gameStatus: GameStatus = .uninitialized
    
    @Persisted var currentQuestionNumber: Int
    @Persisted var currentQuestion: Question?
    
    @Persisted var isFiftyFiftyUsed: Bool
    @Persisted var isPhoneUsed: Bool
    @Persisted var isAskAudienceUsed: Bool
    
    var earnedMoney: Int {
        let game = Game.shared
        return game.payout[currentQuestionNumber - 1] ?? 0
    }
    
    var guaranteedEarnedMoney: Int {
        let game = Game.shared
        switch currentQuestionNumber {
        case 0...5: return 0
        case 6...10: return game.payout[5] ?? 0
        case 11...15: return game.payout[10] ?? 0
        default: return 0
        }
    }
}

@objc enum GameStatus: Int, RealmEnum {
    case uninitialized = 0
    case inProgress = 1
    case lost = 2
    case aborted = 3
    case won = 4
}

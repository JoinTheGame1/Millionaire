//
//  Game.swift
//  Millionaire
//
//  Created by Никитка on 06.12.2021.
//

import Foundation

class Game {
    static let shared = Game()
    private init() {}
    
    var gameSession: GameSession?
    
    let totalQuestions = 15
    let delay: TimeInterval = 1
    let payout = [
        1: 500,
        2: 1_000,
        3: 2_000,
        4: 3_000,
        5: 5_000,
        6: 10_000,
        7: 15_000,
        8: 25_000,
        9: 50_000,
        10: 100_000,
        11: 200_000,
        12: 400_000,
        13: 800_000,
        14: 1_500_000,
        15: 3_000_000
    ]
    
    var currentQuestionIndex: Int {
        var current = gameSession?.currentQuestionNumber ?? 0
        if (gameSession?.gameStatus == .lost && current > 0) || (gameSession?.gameStatus == .aborted) {
            current -= 1
        }
        return current
    }
    
    var currentQuestionText: String {
        return gameSession?.currentQuestion?.text ?? ""
    }
    
    var correctAnswer: String {
        let currentQuestion = gameSession?.currentQuestion
        let correctAnswerIndex = currentQuestion?.correctAnswerIndex ?? 0
        return currentQuestion?.answers[correctAnswerIndex].text ?? ""
    }
    
    var percentage: Int {
        return currentQuestionIndex * 100 / totalQuestions
    }
    
    var totalMoneyWon: Int {
        guard let status = self.gameSession?.gameStatus else { return 0 }
        
        switch status {
        case .uninitialized: return 0
        case .lost: return gameSession!.guaranteedEarnedMoney
        case .aborted: return gameSession!.earnedMoney
        case .won: return payout[totalQuestions] ?? 3_000_000
        default: return 0
        }
    }
    
    var gameStatus: String {
        guard let status = self.gameSession?.gameStatus else { return "-----" }
        switch status {
        case .uninitialized: return "not initialized"
        case .inProgress: return "in progress"
        case .lost: return "lost"
        case .aborted: return "aborted by user"
        case .won: return "won"
        }
    }
    
    let letterForAnswerIndex = [
        0: "A",
        1: "B",
        2: "C",
        3: "D",
    ]
}

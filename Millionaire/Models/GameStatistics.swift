//
//  GameStatistics.swift
//  Millionaire
//
//  Created by Никитка on 07.12.2021.
//

import Foundation
import RealmSwift

class GameStatistics: Object {
    @Persisted var date: String?
    @Persisted var gameStatus: String?
    
    @Persisted var correctAnswersCount: Int
    @Persisted var percentage: Int
    
    @Persisted var isFiftyFiftyUsed: Bool
    @Persisted var isPhoneUsed: Bool
    @Persisted var isAskAudienceUsed: Bool
    
    @Persisted var totalMoneyWon: Int
    @Persisted var fatalQuestion: String?
    @Persisted var correctAnswerForFatal: String?
    
    var text: String {
        var text = """
        Date: \(self.date ?? "-")
        Result: \(self.gameStatus ?? "-")
        -----------------
        Money won: \(self.totalMoneyWon.formatted) ₽
        Correct: \(self.correctAnswersCount)/15, \(self.percentage)%
        
        -----HINTS-----
        50/50: \(self.isFiftyFiftyUsed ? "used" : "not used")
        Phone: \(self.isPhoneUsed ? "used" : "not used")
        Ask audience: \(self.isAskAudienceUsed ? "used" : "not used")
        -----------------
        """
        
        if self.fatalQuestion != nil {
            text += """
            ---------------
            Fatal question: \(self.fatalQuestion!)
            Correct answer: \(self.correctAnswerForFatal!)
            """
        }
        return text
    }
}

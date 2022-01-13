//
//  QnA.swift
//  Millionaire
//
//  Created by Никитка on 05.12.2021.
//

import Foundation
import RealmSwift

class Question: Object {
    @Persisted var difficulty: Int
    @Persisted var text: String
    @Persisted var answers: List<Answer>
    
    var correctAnswerIndex: Int {
        return answers.firstIndex(where: { $0.correct }) ?? 0
    }
}

class Answer: Object {
    @Persisted var text: String
    @Persisted var correct: Bool
}

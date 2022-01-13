//
//  QnAProvider.swift
//  Millionaire
//
//  Created by Никитка on 06.12.2021.
//

import Foundation
import RealmSwift

class QnAProvider {
    lazy var dbUrl = Bundle.main.url(forResource: "dataNew", withExtension: "realm")
    lazy var configuration = Realm.Configuration(fileURL: dbUrl, readOnly: true, objectTypes: [Question.self, Answer.self])
    lazy var realm = try! Realm(configuration: configuration)
    
    func fetchRandomQuestion(for difficulty: Int) -> Question? {
        
        let questions = Array(realm.objects(Question.self).filter("difficulty == \(difficulty)"))
        return questions.count > 0 ? questions[Int.random(in: 0..<questions.count)] : nil
    }
    
    func numberOfQuestions(for difficulty: Int) -> Int? {
        
        return realm.objects(Question.self).filter("difficulty == \(difficulty)").count
    }
}

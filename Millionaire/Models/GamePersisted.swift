//
//  GamePersisted.swift
//  Millionaire
//
//  Created by Никитка on 07.12.2021.
//

import Foundation
import RealmSwift

class GamePersisted: Object {
    @Persisted var id: String
    @Persisted var currentQuestionNumber: Int
    @Persisted var isFiftyFiftyUsed: Bool
    @Persisted var isPhoneUsed: Bool
    @Persisted var isAskAudienceUsed: Bool
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

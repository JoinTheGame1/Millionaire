//
//  StatisticsService.swift
//  Millionaire
//
//  Created by Никитка on 09.12.2021.
//

import Foundation
import RealmSwift

class StatisticsService {
    lazy var configuration = Realm.Configuration(objectTypes: [GameStatistics.self, GamePersisted.self])
    lazy var realm = try! Realm(configuration: configuration)
    
    func fetch() -> [GameStatistics]? {
        return Array(realm.objects(GameStatistics.self))
    }
    
    func fetchLast() -> GameStatistics? {
        return realm.objects(GameStatistics.self).last
    }
    
    func add(_ data: GameStatistics) {
        do {
            try realm.write {
                realm.add(data)
            }
        }
        catch {
            print(error.localizedDescription)
        }
    }
}

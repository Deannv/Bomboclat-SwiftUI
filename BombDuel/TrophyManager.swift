//
//  TrophyManager.swift
//  BombDuel
//
//  Created by Kemas Deanova on 19/05/25.
//

import Foundation

class TrophyManager {
    static let shared = TrophyManager()

    func getTrophies(for player: String) -> Int {
        UserDefaults.standard.integer(forKey: "trophies_\(player)")
    }

    func incrementTrophies(for player: String) {
        let key = "trophies_\(player)"
        let current = getTrophies(for: player)
        UserDefaults.standard.set(current + 1, forKey: key)
    }
}

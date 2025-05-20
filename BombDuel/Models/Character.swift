//
//  Character.swift
//  BombDuel
//
//  Created by Kemas Deanova on 19/05/25.
//

import Foundation

struct Character: Identifiable {
    let id = UUID()
    var name: String
    var imageName: String
    var unlockTrophy: Int
}


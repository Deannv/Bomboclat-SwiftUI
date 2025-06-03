//
//  Player.swift
//  BombDuel
//
//  Created by Kemas Deanova on 19/05/25.
//

import Foundation

struct Player: Identifiable {
    let id = UUID()
    var name: String
    var selectedCharacter: Character
    var lives: Int = 3
    
   
    
}

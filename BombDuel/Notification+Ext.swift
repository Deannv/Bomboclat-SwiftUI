//
//  Notification+Ext.swift
//  BombDuel
//
//  Created by Kemas Deanova on 19/05/25.
//

import Foundation

extension Notification.Name {
    static let passBombP1 = Notification.Name("passBombP1")
    static let passBombP2 = Notification.Name("passBombP2")
    static let effectP1 = Notification.Name("effectP1")
    static let effectP2 = Notification.Name("effectP2")
    static let updateHearts = Notification.Name("updateHearts")
    static let effectReset = Notification.Name("effectReset")
    static let gameOver = Notification.Name("gameOver")
    static let rematch = Notification.Name("rematch")
    static let bombHolderChanged = Notification.Name("bombHolderChanged")
    static let showExplosionModal = Notification.Name("showExplosionModal")
}


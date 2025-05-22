//
//  GameViewModel.swift
//  BombDuel
//
//  Created by Kemas Deanova on 22/05/25.
//

import Foundation
import Combine

class GameViewModel: ObservableObject {
    @Published var player1: Player
    @Published var player2: Player
    @Published var holdingPlayer: Player
    @Published var bombTimeRemaining: Int = 0
    @Published var isTimerVisible: Bool = true
    @Published var bombExploded: Bool = false
    @Published var gameOver: Bool = false
    @Published var winner: Player? = nil

    var timer: Timer?

    init(player1: Player, player2: Player) {
        self.player1 = player1
        self.player2 = player2
        self.holdingPlayer = player1
        startBombTimer()
    }

    func startBombTimer() {
        bombTimeRemaining = Int.random(in: 5...8)
        isTimerVisible = true
        bombExploded = false

        // Hide timer after 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.isTimerVisible = false
        }

        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { t in
            if self.bombTimeRemaining > 0 {
                self.bombTimeRemaining -= 1
            } else {
                t.invalidate()
                self.explodeBomb()
            }
        }
    }

    func explodeBomb() {
        bombExploded = true
        holdingPlayer.lives -= 1

        if holdingPlayer.lives <= 0 {
            gameOver = true
            winner = (holdingPlayer.id == player1.id) ? player2 : player1
        } else {
            startBombTimer()
        }
    }

    func passBomb() {
        timer?.invalidate()
        holdingPlayer = (holdingPlayer.id == player1.id) ? player2 : player1
        startBombTimer()
    }

    func resetGame() {
        player1.lives = 3
        player2.lives = 3
        holdingPlayer = player1
        gameOver = false
        winner = nil
        startBombTimer()
    }
}

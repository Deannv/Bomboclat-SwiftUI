//
//  GameLogicViewModel.swift
//  BombDuel
//
//  Created by Kemas Deanova on 22/05/25.
//

import Foundation
import Combine

class GameLogicViewModel: ObservableObject {
    @Published var bombTimer: Int = 0
    @Published var showBombTimer: Bool = true
    @Published var bombHolder: Int = 1
    @Published var p1Hearts = 3
    @Published var p2Hearts = 3

    @Published var passCooldown = 0
    @Published var showExplosionModal = false
    @Published var explodedPlayerName: String = ""

    private var bombTickTimer: Timer?
    private var cooldownTimer: Timer?
    private var bombStartTime: Date?

    func startGame() {
        startBombTimer()
    }

    func startBombTimer() {
        bombTimer = Int.random(in: 10...15)
        bombStartTime = Date()
        showBombTimer = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.showBombTimer = false
        }

        bombTickTimer?.invalidate()
        bombTickTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            self.bombTimer -= 1
            if self.bombTimer <= 0 {
                timer.invalidate()
                self.handleExplosion()
            }
        }
    }

    func startPassCooldown() {
        passCooldown = 3
        cooldownTimer?.invalidate()
        cooldownTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            self.passCooldown -= 1
            if self.passCooldown <= 0 {
                timer.invalidate()
            }
        }
    }

    func canPass(for player: Int) -> Bool {
        return player == bombHolder && passCooldown == 0
    }

    func passBomb() {
        guard canPass(for: bombHolder) else { return }
        bombHolder = bombHolder == 1 ? 2 : 1
        startPassCooldown()
        // Don't reset bomb timer — it stays running
    }

    func handleExplosion() {
        if bombHolder == 1 {
            p1Hearts -= 1
            explodedPlayerName = "💥 \(bombHolderName()) exploded!"
        } else {
            p2Hearts -= 1
            explodedPlayerName = "💥 \(bombHolderName()) exploded!"
        }

        showExplosionModal = true
    }

    func continueAfterExplosion() {
        showExplosionModal = false
        if p1Hearts == 0 || p2Hearts == 0 {
            NotificationCenter.default.post(name: .gameOver, object: p1Hearts > 0 ? 1 : 2)
        } else {
            startGame()
        }
    }

    func bombHolderName() -> String {
        return bombHolder == 1 ? "Player 1" : "Player 2"
    }

    func stop() {
        bombTickTimer?.invalidate()
        cooldownTimer?.invalidate()
    }
}


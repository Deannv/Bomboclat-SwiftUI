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
    @Published var bombHolder: Int {
        didSet {
            NotificationCenter.default.post(name: .bombHolderChanged, object: bombHolder)
        }
    }
    @Published var p1Hearts = 3
    @Published var p2Hearts = 3

    @Published var passCooldownPlayerOne = 0
    @Published var passCooldownPlayerTwo = 0
    @Published var showExplosionModal = false
    @Published var explodedPlayerName: String = ""

    @Published var p1EffectUsed = false
    @Published var p2EffectUsed = false

    private var bombTickTimer: Timer?
    private var cooldownTimer: Timer?
    private var bombStartTime: Date?

    var characterOne: Character?
    var characterTwo: Character?

    init(characterOne: Character? = nil, characterTwo: Character? = nil) {
        self.characterOne = characterOne
        self.characterTwo = characterTwo
        self.bombHolder = 1
    }

    func startGame() {
        passCooldownPlayerOne = 0
        passCooldownPlayerTwo = 0
//        NotificationCenter.default.post(name: .updateHearts, object: [1: p1Hearts, 2: p2Hearts])
//        NotificationCenter.default.post(name: .effectReset, object: nil)

        startBombTimer()
    }

    func rematch() {
        p1EffectUsed = false
        p2EffectUsed = false
        p1Hearts = 3
        p2Hearts = 3
        bombHolder = 1
        
        startGame()
    }

    func startBombTimer() {
        bombTimer = bombTimer < 1 ? Int.random(in: 10...15) : bombTimer
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
        if bombHolder == 1 {
            passCooldownPlayerTwo = Int.random(in: 1...3)
        } else {
            passCooldownPlayerOne = Int.random(in: 1...3)
        }

        cooldownTimer?.invalidate()
        cooldownTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if self.passCooldownPlayerTwo > 0 {
                self.passCooldownPlayerTwo -= 1
            }
            if self.passCooldownPlayerOne > 0 {
                self.passCooldownPlayerOne -= 1
            }
            if self.passCooldownPlayerOne == 0 && self.passCooldownPlayerTwo == 0 {
                timer.invalidate()
            }
        }
    }

    func canPass(for player: Int) -> Bool {
        return player == bombHolder && (player == 1 ? passCooldownPlayerOne == 0 : passCooldownPlayerTwo == 0)
    }

    func passBomb() {
        guard canPass(for: bombHolder) else { return }
        bombHolder = bombHolder == 1 ? 2 : 1
        startPassCooldown()
    }
    
    func checkGameOver() {
        if p1Hearts <= 0 {
            NotificationCenter.default.post(name: .gameOver, object: 2) // Player 2 wins
            
        } else if p2Hearts <= 0 {
            NotificationCenter.default.post(name: .gameOver, object: 1) // Player 1 wins
        }
    }
    
    func endGame(winner: Int) {
        NotificationCenter.default.post(name: .gameOver, object: winner)
    }


    func useEffect(player: Int) {
        if (player == 1 && p1EffectUsed) || (player == 2 && p2EffectUsed) { return }

        let isHeal = Bool.random()
        if player == 1 {
            p1EffectUsed = true
            if isHeal && p1Hearts < 3 {
                p1Hearts += 1
            } else {
                p1Hearts -= 1
                checkGameOver()
            }
            NotificationCenter.default.post(name: .updateHearts, object: [1: p1Hearts])
        } else {
            p2EffectUsed = true
            if isHeal && p2Hearts < 3 {
                p2Hearts += 1
            } else {
                p2Hearts -= 1
                checkGameOver()
            }
            NotificationCenter.default.post(name: .updateHearts, object: [2: p2Hearts])
        }
    }

    func handleExplosion() {
        if bombHolder == 1 {
            p1Hearts -= 1
            explodedPlayerName = "💥 \(bombHolderName() ?? "Unknown") exploded!"
        } else {
            p2Hearts -= 1
            explodedPlayerName = "💥 \(bombHolderName() ?? "Unknown") exploded!"
        }
        NotificationCenter.default.post(name: .updateHearts, object: [1: p1Hearts, 2: p2Hearts])
        showExplosionModal = true
    }

    func continueAfterExplosion() {
        showExplosionModal = false
        if p1Hearts == 0 || p2Hearts == 0 {
            NotificationCenter.default.post(name: .gameOver, object: p1Hearts > 0 ? 1 : 2)
            rematch()
        } else {
            startGame()
        }
    }

    func bombHolderName() -> String? {
        return bombHolder == 1 ? characterOne?.name : characterTwo?.name
    }

    func stop() {
        bombTickTimer?.invalidate()
        cooldownTimer?.invalidate()
    }
}



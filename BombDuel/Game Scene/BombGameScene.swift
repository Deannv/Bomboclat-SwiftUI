//
//  BombGameScene.swift
//  BombDuel
//
//  Created by Kemas Deanova on 19/05/25.
//

import Foundation
import SpriteKit

class BombGameScene: SKScene {
    // Force unwrapping
    var player1: Player!
    var player2: Player!

    private var bombNode: SKSpriteNode!
    private var currentHolder = 1 // 1 = player1, 2 = player2

    private var p1EffectUsed = false
    private var p2EffectUsed = false
    private var passCooldown = false
    
    private var p1Lives = 3
    private var p2Lives = 3

    private var heartNodesP1 = [SKSpriteNode]()
    private var heartNodesP2 = [SKSpriteNode]()


    override func didMove(to view: SKView) {
        backgroundColor = .gray

        setupPlayers()
        setupBomb()
        setupNotifications()
        setupHearts()
    }
    
    func setupHearts() {
        for i in 0..<3 {
            let heart = SKSpriteNode(imageNamed: "heart")
            heart.position = CGPoint(x: 40 + CGFloat(i) * 40, y: size.height - 40)
            heart.size = CGSize(width: 30, height: 30)
            addChild(heart)
            heartNodesP1.append(heart)
        }

        for i in 0..<3 {
            let heart = SKSpriteNode(imageNamed: "heart")
            heart.position = CGPoint(x: size.width - 40 - CGFloat(i) * 40, y: 40)
            heart.size = CGSize(width: 30, height: 30)
            addChild(heart)
            heartNodesP2.append(heart)
        }
    }

    
    func setupPlayers() {
        let p1Sprite = SKSpriteNode(imageNamed: player1.selectedCharacter.imageName)
        p1Sprite.position = CGPoint(x: size.width/2, y: size.height * 0.8)
        p1Sprite.size = CGSize(width: 150, height: 200)
        addChild(p1Sprite)

        let p2Sprite = SKSpriteNode(imageNamed: player2.selectedCharacter.imageName)
        p2Sprite.position = CGPoint(x: size.width/2, y: size.height * 0.2)
        p2Sprite.size = CGSize(width: 150, height: 200)
        addChild(p2Sprite)
    }

    func setupBomb() {
        bombNode = SKSpriteNode(imageNamed: "bomb") // Make sure you add this image in Assets
        bombNode.position = CGPoint(x: size.width/2, y: size.height * 0.8)
        bombNode.size = CGSize(width: 50, height: 50)
        addChild(bombNode)
    }

    func setupNotifications() {
        NotificationCenter.default.addObserver(forName: .passBombP1, object: nil, queue: .main) { _ in
            self.tryPassBomb(from: 1)
        }

        NotificationCenter.default.addObserver(forName: .passBombP2, object: nil, queue: .main) { _ in
            self.tryPassBomb(from: 2)
        }

        NotificationCenter.default.addObserver(forName: .effectP1, object: nil, queue: .main) { _ in
            self.useEffect(player: 1)
        }

        NotificationCenter.default.addObserver(forName: .effectP2, object: nil, queue: .main) { _ in
            self.useEffect(player: 2)
        }
    }

    func tryPassBomb(from player: Int) {
        guard !passCooldown, currentHolder == player else { return }

        passCooldown = true
        currentHolder = (player == 1) ? 2 : 1

        let targetY = currentHolder == 1 ? size.height * 0.8 : size.height * 0.2

        let move = SKAction.moveTo(y: targetY, duration: 0.3)
        bombNode.run(move)

        let cooldown = Double(Int.random(in: 1...3))

        DispatchQueue.main.asyncAfter(deadline: .now() + cooldown) {
            self.passCooldown = false
        }
    }
    
    func updateHearts(player: Int) {
        let nodes = (player == 1) ? heartNodesP1 : heartNodesP2
        let lives = (player == 1) ? p1Lives : p2Lives

        for (index, heart) in nodes.enumerated() {
            heart.alpha = index < lives ? 1.0 : 0.2
        }
    }

    func checkGameOver() {
        if p1Lives <= 0 {
            showGameOver(winner: 2)
        } else if p2Lives <= 0 {
            showGameOver(winner: 1)
        }
    }

    func showGameOver(winner: Int) {
        NotificationCenter.default.post(name: .gameOver, object: winner)
        isPaused = true
    }

    
    func useEffect(player: Int) {
        if player == 1 && p1EffectUsed { return }
        if player == 2 && p2EffectUsed { return }

        let isHeal = Bool.random()

        if player == 1 {
            p1EffectUsed = true
            if isHeal {
                if p1Lives < 3 {
                    p1Lives += 1
                    updateHearts(player: 1)
                }
            } else {
                p1Lives -= 1
                updateHearts(player: 1)
                checkGameOver()
            }
        } else {
            p2EffectUsed = true
            if isHeal {
                if p2Lives < 3 {
                    p2Lives += 1
                    updateHearts(player: 2)
                }
            } else {
                p2Lives -= 1
                updateHearts(player: 2)
                checkGameOver()
            }
        }
    }

}

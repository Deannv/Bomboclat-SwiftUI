//
//  BombGameScene.swift
//  BombDuel
//
//  Created by Kemas Deanova on 19/05/25.
//

import SpriteKit

class BombGameScene: SKScene {
    var player1: Player!
    var player2: Player!

    private var bombNode: SKSpriteNode!
    private var p1Sprite: SKSpriteNode!
    private var p2Sprite: SKSpriteNode!

    override func didMove(to view: SKView) {
        backgroundColor = .gray
        setupPlayers()
        setupBomb()
        setupNotifications()
    }

    func setupPlayers() {
        p1Sprite = SKSpriteNode(imageNamed: player1.selectedCharacter.imageName)
        p1Sprite.position = CGPoint(x: size.width/2, y: size.height * 0.8)
        p1Sprite.size = CGSize(width: 150, height: 200)
        addChild(p1Sprite)

        p2Sprite = SKSpriteNode(imageNamed: player2.selectedCharacter.imageName)
        p2Sprite.position = CGPoint(x: size.width/2, y: size.height * 0.2)
        p2Sprite.size = CGSize(width: 150, height: 200)
        addChild(p2Sprite)
    }

    func setupBomb() {
        bombNode = SKSpriteNode(imageNamed: "bomb")
        bombNode.position = CGPoint(x: size.width/2, y: size.height * 0.8) // Default start
        bombNode.size = CGSize(width: 50, height: 50)
        addChild(bombNode)
    }

    func setupNotifications() {
        NotificationCenter.default.addObserver(forName: .bombHolderChanged, object: nil, queue: .main) { [weak self] notification in
            guard let self = self else { return }
            if let holder = notification.object as? Int {
                self.moveBomb(to: holder)
            }
        }
    }

    func moveBomb(to player: Int) {
        let targetY = player == 1 ? size.height * 0.8 : size.height * 0.2
        let move = SKAction.moveTo(y: targetY, duration: 0.3)
        bombNode.run(move)
    }
}


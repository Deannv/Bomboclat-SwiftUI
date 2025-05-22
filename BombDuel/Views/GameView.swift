//
//  GameView.swift
//  BombDuel
//
//  Created by Kemas Deanova on 19/05/25.
//
import SwiftUI
import SpriteKit

struct GameView: View {
    @Environment(\.presentationMode) var presentationMode
    var player1: Player
    var player2: Player

    @State private var isPaused = false
    @State private var isMuted = false
    @State private var winnerPlayer: Player? = nil
    @StateObject private var gameLogic = GameLogicViewModel()

    private var scene: SKScene {
        let scene = BombGameScene(size: UIScreen.main.bounds.size)
        scene.scaleMode = .resizeFill
        scene.player1 = player1
        scene.player2 = player2
        return scene
    }

    var body: some View {
        ZStack {
            SpriteView(scene: scene)
                .ignoresSafeArea()

            VStack {
                HStack {
                    Button(action: {
                        isMuted.toggle()
                        SoundManager.shared.toggleMute()
                    }) {
                        Image(systemName: isMuted ? "speaker.slash.fill" : "speaker.wave.2.fill")
                            .font(.title)
                            .padding()
                    }

                    Spacer()

                    Button("Pause") {
                        isPaused = true
                        scene.isPaused = true
                        gameLogic.stop()
                    }
                    .padding()
                }

                Spacer()

                if gameLogic.showBombTimer {
                    Text("💣 \(gameLogic.bombTimer)")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.black.opacity(0.7))
                        .cornerRadius(12)
                }

                Spacer()

                HStack {
                    VStack {
                        Text("❤️ \(gameLogic.p1Hearts)")
                        Button(action: {
                            gameLogic.passBomb()
                            NotificationCenter.default.post(name: .passBombP1, object: nil)
                        }) {
                            Text(gameLogic.canPass(for: 1)
                                 ? "Pass Bomb"
                                 : "Cooldown \(gameLogic.passCooldown)")
                        }
                        .disabled(!gameLogic.canPass(for: 1) || isPaused || gameLogic.showExplosionModal)
                        .padding()

                        Button("Effect") {
                            NotificationCenter.default.post(name: .effectP1, object: nil)
                        }
                        .disabled(isPaused || gameLogic.bombHolder != 1 || gameLogic.showExplosionModal)
                        .padding()
                    }

                    Spacer()

                    VStack {
                        Text("❤️ \(gameLogic.p2Hearts)")
                        Button(action: {
                            gameLogic.passBomb()
                            NotificationCenter.default.post(name: .passBombP2, object: nil)
                        }) {
                            Text(gameLogic.canPass(for: 2)
                                 ? "Pass Bomb"
                                 : "Cooldown \(gameLogic.passCooldown)")
                        }
                        .disabled(!gameLogic.canPass(for: 2) || isPaused || gameLogic.showExplosionModal)
                        .padding()

                        Button("Effect") {
                            NotificationCenter.default.post(name: .effectP2, object: nil)
                        }
                        .disabled(isPaused || gameLogic.bombHolder != 2 || gameLogic.showExplosionModal)
                        .padding()
                    }
                }
                .padding()
            }

            // Pause Modal
            if isPaused {
                VStack {
                    Text("Paused").font(.largeTitle)
                    Button("Resume") {
                        isPaused = false
                        scene.isPaused = false
                        gameLogic.startBombTimer()
                    }.padding()

                    Button("Exit") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                .padding()
                .background(Color.black.opacity(0.8))
                .cornerRadius(10)
            }

            // Explosion Modal
            if gameLogic.showExplosionModal {
                VStack {
                    Text(gameLogic.explodedPlayerName)
                        .font(.largeTitle)
                        .padding()
                    Button("Continue") {
                        gameLogic.continueAfterExplosion()
                    }
                }
                .padding()
                .background(Color.red.opacity(0.85))
                .cornerRadius(12)
            }

            // Game Over Modal
            if let winner = winnerPlayer {
                GameOverView(winner: winner) {
                    winnerPlayer = nil
                    gameLogic.stop()
                } onExit: {
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
        .onAppear {
            gameLogic.startGame()
            NotificationCenter.default.addObserver(forName: .gameOver, object: nil, queue: .main) { notification in
                if let winnerNum = notification.object as? Int {
                    let winner = winnerNum == 1 ? player1 : player2
                    self.winnerPlayer = winner
                    TrophyManager.shared.incrementTrophies(for: winner.name)
                }
            }
        }
        .onDisappear {
            gameLogic.stop()
        }
    }
}

#Preview {
//    GameView()
}

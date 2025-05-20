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

    // Computed Propertieis
    private var scene: SKScene {
        let scene = BombGameScene(size: UIScreen.main.bounds.size)
        scene.scaleMode = .resizeFill
        scene.player1 = player1
        scene.player2 = player2
        return scene
    }

    var body: some View {
        if let winner = winnerPlayer {
            GameOverView(winner: winner) {
                winnerPlayer = nil
                // Reset logic (recreate scene)
            } onExit: {
                presentationMode.wrappedValue.dismiss()
            }
        }

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
                    }
                    .padding()
                }

                Spacer()

                HStack {
                    VStack {
                        Button("Pass Bomb") {
                            NotificationCenter.default.post(name: .passBombP1, object: nil)
                        }
                        .padding()

                        Button("Effect") {
                            NotificationCenter.default.post(name: .effectP1, object: nil)
                        }
                        .padding()
                    }

                    Spacer()

                    VStack {
                        Button("Pass Bomb") {
                            NotificationCenter.default.post(name: .passBombP2, object: nil)
                        }
                        .padding()

                        Button("Effect") {
                            NotificationCenter.default.post(name: .effectP2, object: nil)
                        }
                        .padding()
                    }
                }
                .padding()
            }

            if isPaused {
                VStack {
                    Text("Paused")
                        .font(.largeTitle)
                    Button("Resume") {
                        isPaused = false
                        scene.isPaused = false
                    }
                    Button("Exit") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                .padding()
                .background(Color.black.opacity(0.8))
                .cornerRadius(10)
            }
        }
        .onAppear {
            NotificationCenter.default.addObserver(forName: .gameOver, object: nil, queue: .main) { notification in
                if let winnerNum = notification.object as? Int {
                    let winner = winnerNum == 1 ? player1 : player2
                    self.winnerPlayer = winner
                    TrophyManager.shared.incrementTrophies(for: winner.name)
                }
            }
        }

    }
}


#Preview {
//    GameView()
}

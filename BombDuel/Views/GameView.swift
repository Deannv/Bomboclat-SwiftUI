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
    @State private var bombPosition: CGFloat = 0.76
    @StateObject private var gameLogic: GameLogicViewModel
    
    @State private var bombScale: CGFloat = 1.0
    @State private var bombRotation: Double = 0
    
    private var scene: SKScene {
        let scene = BombGameScene()
        scene.size = UIScreen.main.bounds.size
        scene.scaleMode = .resizeFill
        return scene
    }
    
    init(player1: Player, player2: Player) {
        self.player1 = player1
        self.player2 = player2
        _gameLogic = StateObject(wrappedValue: GameLogicViewModel(
            characterOne: player1.selectedCharacter,
            characterTwo: player2.selectedCharacter
        ))
    }
    
    var body: some View {
        ZStack {
            SpriteView(scene: scene)
                .ignoresSafeArea()
                .zIndex(0)
            
            Color(red: 0.99, green: 0.49, blue: 0.02)
                .ignoresSafeArea()
            
            VStack {
                PlayerView(player: player2, isFlipped: true)
                    .offset(y: -80)
                    .rotationEffect(.degrees(180))
                
                Spacer()
                
                Image("bomb")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .scaleEffect(bombScale)
                    .rotationEffect(.degrees(bombRotation))
                    .offset(y: bombPosition * UIScreen.main.bounds.height - UIScreen.main.bounds.height/2)
                    .animation(.easeInOut(duration: 0.3), value: bombPosition)
                    .zIndex(99)
                
                Spacer()
                
                PlayerView(player: player1, isFlipped: false)
                    .offset(y: -70)
            }
            
            TrainTrackView()
            
            HeartsView(count: gameLogic.p1Hearts)
                .offset(y: 350)
            
            HeartsView(count: gameLogic.p2Hearts)
                .scaleEffect(x: -1, y: -1)
                .offset(y: -350)
            
            controlButtons
            
            pauseModal
            explosionModal
            gameOverModal
        }
        .onAppear(perform: setupGame)
        .onReceive(NotificationCenter.default.publisher(for: .bombHolderChanged)) { notification in
            if let holder = notification.object as? Int {
                withAnimation {
                    bombPosition = holder == 1 ? 0.8 : 0.2
                }
                animateBomb()
            }
        }
    }
    
    // MARK: - Subviews
    
    private var controlButtons: some View {
        Group {
            // Pass buttons
            SquareButton(callback: { gameLogic.passBomb() }, size: 20, label: gameLogic.passCooldownPlayerTwo == 0 ? "Pass" : String(gameLogic.passCooldownPlayerTwo))
                .scaleEffect(x: -1, y: -1)
                .offset(x: -130, y: -260)
                .disabled(!gameLogic.canPass(for: 2) || isPaused || gameLogic.bombTimer == 0)
            
            SquareButton(callback: { gameLogic.passBomb() }, size: 20, label: gameLogic.passCooldownPlayerOne == 0 ? "Pass" : String(gameLogic.passCooldownPlayerOne))
                .offset(x: 130, y: 260)
                .disabled(!gameLogic.canPass(for: 1) || isPaused || gameLogic.bombTimer == 0)
            
            // Effect buttons
            SquareButton(callback: { gameLogic.useEffect(player: 1) }, size: 15, label: "Effects")
                .offset(x: -130, y: 260)
                .disabled(gameLogic.bombHolder != 1 || gameLogic.p1EffectUsed)
            
            SquareButton(callback: { gameLogic.useEffect(player: 2) }, size: 15, label: "Effects")
                .scaleEffect(x: -1, y: -1)
                .offset(x: 130, y: -260)
                .disabled(gameLogic.bombHolder != 2 || gameLogic.p2EffectUsed)
            
            // Top buttons
            HintButton().offset(x: -150, y: 360)
            Button{
                pauseGame()
            }label:{
                SettingButton()
            }.offset(x: 150, y: 360)
            
        }
    }
    
    // MARK: - Modals
    
    private var pauseModal: some View {
        Group {
            if isPaused {
                VStack(spacing: 20) {
                    Text("Paused")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                    
                    Button(action: toggleMute) {
                        Image(systemName: isMuted ? "speaker.slash.fill" : "speaker.wave.2.fill")
                            .font(.title)
                    }
                    
                    Button("Resume") { resumeGame() }
                        .buttonStyle(GameButtonStyle())
                    
                    Button("Exit") { presentationMode.wrappedValue.dismiss() }
                        .buttonStyle(GameButtonStyle())
                }
                .padding()
                .background(Color.black.opacity(0.9))
                .cornerRadius(20)
                .zIndex(1) // Ensure modal appears on top
            }
        }
    }
    
    private var explosionModal: some View {
        Group {
            if gameLogic.showExplosionModal {
                VStack(spacing: 20) {
                    Text("\(gameLogic.explodedPlayerName) exploded!")
                        .font(.title)
                        .foregroundColor(.white)
                    
                    Button("Continue") { gameLogic.continueAfterExplosion() }
                        .buttonStyle(GameButtonStyle())
                }
                .padding()
                .background(Color.red.opacity(0.9))
                .cornerRadius(20)
                .zIndex(1)
            }
        }
    }
    
    private var gameOverModal: some View {
        Group {
            if let winner = winnerPlayer {
                GameOverView(winner: winner) {
                    winnerPlayer = nil
                    gameLogic.rematch()
                } onExit: {
                    presentationMode.wrappedValue.dismiss()
                }
                .zIndex(1)
            }
        }
    }
    
    // MARK: - Game Functions
    
    private func setupGame() {
        gameLogic.startGame()
        NotificationCenter.default.addObserver(forName: .gameOver, object: nil, queue: .main) { notification in
            if let winnerNum = notification.object as? Int {
                winnerPlayer = winnerNum == 1 ? player1 : player2
            }
        }
    }
    
    private func toggleMute() {
        isMuted.toggle()
        SoundManager.shared.toggleMute()
    }
    
    private func pauseGame() {
        isPaused = true
        gameLogic.stop()
    }
    
    private func resumeGame() {
        isPaused = false
        gameLogic.startBombTimer()
    }
    
    private func animateBomb() {
        withAnimation(.easeInOut(duration: 0.1).repeatCount(3)) {
            bombScale = 0
            bombRotation += 360
        }
        bombScale = 1.0
    }
}

struct PlayerView: View {
    let player: Player
    let isFlipped: Bool
    
    var body: some View {
        VStack {
            Image(player.selectedCharacter.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .scaleEffect(x: isFlipped ? -1 : 1)
            
            Text(player.name)
                .font(.custom("ARCADECLASSIC", size: 32))
                .foregroundColor(.white)
        }
    }
}

struct GameButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.title)
            .foregroundColor(.white)
            .padding()
            .background(Color.blue)
            .cornerRadius(10)
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
    }
}


struct TrainTrackView: View {
    let imageWidth: CGFloat = 25
    let screenWidth = UIScreen.main.bounds.width
    let imageCount: Int

    init() {
        self.imageCount = Int(ceil(screenWidth / imageWidth)) + 3
    }

    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<imageCount, id: \.self) { _ in
                Image("TrainTracks")
                    .resizable()
                    .scaledToFit()
                    .frame(width: imageWidth)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct HeartsView: View {
    let count: Int

    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<count, id: \.self) { _ in
                Image("Heart")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 35, height: 35)
                    .padding(.horizontal ,10)
            }
        }
    }
}

struct CharacterBattle: View {
    let name: String


    var body: some View {


        VStack{

            Image(name + " BW")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
            Text(name)
                .font(.custom("ARCADECLASSIC", size: 32))
                .foregroundColor(.white)

        }
    }
}

struct SquareButton: View {
    var callback: () -> Void
    var size: Int
    var label: String

    var body: some View {
        Button(action: {
            callback()
        }) {

            ZStack{

                Rectangle()
                  .foregroundColor(.clear)
                  .frame(width: 65, height: 65)
                  .background(
                    LinearGradient(
                      stops: [
                        Gradient.Stop(color: Color(red: 0.98, green: 0.72, blue: 0.37), location: 0.00),
                        Gradient.Stop(color: Color(red: 0.83, green: 0.57, blue: 0.16), location: 1.00),
                      ],
                      startPoint: UnitPoint(x: 0.5, y: 0),
                      endPoint: UnitPoint(x: 0.5, y: 1)
                    )
                  )
                  .cornerRadius(20)
                  .shadow(color: Color(red: 0.64, green: 0.38, blue: 0.12), radius: 0, x: 0, y: 4)
                  .overlay(
                    RoundedRectangle(cornerRadius: 20)
                      .inset(by: 1)
                      .stroke(Color(red: 0.98, green: 0.87, blue: 0.77), lineWidth: 2)
                  )
                Text(label)
                    .font(Font.custom("ARCADECLASSIC", size: CGFloat(size - (size * 12 / 100))))
                    .foregroundColor(.white)
                    .padding(CGFloat(size))
            }

        }
    }
}

struct HintButton: View {
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            // Example content, replace with your own
            Image(systemName: "questionmark")
                .foregroundColor(.white)
        }
        .padding(0)
        .frame(width: 50, height: 50, alignment: .center)
        .background(
            LinearGradient(
                stops: [
                    Gradient.Stop(color: Color(red: 0.99, green: 0.49, blue: 0.02), location: 0.00),
                    Gradient.Stop(color: Color(red: 0.68, green: 0.33, blue: 0), location: 1.00),
                ],
                startPoint: UnitPoint(x: 0.5, y: 0),
                endPoint: UnitPoint(x: 0.5, y: 1)
            )
        )
        .cornerRadius(500) // This will make it a circle since width == height
        .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
    }
}

struct SettingButton: View {
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            // Example content, replace with your own
            Image(systemName: "gear")
                .foregroundColor(.white)

        }
        .padding(0)
        .frame(width: 50, height: 50, alignment: .center)
        .background(
            LinearGradient(
                stops: [
                    Gradient.Stop(color: Color(red: 0.99, green: 0.49, blue: 0.02), location: 0.00),
                    Gradient.Stop(color: Color(red: 0.68, green: 0.33, blue: 0), location: 1.00),
                ],
                startPoint: UnitPoint(x: 0.5, y: 0),
                endPoint: UnitPoint(x: 0.5, y: 1)
            )
        )
        .cornerRadius(500) // This will make it a circle since width == height
        .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
    }
}

struct GameBackground: View {
    var randomize: Bool = false
    @State var randomIndex: Int = Int.random(in: 1...2)
    
    var body: some View {
        
        if randomIndex == 1 && randomize {
            Color(red: 0.99, green: 0.49, blue: 0.02)
                .ignoresSafeArea(edges: .all)
            Image("blur-cloud")
                .scaledToFit()
                .offset(x: 0, y: -200)
            Image("blur-cloud")
                .scaledToFit()
                .offset(x: -90, y: 200)
        }else if randomIndex == 2 && randomize {
            Color(red: 0.40, green: 0.49, blue: 0.02)
                .ignoresSafeArea(edges: .all)
            Image("blur-cloud")
                .scaledToFit()
                .offset(x: 0, y: -200)
            Image("blur-cloud")
                .scaledToFit()
                .offset(x: -90, y: 200)
        }
    }
}


#Preview {
    GameView(player1: Player(name: "Farid", selectedCharacter: Character(name: "ninja", imageName: "ninja", unlockTrophy: 2), lives: 2), player2: Player(name: "Farid", selectedCharacter: Character(name: "ninja", imageName: "ninja", unlockTrophy: 2), lives: 2))
}

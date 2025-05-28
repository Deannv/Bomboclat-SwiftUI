////
////  AdrianGameplayView.swift
////  BombDuel
////
////  Created by Adrian Yusufa Rachman on 22/05/25.
////
//
//import SwiftUI
//import SpriteKit
//
//struct AdrianGameplayView: View {
////    @Environment(\.presentationMode) var presentationMode
////    var player1: Player
////    var player2: Player
////
////    @State private var isPaused = false
////    @State private var isMuted = false
////    @State private var winnerPlayer: Player? = nil
////    @StateObject private var gameLogic: GameLogicViewModel
////
////    private var scene: SKScene {
////        let scene = BombGameScene(size: UIScreen.main.bounds.size)
////        scene.scaleMode = .resizeFill
////        scene.player1 = player1
////        scene.player2 = player2
////        return scene
////    }
//    
//    var body: some View {
//        ZStack {
//            Color(red: 0.99, green: 0.49, blue: 0.02)
//                .ignoresSafeArea(edges: .all)
//            Image("blur-cloud")
//                .scaledToFit()
//                .offset(x: 0, y: -200)
//            
//            Image("blur-cloud")
//                .scaledToFit()
//                .offset(x: -90, y: 200)
//            
//            TrainTrackView()
//            
//         
//                HeartsView(count: 3)
//                    .offset(x: 0, y: 350)
//                HeartsView(count: 3)
////                    .rotationEffect(.degrees(180))
//                    .scaleEffect(x: -1, y: -1)
//                    .offset(x: 0, y: -350)
//                
//                CharacterBattle(name: "Angel")
//                    .offset(x: 0, y: 200)
//                CharacterBattle(name: "Kemas")
//                    .scaleEffect(x: -1, y: -1)
//                    .offset(x: 0, y: -200)
//                    
//
//                
//                
//            
//            SquareButton(callback: {return}, size: 20, label: "Pass")
//                .scaleEffect(x: -1, y: -1)
//                .offset(x: -130, y: -260)
//
//            SquareButton(callback: {return}, size: 20, label: "Pass")
//                .offset(x: 130, y: 260)
//            
//            SquareButton(callback: {return}, size: 15, label: "Effects")
//                .offset(x: -130, y: 260)
//            SquareButton(callback: {return}, size: 15, label: "Effects")
//                .scaleEffect(x: -1, y: -1)
//                .offset(x: 130, y: -260)
//            
//            
//            HintButton()
//                .offset(x: -150, y: 360)
//            
//            HintButton()
//                .scaleEffect(x: -1, y: -1)
//                .offset(x: 150, y: -360)
//            
//            SettingButton()
//                .offset(x: 150, y: 360)
//
//
//
//
//           
//        }
//    }
//}
//
//
//struct TrainTrackView: View {
//    let imageWidth: CGFloat = 25 // Set this to your actual image width
//    let screenWidth = UIScreen.main.bounds.width
//    let imageCount: Int // Number of images needed to cover the screen
//
//    init() {
//        // Calculate how many images are needed to cover the screen
//        self.imageCount = Int(ceil(screenWidth / imageWidth)) + 3
//    }
//
//    var body: some View {
//        HStack(spacing: 0) {
//            ForEach(0..<imageCount, id: \.self) { _ in
//                Image("TrainTracks")
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: imageWidth)
//            }
//        }
//        .frame(maxWidth: .infinity, alignment: .leading)
//    }
//}
//
//struct HeartsView: View {
//    let count: Int
//
//    var body: some View {
//        HStack(spacing: 4) {
//            ForEach(0..<count, id: \.self) { _ in
//                Image("Heart")
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 35, height: 35)
//                    .padding(.horizontal ,10)
//            }
//        }
//    }
//}
//
//struct CharacterBattle: View {
//    let name: String
//    
//
//    var body: some View {
//        
//        
//        VStack{
//            
//            Image(name + " BW")
//     // Assumes your asset names match the character names
//                .resizable()
//                .scaledToFit()
//                .frame(width: 200, height: 200)
//            Text(name)
//                .font(.custom("ARCADECLASSIC", size: 32))
//                .foregroundColor(.white)
//
//        }
//                
//           
//           
//            
//    }
//}
//
//struct SquareButton: View {
//    var callback: () -> Void
//    var size: Int
//    var label: String
//
//    var body: some View {
//        Button(action: {
//            callback()
//        }) {
//            
//            ZStack{
//               
//                Rectangle()
//                  .foregroundColor(.clear)
//                  .frame(width: 65, height: 65)
//                  .background(
//                    LinearGradient(
//                      stops: [
//                        Gradient.Stop(color: Color(red: 0.98, green: 0.72, blue: 0.37), location: 0.00),
//                        Gradient.Stop(color: Color(red: 0.83, green: 0.57, blue: 0.16), location: 1.00),
//                      ],
//                      startPoint: UnitPoint(x: 0.5, y: 0),
//                      endPoint: UnitPoint(x: 0.5, y: 1)
//                    )
//                  )
//                  .cornerRadius(20)
//                  .shadow(color: Color(red: 0.64, green: 0.38, blue: 0.12), radius: 0, x: 0, y: 4)
//                  .overlay(
//                    RoundedRectangle(cornerRadius: 20)
//                      .inset(by: 1)
//                      .stroke(Color(red: 0.98, green: 0.87, blue: 0.77), lineWidth: 2)
//                  )
//                Text(label)
//                    .font(Font.custom("ARCADECLASSIC", size: CGFloat(size - (size * 12 / 100))))
//                    .foregroundColor(.white)
//                    .padding(CGFloat(size))
//            }
//            
//        }
//    }
//}
//
//struct HintButton: View {
//    var body: some View {
//        HStack(alignment: .center, spacing: 0) {
//            // Example content, replace with your own
//            Image(systemName: "questionmark")
//                .foregroundColor(.white)
//        }
//        .padding(0)
//        .frame(width: 50, height: 50, alignment: .center)
//        .background(
//            LinearGradient(
//                stops: [
//                    Gradient.Stop(color: Color(red: 0.99, green: 0.49, blue: 0.02), location: 0.00),
//                    Gradient.Stop(color: Color(red: 0.68, green: 0.33, blue: 0), location: 1.00),
//                ],
//                startPoint: UnitPoint(x: 0.5, y: 0),
//                endPoint: UnitPoint(x: 0.5, y: 1)
//            )
//        )
//        .cornerRadius(500) // This will make it a circle since width == height
//        .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
//    }
//}
//
//struct SettingButton: View {
//    var body: some View {
//        HStack(alignment: .center, spacing: 0) {
//            // Example content, replace with your own
//            Image(systemName: "gear")
//                .foregroundColor(.white)
//
//        }
//        .padding(0)
//        .frame(width: 50, height: 50, alignment: .center)
//        .background(
//            LinearGradient(
//                stops: [
//                    Gradient.Stop(color: Color(red: 0.99, green: 0.49, blue: 0.02), location: 0.00),
//                    Gradient.Stop(color: Color(red: 0.68, green: 0.33, blue: 0), location: 1.00),
//                ],
//                startPoint: UnitPoint(x: 0.5, y: 0),
//                endPoint: UnitPoint(x: 0.5, y: 1)
//            )
//        )
//        .cornerRadius(500) // This will make it a circle since width == height
//        .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
//    }
//}
//
//
//#Preview {
//    AdrianGameplayView()
//}

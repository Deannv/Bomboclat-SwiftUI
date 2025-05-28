//
//  HomeView.swift
//  BombDuel
//
//  Created by Kemas Deanova on 19/05/25.
//

import SwiftUI

struct HomeView: View {
    @State private var player1Character: Character?
    @State private var player2Character: Character?
    @State private var selectedIndex = 0 // Single or Double mode
    @State private var selectedCharacterIndex1 = 0 // Player 1 character
    @State private var selectedCharacterIndex2 = 0 // Player 2 character or CPU/PvP
    @State private var navigateToGame = false

    let options = ["Single", "Double"]
    let characterOptions = ["Angel", "Kemas", "Farid", "Javier", "Adrian", "Nanda", "Ravshan"]

    var body: some View {
        NavigationStack {
            ZStack {
                BackGroundImg()

                // Back button image (non-functional)
//                Image("Back-Button")
//                    .resizable()
//                    .frame(width: 31, height: 31)
//                    .offset(x: -160, y: -330)
//
                // Main content
                VStack {
                    Spacer()
                        .frame(height: 80)
                    
                    Text("Bomboclat")
                        .font(.custom("ARCADECLASSIC", size: 24))
                        .foregroundColor(.white)
                    
                    // Player 1 character selection
                    VStack {
                        Text("Player 1")
                            .font(.custom("ARCADECLASSIC", size: 20))
                            .foregroundColor(.white)
                        
                        CharacterView(
                            selectedIndex: $selectedIndex,
                            selectedCharacterIndex: $selectedCharacterIndex1,
                            characterOptions: characterOptions,
                            selectedCharacter: $player1Character
                        )
                    }
                    
                    
                    
                    // CPU/PvP selector for Double mode
                    if selectedIndex == 1 {
                        SelectorView(options: ["CPU", "PvP"], currentIndex: $selectedCharacterIndex2) { index in
                            print("Selected index: \(index)")
                        }
                    }
                    

                    
                    // Single/Double selector
                    SelectorView(options: options, currentIndex: $selectedIndex) { index in
                        print("Selected mode: \(options[index])")
                        player2Character = nil
                        selectedCharacterIndex2 = 0
                    }
                    
                 
                    
                    Spacer()
                        .frame(height: 50)
                    // Continue button
                    ContinueButton(action: {
                        navigateToGame = true
                    }, label: "CONTINUE")
                }
                .padding()
                // Modern navigation destination with safe fallback for preview
                .navigationDestination(isPresented: $navigateToGame) {
                    GameView(
                        player1: Player(name: "Player 1", selectedCharacter: player1Character ?? Character(name: "Default", imageName: "DefaultChara", unlockTrophy: 0)),
                        player2: Player(
                            name: selectedIndex == 0 ? "CPU" : "Player 2",
                            selectedCharacter: selectedIndex == 0 ? Character(name: characterOptions.randomElement() ?? "Default", imageName: characterOptions.randomElement() ?? "DefaultChara", unlockTrophy: 0) : player2Character ?? Character(name: "Default", imageName: "DefaultChara", unlockTrophy: 0)
                        )
                    )
                }
            }
        }
    }
}

struct BackGroundImg: View {
    var body: some View {
        // Background color
        Color(red: 0.99, green: 0.49, blue: 0.02)
            .ignoresSafeArea(edges: .all)
        
        // Cloud images
        Image("blur-cloud")
            .scaledToFit()
            .offset(x: 0, y: -200)
        
        Image("blur-cloud")
            .scaledToFit()
            .offset(x: -90, y: 200)

    }

}

struct CharacterView: View {
    @Binding var selectedIndex: Int
    @Binding var selectedCharacterIndex: Int
    let characterOptions: [String]
    @Binding var selectedCharacter: Character?
    let imageSize: CGSize // <-- New parameter

    // Default initializer with default size
    init(selectedIndex: Binding<Int>,
         selectedCharacterIndex: Binding<Int>,
         characterOptions: [String],
         selectedCharacter: Binding<Character?>,
         imageSize: CGSize = CGSize(width: 350, height: 350)) {
        self._selectedIndex = selectedIndex
        self._selectedCharacterIndex = selectedCharacterIndex
        self.characterOptions = characterOptions
        self._selectedCharacter = selectedCharacter
        self.imageSize = imageSize
    }

    var currentCharacter: String {
        characterOptions[selectedCharacterIndex]
    }

    var body: some View {
        VStack {
            // Character images
            ZStack {
                Image(currentCharacter)
                    .resizable()
                    .scaledToFit()
                    .frame(width: imageSize.width, height: imageSize.height) // <-- Use imageSize
                    .offset(x: selectedIndex == 1 ? -90 : 0)
                    .scaleEffect(selectedIndex == 1 ? 0.75 : 1.0)
                    .animation(.spring(response: 0.4, dampingFraction: 0.4), value: selectedIndex)
                
                // Player 2 character
                if selectedIndex == 1 {
                    Image("DefaultChara")
                        .resizable()
                        .scaledToFit()
                        .frame(width: imageSize.width, height: imageSize.height) // <-- Use imageSize
                        .transition(
                            .asymmetric(
                                insertion: .move(edge: .trailing).combined(with: .opacity),
                                removal: .move(edge: .trailing).combined(with: .opacity)
                            )
                        )
                        .scaleEffect(0.75)
                        .offset(x: 90)
                }
            }
            .animation(.spring(response: 0.4, dampingFraction: 0.6), value: selectedIndex)

            Spacer().frame(height: 30)
            
            // Character selector
            if selectedIndex == 0 {
                SelectorView(options: characterOptions, currentIndex: $selectedCharacterIndex) { index in
                    print("Selected character: \(characterOptions[index])")
                    selectedCharacter = Character(name: characterOptions[index], imageName: characterOptions[index], unlockTrophy: 0)
                }
            }
        }
    }
}



struct SelectorView: View {
    let options: [String]
    @Binding var currentIndex: Int
    var onSelectionChanged: ((Int) -> Void)?

    var body: some View {
        HStack {
            // Left arrow button
            Button {
                currentIndex = (currentIndex - 1 + options.count) % options.count
                onSelectionChanged?(currentIndex)
            } label: {
                Image("arrow-left-svg")
                    .resizable()
                    .frame(width: 35, height: 35)
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.trailing, 10)

            // Current selection
            Text(options[currentIndex])
                .font(.custom("ARCADECLASSIC", size: 32))
                .foregroundColor(.white)

            // Right arrow button
            Button {
                currentIndex = (currentIndex + 1) % options.count
                onSelectionChanged?(currentIndex)
            } label: {
                Image("arrow-right-svg")
                    .resizable()
                    .frame(width: 35, height: 35)
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.leading, 10)
        }    }
}

struct ContinueButton: View {
    let action: () -> Void
    let label: String

    var body: some View {
        Button(action: action) {
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 194, height: 56.86207)
                .background(
                    LinearGradient(
                        stops: [
                            Gradient.Stop(color: Color(red: 0.98, green: 0.72, blue: 0.37), location: 0),
                            Gradient.Stop(color: Color(red: 0.83, green: 0.57, blue: 0.16), location: 1)
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
                .overlay(
                    Text(label)
                        .font(.custom("ARCADECLASSIC", size: 20))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .frame(width: 98.67242, height: 25.08621)
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    HomeView()
}

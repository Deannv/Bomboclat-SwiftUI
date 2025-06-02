//
//  HomeView.swift
//  BombDuel
//
//  Created by Kemas Deanova on 19/05/25.
//

import SwiftUI
import SpriteKit // Perlu diimpor karena GameView menggunakannya


struct HomeView: View {
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding: Bool = false
    @State private var player1Character: Character?
    @State private var player2Character: Character?
    @State private var selectedIndex = 0 // Single or Double mode
    @State private var selectedCharacterIndex1 = 0 // Player 1 character
    @State private var selectedCharacterIndex2 = 0 // Player 2 character or CPU/PvP
    @State private var navigateToGame = false
    @State private var navigateToCharacterSelect = false

    let options = ["Single", "Double"]
    let characterOptions = ["Angel", "Kemas", "Farid", "Javier", "Adrian", "Nanda", "Ravshan", "Charlie", "Emma", "Frea"]

    var body: some View {
        NavigationStack {
            ZStack {
                BackGroundImg()

                // Main content
                VStack {
                    Spacer()
                        .frame(height: 80)

                    Text("Bomboclat")
                        .font(.custom("ARCADECLASSIC", size: 24))
                        .foregroundColor(.white)

                    // Player 1 character selection (only visible in Single mode or initial character select)
                    if selectedIndex == 0 {
                        VStack {
                            Text("Player")
                                .font(.custom("ARCADECLASSIC", size: 20))
                                .foregroundColor(.white)

                            CharacterView(
                                selectedIndex: $selectedIndex,
                                selectedCharacterIndex: $selectedCharacterIndex1,
                                characterOptions: characterOptions,
                                selectedCharacter: $player1Character
                            )
                        }
                    } else {
                        // Display default character for Player 1 when in Double mode (actual selection in CharacterSelectView)
                        VStack {
                            Text("Player 1")
                                .font(.custom("ARCADECLASSIC", size: 20))
                                .foregroundColor(.white)
                            Image(characterOptions[selectedCharacterIndex1])
                                .resizable()
                                .scaledToFit()
                                .frame(width: 350, height: 350)
                        }
                    }

                    Spacer()
                        .frame(height: 20)

                    // Single/Double selector
                    SelectorView(options: options, currentIndex: $selectedIndex) { index in
                        print("Selected mode: \(options[index])")
                        player2Character = nil // Reset player2 character when mode changes
                        selectedCharacterIndex2 = 0 // Reset player2 index
                    }

                    Spacer()

                    // Continue button
                    Button(action: {
                        if selectedIndex == 0 { // Single Player
                            navigateToGame = true
                        } else { // Double Player, navigate to CharacterSelectView
                            navigateToCharacterSelect = true
                        }
                    }) {
                        Image("Next Button")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 130, height: 130) // Adjust size as needed
                    }
                    .buttonStyle(PlainButtonStyle()) // Optional: removes default button highlight

                }
                .padding()
                // Navigation destination for Single Player mode
                .navigationDestination(isPresented: $navigateToGame) {
                    GameView(
                        player1: Player(name: "Player 1", selectedCharacter: player1Character ?? Character(name: characterOptions[selectedCharacterIndex1], imageName: characterOptions[selectedCharacterIndex1], unlockTrophy: 0)),
                        player2: Player(
                            name: "CPU",
                            selectedCharacter: Character(name: characterOptions.randomElement() ?? "Default", imageName: characterOptions.randomElement() ?? "DefaultChara", unlockTrophy: 0)
                        )
                    )
                }
                // Navigation destination for CharacterSelectView (Multiplayer)
                .navigationDestination(isPresented: $navigateToCharacterSelect) {
                    CharacteSelectView()
                }
                
                Button{
                    hasSeenOnboarding = false
                }label:{
                    HintButton()
                }
                .offset(x: 150, y: -360)
                
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

                // Player 2 character (will be removed as it's handled in CharacterSelectView)
                // if selectedIndex == 1 {
                //     Image("DefaultChara")
                //         .resizable()
                //         .scaledToFit()
                //         .frame(width: imageSize.width, height: imageSize.height)
                //         .transition(
                //             .asymmetric(
                //                 insertion: .move(edge: .trailing).combined(with: .opacity),
                //                 removal: .move(edge: .trailing).combined(with: .opacity)
                //             )
                //         )
                //         .scaleEffect(0.75)
                //         .offset(x: 90)
                // }
            }
            .animation(.spring(response: 0.4, dampingFraction: 0.6), value: selectedIndex)

            Spacer().frame(height: 30)

            // Character selector
            // This SelectorView will now only be present when selectedIndex == 0 (Single Player)
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

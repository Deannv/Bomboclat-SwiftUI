//
//  CharacteSelectView.swift
//  BombDuel
//
//  Created by Adrian Yusufa Rachman on 23/05/25.
//

import SwiftUI

struct CharacteSelectView: View {
    // Separate state for each player
    @State private var player1Character: Character?
    @State private var player2Character: Character?
    @State private var selectedIndex = 0 // Single or Double mode
    @State private var selectedCharacterIndex1 = 0 // Player 1 character
    @State private var selectedCharacterIndex2 = 0 // Player 2 character
    @State private var navigateToGame = false

    let characterOptions = ["Angel", "Kemas", "Farid", "Javier", "Adrian", "Nanda", "Ravshan", "Charlie", "Emma", "Frea"]

    var body: some View {
        ZStack{
            BackGroundImg()
            Image("Back-Button")
                .resizable()
                .frame(width: 31, height: 31)
                .offset(x: -160, y: -330)

            // Player 1 selector (top)
            CharacterViewForSelectScreen(
                selectedIndex: $selectedIndex,
                selectedCharacterIndex: $selectedCharacterIndex1, // <- Player 1 index
                characterOptions: characterOptions,
                selectedCharacter: $player1Character,
                imageSize: CGSize(width: 200, height: 200)
            )
            .scaleEffect(x: -1, y: -1)
            .offset(x: 0, y: -200)

            Seperator(imageName: "TrainTracks")

            // Player 2 selector (bottom)
            CharacterViewForSelectScreen(
                selectedIndex: $selectedIndex,
                selectedCharacterIndex: $selectedCharacterIndex2, // <- Player 2 index
                characterOptions: characterOptions,
                selectedCharacter: $player2Character,
                imageSize: CGSize(width: 200, height: 200)
            )
            .offset(x: 0, y: 170)

            Button(action: {
                navigateToGame = true
            }) {
                Image("Next Button")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120) // Adjust size as needed
            }
            .buttonStyle(PlainButtonStyle()) // Optional: removes default button highlight

            .offset(x: 0, y: 350)
        }
    }
}

// The rest of your code (CharacterViewForSelectScreen, CharacterCard, etc.) stays the same!



struct CharacterViewForSelectScreen: View {
    @Binding var selectedIndex: Int
    @Binding var selectedCharacterIndex: Int
    let characterOptions: [String]
    @Binding var selectedCharacter: Character?
    let imageSize: CGSize
    
    // ScrollView proxy for programmatic scrolling
    @State private var scrollViewProxy: ScrollViewProxy?
    
    private let spacing: CGFloat = 20
    
    var body: some View {
        VStack(spacing: 20) {
            // Carousel with arrows
            HStack(spacing: 0) {
                // Left arrow button
                Button(action: {
                    withAnimation(.easeInOut) {
                        selectedCharacterIndex = max(selectedCharacterIndex - 1, 0)
                        updateSelectedCharacter()
                        scrollToSelected()
                    }
                }) {
                    Image(systemName: "chevron.left.circle.fill")
                        .font(.system(size: 40))
                        .foregroundColor(selectedCharacterIndex == 0 ? .gray : .blue)
                }
                .disabled(selectedCharacterIndex == 0)
                
                // ScrollView carousel
                ScrollViewReader { proxy in
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: spacing) {
                            ForEach(Array(characterOptions.enumerated()), id: \.offset) { index, character in
                                CharacterCard(
                                    character: character,
                                    isSelected: index == selectedCharacterIndex,
                                    imageSize: imageSize
                                )
                                .id(index)
                                .onTapGesture {
                                    withAnimation(.easeInOut) {
                                        selectedCharacterIndex = index
                                        updateSelectedCharacter()
                                        scrollToSelected(proxy: proxy)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, (UIScreen.main.bounds.width ))
                    }
                    .onAppear {
                        scrollViewProxy = proxy
                        // Scroll to initial selected character on appear
                        scrollToSelected(proxy: proxy)
                    }
                }
                
                // Right arrow button
                Button(action: {
                    withAnimation(.easeInOut) {
                        selectedCharacterIndex = min(selectedCharacterIndex + 1, characterOptions.count - 1)
                        updateSelectedCharacter()
                        scrollToSelected()
                    }
                }) {
                    Image(systemName: "chevron.right.circle.fill")
                        .font(.system(size: 40))
                        .foregroundColor(selectedCharacterIndex == characterOptions.count - 1 ? .gray : .blue)
                }
                .disabled(selectedCharacterIndex == characterOptions.count - 1)
            }
            
            // Optional: SelectorView if you want below carousel
            SelectorView(
                options: characterOptions,
                currentIndex: $selectedCharacterIndex
            ) { index in
                withAnimation(.easeInOut) {
                    selectedCharacterIndex = index
                    updateSelectedCharacter()
                    scrollToSelected()
                }
            }
        }
    }
    
    private func updateSelectedCharacter() {
        selectedCharacter = Character(
            name: characterOptions[selectedCharacterIndex],
            imageName: characterOptions[selectedCharacterIndex],
            unlockTrophy: 0
        )
    }
    
    private func scrollToSelected(proxy: ScrollViewProxy? = nil) {
        let proxyToUse = proxy ?? scrollViewProxy
        guard let proxy = proxyToUse else { return }
        proxy.scrollTo(selectedCharacterIndex, anchor: .center)
    }
}

struct CharacterCard: View {
    let character: String
    let isSelected: Bool
    let imageSize: CGSize
    
    var body: some View {
        Image(character)
            .resizable()
            .scaledToFit()
            .frame(width: imageSize.width, height: imageSize.height)
            .scaleEffect(isSelected ? 1.0 : 0.8)
            .opacity(isSelected ? 1.0 : 0.6)
            .shadow(color: isSelected ? .yellow.opacity(0.8) : .clear, radius: 10)
            .animation(.spring, value: isSelected)
            .cornerRadius(12)
    }
}


#Preview {
    CharacteSelectView()
}

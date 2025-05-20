//
//  CharacterSelectionView.swift
//  BombDuel
//
//  Created by Kemas Deanova on 19/05/25.
//

import SwiftUI

struct CharacterSelectionView: View {
    @Binding var selectedCharacter: Character?
    var playerName: String

    let characters: [Character] = [
        Character(name: "Bomber", imageName: "bomber", unlockTrophy: 0),
        Character(name: "Ninja", imageName: "ninja", unlockTrophy: 3),
        Character(name: "Knight", imageName: "knight", unlockTrophy: 5)
        // Add more if needed
    ]

    var body: some View {
        let trophies = TrophyManager.shared.getTrophies(for: playerName)

        ScrollView(.horizontal) {
            HStack {
                ForEach(characters) { character in
                    let isLocked = character.unlockTrophy > trophies

                    Button(action: {
                        if !isLocked {
                            selectedCharacter = character
                        }
                    }) {
                        VStack {
                            Image(character.imageName)
                                .resizable()
                                .frame(width: 80, height: 80)
                                .grayscale(isLocked ? 1.0 : 0.0)
                                .overlay(
                                    isLocked
                                    ? Text("🔒 \(character.unlockTrophy)🏆")
                                        .font(.caption)
                                        .foregroundColor(.white)
                                        .padding(4)
                                        .background(Color.black.opacity(0.7))
                                        .cornerRadius(6)
                                    : nil,
                                    alignment: .bottom
                                )
                            Text(character.name)
                        }
                    }
                    .disabled(isLocked)
                }
            }
        }
    }
}



#Preview {
//    CharacterSelectionView()
}

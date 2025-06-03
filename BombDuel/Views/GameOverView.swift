//
//  GameOverView.swift
//  BombDuel
//
//  Created by Kemas Deanova on 19/05/25.
//

import SwiftUI

struct GameOverView: View {
    let winner: Player
    let onRematch: () -> Void
    let onExit: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Text("🎉 \(winner.name) Wins!")
                .font(.custom("Gameplay", size: 14))
                .foregroundStyle(.white)

            HStack {
                DynamicSquareButton(callback: onRematch, size: 18, width: 85, label: "Rematch")
                
                DynamicSquareButton(callback: onExit, size: 18, width: 85, label: "Exit")
            }

        }
        .padding()
        .background(.black.opacity(0.9))
        .cornerRadius(12)
        .shadow(radius: 8)
    }
}


#Preview {
    GameOverView(
        winner: Player(name: "Test Name", selectedCharacter: Character(name: "Ninja", imageName: "ninja", unlockTrophy: 3), lives: 3), onRematch: {return}, onExit: {return}
    )
}

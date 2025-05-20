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
                .font(.largeTitle)

            Button("Rematch", action: onRematch)
                .padding()

            Button("Back to Home", action: onExit)
                .padding()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 8)
    }
}


#Preview {
//    GameOverView()
}

//
//  HomeView.swift
//  BombDuel
//
//  Created by Kemas Deanova on 19/05/25.
//

import SwiftUI

struct HomeView: View {
    @State private var player1Name = ""
    @State private var player2Name = ""
    @State private var player1Character: Character? = nil
    @State private var player2Character: Character? = nil
    @State private var startGame = false


    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Bomboclat")
                    .font(.custom("ARCADECLASSIC", size: 24))
                    
                
                VStack {
                    Text("Player 1")
                    TextField("Enter nickname", text: $player1Name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }

                CharacterSelectionView(selectedCharacter: $player1Character, playerName: player1Name)

                VStack {
                    Text("Player 2")
                    TextField("Enter nickname", text: $player2Name)
                }

                CharacterSelectionView(selectedCharacter: $player2Character, playerName: player2Name)

                if let char1 = player1Character, let char2 = player2Character {
                    NavigationLink(destination: GameView(player1: Player(name: player1Name, selectedCharacter: char1), player2: Player(name: player2Name, selectedCharacter: char2))) {
                        Text("Start Game")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                }
            }
            .padding()
        }
    }
}


#Preview {
    HomeView()
}

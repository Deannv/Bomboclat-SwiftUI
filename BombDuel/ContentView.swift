//
//  ContentView.swift
//  BombDuel
//
//  Created by Kemas Deanova on 19/05/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding: Bool = false
    
    var body: some View {
        if hasSeenOnboarding {
            HomeView()
        }else{
            Onboarding()
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}

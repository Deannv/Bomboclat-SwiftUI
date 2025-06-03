//
//  Onboarding.swift
//  BombDuel
//
//  Created by Kemas Deanova on 21/05/25.
//

import SwiftUI

struct Onboarding: View {
    @State private var currentIndex = 0
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding: Bool = false
    
    var titles = [
        "Pass  the  bomb.",
        "Watch  the  cooldown!",
        "Play  with  a  friend or  BOT."
    ]
    
    var descriptions = [
        "Pass the bomb to your opponent, guess the timer in your head, and try to distract them. If the bomb explodes in your hands, you lose.",
        "There's cooldown to each pass! and yes it's random. Be aware of random timer during the gameplay!",
        "We encourage you to play with friends :)"
    ]
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                Color(.primary)
                
                TabView(selection: $currentIndex) {
                    Rules().tag(0)
                    Detail().tag(1)
                    Final().tag(2)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                
                VStack (spacing: 20){
                    Text(titles[currentIndex])
                    .font(.custom("ARCADECLASSIC", size: 38))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    
                    Text(descriptions[currentIndex])
                        .frame(width: 330)
                        .padding()
                        .background(.white.opacity(0.18))
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.white)
                    
                    HStack{
                        if currentIndex > 0 {
                            CircleButton(callback: {
                                currentIndex -= 1
                            }, size: 25, label: "Back")
                        }
                        
                        if currentIndex < 2 {
                            CircleButton(callback: {
                                currentIndex+=1
                            }, size: 25, label: "Next")
                            
                        }else{
                            NavigationLink {
                                HomeView()
                                    .navigationBarBackButtonHidden(true)
                            } label: {
                                Button{
                                    hasSeenOnboarding = true
                                }label: {
                                    CircleButtonVisual(size: 25, label: "Start")
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 30)
                }
                .padding(.bottom, 100)
                .animation(.easeInOut, value: currentIndex)
            }
            .ignoresSafeArea()
        }
    }
}

#Preview {
    Onboarding()
}

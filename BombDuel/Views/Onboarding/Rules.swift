//
//  Rules.swift
//  BombDuel
//
//  Created by Kemas Deanova on 21/05/25.
//

import SwiftUI

struct Rules: View {
    var body: some View {
        ZStack(alignment: .top)
        {
            Image("onboarding1")
                .resizable()
                .frame(width: 270, height: 300)
                .padding(.top, -200)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    Rules()
}

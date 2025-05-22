//
//  Final.swift
//  BombDuel
//
//  Created by Kemas Deanova on 21/05/25.
//

import SwiftUI

struct Final: View {
    var body: some View {
        ZStack(alignment: .top)
        {
            Image("blur-cloud")
                .scaledToFit()
            
            Image("onboarding2")
                .resizable()
                .frame(width: 200, height: 230)
                .position(x: 230, y: 330)
            
            Image("onboarding1")
                .resizable()
                .frame(width: 270, height: 300)
                .position(x: 320, y: 330)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    Final()
}

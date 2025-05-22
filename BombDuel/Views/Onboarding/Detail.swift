//
//  Detail.swift
//  BombDuel
//
//  Created by Kemas Deanova on 21/05/25.
//

import SwiftUI

struct Detail: View {
    var body: some View {
        ZStack(alignment: .top)
        {
            
            Image("blur-cloud")
                .scaledToFit()
            
            Image("onboarding2")
                .resizable()
                .frame(width: 270, height: 300)
                .padding(.top, -50)
            
        }
        .ignoresSafeArea()
    }
}

#Preview {
    Detail()
}
